local confetti = require("confetti")

local bLife = 15
confetti.registerMesh("blood", models.blood, bLife)
local sOT = 1.0 / bLife

local sitAnim = animations.emotes.sit

function getUp()
    sitAnim:stop()
    renderer:setOffsetCameraPivot(0)
end

function pings.sit()
    if sitAnim:isPlaying() then
        getUp()
    else
        sitAnim:play()
        renderer:setOffsetCameraPivot(0, -9.75 / 16, 0)
    end
end

local hMin = 0.2
local hMax = 0.6
local hRnd = 0.1
local yMin = 0.4
local yMax = 0.8

function random(a)
    return math.random() * a
end

function random2(a, b)
    return a + math.random() * (b-a)
end

function onCutter(pPos, cPos)
    return math.abs(pPos.x - cPos.x) < 0.25 and math.abs(pPos.z - cPos.z) < 0.25
end

function events.tick()
    if sitAnim:isPlaying() then
        if player:getVelocity().xyz:length() > .01 or player:getPose() ~= "STANDING" then -- Get up on move
            getUp()
            return
        end
        
        -- Sitting on a stonecutter kinda hurts
        local sittingOn = world.getBlockState(player:getPos())
        if sittingOn:getID() == "minecraft:stonecutter" then
            local cutterCenter = sittingOn:getPos() + vec(0.5, 0.5, 0.5)
            if onCutter(player:getPos(), cutterCenter) then
                local facing = sittingOn:getProperties().facing
                
                local hVel = random2(hMin, hMax)
                local rnd = random2(-hRnd, hRnd)
                local yVel = random2(yMin, yMax)
                
                local vel = vec(rnd, yVel, hVel) --west
                if facing == "east" then vel.z = -vel.z end
                if facing == "north" then
                    vel.x = -hVel
                    vel.z = rnd
                end
                if facing == "south" then
                    vel.x = hVel
                    vel.z = rnd
                end
                
                confetti.newParticle(
                    "blood",
                    sittingOn:getPos() + vec(0.5, 0.5, 0.5),
                    --player:getPos(),
                    vel,
                    {
                        acceleration = vec(0, -0.1, 0),
                        scaleOverTime = -sOT,
                        rotation = vec(random(360), random(360), random(360))
                    }
                )
                
                sounds:playSound("ui.stonecutter.take_result", player:getPos(), 1, 1, false)
            end
        end
    end
end

local Sit = {}
function Sit.addEmote(emotes)
    local data = {
        title = 'Sit',
        item = 'minecraft:oak_stairs',
        clicked = pings.sit,
        anim = sitAnim
    }
    table.insert(emotes, data)
end
return Sit