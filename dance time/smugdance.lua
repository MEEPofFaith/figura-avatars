local smugDance = animations.emotes.smug_dance

function pings.smugDance()
    if smugDance:isPlaying() then
        smugDance:stop()
    else
        smugDance:play()
    end
end

function pings.stopSmugDance()
    smugDance:stop()
end

function events.tick()
    if smugDance:isPlaying() and (player:getVelocity().xyz:length() > .01 or player:getPose() ~= "STANDING") then
        smugDance:stop()
    end
end

function addEmote(emotes)
    local data = {
        title = 'Smug Dance',
        item = 'minecraft:leather_helmet',
        clicked = pings.smugDance,
        stop = pings.stopSmugDance
    }
    table.insert(emotes, data)
end
return addEmote