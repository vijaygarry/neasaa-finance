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

### Step 2: Database Setup

Complete the database setup by following the instructions in [docs/db-setup.md](docs/db-setup.md).

### Step 3: Build

# Normal build (skips React build — fast)
./gradlew build

# Full build including React UX (slow — use before deploy)
./gradlew build -PbuildReactApp
