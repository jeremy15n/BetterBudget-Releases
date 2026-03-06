# Roadmap

## Completed

### Core Features
- Dashboard with stat cards, cash flow chart, category breakdowns, recurring costs, savings breakdown, and recent transactions
- Transaction management with pagination, search, filters, bulk actions, inline editing, and flagging
- Account management with asset/liability tracking and custom icons
- Monthly budget tracking with category limits and rollover support
- Budget pay-period view with paycheck anchor date
- Investment portfolio tracking with live Yahoo Finance price refresh
- Net worth tracking with historical snapshots and what-if projections
- Net worth projector with retirement planning (401k, IRA, employer match, FIRE number, salary growth, pull from budget)
- Financial goals with progress tracking
- Recurring cost planning records

### Import & Categorization
- CSV/XLSX import with auto-detection for AMEX, USAA, Abound, PayPal, Fidelity, Schwab, and generic CSV
- Smart categorization: rule engine (exact, contains, starts-with, IF/THEN conditions)
- ML auto-categorization (Naive Bayes) that learns from your transactions
- AI prediction review flow with rule creation prompts
- Category aliases for flexible naming
- Always-on duplicate suggestion flagging during import
- Transfer reconciliation for internal account movements
- Legacy/no-account imports

### Desktop App & Distribution
- Electron desktop app (Windows) with NSIS installer and portable exe
- Auto-update system via electron-updater (GitHub Releases)
- Offline RSA-4096 license validation with machine fingerprint
- JavaScript code obfuscation (frontend + backend)
- Three-repo architecture (private source, private web/licensing, public releases)
- Automated release pipeline with `npm run release` and `npm run release:publish`

### User Experience
- Customizable categories with colors and sort order
- Dark mode (system-aware) with custom floating scrollbars
- Colorblind mode support (protanopia, deuteranopia, tritanopia)
- Privacy blur — one-click eye toggle to hide monetary amounts
- Preferences page (landing page, pay frequency, budget view, colorblind mode, auto-sync toggle, currency/number format)
- Database export and import from Preferences
- Recycle bin with soft-delete, restore, and permanent delete
- Delete confirmations for destructive actions
- IRA double-count warnings when pulling from budget
- In-app documentation page
- Auto-sync net worth on startup and daily

## Planned

<!-- Add planned features here -->

## Ideas / Under Consideration

<!-- Add feature ideas here for future consideration -->
