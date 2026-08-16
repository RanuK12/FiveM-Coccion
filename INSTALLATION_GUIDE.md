# FiveM-Coccion Installation Guide

## ✅ Requirements
- **FiveM Server**
- **ESX Framework** (1.2+) or **QB-Core Framework** (3.0+)
- **ox_lib** (3.0+, optional for progress bar)
- **Database** (MySQL)

## 🛠️ Step-by-Step Installation

1. **Download the Resource**
   - Purchase from [Tebex](https://ranuk.dev/fivem-coccion) and download the `.zip` file.
   - Extract the zip file and rename the folder to `coccion`.

2. **Place in Resources Folder**
   - Move the `coccion` folder to your FiveM server's `resources` directory.
   - Ensure the path is: `resources/coccion/`.

3. **Edit server.cfg**
   - Add the following line to your `server.cfg`:
     ```
     ensure coccion
     ```

4. **Database Setup**
   - Execute the SQL script `sql/init.sql` in your MySQL database.
   - This creates the `coccion_player_data` table and sample data.

5. **Configure Framework**
   - Open `config.lua` and set `Config.Framework` to `'esx'` or `'qbcore'`.
   - Adjust `Config.Discord.WebhookURL` if you want logging.

6. **Start the Server**
   - Restart your FiveM server to load the resource.

## 📦 Release Package

The release package includes:
- `client/` - Client-side scripts and visuals
- `server/` - Server-side logic and database handling
- `shared/` - Shared constants and utilities
- `sql/` - Database initialization scripts
- `config.lua` - Configuration options
- `fxmanifest.lua` - Resource manifest

## 🧪 Verified SQL Script

The `sql/init.sql` script:
- Creates `coccion_player_data` table with proper indexes
- Includes sample data for testing
- Uses safe `DROP TABLE IF EXISTS` to prevent errors
- Creates views for player statistics

All files are correctly declared in `fxmanifest.lua`:
- Client: `client/*.lua`, `client/*.yml`, `client/*.sc`
- Server: `server/*.lua`, `data/*.lua`