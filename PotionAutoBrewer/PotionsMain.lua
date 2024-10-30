-- -----------------------------------------------------------------------------
-- Potion Autocrafting AE2 Script
-- -----------------------------------------------------------------------------
-- Import Customisation
local Customisation = require("/PotionAutocrafting/Customisation")

-- Import PotionCore
local PotionsCore = require("/PotionAutocrafting/PotionsCore")

-- Import Potions
local Potions = require("/PotionAutocrafting/Potions")

-- -----------------------------------------------------------------------------
-- Search Functions
-- -----------------------------------------------------------------------------

-- Looks for all the crafting recipes for vanilla potions
function LookForVanillaPotions()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.VANILLA_POTIONS_BASE)
        sleep(Customisation.VANILLA_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for bases (awkward, mundane etc)
function LookForPotionsBase()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.BASE_POTIONS)
        sleep(Customisation.BASE_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for CORAIL
function LookForPotionsCorail()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.CORAIL_TOMBSTONE)
        sleep(Customisation.CORAIL_TOMBSTONE_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for APOTHEOSIS
function LookForPotionsApotheosis()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.APOTHEOSIS)
        sleep(Customisation.APOTHEOSIS_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for IRONS_SPELLBOOKS
function LookForPotionsIronsSpellbooks()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.IRONS_SPELLBOOKS)
        sleep(Customisation.IRONS_SPELLBOOKS_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for ECOLOGICS
function LookForPotionsEcologics()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.ECOLOGICS)
        sleep(Customisation.ECOLOGICS_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for ARS_NOUVEAU
function LookForPotionsArsNouveau()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.ARS_NOUVEAU)
        sleep(Customisation.ARS_NOUVEAU_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for ARS_ELEMENTAL
function LookForPotionsArsElemental()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.ARS_ELEMENTAL)
        sleep(Customisation.ARS_ELEMENTAL_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for EIDOLON
function LookForPotionsEidolon()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.EIDOLON)
        sleep(Customisation.EIDOLON_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for NATURALIST
function LookForPotionsNaturalist()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.NATURALIST)
        sleep(Customisation.NATURALIST_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for POTIONS_MASTER
function LookForPotionsPotionsMaster()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.POTIONS_MASTER)
        sleep(Customisation.POTIONS_MASTER_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for DEEPER_DARKER
function LookForPotionsDeeperDarker()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.DEEPER_DARKER)
        sleep(Customisation.DEEPER_DARKER_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for AUTUMNITY
function LookForPotionsAutumnity()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.AUTUMNITY)
        sleep(Customisation.AUTUMNITY_WAIT_FOR_SCAN)
    end
end

-- Looks for all the crafting recipes for QUARK
function LookForPotionsQuark()
    while true do
        PotionsCore:SearchAndStartCrafting(Potions.QUARK)
        sleep(Customisation.QUARK_WAIT_FOR_SCAN)
    end
end

-- -----------------------------------------------------------------------------
-- Init Stuff
-- -----------------------------------------------------------------------------

-- Sets up peripherals
PotionsCore:SetupPeripherals()

-- Main loop
parallel.waitForAll(LookForVanillaPotions,LookForPotionsBase,LookForPotionsCorail,LookForPotionsApotheosis,LookForPotionsIronsSpellbooks,LookForPotionsEcologics,LookForPotionsArsNouveau,LookForPotionsArsElemental,LookForPotionsEidolon,LookForPotionsNaturalist,LookForPotionsPotionsMaster,LookForPotionsDeeperDarker,LookForPotionsAutumnity,LookForPotionsQuark)
