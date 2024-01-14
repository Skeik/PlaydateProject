mgrLevels = {}
mgrLevels.levelTilemapSprites = {}
mgrLevels.levelTilemapExits = {}
mgrLevels.levelTilemapHitbox = nil
mgrLevels.loadTo = 'default'
mgrLevels.curLevel = nil
local TILEMAP_ZINDEX_START = -1000
local TILEMAP_ZINDEX_ITERATOR = 10
local gfx <const> = playdate.graphics





function mgrLevels.init()
    mgrLevels.loadLevel(levels.r1a001)
end



function mgrLevels.colTestLevel(loc)
   
    if   mgrLevels.curLevel ~= nil and mgrLevels.levelTilemapHitbox  ~= nil then
        local intX = math.floor(loc.x/mgrLevels.curLevel.tilewidth)
        local intY = math.floor(loc.y/mgrLevels.curLevel.tilewidth)
        local tileMapPos =  (intY * mgrLevels.curLevel.width)+intX
        return mgrLevels.levelTilemapHitbox.data[tileMapPos]
    end
    
end


function mgrLevels.update()
    if mgrLevels.levelTilemapExits['objects']  ~= nil  then
        for k,v in pairs(mgrLevels.levelTilemapExits['objects']) do

            local box = {x=v.x, w=v.width, y=v.y, h=v.height}
            if insideBox(playerThing.pos.x, playerThing.pos.y, box) then
                local t = mysplit(v.name, "-")
                local nextLevel = t[1]
                mgrLevels.loadTo = t[2]
                mgrLevels.loadLevel(levels[nextLevel])
            end
        end
    end
end


--Feed a Tiled layers table into this function and it will render
    --all the layers in order. 
function mgrLevels.renderLevelTilemaps(layersTable)
    mgrLevels.levelTilemapExits = {}


    for k,v in pairs(mgrLevels.levelTilemapSprites) do
        v:remove();
    end
    mgrLevels.levelTilemapSprites = {}
    mgrLevels.levelTilemapHitbox = nil
    local layersAdded = 0;
    for k,v in pairs(layersTable) do
        if string.find(v.name, 'render') then
            
            local tilemap = playdate.graphics.tilemap.new()
            tilemap:setImageTable(myImages.mainTilesheet )
            tilemap:setTiles(v.data, v.width)
            local newTilemapSprite = gfx.sprite.new(tilemap)
            newTilemapSprite:setCenter(0, 0)
            newTilemapSprite:add()

            newTilemapSprite:setZIndex(TILEMAP_ZINDEX_START + (TILEMAP_ZINDEX_ITERATOR * layersAdded) )

            table.insert(mgrLevels.levelTilemapSprites, newTilemapSprite);
            layersAdded = layersAdded + 1
        end       
        
        --look for the entry point of the player to set their position.
        if string.find(v.name, 'entry') then
            for kk,vv in pairs(v.objects) do
                if string.find(vv.name, mgrLevels.loadTo) then
                    playerThing.pos.x = vv.x
                    playerThing.pos.y = vv.y
                end  
            end
        end

        if string.find(v.name, 'exit') then
            mgrLevels.levelTilemapExits = v;
        end        
        if string.find(v.name, 'hitbox') then
            mgrLevels.levelTilemapHitbox = v;
        end    
        
    end  

    
end
function mgrLevels.loadLevel(levelTable)
    mgrLevels.curLevel = nil
    camBounds.w = levelTable.tilewidth * levelTable.width
    camBounds.h = levelTable.tileheight * levelTable.height
    mgrLevels.renderLevelTilemaps(levelTable.layers)
    mgrLevels.curLevel = levelTable
    
end 

SIGNALS:subscribe("loadLevel", mgrEffects, function(_, __, ___, posX, posY)
    local newSwipe = swipe:new()
    newSwipe.pos.x = posX
    newSwipe.pos.y = posY
    table.insert(mgrEffects.swipeEffects, newSwipe)
   
 end)