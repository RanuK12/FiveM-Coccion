# FiveM-Coccion - Handoff Document

## Phase: B1-F3 (Anti-Cheat + Visuals + Discord Logging)

### Status: ✅ COMPLETED

### What was done:
- ✅ `server/anticheat.lua` — Anti-cheat system with 3 layers:
  - Cooldown check (Config.AntiCheat.CooldownBetweenCooks, default 3000ms) — anti-spam
  - Distance check (Config.AntiCheat.MaxCookingDistance, default 3.0m) — must be near a kitchen marker
  - Server-side ingredient verification — validates inventory before allowing cook
  - Triggers `coccion:cookRejected` with reason on failure, `coccion:cookApproved` on success
- ✅ `server/webhook.lua` — Discord webhook logger:
  - Logs cooking attempts, level ups, and cheat attempts as Discord embeds
  - Configurable via Config.Discord (WebhookURL, toggle per event type, colors)
  - Hooks into `coccion:cookApproved` and `coccion:addExperience`
- ✅ `client/visuals.lua` — Visual effects:
  - **Blips**: 3 cooking locations on the map (Restaurant Kitchen, Vespucci Kitchen, Sandy Shores Diner)
  - **3D Markers**: Cylinder markers at each location, visible within 30m, cyan color, rotate + bob
  - **Help text**: "Press E to open Cooking Menu" when near a kitchen
  - **Animations**: Cooking animation (anim@amb@business@coc@coc_unpack_cut@) with auto-cleanup
  - **Particles**: Smoke + fire during cooking, sparkle burst on completion
  - **E-key proximity**: Triggers `coccion:openMenu` event when E pressed within 2.5m
  - Events: `coccion:startCookingVisuals` / `coccion:stopCookingVisuals(success)`
- ✅ `config.lua` — Added Config.Discord, Config.AntiCheat, Config.Visuals sections
- ✅ `fxmanifest.lua` — Registered client/visuals.lua, server/anticheat.lua, server/webhook.lua

### Files changed this phase:
| File | Change |
|------|--------|
| client/visuals.lua | NEW: 230 lines |
| server/anticheat.lua | NEW: 138 lines |
| server/webhook.lua | NEW: 68 lines |
| config.lua | MODIFIED: +138 lines (Discord + AntiCheat + Visuals sections) |
| fxmanifest.lua | MODIFIED: +3 lines (new scripts) |

### Configuration required by server owner:
1. Set `Config.Discord.WebhookURL` to a real Discord webhook URL (empty = disabled)
2. Adjust `Config.Visuals.Locations` to match actual kitchen coordinates on the server
3. Tune `Config.AntiCheat.CooldownBetweenCooks` and `Config.AntiCheat.MaxCookingDistance` as needed
4. Particle effect names can be changed in `Config.Visuals.Particles` if custom effects are preferred

### How to test:
- Join a FiveM server with the resource installed
- Go to one of the 3 kitchen locations (blips on map, cyan cylinder markers)
- Press E near a kitchen → should open cooking menu (if connected to main client)
- Attempt rapid cooking → should be rejected with cooldown
- Attempt cooking from far away → should be rejected with distance
- Set Discord WebhookURL → check Discord channel for logs
- Check that animations and particles play during cooking

### Next Steps (future phases):
- [ ] Integrate anticheat events with main client cooking flow (coccion:requestCook)
- [ ] Add more cooking locations
- [ ] Add sound effects
- [ ] Implement cooking skill multipliers
- [ ] Add item definitions for ingredients and cooked items

### Branch: ranukita/0110c5
### Repo: github.com/RanuK12/FiveM-Coccion
### Commit: 25ba683