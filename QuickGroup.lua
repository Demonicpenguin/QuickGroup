-- Author      : Demonicpenguin

	SLASH_QUICKGROUP1, SLASH_QUICKGROUP2 = "/qg", "/QG";
	lKeystone = nil;
	local KeystoneId = 158923
	dialog = nil;
	bTank = false;
	bHeal = false;
	bDPS = false;
	bAutoConfirm = false;
	sNote = "";
	local appliedgroups = {}
	wtarget = "";
	iMode = 0;
	achid = 13322;

SlashCmdList["QUICKGROUP"] = function(msg)
	local command = strsplit(" ",msg)
	if command == nil or command == "" then
		QuickGroupFrame:Show()
	elseif command == "set" then
		QuickGroupFrame:Show()
	-- elseif command == "print" then
		-- if bTank == true then print("Tank: True") else print("Tank: False") end
		-- if bHeal == true then print("Heal: True") else print("Heal: False") end
		-- if bDPS == true then print("DPS: True") else print("DPS: False") end
	elseif command == "join" then
		-- local result = GetMouseFocus().resultID
		-- if result ~= nil then
		-- a, b, c, d, e, f, g, h, i, j, k, l, w = C_LFGList.GetSearchResultInfo(result);
		-- end
		
		-- if w ~= nil and result ~= nil then
		
		-- if bTank == false and bHeal == false and bDPS == false then
			-- PopupMessage("No roles configured");
			-- QuickGroupFrame:Show()
			-- return;
		-- else
			-- C_LFGList.ApplyToGroup(result, sNote, bTank, bHeal, bDPS);		
		-- end
		
		-- if iMode == 0 then
			-- local keystones = GetKeystone()
			-- for i = 1, #keystones do
				-- lKeystone = keystones[i]
			-- end
	
			-- if lKeystone == nil then
				-- PopupMessage("No key setup!");
			-- else
				-- SendChatMessage(lKeystone, "WHISPER", nil, w); 
			-- end
		-- elseif iMode == 1 then
			-- SendChatMessage(GetAchievementLink(achid), "WHISPER", nil, w);
		-- elseif iMode == nil then
			-- PopupMessage("You broke the addon")
		-- end
		
	 -- else
      -- if w == nil then
        -- PopupMessage("Error trying to find leader");
      -- end
      -- if result == nil then
        -- PopupMessage("No result found, were you moused over the LFG window?");
      -- end
    -- end
	elseif command == "id" then
		if GetMouseFocus().id ~= nil then
			achid = GetMouseFocus().id;
			achid = achid + 0;
			if achid > 0 then
				PopupMessage("Achievement set to: "..GetAchievementLink(achid));
			else
				PopupMessage("No Achievement found, please mouse over an achievement and run the command again");
			end
		else
			PopupMessage("No Achievement found, please mouse over an achievement and run the command again");
		end
	end

end	

function QuickGroupFrame_OnLoad()

	QuickGroupFrame:Hide()
	print("QuickGroup: Loaded, use /qg to open the main window!")
	TankTexture:SetTexCoord(GetTexCoordsForRole("TANK"));
	HealsTexture:SetTexCoord(GetTexCoordsForRole("HEALER"));
	DPSTexture:SetTexCoord(GetTexCoordsForRole("DAMAGER"));
	
	local joinFrame = CreateFrame("Button", "joinFrame", LFGListFrame.SearchPanel, 'UIPanelButtonTemplate')
	joinFrame:SetScript("OnMouseDown", JoinGroup)
	joinFrame:SetSize(96,26)
	joinFrame:SetText("Quick Join")
	joinFrame:SetPoint("RIGHT", LFGListFrame.SearchPanel.RefreshButton, "LEFT", -5, 0)

	StaticPopupDialogs["AppliedGroupFrame"] = {
					text = "You have recently applied to this group, do you want to continue?",
					button1 = "Yes",
					button2 = "No",
					OnAccept = function()
						
						--C_LFGList.ApplyToGroup(dialog, sNote, bTank, bHeal, bDPS);
						C_LFGList.ApplyToGroup(dialog, bTank, bHeal, bDPS);
						SendWhisper(wtarget)
					end,
					timeout = 0,
					whileDead = true,
					hideOnEscape = false,
					preferredIndex = 3,
	}
	
	StaticPopupDialogs["QuickGroupError"] = {
					text = "BLANK",
					button1 = "Ok",
					timeout = 0,
					whileDead = true,
					hideOnEscape = true,
					preferredIndex = 3,
					showAlert = true,
	}
	
local origLFGList_OnClick = LFGListSearchPanel_SelectResult;
LFGListSearchPanel_SelectResult = function(...)
	local button = ...;
	
	origLFGList_OnClick(...); -- (6)
	
	if IsControlKeyDown() == true then
		JoinGroup();
	else
	end
	
	
end
end

function QuickGroupFrame_OnShow()
	if bTank == true then
		TankCheckBox:SetChecked(true)
	else
		TankCheckBox:SetChecked(false)
	end

	if bHeal == true then
		HealsCheckBox:SetChecked(true)
	else
		HealsCheckBox:SetChecked(false)
	end

	if bDPS == true then
		DPSCheckBox:SetChecked(true)
	else
		DPSCheckBox:SetChecked(false)
	end

	if bAutoConfirm == true then
		chkAutoConfirm:SetChecked(true)		
	else
		chkAutoConfirm:SetChecked(false)
	end

	if iMode == 0 then
		chkKeystone:SetChecked(true)
	elseif iMode == 1 then
		chkRaid:SetChecked(true)
	elseif iMode == 2 then
		chkNone:SetChecked(true)
	end

	-- boxNote:SetText(sNote)

	AchieveCheck();
end

local function onEvent(regFrame)
    if AchievementFrame then
        local idFrame = CreateFrame("Button", "idFrame", AchievementFrameCloseButton, 'UIPanelButtonTemplate')
		idFrame:SetScript("OnClick", GetID)
		idFrame:SetSize(63,26)
		idFrame:SetText("Get ID")
		idFrame:SetPoint("RIGHT", AchievementFrameCloseButton, "LEFT", -5, 0)
        regFrame:UnregisterAllEvents()
    end
end

local function SendRoles()
	if bAutoConfirm == true then
		local _, _, _, _, _, isBGRoleCheck = GetLFGRoleUpdate();
	
		if ( isBGRoleCheck ) then
			SetPVPRoles(bTank, bHeal, bDPS);
		else
			local oldLeader = GetLFGRoles();
			SetLFGRoles(oldLeader, bTank, bHeal, bDPS);
		end
	
		CompleteLFGRoleCheck(true);
	end
end

local regFrame = CreateFrame("Frame")
regFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
regFrame:RegisterEvent("ADDON_LOADED")
regFrame:SetScript("OnEvent", onEvent)

local lfrrFrame = CreateFrame("Frame")
lfrrFrame:RegisterEvent("LFG_ROLE_CHECK_SHOW")
lfrrFrame:SetScript("OnEvent", SendRoles)

function btnOk_OnClick()
	if TankCheckBox:GetChecked() == true then
		bTank = true;
	else
		bTank = false;
	end

	if HealsCheckBox:GetChecked() == true then
		bHeal = true;
	else
		bHeal = false;
	end

	if DPSCheckBox:GetChecked() == true then
		bDPS = true;
	else
		bDPS = false;
	end	

	if chkKeystone:GetChecked() == true then
		iMode = 0;
		local keystones = GetKeystone()
			for i = 1, #keystones do
				lKeystone = keystones[i]
		end
		if lKeystone ~= nil then
			PopupMessage("Keystone Mode - Enabled: "..lKeystone)
		else
			PopupMessage("Keystone Mode - Enabled")
		end
	end

	if chkRaid:GetChecked() == true then
		iMode = 1;
		PopupMessage("Raid Mode / Achievement - Enabled: "..GetAchievementLink(achid));
	end

	if chkNone:GetChecked() == true then
		iMode = 2;
		PopupMessage("No whisper will be sent to the leader")
	end

	-- sNote = boxNote:GetText()

	QuickGroupFrame:Hide();
end

function chkKeystone_OnClick()
	chkRaid:SetChecked(false);
	chkNone:SetChecked(false);
	AchieveCheck()
end

function chkRaid_OnClick()
	chkKeystone:SetChecked(false);
	chkNone:SetChecked(false);
	AchieveCheck()
end

function chkNone_OnClick()
	chkRaid:SetChecked(false);
	chkKeystone:SetChecked(false);
	AchieveCheck()
end

function chkAutoConfirm_OnClick()
	if chkAutoConfirm:GetChecked() == true then
		bAutoConfirm = true;
	else
		bAutoConfirm = false;
	end
end

function btnAoTC_OnClick()
	achid = 12110
	PopupMessage("Achievement set to: "..GetAchievementLink(achid));
end

function btnKeystone_OnClick()
	achid = 11162
	PopupMessage("Achievement set to: "..GetAchievementLink(achid));
end

function btnOther_OnClick()
	if AchievementFrameAchievements ~= nil then
		GetID()
	end
end

function GetKeystone()

	local texture, count, locked, quality, readable, lootable, link, isFiltered, hasNoValue, itemId
	local keystones = {}
	local slots = {}
	slots[1] = GetContainerNumSlots(0)
	slots[2] = GetContainerNumSlots(1)
	slots[3] = GetContainerNumSlots(2)
	slots[4] = GetContainerNumSlots(3)
	slots[5] = GetContainerNumSlots(4)

	for i = 1, #slots do
		for j = 1, slots[i] do

			texture, count, locked, quality, readable, lootable, link, isFiltered, hasNoValue, itemId = GetContainerItemInfo(i - 1, j)

			if itemId and itemId == KeystoneId then
				table.insert(keystones, link)
			end
		end
	end

	return keystones
end

function AchieveCheck()
	if chkRaid:GetChecked() == true then
		btnAoTC:Enable()
		btnKeystone:Enable()
		btnOther:Enable()
	else
		btnAoTC:Disable()
		btnKeystone:Disable()
		btnOther:Disable()
	end
end

function SendWhisper(w)
	if iMode == 0 then
		local keystones = GetKeystone()
		for i = 1, #keystones do
			lKeystone = keystones[i]
		end

		if lKeystone == nil then
			PopupMessage("No key setup!");
		else
			SendChatMessage(lKeystone, "WHISPER", nil, w);
		end
	elseif iMode == 1 then
		SendChatMessage(GetAchievementLink(achid), "WHISPER", nil, w);
	elseif iMode == nil then
		PopupMessage("You broke the addon")
	end
end

function JoinGroup(joinFrame, button)

	if button == 'LeftButton' or IsControlKeyDown() == true then
		dialog = LFGListFrame.SearchPanel.selectedResult
		if dialog ~= nil then
			--a, b, groupname, d, e, f, g, h, i, j, k, l, w = C_LFGList.GetSearchResultInfo(dialog);
			--autoAccept, age, comment, numGuildMates, leaderName, questID, activityID, numBNetFriends, numMembers, requiredItemLevel, searchResultID, voiceChat, requiredHonorLevel, isDelisted, numCharFriends = C_LFGList.GetSearchResultInfo(dialog);
			group = C_LFGList.GetSearchResultInfo(dialog);
		end

		wtarget = group.leaderName

		if wtarget ~= nil and dialog ~= nil then
			if bTank == false and bHeal == false and bDPS == false then
				PopupMessage("No roles configured");
				QuickGroupFrame:Show()
				return;
			else
				if has_applied(wtarget) == true then
					StaticPopup_Show ("AppliedGroupFrame")
				else
					
					--C_LFGList.ApplyToGroup(dialog, sNote, bTank, bHeal, bDPS);
					C_LFGList.ApplyToGroup(dialog, bTank, bHeal, bDPS);
					table.insert(appliedgroups, wtarget)
					SendWhisper(wtarget)
				end				
			end
		
		else
			if wtarget == nil then
			PopupMessage("Error trying to find leader");
			end

			if dialog == nil then
			PopupMessage("No result found, did you click on a group?");
			end
		end
	end

	if button == 'RightButton' then
		QuickGroupFrame:Show()
	end

end

function GetID()
	achid = AchievementFrameAchievements.selection
	if achid ~= nil then
		PopupMessage("Achievement set to: "..GetAchievementLink(achid));
	else
		PopupMessage("Please select an achievement in the achievement window.")
	end
end

function has_applied (val)
    for index, value in ipairs(appliedgroups) do
        if value == val then
            return true
        end
    end

    return false
end

function PopupMessage(msg)
	StaticPopupDialogs["QuickGroupError"].text = msg;
	StaticPopup_Show("QuickGroupError");
end
