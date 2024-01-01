


--Playdate Imports

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"
import "CoreLibs/frameTimer"

import "helpers"

-- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- NOTE: Because it's local, you'll have to do it in every .lua source file.
local gfx <const> = playdate.graphics


import "loadImages"

import "thing" --generic physics "thing"


local playerThing = thing:new();




function myGameSetUp()
    
    
	
	--sprite = gfx.sprite.new(myImages.gameStuff);
	--sprite:add()
end

function playdate.update()
    playerThing:update()
    
    --sprite:moveTo(playerThing.pos.x,playerThing.pos.y)
    
    gfx.sprite.update()
    playdate.timer.updateTimers()
    playdate.frameTimer.updateTimers()
    playdate.drawFPS()
end



myGameSetUp()
