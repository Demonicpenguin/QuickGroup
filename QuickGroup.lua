-- Author      : Demonicpenguin


print("QuickGroup Loaded!");
SLASH_QUICKGROUP1, SLASH_QUICKGROUP2 = "/qg", "/QG";
local link;
local ta = false;
local he = false;
local dp = false;
local sAd = "Joined using QuickGroup"
local bAd = false;
local sMode = "none";
local achid = 11194;
local queue = "You will be queued as ";

SlashCmdList["QUICKGROUP"] = function(msg)
	local command, tank, heals, dps, mode = strsplit(" ",msg)
	if command == 'set' then
		queue = "You will be queued as ";
		
		if tank == 'y' then
			ta = true;
			queue = queue.."Tank "
		elseif tank == 'n' then
			ta = false;
		else
			print("Unrecognized option for tank: "..tank);
		end
		
		if heals == 'y' then
			he = true;
			queue = queue.."Healer "
		elseif heals == 'n' then
			he = false;
		else
			print("Unrecognized option for healer: "..heals);
		end
		
		if dps == 'y' then
			dp = true;
			queue = queue.."DPS ";
		elseif dps == 'n' then
			dp = false;
		else
			print("Unrecognized option for dps: "..dps);
		end
		
		if mode == 'key' then
			sMode = "key";
			for bag=0, NUM_BAG_SLOTS do
			for bagSlots=1, GetContainerNumSlots(bag) do
			local itemlink = GetContainerItemLink(bag, bagSlots)
			local unusedTexture, itemCount = GetContainerItemInfo(bag, bagSlots)
			if (itemlink) then
			local itemName, itemLink = GetItemInfo(itemlink)
			if string.match(itemName, "Keystone") then
				link = itemLink;
			end
			end 
			end 
			end 
			if link == nil then
				print("Unable to find Keystone!!!");
				return;
			else
				if string.match(link, "Keystone") then
					print("Keystone mode enabled - "..link);
				else
					print("This doesn't look like a keystone");
					link = nil;
				end
			end
		elseif mode == 'raid' then
			sMode = "raid";
			print("Raid mode enabled, Achievement: "..GetAchievementLink(achid));					
		elseif mode == 'none' then
		  sMode = "none";
		else
			print("No mode selected!");
		end
		
		print(queue);
		
	elseif command == 'join' then
		local result = GetMouseFocus().resultID
		if result ~= nil then
		a, b, c, d, e, f, g, h, i, j, k, l, w = C_LFGList.GetSearchResultInfo(result);
		end
		
		if w ~= nil and result ~= nil then
		
		if ta == false and he == false and dp == false then
			print("No roles configured");
			return;
		else
			if bAd == true then
				C_LFGList.ApplyToGroup(result, sAd, ta, he, dp);
			else
				C_LFGList.ApplyToGroup(result, "", ta, he, dp);
			end			
		end		 
		
		if sMode == "key" then
			if link == nil then
				print("No key setup!");
			else
				SendChatMessage(link, "WHISPER", nil, w); 
			end		  
		elseif sMode == "raid" then
			SendChatMessage(GetAchievementLink(achid), "WHISPER", nil, w);
		elseif sMode == "none" then
		
		end
		
	 else
      if w == nil then
        print("Error trying to find leader");
      end
      if result == nil then
        print("No result found, were you moused over the LFG window?");
      end
    end
	
	elseif command == 'id' then
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
		
	elseif command == 'ad' then
		if bAd == true then
			bAd = false;
			print("Ad has been turned: off");
		else
			bAd = true;
			print("Ad has been turned: on");
		end
	elseif command == 'mode' then
		sMode = tank;
		print("Mode set to: "..sMode);
	end
end
