-- Author      : Demonicpenguin

	SLASH_QUICKGROUP1, SLASH_QUICKGROUP2 = "/qg", "/QG";
	lKeystone = nil;
	local KeystoneId = 138019
	bTank = false;
	bHeal = false;
	bDPS = false;
	iMode = 0;
	achid = 12110;

SlashCmdList["QUICKGROUP"] = function(msg)
	local command = strsplit(" ",msg)
	if command == nil or command == "" then
		QuickGroupFrame:Show()
	elseif command == "set" then
		QuickGroupFrame:Show()
	elseif command == "join" then
		local result = GetMouseFocus().resultID
		if result ~= nil then
		a, b, c, d, e, f, g, h, i, j, k, l, w = C_LFGList.GetSearchResultInfo(result);
		end
		
		if w ~= nil and result ~= nil then
		
		if bTank == false and bHeal == false and bDPS == false then
			print("No roles configured");
			QuickGroupFrame:Show()
			return;
		else
			C_LFGList.ApplyToGroup(result, "", bTank, bHeal, bDPS);		
		end
		
		if iMode == 0 then
			local keystones = GetKeystone()
			for i = 1, #keystones do
				lKeystone = keystones[i]
			end
	
			if lKeystone == nil then
				print("No key setup!");
			else
				SendChatMessage(lKeystone, "WHISPER", nil, w); 
			end
		elseif iMode == 1 then
			SendChatMessage(GetAchievementLink(achid), "WHISPER", nil, w);
		elseif iMode == nil then
			print("You broke the addon")
		end
		
	 else
      if w == nil then
        print("Error trying to find leader");
      end
      if result == nil then
        print("No result found, were you moused over the LFG window?");
      end
    end
	elseif command == "id" then
		if GetMouseFocus().id ~= nil then
			achid = GetMouseFocus().id;
			achid = achid + 0;
			if achid > 0 then
				print("Achievement set to: "..GetAchievementLink(achid));
			else
				print("No Achievement found, please mouse over an achievement and run the command again");
			end
		else
			print("No Achievement found, please mouse over an achievement and run the command again");
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

	if iMode == 0 then
		chkKeystone:SetChecked(true)
	elseif iMode == 1 then
		chkRaid:SetChecked(true)
	elseif iMode == 2 then
		chkNone:SetChecked(true)
	end

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

local regFrame = CreateFrame("Frame")
regFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
regFrame:RegisterEvent("ADDON_LOADED")
regFrame:SetScript("OnEvent", onEvent)

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
			print("Keystone Mode - Enabled: "..lKeystone)
		else
			print("Keystone Mode - Enabled")
		end
	end

	if chkRaid:GetChecked() == true then
		iMode = 1;
		print("Raid Mode / Achievement - Enabled: "..GetAchievementLink(achid));
	end

	if chkNone:GetChecked() == true then
		iMode = 2;
		print("No whisper will be sent to the leader")
	end

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

function btnAoTC_OnClick()
	achid = 12110
	print("Achievement set to: "..GetAchievementLink(achid));
end

function btnKeystone_OnClick()
	achid = 11162
	print("Achievement set to: "..GetAchievementLink(achid));
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

function JoinGroup(joinFrame, button)
	if button == 'LeftButton' then
		local dialog = joinFrame:GetParent().selectedResult
		if dialog ~= nil then
			a, b, c, d, e, f, g, h, i, j, k, l, w = C_LFGList.GetSearchResultInfo(dialog);
		end
		if w ~= nil and dialog ~= nil then
			if bTank == false and bHeal == false and bDPS == false then
				print("No roles configured");
				QuickGroupFrame:Show()
				return;
			else
				C_LFGList.ApplyToGroup(dialog, "", bTank, bHeal, bDPS);		
			end
		
			if iMode == 0 then
				local keystones = GetKeystone()
				for i = 1, #keystones do
					lKeystone = keystones[i]
				end
	
				if lKeystone == nil then
					print("No key setup!");
				else
					SendChatMessage(lKeystone, "WHISPER", nil, w); 
				end
			elseif iMode == 1 then
				SendChatMessage(GetAchievementLink(achid), "WHISPER", nil, w);
			elseif iMode == nil then
				print("You broke the addon")
			end
		
		else
			if w == nil then
			print("Error trying to find leader");
			end

			if dialog == nil then
			print("No result found, did you click on a group?");
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
		print("Achievement set to: "..GetAchievementLink(achid));
	else
		print("Please select an achievement in the achievement window.")
	end
end