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

--Only print certain things if we are in verbose printing mode.
function printy(v,verbosity)
    if VERBOSE and verbosity then
        print(v)
    elseif not VERBOSE then
        print(v)
    end
end

function insideBox(x, y, box)
    if x>=box.x and x<= box.x+box.w then
        if y>=box.y and y<= box.y+box.h then
            return true
        end
    end
    return false
end

function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end


--whoToKeepOut MUST have a variable called pos, velocity, and must have a boundingBox 
function keepOutOfWalls(whoToKeepOut)

	--wall collision logic
	local bbox = {}               



    bbox = whoToKeepOut.boundingBox:offsetBy(whoToKeepOut.pos.x, whoToKeepOut.pos.y)

    local pLeft = function (vec)
        while (mgrLevels.colTestLevel(vec) or 0 )~= 0 do
            whoToKeepOut.velocity.x = 0
            whoToKeepOut.pos.x = whoToKeepOut.pos.x - 1
            vec.x = vec.x-1          
        end        
        bbox = whoToKeepOut.boundingBox:offsetBy(whoToKeepOut.pos.x, whoToKeepOut.pos.y)
    end
    local pRight = function (vec)
        while (mgrLevels.colTestLevel(vec) or 0 )~= 0 do
            whoToKeepOut.velocity.x = 0
            whoToKeepOut.pos.x = whoToKeepOut.pos.x + 1
            vec.x = vec.x + 1          
        end        
        bbox = whoToKeepOut.boundingBox:offsetBy(whoToKeepOut.pos.x, whoToKeepOut.pos.y)
    end

    local pUp = function (vec)
        while (mgrLevels.colTestLevel(vec) or 0 )~= 0 do
            whoToKeepOut.velocity.y = 0
            whoToKeepOut.pos.y = whoToKeepOut.pos.y - 1
            vec.y = vec.y-1          
        end        
        bbox = whoToKeepOut.boundingBox:offsetBy(whoToKeepOut.pos.x, whoToKeepOut.pos.y)
    end
    local pDown = function (vec)
        while (mgrLevels.colTestLevel(vec) or 0 )~= 0 do
            whoToKeepOut.velocity.y = 0
            whoToKeepOut.pos.y = whoToKeepOut.pos.y + 1
            vec.y = vec.y + 1          
        end        
        bbox = whoToKeepOut.boundingBox:offsetBy(whoToKeepOut.pos.x, whoToKeepOut.pos.y)
    end


    local cornerOffset = 10

    pLeft(playdate.geometry.vector2D.new(bbox.x+bbox.width,     bbox.y+cornerOffset))
    pLeft(playdate.geometry.vector2D.new(bbox.x+bbox.width,     bbox.y+bbox.height - cornerOffset))

    
    pRight(playdate.geometry.vector2D.new(bbox.x,               bbox.y + cornerOffset))
    pRight(playdate.geometry.vector2D.new(bbox.x,               bbox.y+bbox.height-cornerOffset))

    pUp(playdate.geometry.vector2D.new(bbox.x+cornerOffset,                  bbox.y+bbox.height))
    pUp(playdate.geometry.vector2D.new(bbox.x+bbox.width-cornerOffset,       bbox.y+bbox.height))

    pDown(playdate.geometry.vector2D.new(bbox.x+cornerOffset,                bbox.y))
    pDown(playdate.geometry.vector2D.new(bbox.x+bbox.width-cornerOffset,     bbox.y))
    playdate.graphics.drawRect(bbox)

end