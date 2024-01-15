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
	local pushLeft = {}             
	local pushRight = {}           
    local pushUp = {}                
	local pushDown = {}
    local f = function ()
        bbox = whoToKeepOut.boundingBox:offsetBy(whoToKeepOut.pos.x, whoToKeepOut.pos.y)
        pushLeft = {playdate.geometry.vector2D.new(bbox.x+bbox.width, bbox.y), playdate.geometry.vector2D.new(bbox.x+bbox.width, bbox.y+bbox.height)}
        pushRight = {playdate.geometry.vector2D.new(bbox.x, bbox.y), playdate.geometry.vector2D.new(bbox.x, bbox.y+bbox.height)}
        pushUp = {playdate.geometry.vector2D.new(bbox.x, bbox.y+bbox.height), playdate.geometry.vector2D.new(bbox.x+bbox.width, bbox.y+bbox.height)}
        pushDown = {playdate.geometry.vector2D.new(bbox.x, bbox.y), playdate.geometry.vector2D.new(bbox.x+bbox.width, bbox.y)}
    end
    f()
    for k,v in pairs(pushLeft) do
        while mgrLevels.colTestLevel(v) do
            whoToKeepOut.velocity.x = 0
            whoToKeepOut.pos.x = whoToKeepOut.pos.x - 1
            v.x = v.x-1
            print(v)
            
        end
        f()
    end
    for k,v in pairs(pushRight) do
        while mgrLevels.colTestLevel(v) do
            whoToKeepOut.velocity.x = 0
            whoToKeepOut.pos.x = whoToKeepOut.pos.x + 1
            v.x = v.x+1
        end
        f()
    end
end