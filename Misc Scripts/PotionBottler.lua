local ME = peripheral.wrap("meBridge_1")
local tunnel = peripheral.wrap("create:brass_tunnel_0")
local cableColor = 0x1
local bundledDir = "bottom"
local cur_output = redstone.getBundledOutput(bundledDir)

function CheckForPotionRecipe()
    while true do
        local craftableItems = ME.listCraftableItems()

        -- Looks for crafting job, if ME has one going, export bottles
        for _, item in pairs(craftableItems) do
            if item.tags then
                for _, tag in pairs(item.tags) do
                    if tag == "minecraft:item/utilitix:potions" or tag == "Potion" then
                        if ME.isItemCrafting(item) then
                            -- Turn on Power
                            cur_output = colours.combine(cur_output, cableColor)
                            redstone.setBundledOutput(bundledDir, cur_output)

                            -- Export bottles
                            print("Exporting bottles to tunnel")
                            ME.exportItemToPeripheral({
                                name = "minecraft:glass_bottle"
                            }, "create:brass_tunnel_0")
                        else
                            -- Turn off the power
                            cur_output = colours.subtract(cur_output, cableColor)
                            redstone.setBundledOutput(bundledDir, cur_output)
                        end
                    end
                end
            end
        end
        sleep(60)
    end
end

parallel.waitForAll(CheckForPotionRecipe)
