mgrEffects = {}
mgrEffects.swipeEffects = {}

function mgrEffects.update()
    for i=#mgrEffects.swipeEffects,1,-1 do
        mgrEffects.swipeEffects[i]:update()
    end
    for i=#mgrEffects.swipeEffects,1,-1 do
        if mgrEffects.swipeEffects[i].dead then
            table.remove(mgrEffects.swipeEffects, i)
        end
    end   
end

SIGNALS:subscribe("swipe", mgrEffects, function(_, __, ___, posX, posY)
    local newSwipe = swipe:new()
    newSwipe.pos.x = posX
    newSwipe.pos.y = posY
    table.insert(mgrEffects.swipeEffects, newSwipe)
   
 end)