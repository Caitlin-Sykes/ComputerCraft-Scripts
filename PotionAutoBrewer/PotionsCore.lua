-- -----------------------------------------------------------------------------
-- Potion Auto brewer Core Functions
-- -----------------------------------------------------------------------------
local PotionsCore = {}

-- Imports Customisation
local Customisation = require("/PotionAutocrafting/Customisation")

-- Import Chests
local Chests = require("/PotionAutocrafting/Chests")

-- Import potions
local Potions = require("/PotionAutocrafting/Potions")

-- Import items
local Items = require("/PotionAutocrafting/Items")

-- Private variables to store peripherals
local ME

-- Cur output
local cur_output = redstone.getBundledOutput(Customisation.BUNDLED_CABLE_SIDE)

-- -----------------------------------------------------------------------------
-- Peripheral Things
-- -----------------------------------------------------------------------------

-- Private method to check for peripheral validity
local function ValidatePeripheral(peripheral, name)
    if peripheral == nil then
        error("PERIPHERAL ERROR: Cannot find a connected " .. name .. ".")
    else
        print(name .. " successfully connected.")
    end
    return peripheral
end

-- Initialises and sets up peripherals
function PotionsCore:SetupPeripherals()
    -- ME Bridge
    ME = ValidatePeripheral(peripheral.wrap(Customisation.ME), "ME Bridge")
    cur_output = 0
    redstone.setBundledOutput(Customisation.BUNDLED_CABLE_SIDE, cur_output)

end

-- -----------------------------------------------------------------------------
-- Getters
-- -----------------------------------------------------------------------------
-- Method to return reactor info
function PotionsCore:GetMEInfo()
    return ME
end

-- Function to get a chest by its id
local function GetChestById(id)
    for key, chest in pairs(Chests.chests) do
        if chest.id == id then
            return chest
        end
    end
    return nil
end

-- -----------------------------------------------------------------------------
-- Core Logic
-- -----------------------------------------------------------------------------
-- Handles the potion crafting
function PotionsCore:PotionCrafting(potion, chest_cluster)

    if (chest_cluster.id ~= nil) then
        print("Starting the crafting of: " .. potion.result .. " in chest cluster " .. chest_cluster.id)
        -- Gets the attached chest
        chest_modem = peripheral.wrap(chest_cluster.id)
        basin_modem = peripheral.wrap(chest_cluster.basin)

        if (chest_modem ~= nil and basin_modem ~= nil) then
            -- Exporting the base potion to the basin
            ME.exportFluidToPeripheral({
                name = potion.base_potion
            }, chest_cluster.basin, 1000)

            -- Exporting the item from the chest to the basin
            chest_modem.pushItems(chest_cluster.basin, 1)
        end

        print("Ending the crafting of: " .. potion.result .. " in chest cluster " .. chest_cluster.id)
    end

end

-- Handles the item crafting
function PotionsCore:ItemCrafting(item, chest_cluster)
    if (chest_cluster.id ~= nil) then
        print("Starting the crafting of: " .. item.result .. " in chest cluster " .. chest_cluster.id)

        -- Gets the attached chest and basin
        local chest_modem = peripheral.wrap(chest_cluster.id)
        local basin_modem = peripheral.wrap(chest_cluster.basin)

        if (chest_modem ~= nil and basin_modem ~= nil) then

            -- Iterate over each ingredient in item.ingredient and find it in the chest
            for _, ingredientName in ipairs(item.ingredient) do
                local found = false -- Track if we found the ingredient

                -- Check each slot in the chest for the ingredient
                for slot, chestItem in pairs(chest_modem.list()) do
                    if chestItem.name == ingredientName then
                        -- Export one of the ingredient to the basin
                        chest_modem.pushItems(chest_cluster.basin, slot, 1)
                        print("Exported " .. ingredientName .. " from slot " .. slot .. " to basin")
                        found = true
                        break -- Move to the next ingredient once found
                    end
                end

                -- If ingredient wasn't found, print a message (optional)
                if not found then
                    print("Ingredient " .. ingredientName .. " not found in chest " .. chest_cluster.id)
                end
            end
        end

        print("Ending the crafting of: " .. item.result .. " in chest cluster " .. chest_cluster.id)
    end
end

-- Manages the crafting of potions
function PotionCraftingManagement(potion, crafted)
    cur_output = redstone.getBundledOutput(Customisation.BUNDLED_CABLE_SIDE)

    -- If it's got a crafting job and isn't in any of the chests
    if ME.isFluidCrafting({
        name = potion.result
    }) and crafted == false then

        -- Looks for the chest that has the corresponding item
        local assignedChestId = AssignChest(potion, "potion")

        if assignedChestId then
            -- Gets the chest by its ID
            chest_cluster = GetChestById(assignedChestId)

            -- Turn on Power
            cur_output = colours.combine(cur_output, chest_cluster.cable)
            redstone.setBundledOutput(Customisation.BUNDLED_CABLE_SIDE, cur_output)

            -- Craft the potion
            PotionsCore:PotionCrafting(potion, chest_cluster)

            -- Wait for potion to appear in the basin, so it can export it to ME
            while not IsPotionInBasin(potion.result, chest_cluster.basin) do
                sleep(1)
            end

            -- Imports fluid from the basin
            ME.importFluidFromPeripheral({
                name = potion.result
            }, chest_cluster.basin)
        end

        -- If crafted is not false, it must be an id, and if its got a crafting recipe, still crafting
    elseif (ME.isFluidCrafting({
        name = potion.result
    }) and crafted ~= false) then

        -- Looks for the chest that has the corresponding item
        local assignedChestId = AssignChest(potion, "potion")

        -- Gets the chest by its ID
        chest_cluster = GetChestById(assignedChestId)

        -- Craft the potion
        PotionsCore:PotionCrafting(potion, chest_cluster)

        -- Wait for potion to appear in the basin, so it can export it to ME
        while not IsPotionInBasin(potion.result, chest_cluster.basin) do
            sleep(1)
        end

        -- Imports fluid from the basin
        ME.importFluidFromPeripheral({
            name = potion.result
        }, chest_cluster.basin)

        -- Else if it takes up a chest but does not have an active recipe, reset
    elseif (crafted ~= false) then
        -- Resets to idle
        chest_to_reset = GetChestById(crafted)
        chest_to_reset.status = "idle"

        -- Turn off the cluster
        cur_output = colours.subtract(cur_output, chest_to_reset.cable)
        redstone.setBundledOutput(Customisation.BUNDLED_CABLE_SIDE, cur_output)

    end
end

-- Manages the crafting of items
function ItemCraftingManagement(item, crafted)
    -- print("CRAFTED IS:".. tostring(crafted))
    cur_output = redstone.getBundledOutput(Customisation.BUNDLED_CABLE_SIDE)

    -- If it's got a crafting job and isn't in any of the chests
    if ME.isItemCrafting({
        name = item.result
    }) and crafted == false then
        -- Looks for the chest that has the corresponding item
        local assignedChestId = AssignChest(item, "item")

        if assignedChestId then
            -- Gets the chest by its ID
            chest_cluster = GetChestById(assignedChestId)

            -- Turn on Power
            cur_output = colours.combine(cur_output, chest_cluster.cable)
            redstone.setBundledOutput(Customisation.BUNDLED_CABLE_SIDE, cur_output)

            -- Craft the item
            PotionsCore:ItemCrafting(item, chest_cluster)

            -- Wait for item to appear in the basin, so it can export it to ME
            while not IsItemInBasin(item.result, chest_cluster.basin) do
                sleep(1)
            end

            -- Imports item from the basin
            ME.importItemFromPeripheral({
                name = item.result
            }, chest_cluster.basin)
        end

        -- If crafted is not false, it must be an id, and if its got a crafting recipe, still crafting
    elseif (ME.isItemCrafting({
        name = item.result
    }) and crafted ~= false) then
        -- Looks for the chest that has the corresponding item
        local assignedChestId = AssignChest(item, "item")

        -- Gets the chest by its ID
        chest_cluster = GetChestById(assignedChestId)

        -- Craft the item
        PotionsCore:ItemCrafting(item, chest_cluster)

        -- Wait for item to appear in the basin, so it can export it to ME
        while not IsItemInBasin(item.result, chest_cluster.basin) do
            sleep(1)
        end

        -- Imports item from the basin
        ME.importItemFromPeripheral({
            name = item.result
        }, chest_cluster.basin)

        -- Else if it takes up a chest but does not have an active recipe, reset
    elseif (crafted ~= false) then

        -- Resets to idle
        chest_to_reset = GetChestById(crafted)
        chest_to_reset.status = "idle"

        -- Turn off the cluster
        cur_output = colours.subtract(cur_output, chest_to_reset.cable)
        redstone.setBundledOutput(Customisation.BUNDLED_CABLE_SIDE, cur_output)

    end
end
-- -----------------------------------------------------------------------------
-- Handlers
-- -----------------------------------------------------------------------------

-- Checks if the item is already being crafted by going through the chests
function CheckIfItemIsBeingCrafted(item)
    for _, chest in pairs(Chests.chests) do
        -- If the chest status does not equal idle and equals potion
        if chest.status ~= "idle" and chest.status == item then
            -- It is being crafted in the following chest
            return chest.id
        end
    end
    return false
end

-- Goes through a provided item/PotionList, and checks whether its being crafted
function PotionsCore:SearchAndStartCrafting(list, type)

    -- For every potion in the given potion list
    for _, item in pairs(list) do

        crafted = CheckIfItemIsBeingCrafted(item.result)

        -- If type is potion then starts the potion crafting logic
        if type == "potion" then
            -- Check if its present in any of the chests
            PotionCraftingManagement(item, crafted)

            -- else if type is item then do item crafting logic
        elseif type == "item" then
            ItemCraftingManagement(item, crafted)
        else
            error("Invalid type in potions list: " .. list)
        end
    end
    redstone.setBundledOutput(Customisation.BUNDLED_CABLE_SIDE, cur_output)
end

-- Function finds the chest used for crafting by looking for the ingredient used
function AssignChest(result, type)
    -- For each configured chest cluster
    for _, chest in pairs(Chests.chests) do

        -- Gets the id of the chest attached to this cluster
        chest_modem = peripheral.wrap(chest.id)

        if (chest_modem ~= nil) then
            -- If the chest status matches the potion then return id
            if chest.status == result.result then
                return chest.id

                -- else do some searching
            else
                -- Goes through the chest and looks for the ingredient for the potion
                for slot, item in pairs(chest_modem.list()) do
                    --   If it has the ingredient, sets status to the potion and returns id
                    if (item.name == result.ingredient and type == "potion") then
                        chest.status = result.result
                        return chest.id

                    elseif (IsItemInIngredients(item, result.ingredient) and type == "item") then
                        chest.status = result.result
                        return chest.id
                    end
                end
            end
        else
            print("Cannot find chest by the id: " .. chest.id)
        end
    end
    return false
end

-- Check if the potion is in the basin
function IsPotionInBasin(potionName, basinId)
    local basin = peripheral.wrap(basinId)
    if basin then
        for _, fluid in pairs(basin.tanks()) do
            if fluid.name == potionName then
                return true
            end
        end
    end
    return false
end

-- Check if the item is in the basin
function IsItemInBasin(itemName, basinId)
    local basin = peripheral.wrap(basinId)
    if basin then
        for _, item in pairs(basin.list()) do
            if item.name == itemName then
                return true
            end
        end
    end
    return false
end

-- Function to check if item.name matches any ingredient in the list
function IsItemInIngredients(item, ingredients)
    for _, ingredient in ipairs(ingredients) do
        if item.name == ingredient then
            return true
        end
    end
    return false
end

return PotionsCore

