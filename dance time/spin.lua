local spin = false
local spinAmount = 0
function pings.toggleSpin(state)
    spin = state
    if not state then
        spinAmount = 0
        models.dances.spinPivot:setRot(0, 0, 0)
    end
end

function events.render(delta)
    if spin then
        spinAmount = spinAmount + delta
        models.dances.spinPivot:setRot(0, spinAmount, 0)
    end
end

function isPlaying()
    return spin
end

function addEmote(emotes)
    local data = {
        title = 'Spin',
        item = 'minecraft:music_disc_otherside',
        toggled = pings.toggleSpin,
        playing = isPlaying,
        moveStop = false
    }
    table.insert(emotes, data)
end
return addEmote