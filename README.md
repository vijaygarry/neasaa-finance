# neasaa-finance
Financial Application from Neasaa

## Setup

### Step 1: Clone the Repository

Create the recommended project folder and clone the repository:

```bash
mkdir -p ~/projects/neasaa
cd ~/projects/neasaa
git clone https://github.com/vijaygarry/neasaa-finance.git neasaa-finance
cd neasaa-finance
```

### Step 2: Configure

Before building, set the required credentials in the following files:

#### `local.properties`

Create a `local.properties` file in the project root and set the local paths:

```properties
neasaaBaseAppPath=/path/to/neasaa-base-app
uxComponentRootPath=/path/to/neasaa-finance/source/components/finance-ux
```

> This file is git-ignored. Set the paths to match your local directory layout.

#### `source/components/finance-app/src/main/config/db.properties`

Set the encrypted database password:

```properties
app.datasource.password=<encrypted-db-password>
```

> The password must be encrypted. Use the same salt key configured in `build.gradle` (see below).

#### `source/components/finance-app/src/main/config/finance.properties`

Set the plain-text email (SMTP) password:

```properties
email.server.password=<email-app-password>
```

#### `source/components/finance-app/build.gradle`

Set the salt key used to encrypt/decrypt the database password:

```groovy
environment 'DB_PASSWORD_ENCRYPTION_SALT_KEY', '<your-salt-key>'
```

> The salt key here must match the one used when encrypting the password stored in `db.properties`.

#### `source/components/database/dbsetup/create-db-user.sql`

Replace the placeholder passwords for the database users (`finance_master`, `finance_app_user`, `replicator`) before running the script. See [docs/db-setup.md](docs/db-setup.md) for details.

---

### Step 3: Database Setup

Complete the database setup by following the instructions in [docs/db-setup.md](docs/db-setup.md).

### Step 3: Build

# Normal build (skips React build — fast)
./gradlew build

# Full build including React UX (slow — use before deploy)
./gradlew build -PbuildReactApp

# Clean + full build + copy to distribution folder
./gradlew clean buildDist -PbuildReactApp

### Step 5: Start the Server

```bash
./gradlew runFinanceApp
```
