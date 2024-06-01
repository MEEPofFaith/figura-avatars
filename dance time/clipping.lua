local clipping = false
function pings.clipIntoTheFloor(state)
    clipping = state
    if not state then
        models.dances.spinPivot.root
            :setPos(0, 0, 0)
            :setRot(0, 0, 0)
    end
end

local clipSounds = {
    "block.stone.break",
    "item.shield.block",
    "entity.goat.ram_impact",
    "block.deepslate.hit",
    "entity.generic.explode" --May be too insane
}

local posRandMax = 12
function posRand()
    return -posRandMax + 2 * math.random() * posRandMax
end

function rotRand()
    return math.random() * 360
end

function playRandSound()
    local sound = clipSounds[math.random(#clipSounds)]
    sounds[sound]:pos(player:getPos())
        :pitch(0.95 + math.random() * 0.1)
        :volume(1)
        :subtitle("Send Help") --Subtitle needs to be set before clipping
        :play()
end

function events.tick()
    if clipping then
        models.dances.spinPivot.root
            :setPos(posRand(), -15 + posRand(), posRand())
            :setRot(rotRand(), rotRand(), rotRand())
        
        playRandSound()
    end
end

function isPlaying()
    return clipping
end

function addEmote(emotes)
    local data = {
        title = 'Clipping',
        item = 'minecraft:stone',
        toggledColor = vectors.vec3(125, 125, 125) / 255,
        toggled = pings.clipIntoTheFloor,
        playing = isPlaying,
        moveStop = false,
        exclusive = false
    }
    table.insert(emotes, data)
end
return addEmote