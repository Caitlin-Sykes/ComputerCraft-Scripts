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
-- @peripheral -> peripheral to check connection of
-- @name -> name of peripheral
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
-- @id -> name of the chest, ie "minecraft:chest_0"
local function GetChestById(id)
    if id ~= nil then
        for _, chest in pairs(Chests.chests) do
            if chest.id == id then
                return chest
            end
        end
    end
    return nil
end

-- -----------------------------------------------------------------------------
-- Core Logic
-- -----------------------------------------------------------------------------
-- Handles the potion crafting
-- @potion -> the potion that is being crafted
-- @chest_cluster -> the chest cluster that the job is assigned to
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
-- @item -> the item that is being crafted
-- @chest_cluster -> the chest cluster that the job is assigned to
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
-- @potion -> the potion to be made
-- @crafted -> "false" if no existing craft, otherwise a chest id
function PotionCraftingManagement(potion, crafted)

    cur_output = redstone.getBundledOutput(Customisation.BUNDLED_CABLE_SIDE)

    -- If it's got a crafting job and isn't in any of the chests
    if ME.isFluidCrafting({
        name = potion.result
    }) and crafted == false then

        -- Looks for the chest that has the corresponding item
        local assignedChestIds = AssignChest(potion, "potion")

        if assignedChestIds then
            for _, chestId in ipairs(assignedChestIds) do

                -- Gets the chest by its ID
                chest_cluster = GetChestById(chestId)

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
        end

        -- If crafted is not false, it must be an id, and if its got a crafting recipe, still crafting
    elseif (ME.isFluidCrafting({
        name = potion.result
    }) and crafted ~= false) then

        -- Looks for the chest that has the corresponding item
        local assignedChestIds = AssignChest(potion, "potion")

        if assignedChestIds then
            for _, chestId in ipairs(assignedChestIds) do

                -- Gets the chest by its ID
                chest_cluster = GetChestById(chestId)

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
        end
        -- Else if it takes up a chest but does not have an active recipe, reset
    elseif (crafted ~= false) then
        for _, chestId in ipairs(crafted) do
            -- Reset each chest status to idle
            local chest_to_reset = GetChestById(chestId)
            chest_to_reset.status = "idle"

            -- Turn off the cluster
            cur_output = colours.subtract(cur_output, chest_to_reset.cable)
            redstone.setBundledOutput(Customisation.BUNDLED_CABLE_SIDE, cur_output)
        end

    end
end

-- Manages the crafting of items
-- @item -> the item to be made
-- @crafted -> "false" if no existing craft, otherwise a chest id
function ItemCraftingManagement(item, crafted)

    cur_output = redstone.getBundledOutput(Customisation.BUNDLED_CABLE_SIDE)

    -- If it's got a crafting job and isn't in any of the chests
    if ME.isItemCrafting({
        name = item.result
    }) and crafted == false then
        -- Looks for the chest that has the corresponding item
        local assignedChestIds = AssignChest(item, "item")

        if assignedChestIds then
            for _, chestId in ipairs(assignedChestIds) do
                -- Gets the chest by its ID
                chest_cluster = GetChestById(chestId)

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
        end

        -- If crafted is not false, it must be an id, and if its got a crafting recipe, still crafting
    elseif (ME.isItemCrafting({
        name = item.result
    }) and crafted ~= false) then
        -- Looks for the chest that has the corresponding item
        local assignedChestIds = AssignChest(item, "item")

        if assignedChestIds then
            for _, chestId in ipairs(assignedChestIds) do
                -- Gets the chest by its ID
                chest_cluster = GetChestById(chestId)

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
        end
        -- Else if it takes up a chest but does not have an active recipe, reset
    elseif (crafted ~= false) then
        for _, chestId in ipairs(crafted) do
            -- Reset each chest status to idle
            local chest_to_reset = GetChestById(chestId)
            chest_to_reset.status = "idle"

            -- Turn off the cluster
            cur_output = colours.subtract(cur_output, chest_to_reset.cable)
            redstone.setBundledOutput(Customisation.BUNDLED_CABLE_SIDE, cur_output)
        end
    end
end

-- -----------------------------------------------------------------------------
-- Handlers
-- -----------------------------------------------------------------------------

-- Checks if the item is already being crafted by going through the chests
-- @item -> the item that a job may be running for
function CheckIfItemIsBeingCrafted(item)
    local chestIds = {}
    for _, chest in pairs(Chests.chests) do
        -- If the chest status does not equal idle and equals potion
        if chest.status ~= "idle" and chest.status == item then
            -- It is being crafted in the following chest, add to the list
            table.insert(chestIds, chest.id)
        end
    end
    return #chestIds > 0 and chestIds or false
end

-- Goes through a provided item/PotionList, and checks whether its being crafted
-- @list -> the list of items to check the crafting status of
-- @typeOfCraft -> what type of craft it is, either "potion" or "item"
function PotionsCore:SearchAndStartCrafting(list, typeOfCraft)

    -- For every potion in the given potion list
    for _, item in pairs(list) do

        crafted = CheckIfItemIsBeingCrafted(item.result)

        -- If type is potion then starts the potion crafting logic
        if typeOfCraft == "potion" then
            -- If there is multiple nodes already crafting then go through them all and verify status
            if type(crafted) == "table" then
                -- Iterate over each element in crafted if it's an array
                for _, chestId in ipairs(crafted) do
                    print("Processing chest ID: " .. chestId)
                    PotionCraftingManagement(item, chestId)
                end

            else
                -- Check if its present in any of the chests
                PotionCraftingManagement(item, false)
            end

            -- else if type is item then do item crafting logic
        elseif typeOfCraft == "item" then
            -- If there is multiple nodes already crafting then go through them all and verify status
            if type(crafted) == "table" then
                -- Iterate over each element in crafted if it's an array
                for _, chestId in ipairs(crafted) do
                    print("Processing chest ID: " .. chestId)
                    ItemCraftingManagement(item, chestId)
                end
            else
                -- Check if its present in any of the chests
                ItemCraftingManagement(item, false)
            end
        else
            error("Invalid type in potions list: " .. list)
        end
    end
    redstone.setBundledOutput(Customisation.BUNDLED_CABLE_SIDE, cur_output)
end

-- Function finds the chest used for crafting by looking for the ingredient used
-- @result -> the item that is being crafted
-- @type -> type of craft, either "potion" or "item"
function AssignChest(result, type)
    local chestIds = {}
    -- For each configured chest cluster
    for _, chest in pairs(Chests.chests) do

        -- Gets the id of the chest attached to this cluster
        local chest_modem = peripheral.wrap(chest.id)

        if chest_modem ~= nil then
            -- If the chest status matches the potion then add id to the list
            if chest.status == result.result then
                table.insert(chestIds, chest.id)
            else
                -- Goes through the chest and looks for the ingredient for the potion
                for slot, item in pairs(chest_modem.list()) do
                    -- If it has the ingredient, set status to the potion and add id to the list
                    if item.name == result.ingredient and type == "potion" then
                        chest.status = result.result
                        table.insert(chestIds, chest.id)
                        break

                    elseif IsItemInIngredients(item, result.ingredient) and type == "item" then
                        chest.status = result.result
                        table.insert(chestIds, chest.id)
                        break
                    end
                end
            end
        else
            print("Cannot find chest by the id: " .. chest.id)
        end
    end
    return #chestIds > 0 and chestIds or false
end

-- Check if the potion is in the basin
-- @potionName -> the name of the potion that is being crafted
-- @basinId -> the id of a basin to check
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
-- @itemName -> the name of the item that is being crafted
-- @basinId -> the id of a basin to check
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
-- @item -> the list of items in a container
-- @ingredients -> the list of ingredients for a job, an array
function IsItemInIngredients(item, ingredients)
    for _, ingredient in ipairs(ingredients) do
        if item.name == ingredient then
            return true
        end
    end
    return false
end

return PotionsCore

