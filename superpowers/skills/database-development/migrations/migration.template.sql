-- Migration: [Description]
-- Created: [Date]
-- Author: [Author]

-- Enable transaction for safety
BEGIN;

-- Add new table
CREATE TABLE [table_name] (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    -- Add columns here
);

-- Add indexes if needed
CREATE INDEX [index_name] ON [table_name]([column_name]);

-- Add foreign key constraints
ALTER TABLE [table_name]
ADD CONSTRAINT [constraint_name]
FOREIGN KEY ([column_name])
REFERENCES [other_table]([column_name]);

-- Add columns to existing tables
ALTER TABLE [existing_table]
ADD COLUMN [column_name] [type] [constraints];

-- Update timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_[table_name]_updated_at
BEFORE UPDATE ON [table_name]
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

COMMIT;

-- Rollback script (keep for reference):
-- BEGIN;
-- DROP TABLE IF EXISTS [table_name];
-- ALTER TABLE [existing_table] DROP COLUMN [column_name];
-- COMMIT;