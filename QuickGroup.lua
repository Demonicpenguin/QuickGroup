-- Author      : Demonicpenguin

	SLASH_QUICKGROUP1, SLASH_QUICKGROUP2 = "/qg", "/QG";
	lKeystone = nil;
	local KeystoneId = 138019
	bTank = false;
	bHeal = false;
	bDPS = false;
	iMode = 0;
	achid = 12110;



function QuickGroupFrame_OnLoad()
	QuickGroupFrame:Hide()
	print("QuickGroup: Loaded, use /qg or /QG to open the main window!")
	TankTexture:SetTexCoord(GetTexCoordsForRole("TANK"));
	HealsTexture:SetTexCoord(GetTexCoordsForRole("HEALER"));
	DPSTexture:SetTexCoord(GetTexCoordsForRole("DAMAGER"));

--	if bTank == true then
--		t1 = "True";
--	else
--		t1 = "False";
--	end

--	if bHeal == true then
--		t2 = "True";
--	else
--		t2 = "False";
--	end

--	if bDPS == true then
--		t3 = "True";
--	else
--		t3 = "False";
--	end
--	print("Tank: "..t1.." Heals: "..t2.." DPS: "..t3);
--	print("Mode: "..iMode);

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

	if bTank == true then
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

--function QuickGroupFrame_OnEvent(event, arg1)
--	if event == "ADDON_LOADED" and arg1 == "QuickGroupUI" then
--		print("QuickGroup Loaded! NOW WITH UI!!");
--	if bTank == true then
--		t1 = "True";
--	else
--		t1 = "False";
--	end

--	if bHeal == true then
--		t2 = "True";
--	else
--		t2 = "False";
--	end

--	if bDPS == true then
--		t3 = "True";
--	else
--		t3 = "False";
--	end
--	print("Tank: "..t1.." Heals: "..t2.." DPS: "..t3);
--	print("Mode: "..iMode);

--	if bTank == true then
--		TankCheckBox:SetChecked(true)
--	else
--		TankCheckBox:SetChecked(false)
--	end

--	if bHeal == true then
--		HealsCheckBox:SetChecked(true)
--	else
--		HealsCheckBox:SetChecked(false)
--	end

--	if bTank == true then
--		DPSCheckBox:SetChecked(true)
--	else
--		DPSCheckBox:SetChecked(false)
--	end

--	if iMode == 0 then
--		chkKeystone:SetChecked(true)
--	elseif iMode == 1 then
--		chkRaid:SetChecked(true)
--	elseif iMode == 2 then
--		chkNone:SetChecked(true)
--	end

--	AchieveCheck();
--	elseif event == "PLAYER_LOGOUT" then
   
--	end
--end

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

--	if bTank == true then
--		t1 = "True";
--	else
--		t1 = "False";
--	end

--	if bHeal == true then
--		t2 = "True";
--	else
--		t2 = "False";
--	end

--	if bDPS == true then
--		t3 = "True";
--	else
--		t3 = "False";
--	end
--	print("Tank: "..t1.." Heals: "..t2.." DPS: "..t3);
--	print("Mode: "..iMode);
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

function btnAoTC_OnClick()
	achid = 12110
	print("Achievement set to: "..GetAchievementLink(achid));
end

function btnKeystone_OnClick()
	achid = 11162
	print("Achievement set to: "..GetAchievementLink(achid));
end

function btnOther_OnClick()
	print("To set a different achievement, please use ' /qg id ' while you are moused over the achievement in the Achievement window.")
end
