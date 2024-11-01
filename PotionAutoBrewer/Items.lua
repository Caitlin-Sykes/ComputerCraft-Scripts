-- ----------------------------------------------------------------------------- 
-- Items 
-- These contain dictionaries with the items that are craftable 
-- Unlike potions, these use bog standard recipes
-- -----------------------------------------------------------------------------

-- Do not edit line 6 
local Items = {}

-- Vanilla Potions Base 
Items.CREATE_UTILITIES_ITEMS = { 
    { 
        -- Void Steel Ingot
        result = "createutilities:void_steel_ingot", 
        ingredient = {"minecraft:netherite_ingot", "minecraft:ender_pearl"},
    }
}


return Items
