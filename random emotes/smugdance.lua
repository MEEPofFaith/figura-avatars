local dance = animations.emotes.smug_dance

function pings.smugDance()
    if dance:isPlaying() then
        dance:stop()
    else
        dance:play()
    end
end

function events.tick()
    if dance:isPlaying() and (player:getVelocity().xyz:length() > .01 or player:getPose() ~= "STANDING") then -- Get up on move
        dance:stop()
    end
end

local SmugDance = {}
function SmugDance.addEmote(emotes)
    local data = {
        title = 'Smug Dance',
        item = 'minecraft:leather_helmet',
        clicked = pings.smugDance,
        anim = dance
    }
    table.insert(emotes, data)
end
return SmugDance