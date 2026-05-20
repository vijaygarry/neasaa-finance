# React UX Setup — Neasaa Finance

## Prerequisites

Node.js and npm are required. Verify they are installed:

```bash
node --version
npm --version
```

> This project was set up with Node 24 and npm 11.

---

## Step 1 — Install Key Dependencies

```bash
cd <path to neasaa-finance>/source/components/finance-ux

npm install \
  react-router-dom \
  axios \
  @mui/material @mui/icons-material @emotion/react @emotion/styled
```

| Package | Purpose |
|---|---|
| `react-router-dom` | Client-side routing (multiple pages) |
| `axios` | HTTP calls to your backend APIs |
| `@mui/material` | Ready-made UI components (tables, cards, etc.) |

---

## Step 3 — Run the App

```bash
npm start
```

Opens at `http://localhost:3000`.
