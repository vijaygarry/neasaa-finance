# Database Setup Guide

## Overview

All scripts referenced below are located in [source/components/database/](../source/components/database/).

---

## Step 1 — Create database users and roles

Before running the script, open `source/components/database/dbsetup/create-db-user.sql` and replace the placeholder passwords for users `finance_master`, `finance_app_user`, `replicator`.
Contact administrator to get the right password.

Then run the script:

```
source/components/database/dbsetup/create-db-user.sql
```

## Step 2 — Create the database

Once users and roles are created, run the database creation script:

```
source/components/database/dbsetup/create-db.sql
```

## Step 3 — Set up the schema

Choose one of the following options depending on your setup scenario.

### Option A: Fresh setup

Use this when setting up the schema for the first time.

#### 3a. Create the schema structure

Apply the schema, table and object structure:

```
source/components/database/schema/schema.sql
source/components/database/schema/asset-schema.sql
```

#### 3b. Set up permissions

Apply the required database permission grants:

```
source/components/database/dbsetup/grants.sql
```

#### 3c. Insert application metadata

Load the initial application data:

```
source/components/database/data/data.sql
source/components/database/data/asset-data.sql
```

### Option B: Restore from existing dump

Use this when importing an existing schema (e.g. from a production dump). Restore the dump directly into the database:

```bash
psql -U <db_user> -d <db_name> < /path/to/prod_dump.sql
```

> The dump already contains the schema structure and data, so running `create-db.sql`, `schema.sql`, or `data.sql` separately is not required.

---

## Script Reference

| Script | Location | Purpose |
|--------|----------|---------|
| `create-db.sql` | `dbsetup/` | Creates the database |
| `create-db-user.sql` | `dbsetup/` | Creates DB users and roles |
| `grants.sql` | `dbsetup/` | Applies permission grants |
| `schema.sql` | `schema/` | Creates core tables and schema objects |
| `asset-schema.sql` | `schema/` | Creates asset tables and schema objects |
| `data.sql` | `data/` | Inserts core application reference data |
| `asset-data.sql` | `data/` | Inserts asset type, industry, and seed asset data |
