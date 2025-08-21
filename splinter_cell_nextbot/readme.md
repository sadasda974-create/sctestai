\# Splinter Cell NextBot



An advanced tactical AI NextBot for Garry's Mod inspired by Splinter Cell agents. Features sophisticated stealth-based behaviors, environmental manipulation, and psychological operations.



\## Features



\### 🎯 Advanced AI States

\- \*\*Idle/Recon\*\*: Silent patrolling in shadows, gathering intelligence

\- \*\*Investigate\*\*: Moving toward sound/light sources with tactical awareness

\- \*\*Stalking\*\*: Tracking targets from cover while maintaining stealth

\- \*\*Ambush\*\*: Executing silent takedowns when opportunity arises

\- \*\*Engage Suppressed\*\*: Firing from cover with suppressed weapons

\- \*\*Retreat/Reset\*\*: Breaking contact and repositioning tactically

\# Splinter Cell NextBot



An advanced tactical AI NextBot for Garry's Mod inspired by Splinter Cell agents. Features sophisticated stealth-based behaviors, environmental manipulation, and psychological operations.



\## Features



\### 🎯 Advanced AI States

\- \*\*Idle/Recon\*\*: Silent patrolling in shadows, gathering intelligence

\- \*\*Investigate\*\*: Moving toward sound/light sources with tactical awareness

\- \*\*Stalking\*\*: Tracking targets from cover while maintaining stealth

\- \*\*Ambush\*\*: Executing silent takedowns when opportunity arises

\- \*\*Engage Suppressed\*\*: Firing from cover with suppressed weapons

\- \*\*Retreat/Reset\*\*: Breaking contact and repositioning tactically



\### 🌟 Stealth Mechanics

\- \*\*Dynamic Stealth System\*\*: Stealth level changes based on lighting and exposure

\- \*\*Shadow Preference\*\*: AI actively seeks dark areas and avoids bright lights

\- \*\*Light Manipulation\*\*: Automatically disables nearby light sources

\- \*\*Silent Movement\*\*: Reduced detection radius when moving slowly

\- \*\*Environmental Awareness\*\*: Uses cover and concealment effectively



\### 🎮 Interactive Features

\- \*\*Tactical HUD Display\*\*: Shows AI state, objectives, and stealth level to nearby players

\- \*\*Psychological Operations\*\*: Whisper messages and screen effects for nearby players

\- \*\*Environmental Control\*\*: Manipulates props and lighting for tactical advantage

\- \*\*Sound Distractions\*\*: Creates noise to mask movement and confuse targets



\### ⚙️ Technical Features

\- \*\*Advanced Pathfinding\*\*: Uses GMod's navmesh system with intelligent fallbacks

\- \*\*Multi-State AI\*\*: Complex state machine with dynamic transitions

\- \*\*Network Optimization\*\*: Efficient client-server communication

\- \*\*Performance Optimized\*\*: Intelligent update cycles to minimize server load



\## Installation



1\. Extract the `splinter\_cell\_nextbot` folder to your `garrysmod/addons/` directory

2\. Restart your server or use `lua\_run` to reload

3\. The NextBot will appear in the \*\*NPCs\*\* tab in your spawn menu



\## File Structure



```

splinter\_cell\_nextbot/

├── addon.txt                                    # Addon information

└── lua/

&nbsp;   └── entities/

&nbsp;       └── nextbot\_splinter\_cell/

&nbsp;           ├── shared.lua                        # Shared entity definition

&nbsp;           ├── init.lua                          # Server-side AI logic

&nbsp;           └── cl\_init.lua                       # Client-side effects

```



\## Configuration



\### Tactical Configuration (in init.lua)

```lua

local TACTICAL\_CONFIG = {

&nbsp;   STEALTH\_RADIUS = 800,           -- Detection radius for stealth operations

&nbsp;   ENGAGEMENT\_RANGE = 400,         -- Optimal engagement distance

&nbsp;   TAKEDOWN\_RANGE = 100,          -- Range for silent takedowns

&nbsp;   RETREAT\_HEALTH = 50,            -- Health threshold to trigger retreat

&nbsp;   SHADOW\_PREFERENCE = 0.8,        -- Preference for dark areas (0-1)

&nbsp;   PATIENCE\_TIMER = 5,             -- Seconds to wait before changing tactics

&nbsp;   SMOKE\_COOLDOWN = 15,            -- Cooldown between smoke deployments

&nbsp;   LIGHT\_DISABLE\_RANGE = 300,      -- Range to disable light sources

&nbsp;   WHISPER\_RADIUS = 200,           -- Range for psychological operations

&nbsp;   FLASH\_RANGE = 150               -- Range for flashbang effects

}

```



\## Usage



\### Spawning

1\. Open the spawn menu (Q by default)

2\. Navigate to the \*\*NPCs\*\* tab

3\. Find "Splinter Cell Operative" in the list

4\. Click to spawn



\### Interaction

\- \*\*Get Close\*\*: Approach the NextBot to see its tactical information display

\- \*\*Make Noise\*\*: Move quickly, shoot weapons, or make sounds to trigger investigation

\- \*\*Stay in Light\*\*: Remaining in well-lit areas reduces the NextBot's stealth effectiveness

\- \*\*Use Cover\*\*: The NextBot will try to outmaneuver you using environmental cover



\## AI Behavior Guide



\### Detection System

The NextBot detects players based on:

\- \*\*Movement Speed\*\*: Faster movement increases detection chance

\- \*\*Weapon Fire\*\*: Shooting weapons immediately alerts the AI

\- \*\*Distance\*\*: Closer proximity increases detection probability

\- \*\*Line of Sight\*\*: Direct visual contact triggers aggressive behavior



\### Stealth Mechanics

\- \*\*Light Level\*\*: AI performs better in dark areas

\- \*\*Cover Usage\*\*: Actively seeks positions with good cover

\- \*\*Noise Discipline\*\*: Moves quietly and creates distractions

\- \*\*Environmental Control\*\*: Manipulates lights and props



\### Combat Behavior

\- \*\*Silent Takedowns\*\*: Attempts non-lethal takedowns when possible

\- \*\*Suppressed Fire\*\*: Uses quiet weapons to maintain stealth

\- \*\*Tactical Retreat\*\*: Withdraws when compromised or injured

\- \*\*Smoke Deployment\*\*: Uses smoke grenades to break contact



\## Client-Side Effects



\### Visual Effects

\- \*\*Stealth Particles\*\*: Blue glowing particles when highly stealthy

\- \*\*Tactical Display\*\*: 3D HUD showing AI state and objectives

\- \*\*Flash Effects\*\*: Screen distortion when using night vision

\- \*\*Stealth Indicator\*\*: Real-time stealth level visualization



\### Audio Effects

\- \*\*Whisper System\*\*: Psychological messages delivered to nearby players

\- \*\*Suppressed Gunfire\*\*: Realistic silenced weapon sounds

\- \*\*Environmental Audio\*\*: Footsteps and movement sounds



\## Compatibility



\### Requirements

\- \*\*Garry's Mod\*\*: Latest version recommended

\- \*\*Server/Client\*\*: Works on both dedicated servers and singleplayer

\- \*\*Map Compatibility\*\*: Works on all maps (navmesh enhances but not required)



\### Optional Integration

\- \*\*DRGBase\*\*: Enhanced display integration if DRGBase is present

\- \*\*Custom Maps\*\*: Performs better on maps with proper navmesh generation



\## Troubleshooting



\### Common Issues



\*\*NextBot appears in Entities instead of NPCs\*\*

\- Ensure `shared.lua` has `ENT.Type = "nextbot"`

\- Restart the server or reload the addon



\*\*Movement errors or stuck behavior\*\*

\- Check console for Path API errors

\- Ensure the map has proper navmesh generation

\- Try `nav\_generate` in console for better pathfinding



\*\*Client effects not working\*\*

\- Verify all files are properly uploaded to clients

\- Check network string registration in `init.lua`



\### Performance Issues

If experiencing lag:

\- Reduce `TACTICAL\_CONFIG` detection ranges

\- Increase AI update intervals in the timer

\- Limit the number of simultaneous NextBots



\## Customization



\### Modifying AI Behavior

Edit the tactical configuration in `init.lua` to adjust:

\- Detection ranges and sensitivity

\- Stealth mechanics and light preferences

\- Combat engagement rules

\- Retreat and reset conditions



\### Adding New States

To add custom AI states:

1\. Add new state to `AI\_STATES` table

2\. Implement state logic in `ExecuteTacticalAI()`

3\. Add transition conditions in `UpdateTacticalState()`

4\. Update client display in `cl\_init.lua`



\### Custom Models

To use different models:

1\. Change `ENT.Model` in `shared.lua`

2\. Update collision bounds in `Initialize()`

3\. Adjust animation sequences if needed



\## Credits



\- \*\*Development\*\*: AI Assistant

\- \*\*Framework\*\*: Based on Garry's Mod NextBot system

\- \*\*Inspiration\*\*: Splinter Cell series stealth mechanics

\- \*\*Testing\*\*: Community feedback and iteration



\## License



This addon is provided as-is for educational and entertainment purposes. Feel free to modify and distribute while maintaining attribution.



\## Changelog



\### Version 1.0

\- Initial release with full stealth AI system

\- Advanced pathfinding and movement

\- Client-side effects and HUD

\- Psychological operations system

\- Environmental manipulation features



---



\*\*Enjoy your tactical stealth operations!\*\*



\## Support



For issues, suggestions, or contributions:

\- Check the console for error messages

\- Verify all files are properly installed

\- Test on maps with good navmesh coverage

\- Report bugs with detailed reproduction steps



\### Console Commands

Useful commands for debugging:

```

nav\_generate          // Generate navmesh for current map

nav\_edit 1            // Enable navmesh editing

ent\_fire nextbot\_\*    // Target all Splinter Cell NextBots

developer 1           // Enable developer console messages

```



\### Advanced Configuration

For server administrators, you can modify the NextBot's behavior by editing the `TACTICAL\_CONFIG` table in `init.lua`. Common adjustments:



\*\*Make More Aggressive:\*\*

```lua

STEALTH\_RADIUS = 1200,     -- Larger detection range

PATIENCE\_TIMER = 2,        -- Less patience before state change

RETREAT\_HEALTH = 25,       -- Fight longer before retreating

```



\*\*Make More Stealthy:\*\*

```lua

STEALTH\_RADIUS = 400,      -- Smaller detection range

SHADOW\_PREFERENCE = 0.9,   -- Higher preference for darkness

WHISPER\_RADIUS = 300,      -- Larger psychological range

```



\*\*Performance Optimization:\*\*

```lua

STEALTH\_RADIUS = 600,      -- Moderate detection range

LIGHT\_DISABLE\_RANGE = 200, -- Smaller light manipulation range

```



Remember to restart the server or reload the addon after making changes to see the effects.

\### 🌟 Stealth Mechanics

\- \*\*Dynamic Stealth System\*\*: Stealth level changes based on lighting and exposure

\- \*\*Shadow Preference\*\*: AI actively seeks dark areas and avoids bright lights

\- \*\*Light Manipulation\*\*: Automatically disables nearby light sources

\- \*\*Silent Movement\*\*: Reduced detection radius when moving slowly

\- \*\*Environmental Awareness\*\*: Uses cover and concealment effectively



\### 🎮 Interactive Features

\- \*\*Tactical HUD Display\*\*: Shows AI state, objectives, and stealth level to nearby players

\- \*\*Psychological Operations\*\*: Whisper messages and screen effects for nearby players

\- \*\*Environmental Control\*\*: Manipulates props and lighting for tactical advantage

\- \*\*Sound Distractions\*\*: Creates noise to mask movement and confuse targets



\### ⚙️ Technical Features

\- \*\*Advanced Pathfinding\*\*: Uses GMod's navmesh system with intelligent fallbacks

\- \*\*Multi-State AI\*\*: Complex state machine with dynamic transitions

\- \*\*Network Optimization\*\*: Efficient client-server communication

\- \*\*Performance Optimized\*\*: Intelligent update cycles to minimize server load



\## Installation



1\. Extract the `splinter\_cell\_nextbot` folder to your `garrysmod/addons/` directory

2\. Restart your server or use `lua\_run` to reload

3\. The NextBot will appear in the \*\*NPCs\*\* tab in your spawn menu



\## File Structure



```

splinter\_cell\_nextbot/

├── addon.txt                                    # Addon information

└── lua/

&nbsp;   └── entities/

&nbsp;       └── nextbot\_splinter\_cell/

&nbsp;           ├── shared.lua                        # Shared entity definition

&nbsp;           ├── init.lua                          # Server-side AI logic

&nbsp;           └── cl\_init.lua                       # Client-side effects

```



\## Configuration



\### Tactical Configuration (in init.lua)

```lua

local TACTICAL\_CONFIG = {

&nbsp;   STEALTH\_RADIUS = 800,           -- Detection radius for stealth operations

&nbsp;   ENGAGEMENT\_RANGE = 400,         -- Optimal engagement distance

&nbsp;   TAKEDOWN\_RANGE = 100,          -- Range for silent takedowns

&nbsp;   RETREAT\_HEALTH = 50,            -- Health threshold to trigger retreat

&nbsp;   SHADOW\_PREFERENCE = 0.8,        -- Preference for dark areas (0-1)

&nbsp;   PATIENCE\_TIMER = 5,             -- Seconds to wait before changing tactics

&nbsp;   SMOKE\_COOLDOWN = 15,            -- Cooldown between smoke deployments

&nbsp;   LIGHT\_DISABLE\_RANGE = 300,      -- Range to disable light sources

&nbsp;   WHISPER\_RADIUS = 200,           -- Range for psychological operations

&nbsp;   FLASH\_RANGE = 150               -- Range for flashbang effects

}

```



\## Usage



\### Spawning

1\. Open the spawn menu (Q by default)

2\. Navigate to the \*\*NPCs\*\* tab

3\. Find "Splinter Cell Operative" in the list

4\. Click to spawn



\### Interaction

\- \*\*Get Close\*\*: Approach the NextBot to see its tactical information display

\- \*\*Make Noise\*\*: Move quickly, shoot weapons, or make sounds to trigger investigation

\- \*\*Stay in Light\*\*: Remaining in well-lit areas reduces the NextBot's stealth effectiveness

\- \*\*Use Cover\*\*: The NextBot will try to outmaneuver you using environmental cover



\## AI Behavior Guide



\### Detection System

The NextBot detects players based on:

\- \*\*Movement Speed\*\*: Faster movement increases detection chance

\- \*\*Weapon Fire\*\*: Shooting weapons immediately alerts the AI

\- \*\*Distance\*\*: Closer proximity increases detection probability

\- \*\*Line of Sight\*\*: Direct visual contact triggers aggressive behavior



\### Stealth Mechanics

\- \*\*Light Level\*\*: AI performs better in dark areas

\- \*\*Cover Usage\*\*: Actively seeks positions with good cover

\- \*\*Noise Discipline\*\*: Moves quietly and creates distractions

\- \*\*Environmental Control\*\*: Manipulates lights and props



\### Combat Behavior

\- \*\*Silent Takedowns\*\*: Attempts non-lethal takedowns when possible

\- \*\*Suppressed Fire\*\*: Uses quiet weapons to maintain stealth

\- \*\*Tactical Retreat\*\*: Withdraws when compromised or injured

\- \*\*Smoke Deployment\*\*: Uses smoke grenades to break contact



\## Client-Side Effects



\### Visual Effects

\- \*\*Stealth Particles\*\*: Blue glowing particles when highly stealthy

\- \*\*Tactical Display\*\*: 3D HUD showing AI state and objectives

\- \*\*Flash Effects\*\*: Screen distortion when using night vision

\- \*\*Stealth Indicator\*\*: Real-time stealth level visualization



\### Audio Effects

\- \*\*Whisper System\*\*: Psychological messages delivered to nearby players

\- \*\*Suppressed Gunfire\*\*: Realistic silenced weapon sounds

\- \*\*Environmental Audio\*\*: Footsteps and movement sounds



\## Compatibility



\### Requirements

\- \*\*Garry's Mod\*\*: Latest version recommended

\- \*\*Server/Client\*\*: Works on both dedicated servers and singleplayer

\- \*\*Map Compatibility\*\*: Works on all maps (navmesh enhances but not required)



\### Optional Integration

\- \*\*DRGBase\*\*: Enhanced display integration if DRGBase is present

\- \*\*Custom Maps\*\*: Performs better on maps with proper navmesh generation



\## Troubleshooting



\### Common Issues



\*\*NextBot appears in Entities instead of NPCs\*\*

\- Ensure `shared.lua` has `ENT.Type = "nextbot"`

\- Restart the server or reload the addon



\*\*Movement errors or stuck behavior\*\*

\- Check console for Path API errors

\- Ensure the map has proper navmesh generation

\- Try `nav\_generate` in console for better pathfinding



\*\*Client effects not working\*\*

\- Verify all files are properly uploaded to clients

\- Check network string registration in `init.lua`



\### Performance Issues

If experiencing lag:

\- Reduce `TACTICAL\_CONFIG` detection ranges

\- Increase AI update intervals in the timer

\- Limit the number of simultaneous NextBots



\## Customization



\### Modifying AI Behavior

Edit the tactical configuration in `init.lua` to adjust:

\- Detection ranges and sensitivity

\- Stealth mechanics and light preferences

\- Combat engagement rules

\- Retreat and reset conditions



\### Adding New States

To add custom AI states:

1\. Add new state to `AI\_STATES` table

2\. Implement state logic in `ExecuteTacticalAI()`

3\. Add transition conditions in `UpdateTacticalState()`

4\. Update client display in `cl\_init.lua`



\### Custom Models

To use different models:

1\. Change `ENT.Model` in `shared.lua`

2\. Update collision bounds in `Initialize()`

3\. Adjust animation sequences if needed



\## Credits



\- \*\*Development\*\*: AI Assistant

\- \*\*Framework\*\*: Based on Garry's Mod NextBot system

\- \*\*Inspiration\*\*: Splinter Cell series stealth mechanics

\- \*\*Testing\*\*: Community feedback and iteration



\## License



This addon is provided as-is for educational and entertainment purposes. Feel free to modify and distribute while maintaining attribution.



\## Changelog



\### Version 1.0

\- Initial release with full stealth AI system

\- Advanced pathfinding and movement

\- Client-side effects and HUD

\- Psychological operations system

\- Environmental manipulation features



---



\*\*Enjoy your tactical stealth operations!\*\*



\## Support



For issues, suggestions, or contributions:

\- Check the console for error messages

\- Verify all files are properly installed

\- Test on maps with good navmesh coverage

\- Report bugs with detailed reproduction steps



\### Console Commands

Useful commands for debugging:

```

nav\_generate          // Generate navmesh for current map

nav\_edit 1            // Enable navmesh editing

ent\_fire nextbot\_\*    // Target all Splinter Cell NextBots

developer 1           // Enable developer console messages

```



\### Advanced Configuration

For server administrators, you can modify the NextBot's behavior by editing the `TACTICAL\_CONFIG` table in `init.lua`. Common adjustments:



\*\*Make More Aggressive:\*\*

```lua

STEALTH\_RADIUS = 1200,     -- Larger detection range

PATIENCE\_TIMER = 2,        -- Less patience before state change

RETREAT\_HEALTH = 25,       -- Fight longer before retreating

```



\*\*Make More Stealthy:\*\*

```lua

STEALTH\_RADIUS = 400,      -- Smaller detection range

SHADOW\_PREFERENCE = 0.9,   -- Higher preference for darkness

WHISPER\_RADIUS = 300,      -- Larger psychological range

```



\*\*Performance Optimization:\*\*

```lua

STEALTH\_RADIUS = 600,      -- Moderate detection range

LIGHT\_DISABLE\_RANGE = 200, -- Smaller light manipulation range

```



Remember to restart the server or reload the addon after making changes to see the effects.

