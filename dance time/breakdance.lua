local breakdanceStart = animations.dances.breakdance_start
local breakdanceLoop = animations.dances.breakdance_loop
local skullBreakdance = animations.dance_skull.mini_breakdance

models.dance_skull.Skull:setPrimaryTexture("SKIN")

local playing = false
local playTime = 0
function stop()
    breakdanceStart:stop()
    breakdanceLoop:stop()
    playing = false
end

function pings.breakdance()
    if playing then
        stop()
    else
        breakdanceStart:play()
        playing = true
        playTime = 0
    end
end

function pings.stopBreakdance()
    stop()
end

function events.tick()
    if playing then
        if (player:getVelocity().xyz:length() > .01 or player:getPose() ~= "STANDING") then
            stop()
            return
        end
        
        playTime = playTime + 1
        if playTime == 80 then
            breakdanceStart:stop()
            breakdanceLoop:play()
        end
    end
    
    if not skullBreakdance:isPlaying() then
        skullBreakdance:play()
    end
end

function addEmote(emotes)
    local data = {
        title = 'Breakdancing',
        item = 'minecraft:cherry_sapling',
        clicked = pings.breakdance,
        stop = pings.stopBreakdance
    }
    table.insert(emotes, data)
end
return addEmote