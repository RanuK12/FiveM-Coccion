-- FiveM-Coccion Database Initialization
-- Safe for production: uses CREATE TABLE IF NOT EXISTS, no DROP TABLE, no sample data.

-- Create table for player cooking data (non-destructive)
CREATE TABLE IF NOT EXISTS coccion_player_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(60) NOT NULL,
    level INT DEFAULT 1,
    experience INT DEFAULT 0,
    UNIQUE (identifier)
);

-- Create index for faster lookups by identifier
CREATE INDEX IF NOT EXISTS idx_identifier ON coccion_player_data (identifier);

-- Create index for level-based queries
CREATE INDEX IF NOT EXISTS idx_level ON coccion_player_data (level);
