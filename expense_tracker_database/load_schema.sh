#!/bin/bash
# Load the Expense Tracker schema into the MySQL instance configured by startup.sh

set -euo pipefail

DB_NAME="${DB_NAME:-myapp}"
DB_USER="${DB_USER:-appuser}"
DB_PASSWORD="${DB_PASSWORD:-dbuser123}"
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5000}"
SCHEMA_FILE="${SCHEMA_FILE:-schema.sql}"

if [ ! -f "$SCHEMA_FILE" ]; then
  echo "Schema file '$SCHEMA_FILE' not found. Make sure schema.sql is present."
  exit 1
fi

echo "Loading schema into MySQL..."
echo "  Host: $DB_HOST"
echo "  Port: $DB_PORT"
echo "  DB:   $DB_NAME"
echo "  User: $DB_USER"
echo ""

mysql -u "$DB_USER" -p"$DB_PASSWORD" -h "$DB_HOST" -P "$DB_PORT" "$DB_NAME" < "$SCHEMA_FILE"

echo "✓ Schema loaded successfully."
