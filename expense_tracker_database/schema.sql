-- Expense Tracker Database Schema (MySQL)
-- This schema creates the database, tables, constraints, indexes, and seed data.
-- It is designed to work with the startup.sh's defaults:
--   DB_NAME: myapp
--   DB_USER: appuser
--   DB_PASSWORD: dbuser123
--   DB_PORT: 5000
--
-- Usage:
--   mysql -u appuser -pdbuser123 -h localhost -P 5000 myapp < schema.sql
--
-- Notes:
-- - Uses utf8mb4 for proper Unicode support.
-- - Adds sensible indexes for querying by category and date.
-- - Adds simple seed data for categories and example expenses.

-- Ensure database exists and set defaults
CREATE DATABASE IF NOT EXISTS `myapp`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `myapp`;

-- Enable strict mode to catch data issues during development
SET sql_mode = 'STRICT_ALL_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO';

-- Drop tables if they exist (optional for idempotent reruns)
-- Note: Drops in FK order to avoid constraint errors
DROP TABLE IF EXISTS `expenses`;
DROP TABLE IF EXISTS `categories`;

-- Categories table
CREATE TABLE `categories` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_categories_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Expenses table
CREATE TABLE `expenses` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `amount` DECIMAL(10,2) NOT NULL CHECK (`amount` >= 0),
  `category_id` INT UNSIGNED NOT NULL,
  `date` DATE NOT NULL,
  `description` VARCHAR(255) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ix_expenses_category_id` (`category_id`),
  KEY `ix_expenses_date` (`date`),
  CONSTRAINT `fk_expenses_category`
    FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed data for categories
INSERT INTO `categories` (`name`) VALUES
  ('Food'),
  ('Transportation'),
  ('Utilities'),
  ('Entertainment'),
  ('Healthcare'),
  ('Education'),
  ('Shopping'),
  ('Travel'),
  ('Rent'),
  ('Other')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Optional: Seed example expenses (uses existing category ids)
-- These are lightweight examples and can be removed safely
INSERT INTO `expenses` (`amount`, `category_id`, `date`, `description`) VALUES
  (12.50, (SELECT id FROM categories WHERE name='Food' LIMIT 1),        CURDATE(),                         'Lunch sandwich'),
  (45.00, (SELECT id FROM categories WHERE name='Transportation' LIMIT 1), DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'Monthly metro card'),
  (89.99, (SELECT id FROM categories WHERE name='Utilities' LIMIT 1),    DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'Electricity bill'),
  (19.99, (SELECT id FROM categories WHERE name='Entertainment' LIMIT 1), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Streaming subscription'),
  (150.00, (SELECT id FROM categories WHERE name='Healthcare' LIMIT 1),  DATE_SUB(CURDATE(), INTERVAL 10 DAY), 'Dental checkup')
;
