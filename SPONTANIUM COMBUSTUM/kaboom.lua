local confetti = require("confetti")
local frames = 16
local ticksPerFrame = 2

confetti.registerMesh("kaboom", models.kaboom.Explosion, frames * ticksPerFrame)

local myparticles = {}
function explode(spawnPos)
    sounds["silly-boom"]
        :pos(spawnPos)
        :pitch(1)
        :volume(1)
        :subtitle("§lF-ING E X P L O D E S")
        :play()
    
    local particle = confetti.newParticle(
        "kaboom",
        spawnPos,
        vec(0, 0, 0)
    )

    particle.mesh:setSecondaryTexture("PRIMARY")
    table.insert(myparticles, particle)
end

function events.TICK()
    local deleted = {} -- copied from the confetti library
    for i, particle in ipairs(myparticles) do
        if(particle.lifetime <= 0) then table.insert(deleted, i) end
        local frame = math.floor(frames - (particle.lifetime + 1) / ticksPerFrame)
        particle.mesh:setUV(0, frame / frames)
    end
    for i, key in ipairs(deleted) do
        table.remove(myparticles, key-(i-1))
    end
end

-- Explode on death
local isDead = false
function events.TICK()
    if not isDead and not player:isAlive() then
        isDead = true
        explode(player:getPos() + vec(0, 1.25, 0))
    elseif player:isAlive() then
        isDead = false
    end
end

-- Explode when click on skull
local hasClicked = {}
function events.skull_render(delta, block)
    if block == nil then return end
    for _, p in pairs(world.getPlayers()) do
        local _, cPos = p:getTargetedBlock()
        local clicked = hasClicked[p:getName()]
        if clicked == nil then clicked = false end
        if not clicked and p:isSwingingArm() and cPos:floor() == block:getPos() then
            hasClicked[p:getName()] = true
            explode(cPos)
        elseif clicked and not p:isSwingingArm() then
            hasClicked[p:getName()] = false
        end
    end
end

-- Explosion emote
vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)
models.animation:setPrimaryTexture("SKIN")
models.animation.Skull:setPrimaryTexture("SKIN")
models.animation.root.Body.Back.Cape:setPrimaryTexture("CAPE")
models.animation.root.Body.Back.Elytra:setPrimaryTexture("ELYTRA")

local deathAnims = {
    animations.animation.death_anim,
    animations.animation.death_anim2,
    animations.animation.death_anim3
}

local animData = {
    death_anim = {
        offsetX = 0.5,
        offsetY = 0.25,
        offsetZ = 0.25,
        duration = 15
    },
    death_anim2 = {
        offsetX = 0,
        offsetY = 0.25,
        offsetZ = 1,
        duration = 10
    },
    death_anim3 = {
        offsetX = 0,
        offsetY = 3,
        offsetZ = -0.125,
        duration = 30
    }
}

local currentAnim = deathAnims[1]
local deathAnimTime = 0
local startYaw = 0
function pings.anim(anim)
    currentAnim:stop()
    currentAnim = deathAnims[anim]
    animStart()
end

function animStart()
    if not player:isLoaded() then return end

    deathAnimTime = 0
    currentAnim:play()
    
    startYaw = player:getBodyYaw()
    models.animation:setRot(0, 180 - player:getBodyYaw(), 0)
    renderer:setRootRotationAllowed(false)
end

function events.TICK()
    if currentAnim:isPlaying() then
        local data = animData[currentAnim:getName()]
        deathAnimTime = deathAnimTime + 1
        if deathAnimTime == data.duration then
            local theta = startYaw / 180 * math.pi
            local sin = math.sin(theta)
            local cos = math.cos(theta)
            explode(player:getPos() + vec(
                data.offsetX * cos - data.offsetZ * sin,
                data.offsetY,
                data.offsetX * sin + data.offsetZ * cos
            ))
        end
    end
    
    if player:getVelocity().xyz:length() > .01 or player:getPose() ~= "STANDING" then -- Stop on move
        deathAnimTime = 0
        currentAnim:stop()
        models.animation:setRot(0, 0, 0)
        renderer:setRootRotationAllowed(true)
    end
end

local _pos = vec(0, 0, 0)
function events.POST_RENDER()
    local data = animData[currentAnim:getName()]
    if not currentAnim:isPlaying() then
        renderer:setOffsetCameraPivot(0)
        return
    elseif deathAnimTime < data.duration then
        _pos:set(models.animation.root.Head:partToWorldMatrix():apply() - player:getPos())
        _pos.y = _pos.y - 1.40718
    end
    renderer:setOffsetCameraPivot(_pos)
end

local page = action_wheel:newPage()
action_wheel:setPage(page)
page:newAction()
    :title('§c§lSPONTANIUM COMBUSTUM')
    :item('minecraft:oak_stairs')
    :hoverColor(1, 0.568627451, 0)
    :setOnLeftClick(function() pings.anim(1) end)
page:newAction()
    :title('§c§lSPONTANIUM COMBUSTUM')
    :item('minecraft:fire_charge')
    :hoverColor(1, 0.568627451, 0)
    :setOnLeftClick(function() pings.anim(2) end)
page:newAction()
    :title('§c§lSPONTANIUM COMBUSTUM')
    :item('minecraft:tnt')
    :hoverColor(1, 0.568627451, 0)
    :setOnLeftClick(function() pings.anim(3) end)