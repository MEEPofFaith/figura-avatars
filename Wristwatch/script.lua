function events.entity_init()
  models.watch.root.RightArm.moon:setOpacity(0) --Apparently it's nil if never set
end

function canSleep(delta)
    if world.isThundering() then return true end
    local time = world.getDayTime(delta)
    if world.getRainGradient() == 1 then return 12010 < time and time < 23991 end
    return 12542 < time and time < 23459
end

function events.render(delta, context)
    local time = world.getDayTime(delta) + 6000 -- Noon is 6000
    models.watch.root.RightArm.hour:setRot(0, 0, 180 + time / 12000 * 360)
    models.watch.root.RightArm.minute:setRot(0, 0, 180 + time / 1000 * 360)
    
    local opacity = models.watch.root.RightArm.moon:getOpacity()
    if canSleep(delta) then
        opacity = opacity + (1.0 - opacity) * 0.01 * delta
    else
        opacity = opacity + (0.0 - opacity) * 0.01 * delta
    end
    models.watch.root.RightArm.moon:setOpacity(opacity)
end
