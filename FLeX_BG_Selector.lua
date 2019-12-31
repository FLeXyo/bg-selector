local function SetSelectedBattlefieldByNumber(bgNumber)
    for i=1, GetNumBattlefields(), 1 do
        if tostring(GetBattlefieldInstanceInfo(i)) == bgNumber then
            SetSelectedBattlefield(i);
            BattlefieldFrame_Update();
            return true;
        end
    end
    return false;
end

StaticPopupDialogs["BG_SELECTOR_NOT_FOUND"] = {
    text = "BG with that number was not found.",
    button1 = "Okay",
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    referredIndex = 3
  }

local frame = CreateFrame("Frame", "BGSelectorFrame", BattlefieldFrame);

local editBox = CreateFrame("EditBox", "BGSelectorEditBox", frame, "InputBoxTemplate");
editBox:SetSize(80, 22);
editBox:SetPoint("CENTER", BattlefieldFrame, "TOPLEFT", 305, -401);
editBox:SetAutoFocus(false);
editBox:SetNumeric(true);
editBox:SetScript("OnEnterPressed", function(self)
    self:ClearFocus();
    local text = self:GetText();

    if SetSelectedBattlefieldByNumber(text) then
        BattlefieldFrameJoinButton:SetText(BATTLEFIELD_JOIN.."("..text..")");
    elseif text == "" then
        BattlefieldFrame_Update();
        BattlefieldFrameJoinButton:SetText(BATTLEFIELD_JOIN);
    else
        StaticPopup_Show("BG_SELECTOR_NOT_FOUND");
        BattlefieldFrameJoinButton:SetText(BATTLEFIELD_JOIN);
    end
end)

editBox:SetScript("OnShow", function(self)
    self:SetText("");
    BattlefieldFrameJoinButton:SetText(BATTLEFIELD_JOIN);
end)

--Prevent bg frame from closing when queueing
--hacky as fuck, but you gotta do what you gotta do
local origHideUIPanel = HideUIPanel;
HideUIPanel = function(frame)
    local stacktrace = debugstack(2, 1);
    if stacktrace:find("BattlefieldFrameJoinButton_OnClick")
    or stacktrace:find("SSPVP.lua") then
        return;
    else
        origHideUIPanel(frame);
    end
end
