AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName		= "Thermal Detonator Grenade (Remote)"
ENT.Author			= "Ace"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""



if SERVER then

	function ENT:Initialize()
		self:SetModel("models/ace/sw/rh/w_thermaldet.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( true )
		-- Don't collide with the player
		//self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		local phys = self:GetPhysicsObject()
		
		if (phys:IsValid()) then
			phys:Wake()
		end
		
	end


	local HitEnt

	function ENT:PhysicsCollide(data,phys)

		phys:EnableMotion(false)
		phys:Sleep()

		if data.HitEntity:IsValid() then
			if data.HitEntity:IsNPC() or data.HitEntity:IsPlayer() then
				self:SetParent(data.HitEntity)
			else
				HitEnt = data.HitEntity
				constraint.Weld(HitEnt, self, 0, 0, 0, true)  
			end

			phys:EnableMotion(true)
			phys:Wake()
		end
	end



	function ENT:HitEffect()
		for k, v in pairs ( ents.FindInSphere( self:GetPos(), 600 ) ) do
			if v:IsValid() && v:IsPlayer() then
			end	
		end
	end

	function ENT:Explosion()
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect( "HelicopterMegaBomb", effectdata )	 -- Big flame
		
		local explo = ents.Create( "env_explosion" )
			explo:SetOwner( self.GrenadeOwner )
			explo:SetPos( self:GetPos() )
			explo:SetKeyValue( "iMagnitude", "250" )
			explo:Spawn()
			explo:Activate()
			explo:Fire( "Explode", "", 0 )

		local shake = ents.Create( "env_shake" )
			shake:SetOwner( self.Owner )
			shake:SetPos( self:GetPos() )
			shake:SetKeyValue( "amplitude", "2000" )	-- Power of the shake
			shake:SetKeyValue( "radius", "900" )	-- Radius of the shake
			shake:SetKeyValue( "duration", "2.5" )	-- Time of shake
			shake:SetKeyValue( "frequency", "2550" )	-- How har should the screenshake be
			shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
			shake:Spawn()
			shake:Activate()
			shake:Fire( "StartShake", "", 0 )

	end



end


if CLIENT then

	function ENT:Draw()
		self:DrawModel()
	end

end

