ServerEvents.recipes(event => {
    [
        // Vanilla Minecraft
        ['night_vision', { item: 'minecraft:golden_carrot' }, { amount: 1000, fluid: "kubejs:awkward", mod: "minecraft" }],
        ['invisibility', { item: 'minecraft:fermented_spider_eye' }, { amount: 1000, fluid: "kubejs:night_vision", mod: "minecraft" }],
        ['leaping', { item: 'minecraft:rabbit_foot' }, { amount: 1000, fluid: "kubejs:awkward", mod: "minecraft" }],
        ['fire_resistance', { item: 'minecraft:magma_cream' }, { amount: 1000, fluid: "kubejs:awkward", mod: "minecraft" }],
        ['swiftness', { item: 'minecraft:sugar' }, { amount: 1000, fluid: "kubejs:awkward", mod: "minecraft" }],
        ['slowness', { item: 'minecraft:fermented_spider_eye' }, { amount: 1000, fluid: "kubejs:swiftness", mod: "minecraft" }],
        ['turtle_master', { item: 'minecraft:turtle_shell' }, { amount: 1000, fluid: "kubejs:awkward", mod: "minecraft" }],
        ['water_breathing', { item: 'minecraft:pufferfish' }, { amount: 1000, fluid: "kubejs:awkward", mod: "minecraft" }],
        ['harming', { item: 'minecraft:fermented_spider_eye' }, { amount: 1000, fluid: "kubejs:healing", mod: "minecraft" }],
        ['poison', { item: 'minecraft:spider_eye' }, { amount: 1000, fluid: "kubejs:awkward", mod: "minecraft" }],
        ['regeneration', { item: 'minecraft:ghast_tear' }, { amount: 1000, fluid: "kubejs:awkward", mod: "minecraft" }],
        ['strength', { item: 'minecraft:blaze_powder' }, { amount: 1000, fluid: "kubejs:awkward", mod: "minecraft" }],
        ['luck', { item: 'apotheosis:lucky_foot' }, { amount: 1000, fluid: "kubejs:awkward", mod: "minecraft" }],
        ['slow_falling', { item: 'minecraft:phantom_membrane' }, { amount: 1000, fluid: "kubejs:awkward", mod: "minecraft" }],
        ['healing', { item: 'minecraft:glistering_melon_slice' }, { amount: 1000, fluid: "kubejs:mundane", mod: "minecraft" }],
        ['weakness', { item: 'minecraft:fermented_spider_eye' }, { amount: 1000, fluid: "kubejs:mundane", mod: "minecraft" }],
        ['mundane', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "minecraft:water", mod: "minecraft" }],
        ['awkward', { item: 'minecraft:nether_wart' }, { amount: 1000, fluid: "minecraft:water", mod: "minecraft" }],
        ['long_night_vision', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:night_vision", mod: "minecraft" }],
        ['long_invisibility', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:invisibility", mod: "minecraft" }],
        ['long_leaping', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:leaping", mod: "minecraft" }],
        ['long_fire_resistance', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:fire_resistance", mod: "minecraft" }],
        ['long_turtle_master', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:turtle_master", mod: "minecraft" }],
        ['long_swiftness', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:swiftness", mod: "minecraft" }],
        ['long_slowness', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:slowness", mod: "minecraft" }],
        ['long_weakness', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:weakness", mod: "minecraft" }],
        ['long_slow_falling', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:slow_falling", mod: "minecraft" }],
        ['long_water_breathing', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:water_breathing", mod: "minecraft" }],
        ['long_regeneration', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:regeneration", mod: "minecraft" }],
        ['long_strength', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:strength", mod: "minecraft" }],
        ['long_poison', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:poison", mod: "minecraft" }],
        ['strong_swiftness', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:swiftness", mod: "minecraft" }],
        ['strong_strength', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:strength", mod: "minecraft" }],
        ['strong_regeneration', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:regeneration", mod: "minecraft" }],
        ['strong_poison', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:poison", mod: "minecraft" }],
        ['strong_healing', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:healing", mod: "minecraft" }],
        ['strong_harming', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:harming", mod: "minecraft" }],
        ['strong_turtle_master', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:turtle_master", mod: "minecraft" }],
        ['strong_leaping', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:leaping", mod: "minecraft" }],
        ['strong_slowness', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:slowness", mod: "minecraft" }],

        // Corail Tombstone
        ['spectral', { item: 'tombstone:grave_dust' }, { amount: 1000, fluid: "minecraft:water", mod: "tombstone" }],
        // ['earthly_garden', { item: 'minecraft:fermented_spider_eye' }, { amount: 1000, fluid: "kubejs:night_vision", mod:"tombstone"}], //no crafting recipe
        ['bait', { item: 'minecraft:rabbit_foot' }, { amount: 1000, fluid: "kubejs:awkward", mod: "tombstone" }],
        ['frostbite', { item: 'minecraft:magma_cream' }, { amount: 1000, fluid: "kubejs:awkward", mod: "tombstone" }],
        ['darkness', { item: 'minecraft:sugar' }, { amount: 1000, fluid: "kubejs:awkward", mod: "tombstone" }],
        ['discretion', { item: 'minecraft:fermented_spider_eye' }, { amount: 1000, fluid: "kubejs:swiftness", mod: "tombstone" }],
        ['restoration', { item: 'minecraft:turtle_shell' }, { amount: 1000, fluid: "kubejs:awkward", mod: "tombstone" }],

        // Apotheosis
        ['resistance', { item: 'minecraft:shulker_shell' }, { amount: 1000, fluid: "kubejs:awkward", mod: "apotheosis" }],
        ['long_resistance', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:resistance", mod: "apotheosis" }],
        ['strong_resistance', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:resistance", mod: "apotheosis" }],
        ['absorption', { item: 'minecraft:golden_apple' }, { amount: 1000, fluid: "kubejs:awkward", mod: "apotheosis" }],
        ['long_absorption', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:absorption", mod: "apotheosis" }],
        ['strong_absorption', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:absorption", mod: "apotheosis" }],
        ['haste', { item: 'minecraft:mushroom_stew' }, { amount: 1000, fluid: "kubejs:awkward", mod: "apotheosis" }],
        ['long_haste', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:haste", mod: "apotheosis" }],
        ['strong_haste', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:haste", mod: "apotheosis" }],
        ['fatigue', { item: 'minecraft:fermented_spider_eye' }, { amount: 1000, fluid: "kubejs:haste", mod: "apotheosis" }],
        ['long_fatigue', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:fatigue", mod: "apotheosis" }],
        ['strong_fatigue', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:fatigue", mod: "apotheosis" }],
        ['wither', { item: 'minecraft:wither_skeleton_skull' }, { amount: 1000, fluid: "kubejs:awkward", mod: "apotheosis" }],
        ['long_wither', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:wither", mod: "apotheosis" }],
        ['strong_wither', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:wither", mod: "apotheosis" }],
        ['sundering', { item: 'minecraft:fermented_spider_eye' }, { amount: 1000, fluid: "kubejs:resistance", mod: "apotheosis" }],
        ['long_sundering', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:sundering", mod: "apotheosis" }],
        ['strong_sundering', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:sundering", mod: "apotheosis" }],
        ['knowledge', { item: 'minecraft:experience_bottle' }, { amount: 1000, fluid: "kubejs:awkward", mod: "apotheosis" }],
        ['long_knowledge', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:knowledge", mod: "apotheosis" }],
        ['strong_knowledge', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:knowledge", mod: "apotheosis" }],
        ['vitality', { item: 'minecraft:sweet_berries' }, { amount: 1000, fluid: "kubejs:awkward", mod: "apotheosis" }],
        ['long_vitality', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:vitality", mod: "apotheosis" }],
        ['strong_vitality', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:vitality", mod: "apotheosis" }],
        ['grievous', { item: 'minecraft:fermented_spider_eye' }, { amount: 1000, fluid: "kubejs:vitality", mod: "apotheosis" }],
        ['long_grievous', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:grievous", mod: "apotheosis" }],
        ['strong_grievous', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:grievous", mod: "apotheosis" }],
        ['levitation', { item: 'minecraft:fermented_spider_eye' }, { amount: 1000, fluid: "kubejs:slow_falling", mod: "apotheosis" }],
        ['flying', { item: 'minecraft:popped_chorus_fruit' }, { amount: 1000, fluid: "kubejs:levitation", mod: "apotheosis" }],
        ['long_flying', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:flying", mod: "apotheosis" }],
        ['extra_long_flying', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:flying", mod: "apotheosis" }],

        // Undergarden
        ['brittleness', { item: 'undergarden:blood_globule' }, { amount: 1000, fluid: "kubejs:awkward", mod: "undergarden" }],
        ['long_brittleness', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:brittleness", mod: "undergarden" }],
        ['strong_brittleness', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:brittleness", mod: "undergarden" }],
        ['featherweight', { item: 'undergarden:veil_mushroom' }, { amount: 1000, fluid: "kubejs:awkward", mod: "undergarden" }],
        ['long_featherweight', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:featherweight", mod: "undergarden" }],
        ['strong_featherweight', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:featherweight", mod: "undergarden" }],
        ['virulent_resistance', { item: 'undergarden:gloomgourd' }, { amount: 1000, fluid: "kubejs:awkward", mod: "undergarden" }],
        ['long_virulent_resistance', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:virulent_resistance", mod: "undergarden" }],
        ['glowing', { item: 'undergarden:droopvine_item' }, { amount: 1000, fluid: "kubejs:awkward", mod: "undergarden" }],
        ['long_glowing', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:glowing", mod: "undergarden" }],

        // Irons Spellbooks
        ['instant_mana_one', { item: 'irons_spellbooks:arcane_essence' }, { amount: 1000, fluid: "kubejs:awkward", mod: "irons_spellbooks" }],
        ['instant_mana_two', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:instant_mana_one", mod: "irons_spellbooks" }],
        ['instant_mana_three', { item: 'minecraft:amethyst_shard' }, { amount: 1000, fluid: "kubejs:instant_mana_two", mod: "irons_spellbooks" }],
        ['instant_mana_four', { item: 'minecraft:amethyst_cluster' }, { amount: 1000, fluid: "kubejs:instant_mana_three", mod: "irons_spellbooks" }],

        // Ecologics
        ['sliding', { item: 'ecologics:penguin_feather' }, { amount: 1000, fluid: "kubejs:awkward", mod: "ecologics" }],
        ['long_sliding', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:long_sliding", mod: "ecologics" }],

        // Railcraft - Does not need crafting
        // ['creosote', { item: 'minecraft:ghast_tear' }, { amount: 1000, fluid: "kubejs:awkward", mod:"railcraft"}],
        // ['long_creosote', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:awkward", mod:"railcraft"}],
        // ['strong_creosote', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:awkward", mod:"railcraft"}],

        // Ars Nouveau
        ['mana_regen_potion', { item: 'ars_nouveau:sourceberry_bush' }, { amount: 1000, fluid: "kubejs:awkward", mod: "ars_nouveau" }],
        ['mana_regen_potion_long', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:mana_regen_potion", mod: "ars_nouveau" }],
        ['mana_regen_potion_strong', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:mana_regen_potion", mod: "ars_nouveau" }],
        ['spell_damage_potion', { item: 'ars_nouveau:magebloom' }, { amount: 1000, fluid: "kubejs:awkward", mod: "ars_nouveau" }],
        ['spell_damage_potion_long', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:spell_damage_potion", mod: "ars_nouveau" }],
        ['spell_damage_potion_strong', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:spell_damage_potion", mod: "ars_nouveau" }],
        ['recovery_potion', { item: 'ars_nouveau:mendosteen_pod' }, { amount: 1000, fluid: "kubejs:awkward", mod: "ars_nouveau" }],
        ['recovery_potion_long', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:recovery_potion", mod: "ars_nouveau" }],
        ['recovery_potion_strong', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:recovery_potion", mod: "ars_nouveau" }],
        ['blasting_potion', { item: 'ars_nouveau:bombegranate_pod' }, { amount: 1000, fluid: "kubejs:awkward", mod: "ars_nouveau" }],
        ['blasting_potion_long', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:blasting_potion", mod: "ars_nouveau" }],
        ['blasting_potion_strong', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:blasting_potion", mod: "ars_nouveau" }],
        ['freezing_potion', { item: 'ars_nouveau:frostaya_pod' }, { amount: 1000, fluid: "kubejs:awkward", mod: "ars_nouveau" }],
        ['freezing_potion_long', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:freezing_potion", mod: "minecraft" }],
        ['freezing_potion_strong', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:freezing_potion", mod: "ars_nouveau" }],
        ['shielding_potion', { item: 'ars_nouveau:bastion_pod' }, { amount: 1000, fluid: "kubejs:awkward", mod: "ars_nouveau" }],
        ['shielding_potion_long', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:shielding_potion", mod: "ars_nouveau" }],
        ['shielding_potion_strong', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:shielding_potion", mod: "ars_nouveau" }],

        // Ars Elemental
        ['enderference_potion', { item: 'minecraft:twisting_vines' }, { amount: 1000, fluid: "kubejs:awkward", mod: "ars_elemental" }],
        ['enderference_potion_long', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:enderference_potion", mod: "ars_elemental" }],
        ['shock_potion', { item: 'ars_elemental:flashpine_pod' }, { amount: 1000, fluid: "kubejs:awkward", mod: "ars_elemental" }],
        ['shock_potion_long', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:shock_potion", mod: "ars_elemental" }],

        // Eidolon
        ['undeath', { item: 'eidolon:death_essence' }, { amount: 1000, fluid: "kubejs:awkward", mod: "eidolon" }],
        ['long_undeath', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:undeath", mod: "eidolon" }],
        ['vulnerable', { item: 'eidolon:tattered_cloth' }, { amount: 1000, fluid: "kubejs:awkward", mod: "eidolon" }],
        ['long_vulnerable', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:vulnerable", mod: "eidolon" }],
        ['strong_vulnerable', { item: 'minecraft:glowstone' }, { amount: 1000, fluid: "kubejs:vulnerable", mod: "eidolon" }],
        ['reinforced', { item: 'minecraft:nautilus_shell' }, { amount: 1000, fluid: "kubejs:awkward", mod: "eidolon" }],
        ['long_reinforced', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:reinforced", mod: "eidolon" }],
        ['strong_reinforced', { item: 'minecraft:glowstone' }, { amount: 1000, fluid: "kubejs:reinforced", mod: "eidolon" }],
        ['anchored', { item: 'eidolon:warped_sprouts' }, { amount: 1000, fluid: "kubejs:awkward", mod: "eidolon" }],
        ['long_anchored', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:anchored", mod: "eidolon" }],
        ['chilled', { item: 'eidolon:wraith_heart' }, { amount: 1000, fluid: "kubejs:awkward", mod: "eidolon" }],
        ['long_chilled', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:chilled", mod: "eidolon" }],
        ['decay', { item: 'eidolon:withered_heart' }, { amount: 1000, fluid: "kubejs:awkward", mod: "eidolon" }],
        ['long_decay', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:decay", mod: "eidolon" }],
        ['strong_decay', { item: 'minecraft:glowstone' }, { amount: 1000, fluid: "kubejs:decay", mod: "eidolon" }],

        // Naturalist
        ['forest_dasher', { item: 'naturalist:antler' }, { amount: 1000, fluid: "kubejs:awkward", mod: "naturalist" }],
        ['long_forest_dasher', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:forest_dasher", mod: "naturalist" }],
        ['strong_forest_dasher', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:forest_dasher", mod: "naturalist" }],

        // Potions Master
        ['coal_sight', { item: 'potionsmaster:calcinatedcoal_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['iron_sight', { item: 'potionsmaster:calcinatediron_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['redstone_sight', { item: 'potionsmaster:calcinatedredstone_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['lapis_sight', { item: 'potionsmaster:calcinatedlapis_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['gold_sight', { item: 'potionsmaster:calcinatedgold_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['diamond_sight', { item: 'potionsmaster:calcinateddiamond_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['emerald_sight', { item: 'potionsmaster:calcinatedemerald_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['aluminum_sight', { item: 'potionsmaster:calcinatedaluminum_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['copper_sight', { item: 'potionsmaster:calcinatedcopper_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['tin_sight', { item: 'potionsmaster:calcinatedtin_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['nickel_sight', { item: 'potionsmaster:calcinatednickel_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['uranium_sight', { item: 'potionsmaster:calcinateduranium_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['lead_sight', { item: 'potionsmaster:calcinatedlead_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['silver_sight', { item: 'potionsmaster:calcinatedsilver_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['zinc_sight', { item: 'potionsmaster:calcinatedzinc_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['osmium_sight', { item: 'potionsmaster:calcinatedosmium_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['quartz_sight', { item: 'potionsmaster:calcinatedquartz_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['bismuth_sight', { item: 'potionsmaster:calcinatedbismuth_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['crimsoniron_sight', { item: 'potionsmaster:calcinatedcrimsoniron_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['platinum_sight', { item: 'potionsmaster:calcinatedplatinum_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['netherite_sight', { item: 'potionsmaster:calcinatednetherite_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['allthemodium_sight', { item: 'potionsmaster:calcinatedallthemodium_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['vibranium_sight', { item: 'potionsmaster:calcinatedvibranium_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],
        ['unobtainium_sight', { item: 'potionsmaster:calcinatedunobtainium_powder' }, { amount: 1000, fluid: "kubejs:mundane", mod: "potionsmaster" }],

        // Deeper Darker
        ['sculk_affinity', { item: 'deeperdarker:soul_crystal' }, { amount: 1000, fluid: "kubejs:awkward", mod: "deeperdarker" }],
        ['long_sculk_affinity', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:sculk_affinity", mod: "deeperdarker" }],

        // Autumnity
        ['extension', { item: 'autumnity:snail_goo' }, { amount: 1000, fluid: "kubejs:awkward", mod: "autumnity" }],

        // Quark
        ['resilience', { item: 'quark:crab_shell' }, { amount: 1000, fluid: "kubejs:awkward", mod: "quark" }],
        ['long_resilience', { item: 'minecraft:redstone' }, { amount: 1000, fluid: "kubejs:resilience", mod: "quark" }],
        ['strong_resilience', { item: 'minecraft:glowstone_dust' }, { amount: 1000, fluid: "kubejs:resilience", mod: "quark" }]



    ].forEach((potion) => {
        event.custom({
            type: 'create:filling',
            ingredients: [{ fluid: `kubejs:${potion[0]}`, amount: 1000 }, { item: 'minecraft:glass_bottle', mod: "minecraft" }],
            results: [
                {
                    item: 'minecraft:potion',
                    nbt: { Potion: `${potion[2].mod}:${potion[0]}` }
                }
            ]
        });
        event.custom({
            "type": "create:mixing",
            "heatRequirement": "heated",
            "ingredients": [
                potion[1],
                potion[2]
            ],
            "results": [
                { fluid: `kubejs:${potion[0]}`, amount: 1000 }
            ]
        });
    });
})


