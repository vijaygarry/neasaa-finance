# CLAUDE.md

Guidance for Claude Code when working in this repository. Read this before adding or modifying any feature.

## Project Overview

A finance application that lets customers view stock details and option chains, and provides options-income guidance:

- Suggest the best **covered call (CC)** or **cash-secured put (CSP)** to open.
- For positions the customer already holds, advise whether to **close** an existing **covered call (CC)** / **cash-secured put (CSP)** or **roll** it (roll out / up / down).

> This app provides informational guidance, not personalized financial advice. Keep that framing in any user-facing copy.

## Repository Layout

Multi-module Gradle project rooted at `source/`. Key modules:

- `components/finance-app` — Spring Boot backend (Java 17)
- `components/finance-ux` — React/TypeScript frontend (Create React App)
- `components/finance-integ-test` — REST Assured integration tests (require a running server)
- `components/database` — PostgreSQL DDL/seed scripts
- `components/neasaa-base-app` — External base library; path configured via `source/local.properties`

## Tech Stack

- **Frontend:** React / TypeScript (Create React App)
- **Backend:** Spring Boot, Java 17
- **Database:** PostgreSQL
- **Build:** Gradle (multi-module, rooted at `source/`)
- **Auth:** Custom in-house operation-based authorization framework (not Spring Security defaults — see below)

## Architecture & Request Flow

Every backend request follows the same layered path. Do not bypass a layer.

```
HTTP request
   -> Controller        (REST endpoint; request/response binding, validation)
      -> WebRequestHandler.processRequest(OperationClass.class, request)
         -> OperationExecutor.executeOperation(...)
            -> AbstractOperation.doValidate() → doExecute()
               -> DAO   (only when DB access is needed; all SQL/JdbcTemplate lives here)
                  -> PostgreSQL
```

Rules:

- **Controller** is thin. It binds the request, delegates to exactly one Operation via `WebRequestHandler.processRequest`, and maps the result to a response. No business logic, no direct DAO calls.
- **Operation** is the unit of business logic and the unit of authorization. Extend `AbstractOperation<Request, Response>`, annotate with `@Component("Name") @Scope("prototype")`, and register the name in `FinanceOperationNames`. It calls DAOs as needed.
- **DAO** is the only layer that touches the database. Uses Spring JDBC (`JdbcTemplate`) with hand-written `RowMapper` classes. No ORM. Each table has a corresponding `*Dao` and `*RowMapper` class under `dao/pg/`. No SQL outside the DAO layer.

## Authorization Model

Authorization is **operation-based**, not annotation-based or URL-based.

- Every Operation has a corresponding **entry in the database** that maps the operation to the **role(s)** allowed to invoke it.
- When a request reaches an Operation, the custom framework checks the caller's role against that operation's registered role(s) before the business logic runs.
- An Operation with **no database entry will not be authorized** — it will be rejected. Registering the operation in the DB is a required step, not optional.

## How to Add a New Feature

Follow these steps in order. Each new backend capability is a new Operation.

1. **Define the Operation.** Create a class extending `AbstractOperation<Request, Response>`. Annotate with `@Component("OperationName") @Scope("prototype")` and add the name constant to `FinanceOperationNames`. Put business logic here; keep DB access in DAOs.
2. **Register the Operation for authorization.** Add the operation's entry to the database with the allowed role(s). Without this, the operation is not callable.
3. **Add/extend a DAO** only if the feature needs database access. Keep all queries here; return domain/DTO objects to the Operation.
4. **Add the Controller endpoint.** Wire a thin REST method that validates input, calls `WebRequestHandler.processRequest(OperationName.class, request)`, and maps the response. Match existing routing and naming conventions.
5. **Frontend.** Add the React component(s)/page and the API call via `src/services/financeApi.ts` using the `apiClient` axios instance. Reuse existing data-fetching, state, and error-handling patterns. All backend responses share the envelope `{ operationMessage: string | null, ...payload }`.
6. **Tests.** Add tests at the Operation level (business logic + authorization) and DAO level (queries), plus integration tests under `finance-integ-test`.
7. **Migrations.** Any schema or operation-registry change goes through the project's migration process. Schema SQL lives in `source/components/database/schema/`; seed data in `source/components/database/data/`.

When in doubt, find the closest existing feature and mirror its structure end-to-end.

## Build Commands

All Gradle commands run from `source/`.

```bash
# Fast build — skips React (use during backend development)
./gradlew build

# Full build including React UX (slow — use before deploy)
./gradlew build -PbuildReactApp

# Clean + full build + copy JARs to source/distribution/
./gradlew clean buildDist -PbuildReactApp

# Start the Spring Boot server (port 8080)
./gradlew runFinanceApp

# Run backend unit tests
./gradlew test

# Run integration tests (server must already be running)
./gradlew :components:finance-integ-test:test

# Run integration tests against a non-local server
./gradlew :components:finance-integ-test:test -DbaseUrl=http://staging.example.com:8080

# Override UX path for a single build
./gradlew build -PbuildReactApp -PfrontendPath=/path/to/finance-ux
```

## Frontend

```bash
cd source/components/finance-ux
npm start        # dev server at http://localhost:3000
npm test         # unit tests
npm run rebuild  # production build (called by Gradle -PbuildReactApp)
```

The React dev server proxies `/api/*` calls through to the Spring Boot backend. In production, the built static files are served directly by Spring Boot from `src/main/resources/static/`.

Routing via `react-router-dom`; all pages wrap inside `MainLayout`. HTTP calls go through `src/services/apiClient.ts` (axios instance with error normalisation) and page-level functions in `src/services/financeApi.ts`.

## Required Configuration

These files must be set up locally before building:

| File | What to set |
|------|-------------|
| `source/local.properties` | `neasaaBaseAppPath`, `uxComponentRootPath` |
| `source/components/finance-app/src/main/config/db.properties` | `app.datasource.password` (jasypt-encrypted) |
| `source/components/finance-app/src/main/config/finance.properties` | `email.server.password` |
| `source/components/finance-app/build.gradle` | `DB_PASSWORD_ENCRYPTION_SALT_KEY` env var |

`local.properties` is git-ignored. The salt key in `build.gradle` must match the one used to encrypt the value in `db.properties`.

Config files in `src/main/config/` are added to the classpath at runtime (see `runFinanceApp` in `build.gradle`). They live outside the JAR.

## Database

PostgreSQL. Three users: `finance_master`, `finance_app_user`, `replicator`. See `docs/db-setup.md` for the full setup sequence.

- **Schema SQL:** `source/components/database/schema/`
- **Seed data:** `source/components/database/data/`

## Code Style

Spotless is applied to all modules (configured in each `build.gradle`). It runs automatically as part of `./gradlew build` and will fail the build if formatting violations are present. Fix with `./gradlew spotlessApply`.

## Conventions

- Respect the layer boundaries — no shortcuts (e.g., Controller calling a DAO directly).
- Keep Operations single-purpose so the authorization mapping stays one-role-set-per-action and easy to reason about.
- Follow existing package structure and naming.
- Money/quantities: handle prices, premiums, strikes, and share counts with `BigDecimal`, never floating point. Define and reuse the project's standard for rounding and currency.
- Validate option/market inputs (symbol, expiration, strike, contract side) at the Controller boundary; enforce business rules in the Operation.

## Domain Glossary

- **Option chain** — the set of available option contracts for a symbol across strikes and expirations.
- **Covered call (CC)** — selling a call against shares the customer owns.
- **Cash-secured put (CSP)** — selling a put backed by cash set aside to buy the shares if assigned.
- **Close** — buying back an open short option to exit the position.
- **Roll** — closing an existing CC/CSP and opening a new one, typically at a different expiration (roll out) and/or strike (roll up/down).
- **Assignment / Expiration** — outcomes the guidance logic must account for when advising close vs. roll.

## External Integrations

<!-- TODO: market data / option-chain / brokerage provider(s), endpoints, rate limits, auth, and where keys are configured -->
