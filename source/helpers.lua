function clamp(value, min, max)
    return math.max(math.min(value, max), min)
end
function showToast(text, duration)
    local t = playdate.frameTimer.new(duration)
    t.updateCallback = function()
        gfx.setColor(playdate.graphics.kColorBlack)
        gfx.drawTextAligned(text, 200, 70, kTextAlignment.center)
    end
end