-- -----------------------------------------------------------------------------
-- Chests
-- These contain IDs for various chests used for crafting
-- They need to be connected in sequence, ie: chest 0 connects to basin 0 which is wired on redstone circuit 0
-- Example Layout
-- ID: The name of the modem attached to the chest
-- Basin: The name of the modem attached to the basin
-- Status: current status of this crafting job, should not need to change
-- Cable - the colour code of the cable attached to that circuit, available here: https://tweaked.cc/module/colors.html
-- -----------------------------------------------------------------------------
-- Do not edit line 6
local Chests = {}

Chests.chests = {
    chest_0 = {
        ["id"] = "minecraft:chest_0",
        ["basin"] = "basin_0",
        ["status"] = "idle",
        ["cable"] = 0x1
    },

    chest_1 = {
        ["id"] = "minecraft:chest_1",
        ["basin"] = "basin_1",
        ["status"] = "idle",
        ["cable"] = 0x2
    }
}

return Chests
