local elements = {
    arcane = {
        items = {
            "wizards:wand_arcane",
            "wizards:wand_netherite_arcane",
            "wizards:staff_arcane",
            "wizards:staff_netherite_arcane",
            "wizards:staff_crystal_arcane",
            "spellbladenext:arcane_blade",
            "spellbladenext:crystal_cutlass",
            "spellbladenext:arcane_claymore",
            "spellbladenext:arcane_orb"
        },
        color = vec(245, 83, 237) / 255
    },
    fire = {
        items = {
            "wizards:wand_novice",
            "wizards:wand_fire",
            "wizards:wand_netherite_fire",
            "wizards:staff_fire",
            "wizards:staff_netherite_fire",
            "wizards:staff_ruby_fire",
            "spellbladenext:fire_blade",
            "spellbladenext:flaming_falchion",
            "spellbladenext:fire_claymore",
            "spellbladenext:fire_orb"
        },
        color = vec(255, 100, 0) / 255
    },
    frost = {
        items = {
            "wizards:wand_frost",
            "wizards:wand_netherite_frost",
            "wizards:staff_frost",
            "wizards:staff_netherite_frost",
            "wizards:staff_smaragdant_frost",
            "spellbladenext:frost_blade",
            "spellbladenext:glacial_gladius",
            "spellbladenext:frost_claymore",
            "spellbladenext:frost_orb"
        },
        color = vec(0, 238, 255) / 255
    },
    holy = {
        items = {
            "paladins:acolyte_wand",
            "paladins:holy_wand",
            "paladins:diamond_holy_wand",
            "paladins:netherite_holy_wand",
            "paladins:holy_staff",
            "paladins:diamond_holy_staff",
            "paladins:netherite_holy_staff",
            "paladins:netherite_ruby_staff"
        },
        color = vec(255, 255, 66) / 255
    },
    multi = {
        items = {
            "wizards:staff_wizard",
            "spellbladenext:starforge",
            "spellbladenext:voidforge"
        },
        color = vec(1, 1, 1)
    }
}
local elementLess = vec(54, 54, 54) / 255
local currentColor = elementLess:copy()

local parts = {
    models.golem.root.Body.Crystal
}

--Emissive fks with the colors
--[[
for _, part in pairs(parts) do
    part:setSecondaryTexture('PRIMARY')
end
]]

function events.RENDER(delta, context, matrix)
    local targetColor = checkColor(player:getHeldItem())
    if targetColor == elementLess then targetColor = checkColor(player:getHeldItem(true)) end
    
    colorApproach(currentColor, targetColor, 0.1 * delta)

    for _, part in pairs(parts) do
        part:setPrimaryColor(currentColor)
        --part:setSecondaryColor(currentColor)
    end
end

function checkColor(held)
    for i, element in pairs(elements) do
        for j, item in pairs(element.items) do
            if held:getID() == item then
                return element.color;
            end
        end
    end
    return elementLess;
end

function colorApproach(from, to, delta)
    local dr = from.r - to.r
    local dg = from.g - to.g
    local db = from.b - to.b
    local delta2 = delta * delta
    local len2 = dr * dr + dg * dg + db * db
    
    if len2 > delta2 then
        local scl = math.sqrt(delta2 / len2)
        dr = dr * scl
        dg = dg * scl
        db = db * scl
        
        return from:sub(dr, dg, db)
    end
    
    return from:set(to)
end