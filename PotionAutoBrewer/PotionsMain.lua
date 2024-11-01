-- -----------------------------------------------------------------------------
-- Potion Autocrafting AE2 Script
-- -----------------------------------------------------------------------------
-- Import Customisation
local Customisation = require("/PotionAutocrafting/Customisation")

-- Import PotionCore
local PotionsCore = require("/PotionAutocrafting/PotionsCore")

-- Import Potions
local Potions = require("/PotionAutocrafting/Potions")

-- Import items
local Items = require("/PotionAutocrafting/Items")
-- -----------------------------------------------------------------------------
-- Search Functions
-- -----------------------------------------------------------------------------

-- Looks for all the crafting recipes for vanilla potions
function LookForVanillaPotions()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.VANILLA_POTIONS_BASE, "potion")
        sleep(Customisation.VANILLA_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for bases (awkward, mundane etc)
function LookForPotionsBase()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.BASE_POTIONS, "potion")
        sleep(Customisation.BASE_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for CORAIL
function LookForPotionsCorail()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.CORAIL_TOMBSTONE, "potion")
        sleep(Customisation.CORAIL_TOMBSTONE_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for APOTHEOSIS
function LookForPotionsApotheosis()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.APOTHEOSIS, "potion")
        sleep(Customisation.APOTHEOSIS_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for IRONS_SPELLBOOKS
function LookForPotionsIronsSpellbooks()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.IRONS_SPELLBOOKS, "potion")
        sleep(Customisation.IRONS_SPELLBOOKS_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for ECOLOGICS
function LookForPotionsEcologics()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.ECOLOGICS, "potion")
        sleep(Customisation.ECOLOGICS_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for ARS_NOUVEAU
function LookForPotionsArsNouveau()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.ARS_NOUVEAU, "potion")
        sleep(Customisation.ARS_NOUVEAU_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for ARS_ELEMENTAL
function LookForPotionsArsElemental()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.ARS_ELEMENTAL, "potion")
        sleep(Customisation.ARS_ELEMENTAL_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for EIDOLON
function LookForPotionsEidolon()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.EIDOLON, "potion")
        sleep(Customisation.EIDOLON_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for NATURALIST
function LookForPotionsNaturalist()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.NATURALIST, "potion")
        sleep(Customisation.NATURALIST_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for POTIONS_MASTER
function LookForPotionsPotionsMaster()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.POTIONS_MASTER, "potion")
        sleep(Customisation.POTIONS_MASTER_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for DEEPER_DARKER
function LookForPotionsDeeperDarker()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.DEEPER_DARKER, "potion")
        sleep(Customisation.DEEPER_DARKER_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for AUTUMNITY
function LookForPotionsAutumnity()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.AUTUMNITY, "potion")
        sleep(Customisation.AUTUMNITY_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for QUARK
function LookForPotionsQuark()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.QUARK, "potion")
        sleep(Customisation.QUARK_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for CREATE_UTILITIES
function LookForItemsCreateUtilities()
    while true do
        PotionsCore:SearchAndStartCrafting(Items.CREATE_UTILITIES_ITEMS, "item")
        sleep(Customisation.CREATE_UTILITIES_WAIT_FOR_SCAN)
    end
end

-- -----------------------------------------------------------------------------
-- Init Stuff
-- -----------------------------------------------------------------------------

-- Sets up peripherals
PotionsCore:SetupPeripherals()

-- Main loop
parallel.waitForAll(LookForVanillaPotions, LookForPotionsBase, LookForPotionsCorail, LookForPotionsApotheosis,
    LookForPotionsIronsSpellbooks, LookForPotionsEcologics, LookForPotionsArsNouveau, LookForPotionsArsElemental,
    LookForPotionsEidolon, LookForPotionsNaturalist, LookForPotionsPotionsMaster, LookForPotionsDeeperDarker,
    LookForPotionsAutumnity, LookForPotionsQuark, LookForItemsCreateUtilities)
