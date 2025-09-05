Expense Tracker Database Schema (MySQL)

Overview
- Database: myapp (default)
- Tables:
  - categories: id, name, created_at, updated_at
  - expenses: id, amount, category_id, date, description, created_at, updated_at
- Constraints:
  - expenses.category_id -> categories.id (FK, ON UPDATE CASCADE, ON DELETE RESTRICT)
- Indexes:
  - categories.name (unique)
  - expenses.category_id
  - expenses.date
- Charset/Collation: utf8mb4 / utf8mb4_unicode_ci
- Seed data: default categories and sample expenses

Quick Start
1) Start MySQL server (if not already running)
   ./startup.sh

2) Load schema and seed data
   ./load_schema.sh
   or
   mysql -u appuser -pdbuser123 -h localhost -P 5000 myapp < schema.sql

3) Verify
   - List tables:
     mysql -u appuser -pdbuser123 -h localhost -P 5000 -e "USE myapp; SHOW TABLES;"
   - Check seed categories:
     mysql -u appuser -pdbuser123 -h localhost -P 5000 -e "SELECT * FROM myapp.categories;"

Environment Variables (optional overrides)
- DB_NAME (default: myapp)
- DB_USER (default: appuser)
- DB_PASSWORD (default: dbuser123)
- DB_HOST (default: localhost)
- DB_PORT (default: 5000)
- SCHEMA_FILE (default: schema.sql)

Design Notes
- DECIMAL(10,2) is used for amount to avoid floating-point rounding errors.
- dates are stored in DATE column; time-of-day is not required for expense entries.
- utf8mb4 ensures proper Unicode support for descriptions and category names.
- Unique index on categories.name avoids duplicate category names.
- Separate indexes on expenses.category_id and expenses.date to support typical filtering:
  - Filter by category
  - Filter by month/date
  - Monthly aggregations/summaries

Idempotency
- schema.sql drops and recreates tables to ensure repeatability during development.
- Seed INSERTS for categories use ON DUPLICATE KEY UPDATE to avoid duplicate entries.

Backup/Restore
- Use provided scripts:
  - backup_db.sh    -> creates database_backup.sql
  - restore_db.sh   -> restores from database_backup.sql when MySQL is detected

Connection Helper
- A convenient connection command is written to db_connection.txt by startup.sh:
  mysql -u appuser -pdbuser123 -h localhost -P 5000 myapp

Troubleshooting
- If you cannot connect, ensure MySQL is running:
  sudo mysqladmin ping --socket=/var/run/mysqld/mysqld.sock --silent
- If port 5000 is busy, adjust DB_PORT in startup.sh and regenerate db_visualizer/mysql.env, then re-run load_schema.sh with DB_PORT overridden.
