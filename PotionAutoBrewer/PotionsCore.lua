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
    return nil -- Return nil if no matching id is found
end

-- -----------------------------------------------------------------------------
-- Core Logic
-- -----------------------------------------------------------------------------
-- Handles the potion crafting
function PotionsCore:PotionCrafting(potion, chest_cluster)

    if (chest_cluster.id ~= nil) then
        print("Starting the crafting of: " .. potion.potion .. " in chest cluster " .. chest_cluster.id)
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

        print("Ending the crafting of: " .. potion.potion .. " in chest cluster " .. chest_cluster.id)
    end

end

-- -----------------------------------------------------------------------------
-- Handlers
-- -----------------------------------------------------------------------------

-- Checks if the item is already being crafted by going through the chests
local function CheckIfItemIsBeingCrafted(potion)
    for _, chest in pairs(Chests.chests) do
        -- If the chest status does not equal idle and equals potion
        if chest.status ~= "idle" and chest.status == potion then
            -- It is being crafted in the following chest
            return chest.id
        end
    end
    return false
end

-- Goes through a provided potionList, and checks whether its being crafted
function PotionsCore:SearchAndStartCraftingPotions(potionList)

    -- For every potion in the given potion list
    for _, potion in pairs(potionList) do

        -- Check if its present in any of the chests
        crafted = CheckIfItemIsBeingCrafted(potion.potion)

        -- If it's got a crafting job and isn't in any of the chests
        if ME.isFluidCrafting({
            name = potion.potion
        }) and crafted == false then

            -- Looks for the chest that has the corresponding item
            local assignedChestId = AssignChest(potion)

            if assignedChestId then
                -- Gets the chest by its ID
                chest_cluster = GetChestById(assignedChestId)

                -- Turn on the Create cluster
                cur_output = colours.combine(cur_output, chest_cluster.cable)

                -- Turn on Power
                local cur_output = redstone.getBundledOutput(Customisation.BUNDLED_CABLE_SIDE)

                -- Craft the potion
                PotionsCore:PotionCrafting(potion, chest_cluster)

                -- Wait for potion to appear in the basin, so it can export it to ME
                while not IsPotionInBasin(potion.potion, chest_cluster.basin) do
                    sleep(1)
                end

                -- Imports fluid from the basin
                ME.importFluidFromPeripheral({
                    name = potion.potion
                }, chest_cluster.basin)

            end

            -- If crafted is not false, it must be an id, and if its got a crafting recipe, still crafting
        elseif (ME.isFluidCrafting({
            name = potion.potion
        }) and crafted ~= false) then

            -- Looks for the chest that has the corresponding item
            local assignedChestId = AssignChest(potion)

            -- Gets the chest by its ID
            chest_cluster = GetChestById(assignedChestId)

            -- Craft the potion
            PotionsCore:PotionCrafting(potion, chest_cluster)

            -- Wait for potion to appear in the basin, so it can export it to ME
            while not IsPotionInBasin(potion.potion, chest_cluster.basin) do
                sleep(1)
            end

            -- Imports fluid from the basin
            ME.importFluidFromPeripheral({
                name = potion.potion
            }, chest_cluster.basin)

            -- Else if it takes up a chest but does not have an active recipe, reset
        elseif (crafted ~= false) then
            -- Resets to idle
            chest_to_reset = GetChestById(crafted)
            chest_to_reset.status = "idle"

            -- Turn off the cluster
            cur_output = colours.subtract(cur_output, chest_to_reset.cable)
            local cur_output = redstone.getBundledOutput(Customisation.BUNDLED_CABLE_SIDE)

        end
    end
    redstone.setBundledOutput(Customisation.BUNDLED_CABLE_SIDE, cur_output)
end

-- Function finds the chest used for crafting by looking for the ingredient used
function AssignChest(potion)
    -- For each configured chest cluster
    for _, chest in pairs(Chests.chests) do

        -- Gets the id of the chest attached to this cluster
        chest_modem = peripheral.wrap(chest.id)

        if (chest_modem ~= nil) then

            -- If the chest status matches the potion then return id
            if chest.status == potion.potion then
                return chest.id

                -- else do some searching
            else
                -- Goes through the chest and looks for the ingredient for the potion
                for slot, item in pairs(chest_modem.list()) do
                    --   If it has the ingredient, sets status to the potion and returns id
                    if (item.name == potion.ingredient) then
                        chest.status = potion.potion
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

return PotionsCore

