AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

-- Networking for client-side effects
util.AddNetworkString("SplinterCellWhisper")
util.AddNetworkString("SplinterCellFlash")
util.AddNetworkString("SplinterCellFlashEffect")

-- Handle whisper messages
net.Receive("SplinterCellWhisper", function(len, ply)
    local message = net.ReadString()
    if IsValid(ply) then
        -- Send whisper to player
        ply:PrintMessage(HUD_PRINTTALK, "[Whisper] " .. message)
    end
end)

-- Handle flash effects
net.Receive("SplinterCellFlash", function(len, ply)
    local flashPos = net.ReadVector()
    if IsValid(ply) then
        -- Send flash effect to player
        net.Start("SplinterCellFlashEffect")
        net.WriteVector(flashPos)
        net.Send(ply)
    end
end)

-- Splinter Cell NextBot - Advanced Tactical AI
-- Uses proper NextBot framework

ENT.Base = "base_nextbot"
ENT.Type = "nextbot"

-- Tactical AI Configuration
local TACTICAL_CONFIG = {
    STEALTH_RADIUS = 800,           -- Detection radius for stealth operations
    ENGAGEMENT_RANGE = 400,         -- Optimal engagement distance
    TAKEDOWN_RANGE = 100,          -- Range for silent takedowns
    RETREAT_HEALTH = 50,            -- Health threshold to trigger retreat
    SHADOW_PREFERENCE = 0.8,        -- Preference for dark areas (0-1)
    PATIENCE_TIMER = 5,             -- Seconds to wait before changing tactics
    SMOKE_COOLDOWN = 15,            -- Cooldown between smoke deployments
    LIGHT_DISABLE_RANGE = 300,      -- Range to disable light sources
    WHISPER_RADIUS = 200,           -- Range for psychological operations
    FLASH_RANGE = 150               -- Range for flashbang effects
}

-- AI States
local AI_STATES = {
    IDLE_RECON = 1,        -- Patrolling and gathering intel
    INVESTIGATE = 2,       -- Moving toward sound/light sources
    STALKING = 3,          -- Tracking target from cover
    AMBUSH = 4,            -- Executing silent takedown
    ENGAGE_SUPPRESSED = 5, -- Firing from cover
    RETREAT_RESET = 6      -- Breaking contact and repositioning
}

function ENT:Initialize()
    self:SetModel("models/player/combine_super_soldier.mdl")
    self:SetHealth(200)
    self:SetMaxHealth(200)
    self:SetCollisionBounds(Vector(-16, -16, 0), Vector(16, 16, 72))
    
    -- Initialize tactical variables
    self.tacticalState = AI_STATES.IDLE_RECON
    self.targetPlayer = nil
    self.lastKnownPosition = Vector(0, 0, 0)
    self.lastStateChange = CurTime()
    self.smokeLastUsed = 0
    self.stealthLevel = 1.0  -- 1.0 = fully stealth, 0.0 = compromised
    self.patienceTimer = 0
    self.currentObjective = "patrol"
    self.currentPath = nil
    self.targetPosition = nil
    
    -- Network variables for client display
    self:SetNWInt("tacticalState", self.tacticalState)
    self:SetNWFloat("stealthLevel", self.stealthLevel)
    self:SetNWString("currentObjective", self.currentObjective)
    
    -- DRGBase integration
    if DRGBase then
        self:SetNWString("DRGBase_DisplayName", "Splinter Cell Operative")
        self:SetNWString("DRGBase_Description", "Advanced tactical AI specializing in stealth operations")
    end
    
    -- Set up AI behavior
    self:SetupTacticalAI()
end

function ENT:SetupTacticalAI()
    -- Initialize tactical priorities
    self.tacticalPriorities = {
        "maintain_stealth",
        "control_environment", 
        "isolate_targets",
        "execute_ambush",
        "tactical_retreat"
    }
    
    -- Initialize environment control
    self.lightSources = {}
    self.coverPositions = {}
    self.escapeRoutes = {}
    
    -- Start AI cycle
    self:StartAICycle()
end

function ENT:StartAICycle()
    timer.Create("SplinterCellAI_" .. self:EntIndex(), 0.1, 0, function()
        if IsValid(self) then
            self:ExecuteTacticalAI()
        end
    end)
end

function ENT:ExecuteTacticalAI()
    -- Update tactical state based on current conditions
    self:UpdateTacticalState()
    
    -- Execute current state behavior
    if self.tacticalState == AI_STATES.IDLE_RECON then
        self:ExecuteIdleRecon()
    elseif self.tacticalState == AI_STATES.INVESTIGATE then
        self:ExecuteInvestigate()
    elseif self.tacticalState == AI_STATES.STALKING then
        self:ExecuteStalking()
    elseif self.tacticalState == AI_STATES.AMBUSH then
        self:ExecuteAmbush()
    elseif self.tacticalState == AI_STATES.ENGAGE_SUPPRESSED then
        self:ExecuteEngageSuppressed()
    elseif self.tacticalState == AI_STATES.RETREAT_RESET then
        self:ExecuteRetreatReset()
    end
    
    -- Execute environment control
    self:ControlEnvironment()
    
    -- Execute psychological operations
    self:ExecutePsychologicalOps()
    
    -- Update networked variables
    self:SetNWInt("tacticalState", self.tacticalState)
    self:SetNWFloat("stealthLevel", self.stealthLevel)
    self:SetNWString("currentObjective", self.currentObjective)
end

function ENT:UpdateTacticalState()
    local currentTime = CurTime()
    
    -- Check for state transition conditions
    if self.tacticalState == AI_STATES.IDLE_RECON then
        if self:DetectPlayerActivity() then
            self:ChangeState(AI_STATES.INVESTIGATE)
        end
    elseif self.tacticalState == AI_STATES.INVESTIGATE then
        if self:HasVisualContact() then
            self:ChangeState(AI_STATES.STALKING)
        elseif currentTime - self.lastStateChange > TACTICAL_CONFIG.PATIENCE_TIMER then
            self:ChangeState(AI_STATES.IDLE_RECON)
        end
    elseif self.tacticalState == AI_STATES.STALKING then
        if self:CanExecuteTakedown() then
            self:ChangeState(AI_STATES.AMBUSH)
        elseif self:IsCompromised() then
            self:ChangeState(AI_STATES.ENGAGE_SUPPRESSED)
        end
    elseif self.tacticalState == AI_STATES.AMBUSH then
        if self:IsTakedownComplete() then
            self:ChangeState(AI_STATES.RETREAT_RESET)
        end
    elseif self.tacticalState == AI_STATES.ENGAGE_SUPPRESSED then
        if self:ShouldRetreat() then
            self:ChangeState(AI_STATES.RETREAT_RESET)
        end
    elseif self.tacticalState == AI_STATES.RETREAT_RESET then
        if self:IsSafeToReset() then
            self:ChangeState(AI_STATES.IDLE_RECON)
        end
    end
end

function ENT:ChangeState(newState)
    if self.tacticalState ~= newState then
        self.tacticalState = newState
        self.lastStateChange = CurTime()
        self:OnStateChange(newState)
    end
end

function ENT:OnStateChange(newState)
    -- Handle state-specific initialization
    if newState == AI_STATES.IDLE_RECON then
        self.currentObjective = "patrol"
        self:FindPatrolRoute()
    elseif newState == AI_STATES.INVESTIGATE then
        self.currentObjective = "investigate"
        self:MoveToLastKnownPosition()
    elseif newState == AI_STATES.STALKING then
        self.currentObjective = "stalk"
        self:FindCoverPosition()
    elseif newState == AI_STATES.AMBUSH then
        self.currentObjective = "execute_takedown"
        self:PrepareAmbush()
    elseif newState == AI_STATES.ENGAGE_SUPPRESSED then
        self.currentObjective = "suppress"
        self:FindCoverAndEngage()
    elseif newState == AI_STATES.RETREAT_RESET then
        self.currentObjective = "retreat"
        self:ExecuteTacticalRetreat()
    end
end

-- Movement helper functions using proper NextBot methods
function ENT:MoveToPosition(targetPos)
    if not targetPos then return end
    
    self.targetPosition = targetPos
    local path = Path("Follow")
    path:SetMinLookAheadDistance(300)
    path:SetGoalTolerance(20)
    path:Compute(self, targetPos)
    
    if not path:IsValid() then
        -- Direct movement if pathfinding fails
        self:SetLastPosition(targetPos)
        return
    end
    
    self.currentPath = path
end

function ENT:MoveToLastKnownPosition()
    if self.lastKnownPosition and self.lastKnownPosition ~= Vector(0, 0, 0) then
        self:MoveToPosition(self.lastKnownPosition)
    end
end

function ENT:FindCoverPosition()
    if IsValid(self.targetPlayer) then
        local targetPos = self.targetPlayer:GetPos()
        local coverPos = self:FindOptimalCoverPosition(targetPos)
        if coverPos then
            self:MoveToPosition(coverPos)
        end
    end
end

function ENT:PrepareAmbush()
    -- Prepare for silent takedown
    if IsValid(self.targetPlayer) then
        -- Move closer to target if needed
        local distance = self:GetPos():Distance(self.targetPlayer:GetPos())
        if distance > TACTICAL_CONFIG.TAKEDOWN_RANGE then
            self:MoveToPosition(self.targetPlayer:GetPos())
        end
    end
end

function ENT:FindCoverAndEngage()
    if IsValid(self.targetPlayer) then
        local targetPos = self.targetPlayer:GetPos()
        local coverPos = self:FindOptimalCoverPosition(targetPos)
        if coverPos then
            self:MoveToPosition(coverPos)
        end
    end
end

function ENT:ExecuteTacticalRetreat()
    -- Find escape route and move away
    local escapePos = self:FindEscapeRoute()
    if escapePos then
        self:MoveToPosition(escapePos)
    end
end

-- State Execution Functions
function ENT:ExecuteIdleRecon()
    -- Handle current path movement
    if self.currentPath and self.currentPath:IsValid() then
        self.currentPath:Update(self)
        if self.currentPath:GetAge() > 3 then
            self.currentPath:Invalidate()
            self.currentPath = nil
        end
    else
        -- Find new patrol point if not moving
        self:FindNextPatrolPoint()
    end
    
    -- Disable nearby light sources
    self:DisableNearbyLights()
    
    -- Listen for player activity (handled in UpdateTacticalState)
end

function ENT:IsTakedownComplete()
    -- Check if takedown animation is finished
    return not self:IsMoving() and self.targetPlayer == nil
end

function ENT:ExecuteInvestigate()
    -- Handle current path movement
    if self.currentPath and self.currentPath:IsValid() then
        self.currentPath:Update(self)
    else
        -- Move to last known position if no path
        if self.lastKnownPosition and self:GetPos():Distance(self.lastKnownPosition) > 50 then
            self:MoveToPosition(self.lastKnownPosition)
        else
            -- Search the area
            self:SearchArea()
        end
    end
end

function ENT:ExecuteStalking()
    -- Track target while maintaining cover
    if IsValid(self.targetPlayer) then
        local targetPos = self.targetPlayer:GetPos()
        local coverPos = self:FindOptimalCoverPosition(targetPos)
        
        if coverPos then
            self:MoveToPosition(coverPos)
        end
        
        -- Maintain stealth level
        self:MaintainStealth()
    end
end

function ENT:ExecuteAmbush()
    -- Execute silent takedown
    if IsValid(self.targetPlayer) and self:CanExecuteTakedown() then
        self:PerformSilentTakedown()
    end
end

function ENT:ExecuteEngageSuppressed()
    -- Fire from cover with suppressed weapon
    if IsValid(self.targetPlayer) then
        self:FireSuppressedShot()
    end
end

function ENT:ExecuteRetreatReset()
    -- Handle path movement for retreat
    if self.currentPath and self.currentPath:IsValid() then
        self.currentPath:Update(self)
    end
    
    -- Deploy smoke and break contact
    if CurTime() - self.smokeLastUsed > TACTICAL_CONFIG.SMOKE_COOLDOWN then
        self:DeploySmoke()
    end
end

-- Tactical Functions
function ENT:ControlEnvironment()
    -- Disable light sources to create shadows
    self:DisableNearbyLights()
    
    -- Create sound distractions
    if math.random() < 0.01 then
        self:CreateSoundDistraction()
    end
    
    -- Manipulate props for tactical advantage
    self:ManipulateProps()
end

function ENT:ExecutePsychologicalOps()
    -- Whisper to nearby players
    if math.random() < 0.005 then
        self:WhisperToPlayers()
    end
    
    -- Flash goggles effect
    if math.random() < 0.003 then
        self:FlashGoggles()
    end
end

-- Detection and Awareness
function ENT:DetectPlayerActivity()
    local players = player.GetAll()
    for _, player in pairs(players) do
        if IsValid(player) and player:Alive() then
            local distance = self:GetPos():Distance(player:GetPos())
            if distance < TACTICAL_CONFIG.STEALTH_RADIUS then
                -- Check if player is making noise
                if self:IsPlayerMakingNoise(player) then
                    self.targetPlayer = player
                    self.lastKnownPosition = player:GetPos()
                    return true
                end
            end
        end
    end
    return false
end

function ENT:HasVisualContact()
    if not IsValid(self.targetPlayer) then return false end
    
    local trace = util.TraceLine({
        start = self:GetPos() + Vector(0, 0, 50),
        endpos = self.targetPlayer:GetPos() + Vector(0, 0, 50),
        filter = {self, self.targetPlayer}
    })
    
    return not trace.Hit
end

function ENT:CanExecuteTakedown()
    if not IsValid(self.targetPlayer) then return false end
    
    local distance = self:GetPos():Distance(self.targetPlayer:GetPos())
    return distance < TACTICAL_CONFIG.TAKEDOWN_RANGE and self.stealthLevel > 0.7
end

function ENT:IsCompromised()
    return self.stealthLevel < 0.3
end

function ENT:ShouldRetreat()
    return self:Health() < TACTICAL_CONFIG.RETREAT_HEALTH or self.stealthLevel < 0.2
end

function ENT:IsSafeToReset()
    local players = player.GetAll()
    for _, player in pairs(players) do
        if IsValid(player) and player:Alive() then
            local distance = self:GetPos():Distance(player:GetPos())
            if distance < TACTICAL_CONFIG.STEALTH_RADIUS * 0.5 then
                return false
            end
        end
    end
    return true
end

-- Movement and Navigation
function ENT:FindPatrolRoute()
    local areas = navmesh.GetAllNavAreas()
    if #areas > 0 then
        local randomArea = areas[math.random(1, #areas)]
        local randomPos = randomArea:GetRandomPoint()
        self:MoveToPosition(randomPos)
    else
        -- Fallback if no navmesh
        local randomPos = self:GetPos() + VectorRand() * 500
        randomPos.z = self:GetPos().z  -- Keep same height
        self:SetLastPosition(randomPos)
    end
end

function ENT:FindNextPatrolPoint()
    local currentPos = self:GetPos()
    local searchRadius = 500
    
    -- Try to find nav areas first
    local areas = navmesh.GetAllNavAreas()
    if #areas > 0 then
        local nearbyAreas = {}
        
        for _, area in pairs(areas) do
            local areaPos = area:GetCenter()
            if currentPos:Distance(areaPos) < searchRadius then
                table.insert(nearbyAreas, area)
            end
        end
        
        if #nearbyAreas > 0 then
            local randomArea = nearbyAreas[math.random(1, #nearbyAreas)]
            local randomPos = randomArea:GetRandomPoint()
            self:MoveToPosition(randomPos)
            return
        end
    end
    
    -- Fallback to random movement
    local randomDir = VectorRand()
    randomDir.z = 0  -- Keep on same plane
    local randomPos = currentPos + randomDir:GetNormalized() * math.random(200, 400)
    self:SetLastPosition(randomPos)
end

function ENT:IsMoving()
    local velocity = self:GetVelocity():Length()
    return velocity > 10
end

function ENT:FindOptimalCoverPosition(targetPos)
    local searchRadius = 300
    local areas = navmesh.GetAllNavAreas()
    local bestCover = nil
    local bestScore = -1
    
    -- Try navmesh areas first
    if #areas > 0 then
        for _, area in pairs(areas) do
            local areaPos = area:GetCenter()
            local distanceToTarget = areaPos:Distance(targetPos)
            local distanceFromSelf = self:GetPos():Distance(areaPos)
            
            if distanceToTarget < searchRadius and distanceFromSelf < 400 then
                -- Calculate cover score based on distance and shadow preference
                local coverScore = self:CalculateCoverScore(areaPos, targetPos)
                if coverScore > bestScore then
                    bestScore = coverScore
                    bestCover = areaPos
                end
            end
        end
    else
        -- Fallback cover finding
        for i = 1, 8 do
            local angle = i * 45
            local dir = Angle(0, angle, 0):Forward()
            local testPos = self:GetPos() + dir * math.random(100, 300)
            
            local coverScore = self:CalculateCoverScore(testPos, targetPos)
            if coverScore > bestScore then
                bestScore = coverScore
                bestCover = testPos
            end
        end
    end
    
    return bestCover
end

function ENT:CalculateCoverScore(position, targetPos)
    local score = 0
    
    -- Prefer positions closer to target
    local distanceToTarget = position:Distance(targetPos)
    score = score + (300 - distanceToTarget) / 3
    
    -- Prefer positions in shadows
    local lightLevel = self:GetLightLevel(position)
    score = score + (1 - lightLevel) * 100
    
    -- Prefer positions with good cover
    if self:HasCover(position) then
        score = score + 50
    end
    
    return score
end

function ENT:FindEscapeRoute()
    local currentPos = self:GetPos()
    local areas = navmesh.GetAllNavAreas()
    local bestEscape = nil
    local bestDistance = 0
    
    if #areas > 0 then
        for _, area in pairs(areas) do
            local areaPos = area:GetCenter()
            local distance = currentPos:Distance(areaPos)
            
            -- Prefer areas far from current position
            if distance > bestDistance and distance < 800 then
                bestDistance = distance
                bestEscape = areaPos
            end
        end
    else
        -- Fallback escape route
        local escapeDir = VectorRand()
        escapeDir.z = 0
        bestEscape = currentPos + escapeDir:GetNormalized() * 600
    end
    
    return bestEscape
end

-- Environment Control
function ENT:DisableNearbyLights()
    local lights = ents.FindByClass("light*")
    for _, light in pairs(lights) do
        if IsValid(light) then
            local distance = self:GetPos():Distance(light:GetPos())
            if distance < TACTICAL_CONFIG.LIGHT_DISABLE_RANGE then
                -- Disable light source
                if light:GetClass() == "light" then
                    light:Fire("TurnOff")
                elseif light:GetClass() == "light_spot" then
                    light:Fire("TurnOff")
                elseif light:GetClass() == "light_dynamic" then
                    light:Fire("TurnOff")
                end
            end
        end
    end
end

function ENT:CreateSoundDistraction()
    local nearbyProps = ents.FindInSphere(self:GetPos(), 200)
    for _, prop in pairs(nearbyProps) do
        if IsValid(prop) and (prop:GetClass() == "prop_physics" or prop:GetClass() == "prop_physics_multiplayer") then
            -- Knock over prop to create distraction
            if math.random() < 0.3 then
                local phys = prop:GetPhysicsObject()
                if IsValid(phys) then
                    phys:ApplyForceCenter(VectorRand() * 100)
                end
            end
        end
    end
end

function ENT:ManipulateProps()
    -- Move props to create tactical advantages
    local nearbyProps = ents.FindInSphere(self:GetPos(), 150)
    for _, prop in pairs(nearbyProps) do
        if IsValid(prop) and prop:GetClass() == "prop_physics" then
            if math.random() < 0.01 then
                local phys = prop:GetPhysicsObject()
                if IsValid(phys) then
                    -- Move prop slightly to create noise
                    phys:ApplyForceCenter(VectorRand() * 50)
                end
            end
        end
    end
end

-- Psychological Operations
function ENT:WhisperToPlayers()
    local players = player.GetAll()
    for _, player in pairs(players) do
        if IsValid(player) and player:Alive() then
            local distance = self:GetPos():Distance(player:GetPos())
            if distance < TACTICAL_CONFIG.WHISPER_RADIUS then
                -- Send whisper message
                net.Start("SplinterCellWhisper")
                net.WriteString("You're being watched...")
                net.Send(player)
            end
        end
    end
end

function ENT:FlashGoggles()
    local players = player.GetAll()
    for _, player in pairs(players) do
        if IsValid(player) and player:Alive() then
            local distance = self:GetPos():Distance(player:GetPos())
            if distance < TACTICAL_CONFIG.FLASH_RANGE then
                -- Flash effect
                net.Start("SplinterCellFlash")
                net.WriteVector(self:GetPos())
                net.Send(player)
            end
        end
    end
end

-- Combat Functions
function ENT:PerformSilentTakedown()
    if not IsValid(self.targetPlayer) then return end
    
    -- Execute takedown animation
    self:SetSequence(self:LookupSequence("gesture_melee"))
    
    -- Damage player
    local dmg = DamageInfo()
    dmg:SetDamage(100)
    dmg:SetAttacker(self)
    dmg:SetDamageType(DMG_SLASH)
    
    self.targetPlayer:TakeDamageInfo(dmg)
    
    -- Play takedown sound
    self:EmitSound("physics/body/body_medium_impact_hard" .. math.random(1, 6) .. ".wav", 75, 100)
    
    -- Reset target
    self.targetPlayer = nil
end

function ENT:FireSuppressedShot()
    if not IsValid(self.targetPlayer) then return end
    
    -- Fire suppressed weapon
    local trace = util.TraceLine({
        start = self:GetPos() + Vector(0, 0, 50),
        endpos = self.targetPlayer:GetPos() + Vector(0, 0, 50),
        filter = {self, self.targetPlayer}
    })
    
    if not trace.Hit then
        -- Create bullet effect
        local effect = EffectData()
        effect:SetOrigin(trace.HitPos)
        effect:SetNormal(trace.HitNormal)
        util.Effect("cball_bounce", effect)
        
        -- Damage player
        local dmg = DamageInfo()
        dmg:SetDamage(25)
        dmg:SetAttacker(self)
        dmg:SetDamageType(DMG_BULLET)
        
        self.targetPlayer:TakeDamageInfo(dmg)
        
        -- Play suppressed shot sound
        self:EmitSound("weapons/silencer.wav", 50, 100)
    end
end

function ENT:DeploySmoke()
    if CurTime() - self.smokeLastUsed < TACTICAL_CONFIG.SMOKE_COOLDOWN then return end
    
    -- Create smoke effect
    local effect = EffectData()
    effect:SetOrigin(self:GetPos())
    effect:SetScale(2)
    util.Effect("smoke", effect)
    
    self.smokeLastUsed = CurTime()
end

-- Utility Functions
function ENT:GetLightLevel(position)
    -- Simple light level calculation
    local light = util.PointContents(position)
    if bit.band(light, CONTENTS_SOLID) ~= 0 then
        return 0  -- Inside solid = dark
    end
    
    -- Check for nearby lights
    local lights = ents.FindByClass("light*")
    local totalLight = 0
    
    for _, light in pairs(lights) do
        if IsValid(light) then
            local distance = position:Distance(light:GetPos())
            if distance < 300 then
                totalLight = totalLight + (300 - distance) / 300
            end
        end
    end
    
    return math.Clamp(totalLight, 0, 1)
end

function ENT:HasCover(position)
    -- Check if position has cover from multiple angles
    local coverAngles = {0, 45, 90, 135, 180, 225, 270, 315}
    local coverCount = 0
    
    for _, angle in pairs(coverAngles) do
        local forward = Angle(0, angle, 0):Forward()
        local trace = util.TraceLine({
            start = position,
            endpos = position + forward * 100,
            filter = self
        })
        
        if trace.Hit then
            coverCount = coverCount + 1
        end
    end
    
    return coverCount >= 3
end

function ENT:IsPlayerMakingNoise(player)
    -- Check if player is moving, shooting, or making other noise
    local velocity = player:GetVelocity():Length()
    if velocity > 50 then
        return true
    end
    
    -- Check for weapon firing
    local weapon = player:GetActiveWeapon()
    if IsValid(weapon) and weapon:GetNextPrimaryFire() > CurTime() - 0.1 then
        return true
    end
    
    return false
end

function ENT:MaintainStealth()
    -- Gradually recover stealth level when not compromised
    if self.stealthLevel < 1.0 then
        self.stealthLevel = math.min(1.0, self.stealthLevel + 0.01)
    end
    
    -- Reduce stealth when in light
    local lightLevel = self:GetLightLevel(self:GetPos())
    if lightLevel > 0.5 then
        self.stealthLevel = math.max(0.0, self.stealthLevel - 0.02)
    end
end

function ENT:SearchArea()
    -- Search the last known position area
    local searchRadius = 100
    local searchPoints = 8
    
    for i = 1, searchPoints do
        local angle = (i - 1) * (360 / searchPoints)
        local forward = Angle(0, angle, 0):Forward()
        local searchPos = self.lastKnownPosition + forward * searchRadius
        
        -- Move to search position
        timer.Simple(i * 0.5, function()
            if IsValid(self) then
                self:MoveToPosition(searchPos)
            end
        end)
    end
end

-- Override base NextBot functions
function ENT:RunBehaviour()
    -- Let the timer-based AI handle behavior instead
    while true do
        coroutine.wait(1)
    end
end

-- NextBot movement handling
function ENT:BodyUpdate()
    local act = self:GetActivity()
    
    if self:IsMoving() then
        if act ~= ACT_WALK and act ~= ACT_RUN then
            self:StartActivity(ACT_WALK)
        end
    else
        if act ~= ACT_IDLE then
            self:StartActivity(ACT_IDLE)
        end
    end
    
    self:FrameAdvance()
end

function ENT:OnKilled(dmg)
    -- Clean up timers
    timer.Remove("SplinterCellAI_" .. self:EntIndex())
    
    -- Handle death effects
    local effect = EffectData()
    effect:SetOrigin(self:GetPos())
    effect:SetScale(1)
    util.Effect("bloodspray", effect)
    
    -- Remove entity
    self:Remove()
end

function ENT:OnTakeDamage(dmg)
    -- Reduce stealth when taking damage
    self.stealthLevel = math.max(0.0, self.stealthLevel - 0.3)
    
    -- Update last known position to damage source
    local attacker = dmg:GetAttacker()
    if IsValid(attacker) and attacker:IsPlayer() then
        self.lastKnownPosition = attacker:GetPos()
        self.targetPlayer = attacker
        
        -- Become more aggressive when damaged
        if self.tacticalState == AI_STATES.IDLE_RECON then
            self:ChangeState(AI_STATES.INVESTIGATE)
        end
    end
    
    -- Call parent function
    self.BaseClass.OnTakeDamage(self, dmg)
end

-- Path handling for proper NextBot movement
function ENT:MoveTowards(pos)
    local path = Path("Follow")
    path:SetMinLookAheadDistance(300)
    path:SetGoalTolerance(20)
    path:Compute(self, pos)
    
    if not path:IsValid() then
        return false
    end
    
    path:Update(self)
    
    if path:GetAge() > 0.1 then
        path:Invalidate()
    end
    
    return true
end

-- Cleanup
function ENT:OnRemove()
    timer.Remove("SplinterCellAI_" .. self:EntIndex())
end