local smugDance = animations.dances.smug_dance

function pings.smugDance(state)
    if state then
        smugDance:play()
    else
        smugDance:stop()
    end
end

function isPlaying()
    return smugDance:isPlaying()
end

function addEmote(emotes)
    local data = {
        title = 'Smug Dance',
        item = 'minecraft:leather_helmet',
        toggled = pings.smugDance,
        playing = isPlaying,
        moveStop = true
    }
    table.insert(emotes, data)
end
return addEmote