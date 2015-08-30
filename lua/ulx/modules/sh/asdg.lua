local CATEGORY_NAME = UTime

function ulx.viewHours (calling_ply, target_ply)
		local hours = tostring(target_ply:GetUTimeTotalTime() / 3600)
		local name = tostring(target_ply:Nick())
		local message = name.. " has played for " ..hours.. " hours."
		ULib.tsay(calling_ply, message)
		//calling_ply:PrintMessage(HUD_PRINTTALK, message)
end

local seehours = ulx.command("Utime", "ulx viewhours", ulx.viewHours, "!viewhours")
seehours:addParam{type=ULib.cmds.PlayerArg}
seehours:defaultAccess(ULib.ACCESS_ADMIN)
seehours:help("View a player's hours on the server.")

/*
function ulx.viewHoursID(calling_ply, id)
	id = id:upper()
	
	local idhoursnum = id:GetPData("utime", 0)	//UTiem usses a uniquID system that nobody seems to know how to crack so as of now we can't get a steamid version of the command.
	local idhours = tostring(idhoursnum)
	local idstring = tostring(id)
	local messageid = idstring.. " has played for " ..idhours.. " hours."
	ULib.tsay(calling_ply, messageid)
end

local viewhoursid = ulx.command( "UTime", "ulx viewhoursid", ulx.viewHoursID )
viewhoursid:addParam{ type=ULib.cmds.StringArg, hint="SteamID" }
viewhoursid:defaultAccess( ULib.ACCESS_ADMIN )
viewhoursid:help( "View someone's hours on the server by ID." )
*/
