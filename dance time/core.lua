vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

models.dances:setPrimaryTexture("SKIN")
models.dances.spinPivot.root.Body.Back.Cape:setPrimaryTexture("CAPE")
models.dances.spinPivot.root.Body.Back.Elytra:setPrimaryTexture("ELYTRA")

local emotes = {}

local current = nil
function clicked(emote, state)
    if current ~= nil and current ~= emote then
        current.action:setToggled(false)
        current.toggled(false)
    end
    
    current = emote
    emote.toggled(state)
end

function events.tick()
    if current ~= nil and current.moveStop and current.playing() and (player:getVelocity().xyz:length() > .01 or player:getPose() ~= "STANDING") then
        current.action:setToggled(false)
        current.toggled(false)
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
    e.action = action
end