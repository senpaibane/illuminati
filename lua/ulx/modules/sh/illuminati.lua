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
 
function ulx.illuminati ( calling_ply, target_plys)

	for k, v in pairs(target_plys) do 
		local health = v:Health()
		if v:IsActiveTraitor() then
			if health > 10 then
				v:SetHealth( health-10 )
			elseif health <= 10 then
				v:SetHealth(1)
			end
		end
			v:AddHaloEffect() 
			ulx.fancyLogAdmin( calling_ply, "#A prayed to the illuuminati confirming #T as a traitor, and revealed their location!", v )
	end
end

local illuminati = ulx.command( CATEGORY_NAME, "ulx illuminati", ulx.illuminati, "!illuminati", true)
illuminati:addParam{ type=ULib.cmds.PlayersArg }
illuminati:defaultAccess( ULib.ACCESS_ADMIN )
illuminati:help( "Use on camping/delaying traitors, will flush them out guaranteed." )

function ulx.removeHalo ( calling_ply, target_plys)

	for k, v in pairs(target_plys) do 
		v:RemoveHaloEffect() 
		ulx.fancyLogAdmin( calling_ply, "#A removed the halo from #T", v )
	end
end

local removeHalo = ulx.command( CATEGORY_NAME, "ulx removehalo", ulx.removeHalo, "!removehalo", true)
removeHalo:addParam{ type=ULib.cmds.PlayersArg }
removeHalo:defaultAccess( ULib.ACCESS_ADMIN )
removeHalo:help( "Removes a leftover halo from illuminati, use every round that there was a halo otherwise it will stick until map change." )
