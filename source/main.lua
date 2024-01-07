VERBOSE = false;


--Playdate Imports

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"
import "CoreLibs/frameTimer"

import "helpers"
import "Signal"


SIGNALS = Signal()

-- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- NOTE: Because it's local, you'll have to do it in every .lua source file.
local gfx <const> = playdate.graphics


import "loadImages"
import "loadLevels"

import "swipe" --swordSwipes
import "player" --generic physics "thing"
import "mgrEffects"
import "mgrLevels"


function myGameSetUp()

    playerThing = player:new();

    mgrLevels.init()
	
    
	--sprite = gfx.sprite.new(myImages.gameStuff);
	--sprite:add()
end




function playdate.update()
    playerThing:update()
    
    --sprite:moveTo(playerThing.pos.x,playerThing.pos.y)
    mgrEffects.update()
    gfx.sprite.update()
    playdate.timer.updateTimers()
    playdate.frameTimer.updateTimers()
    playdate.drawFPS()
end


function playdate.debugDraw()
    playdate.graphics.drawCircleAtPoint(playerThing.pos.x, playerThing.pos.y, 5)
end




myGameSetUp()
