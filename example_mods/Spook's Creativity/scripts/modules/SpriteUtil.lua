local module = {}

-- tag
-- x, y
-- cam
-- image
-- scrollX, scrollY
-- front 
-- xSize, ySize
-- screenCenter
function module.makeSprite(tabler)
    if tabler.cache ~= null then 
        for i,v in pairs(tabler.cache) do
            preloadImage(v)
        end
    end
    local tag = tabler.tag or "tag"
    makeLuaSprite(tag, tabler.image or "", tabler.x or 0 , tabler.y or 0)
    setScrollFactor(tag, tabler.scrollX or 1 ,tabler.scrollY or 1)
    addLuaSprite(tag, tabler.front or false)
    if tabler.xSize ~= nil then
        scaleObject(tag, tabler.xSize or 1, tabler.ySize or tabler.xSize or 1, true)
    end
    if tabler.graphicWidth ~= nil then 
        makeGraphic(tag, tabler.graphicWidth or 100, tabler.graphicHeight or 100, tabler.graphicColor or "FFFFFF")
    end
    if tabler.cam ~= nil then
        setObjectCamera(tag, tabler.cam or "camGame")
    end
        
end

-- tag
-- x, y
-- cam
-- image
-- scrollX, scrollY
-- front 
-- xSize, ySize
function module.makeAnimateSprite(tabler)
    if tabler.cache ~= null then 
        for i,v in pairs(tabler.cache) do
            preloadImage(v)
        end
    end
    local tag = tabler.tag or "tag"
    makeAnimatedLuaSprite(tag, tabler.image or "", tabler.x or 0 , tabler.y or 0)
    setScrollFactor(tag, tabler.scrollX or 1 ,tabler.scrollY or 1)
    addLuaSprite(tag, tabler.front or false)
    if tabler.xSize ~= nil then
        scaleObject(tag, tabler.xSize or 1, tabler.ySize or tabler.xSize or 1)
    end
    setObjectCamera(tag, tabler.cam or "camGame")
end

-- tag
-- x, y
-- width
-- text
-- cam
-- scrollX, scrollY
-- antialiasing
-- borderQuality
function module.makeText(tabler)
    local tag = tabler.tag or "teg"
   makeLuaText(tag, tabler.text or tag, tabler.width or 0, tabler.x or 0, tabler.y or 0)
   setScrollFactor(tag, tabler.scrollX or 0 ,tabler.scrollY or 0)
   addLuaText(tag)

   if tabler.font ~= nil then setTextFont(tag, tabler.font or "vcr.ttf") end
   setTextAlignment(tag, tabler.align or "center")
   setProperty(tag..".borderQuality", tabler.borderQuality or 0)
   setTextBorder(tag, tabler.borderSize or 2, tabler.borderColor or '000000')
   setTextSize(tag, tabler.size or 16)
   setTextColor(tag, tabler.color or "FFFFFF")
   setProperty(tag..".antialiasing", tabler.antialiasing or getPropertyFromClass("ClientPrefs", "globalAntialiasing"))
   if tabler.cam ~= nil then
    setObjectCamera(tag, tabler.cam or "camHUD")
   end
end

return module