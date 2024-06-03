local breakdanceStart = animations.dances.breakdance_start
local breakdanceLoop = animations.dances.breakdance_loop
local skullBreakdance = animations.dance_skull.mini_breakdance

models.dance_skull.Skull:setPrimaryTexture("SKIN")

function events.skull_render(delta, block, item, entity, mode)
    if mode == "HEAD" then
        models.dance_skull.Skull:setPos(0, 7, 0)
    else
        models.dance_skull.Skull:setPos(0, 0, 0)
    end
end

local playing = false
local playTime = 0
function stopBreakdancing()
    breakdanceStart:stop()
    breakdanceLoop:stop()
    playing = false
end

function pings.breakdance(state)
    playing = state
    if state then
        breakdanceStart:play()
        playing = true
        playTime = 0
    else
        stopBreakdancing()
    end
end

function pings.stopBreakdance()
    stopBreakdancing()
end

function events.tick()
    if playing then
        playTime = playTime + 1
        if playTime == 75 then
            breakdanceStart:stop()
            breakdanceLoop:play()
        end
    end
    
    if not skullBreakdance:isPlaying() then
        skullBreakdance:play()
    end
end

function isPlaying()
    return playing
end

function addEmote(emotes)
    local data = {
        title = 'Breakdancing',
        item = 'minecraft:cherry_sapling',
        toggledColor = vectors.vec3(245, 95, 217) / 255,
        toggled = pings.breakdance,
        playing = isPlaying,
        moveStop = true
    }
    table.insert(emotes, data)
end
return addEmote