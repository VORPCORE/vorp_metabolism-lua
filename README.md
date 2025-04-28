# VORP Metabolism and Consumables Script

## Overview

This script integrates a metabolism system into your RedM server, allowing players to manage their **thirst**, **hunger**, and **metabolism**. Additionally, it allows players to consume items that affect these stats, such as food and beverages. The script also provides support for visual effects (like being drunk) when consuming certain items.

## New Design

<img alt="image" height="450" src="https://github.com/user-attachments/assets/6ec829ac-112d-4c90-86f5-78c34cc56775">
<img alt="image" height="450" src="https://github.com/user-attachments/assets/29dbda2f-2354-4425-adf9-0f7c3251a700">

__Hud redesigned by Z-eus__

## Features

- **Metabolism System**: Manages hunger, thirst, and metabolism stats, with configurable rates for each.
- **Consumable Items**: Items such as food and drinks that restore thirst, hunger, and stamina.
- **Effects System**: Allows application of visual effects (e.g., `PlayerDrunkSaloon1`) when players consume certain items.
- **Configurable Animations**: Each consumable has its associated animation drink/coffee/eat/stew/syringe/bandage
- **Give Back Item:** Item given back to the player after consumable

## Configuration

The following are key settings that control the metabolism system:

```lua
Lang = "en"                                 -- Language of the script.

UseMetabolism = true                        -- Enable/disable the metabolism system.

EveryTimeStatusDown = 3600                  -- Interval in milliseconds for the status drop (3.6 seconds).
HowAmountThirstWhileRunning = 3             -- How much thirst drops when running.
HowAmountHungerWhileRunning = 2             -- How much hunger drops when running.
HowAmountThirst = 2                         -- How much thirst drops while idle.
HowAmountHunger = 1                         -- How much hunger drops while idle.
HowAmountMetabolismWhileRunning = 4         -- How much metabolism decreases while running.
HowAmountMetabolism = 2                     -- How much metabolism decreases while idle.

FirstHungerStatus = 1000                    -- Initial hunger value (full).
FirstThirstStatus = 1000                    -- Initial thirst value (full).

OnRespawnHungerStatus = 1000                -- Hunger status after respawning.
OnRespawnThirstStatus = 1000                -- Thirst status after respawning.
FirstMetabolismStatus = 0                   -- Initial metabolism status.


### How to Add Consumable Items

To add a new consumable item, follow this structure:

```lua
{
    Name = "item_spawn_code",            -- The spawn code/identifier of the item.
    Thirst = 500,                        -- How much thirst this item replenishes (set to 0 if no thirst is restored).
    Hunger = 100,                        -- How much hunger this item replenishes.
    Metabolism = 150,                    -- How much metabolism is affected.
    Stamina = 50,                        -- How much stamina is restored.
    InnerCoreHealth = 50,                -- How much inner core health is affected.
    OuterCoreHealth = 25,                -- How much outer core health is affected.
    PropName = "prop_name",              -- The in-game prop to display while using the item.
    Animation = "animation",             -- The animation the player will use when consuming this item drink/coffee/eat/stew/syringe/bandage
    Effect = "effect_name",              -- (Optional) Any visual effect applied when consuming the item.
    EffectDuration = 1,                  -- (Optional) Duration of the effect in minutes.
    GiveBackItemLabel = "item_label",    -- The display name of the GiveBackItem.
    GiveBackItem = "item_spawn_code",    -- The item given back to the player after using (e.g., an empty bottle after drinking whisky). (If you dont want just leave blank GiveBackItem = "")
    GiveBackItemAmount = 1               -- The amount of given back item
}
```

### Example:
```lua
{
    Name = "whisky",
    Thirst = 500,
    Hunger = 0,
    Metabolism = 150,
    Stamina = 50,
    InnerCoreHealth = 50,
    OuterCoreHealth = 25,
    PropName = "s_inv_whiskey02x",
    Animation = "drink",
    Effect = "PlayerDrunkSaloon1",      -- Visual drunk effect
    EffectDuration = 1,                 -- Effect lasts 1 minute
    GiveBackItemLabel = "Empty Bottle",
    GiveBackItem = "empty_bottle",
    GiveBackItemAmount = 1
}
```

### **Important**: Ensure the Item is Added to the Database

You must make sure the item you're adding to the `config.lua` is also added to your **items table in the database**. This ensures that the item can be properly used in-game.

For example, if you're using VORP as your framework, ensure that the item exists in the `items` table in your MySQL or SQLite database with the same `item` (spawn code) as defined in the configuration.

### Adding Visual Effects

The `Effect` and `EffectDuration` fields can be used to add visual effects when consuming an item. For a full list of available effects, refer to this [link](https://github.com/femga/rdr3_discoveries/blob/master/graphics/animpostfx/animpostfx.lua).

To add an effect to an item:

```lua
Effect = "effect_name" -- The visual effect to apply (e.g., PlayerDrunkSaloon1).
EffectDuration = 1 -- Duration of the effect in minutes.
```
If you don’t want an item to have an effect, simply leave the Effect and EffectDuration fields empty.

## How to Use

### Configuring Items:
- Open the `config.lua` file, and under the `ItemsToUse` section, add any consumable items as demonstrated in the examples above.

### In-Game Usage:
- Players will be able to use these items to restore hunger, thirst, and other stats, as well as trigger any visual effects you have set (e.g., getting drunk when drinking whisky).

## Installation

- Place `vorp_metabolism` into your `resources` folder
- Add `ensure vorp_metabolism` to your `server.cfg` / `resources.cfg` file

## Dependencies
- [vorp_core](https://github.com/VORPCORE/vorp-core-lua)

## Credits
- [VORP-Metabolism](https://github.com/VORPCORE/VORP-Metabolism) (Original script) This script was based on this C# version.
- [DX#2201](https://github.com/DX-BR) (Developer)
- [victorBOY#3179](https://github.com/vWernay) (Developer)
- [Z-eus](https://github.com/Z-eus) (HUD Redesign)

## Support
[VORP Core Discord](https://discord.gg/JjNYMnDKMf)