vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

models.dances:setPrimaryTexture("SKIN")
models.dances.spinPivot.root.Body.Back.Cape:setPrimaryTexture("CAPE")
models.dances.spinPivot.root.Body.Back.Elytra:setPrimaryTexture("ELYTRA")

local emotes = {}

function clicked(emote, state)
    if emote.exclusive then
        for i, e in pairs(emotes) do
            if e.exclusive and e.playing() then
                e.action:setToggled(false)
                e.toggled(false)
            end
        end
    end
    
    emote.toggled(state)
end

function events.tick()
    if player:getVelocity().xyz:length() > .01 or player:getPose() ~= "STANDING" then
        for i, e in pairs(emotes) do
            if e.moveStop and e.playing() then
                e.action:setToggled(false)
                e.toggled(false)
            end
        end
    end
end

require("smugdance")(emotes)
require("breakdance")(emotes)
require("clipping")(emotes)
require("spin")(emotes)

local page = action_wheel:newPage()
action_wheel:setPage(page)
for i, e in pairs(emotes) do
    local action = page:newAction()
        :title(e.title)
        :item(e.item)
        :setOnToggle(function(state) clicked(e, state) end)
    if e.toggledColor ~= nil then action:setToggleColor(e.toggledColor) end
    if e.exclusive == nil then e.exclusive = true end
    e.action = action
end