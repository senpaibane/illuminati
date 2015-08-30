local CATEGORY_NAME = "Illuminati"
local META = FindMetaTable("Player")

if SERVER then 
	util.AddNetworkString("player_halo_effect") 
	util.AddNetworkString("remove_halos")

	function META:AddHaloEffect()
		net.Start("player_halo_effect") 
			net.WriteEntity(self) 
		net.Broadcast() 
	end 
	
	function META:RemoveHaloEffect()
		net.Start("remove_halos") 
			net.WriteEntity(self) 
		net.Broadcast() 
	end 
end 

if CLIENT then 
	local halo_ents = {} 

	function META:AddHaloEffect() 
		table.insert(halo_ents, self) 
	end 
	
	function META:RemoveHaloEffect ()
		table.RemoveByValue(halo_ents, self)
	end

	net.Receive("player_halo_effect", function(len) 
		local ent = net.ReadEntity() 

		if ent and ent:IsValid() and ent:IsPlayer() then 
			ent:AddHaloEffect() 
		end 
	end )

	net.Receive("remove_halos", function(len) 
		local ent = net.ReadEntity() 

		if ent and ent:IsValid() and ent:IsPlayer() then 
			ent:RemoveHaloEffect() 
		end 
	end )

	hook.Add( "PreDrawHalos", "AddTHalos", function()
		if !halo_ents or table.Count(halo_ents) == 0 then return end
		for k, v in pairs( halo_ents ) do
			if !IsValid(v) then continue end 
			halo.Add( {v}, Color( 255, 0, 0 ), 1, 1, 2, true, true )
		end 
	end )
end 

function ulx.juground ( calling_ply )

	--[[These 2 variables will pick the random player]]--
	randomply = math.random(1,#player.GetAll())
	chosenply = player.GetAll()[randomply]
	
	--[[Give health based on how many players are on the server]]--
	local health = #player.GetAll()*100
	
	--[[Console stuff necessary to make the jug into the jug]]--
	chosenply:SetModelScale( 3, 0)
	chosenply:SetHealth( health )
	chosenply:AddHaloEffect()
	chosenply:StripWeapons()
	print( chosenply:Nick() )
	
	--[[Make sure he always has a knife]]--
	timer.Create( "JugRoundGiveKnife", 1, 0, function()
		if !chosenply:HasWeapon( "weapon_ttt_knife" ) then
			chosenply:Give( "weapon_ttt_knife" )
		end
	end )
	
	--[[Make everyone else inno]]--
	for k, v in pairs( player.GetAll() ) do
		v:SetRole( ROLE_INNOCENT )
		if v:Nick() == chosenply:Nick() then
			v:SetRole( ROLE_TRAITOR )
		end
	end
end

local jugg = ulx.command( "Bane's Creations", "ulx jugg", ulx.juground, "!jugg", true )
jugg:defaultAccess( ULib.ACCESS_ADMIN )
jugg:help( "Starts a Jugg Round." )

hook.Add("TTTEndRound", "RemoveJugg", function()
	for k, v in pairs ( player.GetAll() ) do
		v:SetModelScale( 1, 0)
		v:RemoveHaloEffect()
	end
	timer.Destroy( "JugRoundGiveKnife" )	
end)