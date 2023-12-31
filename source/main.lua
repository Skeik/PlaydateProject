function clamp(value, min, max)
    return math.max(math.min(value, max), min)
end

--Playdate Imports

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "thing" --generic physics "thing"

-- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- NOTE: Because it's local, you'll have to do it in every .lua source file.
local gfx <const> = playdate.graphics

local playerThing = thing:new();

function myGameSetUp()
end

function playdate.update()
    playerThing:update()

    gfx.sprite.update()
    playdate.timer.updateTimers()
    
    playdate.drawFPS()
end



myGameSetUp()
