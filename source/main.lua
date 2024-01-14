VERBOSE = false;
PLAYER_ZINDEX = 10
shakeFramesSoft = 0

--Playdate Imports

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"
import "CoreLibs/frameTimer"

import 'res/sound/pulp-audio'


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
    pulp.audio.init('res/sound/pulp-songs.json', 'res/sound/pulp-sounds.json')

    mgrLevels.init()
	
    pulp.audio.playSong('theme')
    
	--sprite = gfx.sprite.new(myImages.gameStuff);
	--sprite:add()
end




camBounds = {x=0, y=0, w=0, h=0}
function playdate.update()

    playerThing:update()
    pulp.audio.update()

    --sprite:moveTo(playerThing.pos.x,playerThing.pos.y)
    mgrEffects.update()
    mgrLevels.update()
    gfx.pushContext()


    local toOffset = {x = -playerThing.pos.x +200, y = -playerThing.pos.y + 120}

    toOffset.x = clamp(toOffset.x, -camBounds.w+400, camBounds.x  )
    toOffset.y = clamp(toOffset.y, -camBounds.h+240 , -camBounds.y)
    
    if shakeFramesSoft > 0 then
        shakeFramesSoft = shakeFramesSoft - 1 
        gfx.setDrawOffset(math.floor(toOffset.x + math.random(-2,2)) , math.floor(toOffset.y)  + math.random(-2,2))
    else
        gfx.setDrawOffset(math.floor(toOffset.x) , math.floor(toOffset.y))
    end
    
    gfx.sprite.update()

    gfx.popContext()

    playdate.timer.updateTimers()
    playdate.frameTimer.updateTimers()
    playdate.drawFPS()
end


function playdate.debugDraw()
    playdate.graphics.drawCircleAtPoint(playerThing.pos.x, playerThing.pos.y, 5)
end




myGameSetUp()
