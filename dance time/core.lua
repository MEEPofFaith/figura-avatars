vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

models.dances:setPrimaryTexture("SKIN")
models.dances.root.Body.Back.Cape:setPrimaryTexture("CAPE")
models.dances.root.Body.Back.Elytra:setPrimaryTexture("ELYTRA")

local emotes = {}

local current = nil
function clicked(emote)
    if current ~= nil and current ~= emote then
        current.stop()
    end
    
    current = emote
    emote.clicked()
end

require("smugdance")(emotes)
require("breakdance")(emotes)

local page = action_wheel:newPage()
action_wheel:setPage(page)
for i, e in pairs(emotes) do
    page:newAction()
        :title(e.title)
        :item(e.item)
        :setOnLeftClick(function() clicked(e) end)
end