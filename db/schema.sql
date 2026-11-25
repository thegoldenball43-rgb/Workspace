-- Evolve Neo Studio Workspace — Relational SQLite / Cloudflare D1 Schema
-- Designed for strict financial integrity, immutable project codes, and audit logging.

CREATE TABLE IF NOT EXISTS clients (
  id TEXT PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  contact TEXT DEFAULT '',
  email TEXT DEFAULT '',
  phone TEXT DEFAULT '',
  country TEXT DEFAULT '',
  address TEXT DEFAULT '',
  currency TEXT NOT NULL DEFAULT 'USD',
  business_type TEXT DEFAULT '',
  website TEXT DEFAULT '',
  status TEXT NOT NULL DEFAULT 'active',
  notes TEXT DEFAULT '',
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS projects (
  id TEXT PRIMARY KEY,
  code TEXT NOT NULL UNIQUE, -- Immutable EVN-YYYY-NNNN
  client_id TEXT NOT NULL REFERENCES clients(id),
  name TEXT NOT NULL,
  service TEXT NOT NULL, -- branding | social | web
  status TEXT NOT NULL DEFAULT 'new',
  priority INTEGER NOT NULL DEFAULT 2,
  start_date TEXT DEFAULT '',
  deadline TEXT DEFAULT '',
  deadline_confirmed INTEGER NOT NULL DEFAULT 0,
  budget_minor INTEGER NOT NULL DEFAULT 0,
  currency TEXT NOT NULL DEFAULT 'USD',
  scope TEXT DEFAULT '',
  confirmed_info TEXT DEFAULT '',
  missing_info TEXT DEFAULT '',
  decision_needed TEXT DEFAULT '',
  pending_reply TEXT DEFAULT '',
  links TEXT DEFAULT '',
  notes TEXT DEFAULT '',
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS tasks (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL REFERENCES projects(id),
  title TEXT NOT NULL,
  priority INTEGER NOT NULL DEFAULT 2,
  status TEXT NOT NULL DEFAULT 'new',
  due_date TEXT DEFAULT '',
  deadline_confirmed INTEGER NOT NULL DEFAULT 0,
  notes TEXT DEFAULT '',
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS invoices (
  id TEXT PRIMARY KEY,
  number TEXT NOT NULL UNIQUE,
  status TEXT NOT NULL DEFAULT 'draft', -- draft | issued | sent | void
  language TEXT NOT NULL DEFAULT 'en',  -- en (default) | ar
  client_id TEXT REFERENCES clients(id),
  project_id TEXT REFERENCES projects(id),
  issue_date TEXT NOT NULL,
  due_date TEXT DEFAULT '',
  currency TEXT NOT NULL DEFAULT 'USD',
  local_currency TEXT DEFAULT 'EGP',
  local_amount_minor INTEGER,
  discount_type TEXT NOT NULL DEFAULT 'fixed',
  discount_value REAL NOT NULL DEFAULT 0,
  tax_rate REAL NOT NULL DEFAULT 0,
  tax_mode TEXT NOT NULL DEFAULT 'exclusive',
  tax_label TEXT DEFAULT 'VAT',
  items_json TEXT NOT NULL,
  frozen_snapshot_json TEXT, -- Locked upon issuance to guarantee identical archived PDFs
  issued_at TEXT DEFAULT '',
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS payments (
  id TEXT PRIMARY KEY,
  invoice_id TEXT NOT NULL REFERENCES invoices(id),
  payment_date TEXT NOT NULL,
  amount_minor INTEGER NOT NULL,
  currency TEXT NOT NULL,
  method TEXT NOT NULL,
  reference TEXT DEFAULT '',
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS credit_notes (
  id TEXT PRIMARY KEY,
  invoice_id TEXT NOT NULL REFERENCES invoices(id),
  number TEXT NOT NULL UNIQUE,
  issue_date TEXT NOT NULL,
  amount_minor INTEGER NOT NULL,
  reason TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS contracts (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL REFERENCES clients(id),
  project_id TEXT REFERENCES projects(id),
  title TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT 'Contract',
  status TEXT NOT NULL DEFAULT 'draft',
  version TEXT NOT NULL DEFAULT 'v1.0',
  signed_date TEXT DEFAULT '',
  r2_object_key TEXT DEFAULT '', -- Private R2 object key (never public URL)
  notes TEXT DEFAULT '',
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS expenses (
  id TEXT PRIMARY KEY,
  project_id TEXT REFERENCES projects(id),
  title TEXT NOT NULL,
  amount_minor INTEGER NOT NULL,
  currency TEXT NOT NULL DEFAULT 'USD',
  expense_date TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS audit_logs (
  id TEXT PRIMARY KEY,
  actor TEXT NOT NULL DEFAULT 'owner',
  event_type TEXT NOT NULL,
  summary_ar TEXT NOT NULL,
  summary_en TEXT NOT NULL,
  created_at TEXT NOT NULL
);
