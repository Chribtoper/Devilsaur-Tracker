local frame = CreateFrame('Frame', 'DragFrame2', UIParent)
local mins = 0
local secs = 0
local spawned = false
local total = 0

local function onUpdate(self, elapsed)
    total = total + elapsed
    if total >= 1 and spawned == true then
        total = 0
        secs = secs + 1
        frame.text:SetText(mins..":"..secs)
    elseif spawned == false then
        frame.text:SetText("Waiting...")
    end

    if secs == 60 then
        secs = 0
        mins = mins + 1
    end
end

function frame:OnEvent(event, ...)
    local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags,
          sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...

        if subevent == 'UNIT_DIED' and string.match(destName, "Devilsaur") then
            DEFAULT_CHAT_FRAME:AddMessage(destName.." has died")
            mins = 0
            secs = 0
            spawned = true
        end
end

frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
frame:SetScript('OnUpdate', onUpdate)
frame:SetScript("OnEvent", function(self, event)
    -- pass a variable number of arguments
    self:OnEvent(event, CombatLogGetCurrentEventInfo())
end)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:SetBackdrop(StaticPopup1:GetBackdrop())
frame:RegisterForDrag('LeftButton')
frame:SetScript('OnDragStart', frame.StartMoving)
frame:SetScript('OnDragStop', frame.StopMovingOrSizing)
frame:SetPoint('LEFT')
 -- width, height
frame:SetSize(200, 100)

frame.text = frame:CreateFontString(nil, 'BACKGROUND', 'GameFontNormal')
frame.text:SetAllPoints()
