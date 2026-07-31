-- FiveM-Coccion Database Initialization
-- Run this SQL script to create the required table for player cooking data

-- Drop table if it exists (for clean installation)
DROP TABLE IF EXISTS coccion_player_data;

-- Create table for player cooking data
CREATE TABLE coccion_player_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(60) NOT NULL,
    level INT DEFAULT 1,
    experience INT DEFAULT 0,
    UNIQUE (identifier)
);

-- Create index for faster lookups
CREATE INDEX idx_identifier ON coccion_player_data (identifier);

-- Add additional indexes for common queries
CREATE INDEX idx_level ON coccion_player_data (level);
CREATE INDEX idx_experience ON coccion_player_data (experience);

-- Create a view for easy player statistics
CREATE VIEW coccion_player_stats AS
SELECT 
    id,
    identifier,
    level,
    experience,
    (level * 100) as experience_needed_for_next_level,
    (experience - ((level - 1) * 100)) as experience_since_last_level
FROM coccion_player_data;

-- Add some sample data for testing (optional)
INSERT INTO coccion_player_data (identifier, level, experience) VALUES 
('sample_identifier_1', 5, 250),
('sample_identifier_2', 10, 950),
('sample_identifier_3', 1, 0),
('sample_identifier_4', 15, 1600),
('sample_identifier_5', 3, 75);

-- Display success message
SELECT 'FiveM-Coccion database table created successfully!' as message;