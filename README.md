# BetterBudget

<div align="center">
  <img src="logo.png" alt="BetterBudget Logo" width="200">
  <p>
    <b>Fully local personal finance app — now available as a desktop app.</b>
  </p>
  <p>
    No cloud. No subscriptions. No data sharing.<br>
    Your financial data stays on your machine in a single encrypted file.
  </p>

  ![Version](https://img.shields.io/badge/version-1.0.0-green.svg)
  ![Platform](https://img.shields.io/badge/platform-Windows-blue.svg)
  ![Status](https://img.shields.io/badge/status-stable-brightgreen.svg)
  ![License](https://img.shields.io/badge/license-proprietary-red.svg)
  
  <p>
    <a href="docs/ui.md"><b>UI</b></a> &nbsp;|&nbsp;
    <a href="docs/installation.md"><b>Installation</b></a> &nbsp;|&nbsp;
    <a href="docs/troubleshooting.md"><b>Troubleshooting</b></a> &nbsp;|&nbsp;
    <a href="docs/api.md"><b>API Documentation</b></a> &nbsp;|&nbsp;
    <a href="docs/architecture.md"><b>Architecture</b></a> &nbsp;|&nbsp;
    <a href="docs/roadmap.md"><b>Roadmap</b></a>
  </p>
  
</div>

---

## About BetterBudget

BetterBudget is a comprehensive personal finance management platform designed for individuals who demand complete control over their financial data. As a fully local desktop application, all financial information—transactions, accounts, investments, and budgets—remains encrypted on your machine. There are no external dependencies, no cloud storage, and no subscription fees.

Built for modern users who value privacy, reliability, and sophisticated financial tracking, BetterBudget combines powerful analytics, intelligent automation, and enterprise-grade security in an intuitive, offline-first architecture.

---

### Financial Tracking & Visibility
- 📊 **Dashboard** — Income, expenses, savings rate, net worth, cash flow charts, spending breakdowns, recurring cost detection, and recent transactions with date range filters
- 💳 **Transactions** — Paginated list with search, category/type/account/status filters, bulk edit, bulk delete, flag for review, and inline editing
- 🏦 **Accounts** — Checking, savings, credit cards, brokerage, and retirement with asset/liability tracking and custom icons
- 💎 **Net Worth** — Live calculation from accounts, historical snapshots, auto-sync, and what-if projections with retirement planning (401k, IRA, employer match, FIRE number)

### Budgeting & Planning
- 💰 **Budget Management** — Monthly and pay-period views with category limits, rollover support, and budget-aware projections
- 🎯 **Goals** — Financial targets with progress tracking
- 📈 **Investment Tracking** — Portfolio tracking with live price refresh (Yahoo Finance)
- **Recurring Cost Planning** — Automatic recurring expense detection and management
- **Retirement Projector** — Advanced what-if analysis with 401(k), IRA, employer matching, salary growth, and FIRE number calculations

### Intelligent Automation
- 🪄 **Smart Categorization** — Rule engine (exact, contains, starts-with, IF/THEN conditions) with category aliases and ML auto-categorization that learns from your transactions
- **ML Auto-Categorization** — Machine learning–powered transaction classification that learns from your behavior (Naive Bayes)
- 🔁 **Duplicate Detection** — Real-time duplicate flagging during import and historical duplicate scanning
- 🔄 **Transfer Reconciliation** — Internal transfer pairing logic with maintenance reconciliation

### Data Import & Export
- 📥 **Multi-Format Import** — CSV and Excel import with automatic bank format detection (AMEX, USAA, PayPal, Fidelity, Schwab, and generic formats)
- 💾 **Database Export/Import** — Back up and restore your budget data from Preferences

### Enterprise Features
- 👁️ **Privacy Controls** — One-click privacy blur to hide/show monetary amounts; colorblind accessibility modes (protanopia, deuteranopia, tritanopia)
- 🔐 **Offline Licensing** — RSA-4096 encrypted license validation with zero external dependencies; works completely offline after activation
- 🔄 **Auto-Update System** — Built-in update checking and installation for the desktop app (installer version)
- 🌙 **Dark Mode** — System-aware dark theme with professional UI and custom floating scrollbars
- ⚙️ **Configurations** — Fully configurable categories with colors, sorting, aliases, and landing page preferences
- 🏷️ **Categories** — Fully customizable spending categories with colors and aliases

---

## Technology Stack

| Component | Technology |
|-----------|-----------|
| **Frontend** | React 18, Vite, TanStack Query, Tailwind CSS, shadcn/ui, Recharts |
| **Backend** | Node.js 18+, Express, SQLite (sql.js) |
| **Desktop** | Electron, electron-builder (NSIS installer + portable), electron-updater |
| **Analytics** | Natural (Naive Bayes), custom ML pipeline |
| **Security** | RSA-4096 encryption, JavaScript obfuscation, offline license validation |
| **Data Import** | PapaParse (CSV), xlsx (Excel), multer (file handling) |

---

## Installation

**System Requirements:**
- Windows 7 SP1 or later
- 400 MB disk space
- Valid license key required (purchase at [betterbudget.com](https://betterbudget.com))

**Download**
1. **Installer** — `BetterBudget Setup X.Y.Z.exe` — Installs to Program Files with auto-update support

Get the latest release from [BetterBudget Releases](https://github.com/jeremy15n/BetterBudget/releases).
