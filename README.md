# FiveM-Coccion

FiveM resource for cooking system supporting ESX and QB-Core frameworks.

## Features

- Multi-framework support (ESX and QB-Core)
- Cooking experience and leveling system
- Recipe management
- Inventory integration
- Localization (English and Spanish)
- Configurable settings

## Installation

1. Place the resource folder in your server's resources directory
2. Add `ensure coccion` to your server.cfg
3. Create the required database table:

```sql
CREATE TABLE IF NOT EXISTS coccion_player_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(60) NOT NULL,
    level INT DEFAULT 1,
    experience INT DEFAULT 0,
    UNIQUE (identifier)
);
```

## Configuration

Edit `config.lua` to customize:

- Framework type (`esx` or `qbcore`)
- Debug mode
- Cooking settings
- Recipes

## Usage

- Press F2 (or bind a key) to open the cooking menu
- Select a recipe to cook
- Required ingredients will be consumed
- Cooked items will be added to your inventory

## API

### Client Exports

```lua
-- Get player cooking data
local playerData = exports['coccion']:GetPlayerData()

-- Get cooking config
local config = exports['coccion']:GetCookingConfig()
```

### Server Exports

```lua
-- Get player cooking data
local playerData = exports['coccion']:GetPlayerCookingData(identifier)

-- Add cooking experience
exports['coccion']:AddCookingExperience(identifier, amount)
```

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License.