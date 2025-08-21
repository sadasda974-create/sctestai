include("shared.lua")

ENT.RenderGroup = RENDERGROUP_OPAQUE

-- Client-side variables
local stealthIndicator = 0
local lastStealthUpdate = 0

function ENT:Initialize()
    -- Initialize client-side effects
    self.stealthParticles = {}
    self.flashEffect = 0
    self.whisperTimer = 0
    
    -- Set up particle effects for stealth mode
    self:SetupStealthParticles()
end

function ENT:SetupStealthParticles()
    -- Create stealth particle effect
    local effect = EffectData()
    effect:SetOrigin(self:GetPos())
    effect:SetScale(0.5)
    util.Effect("smoke", effect)
end

function ENT:Draw()
    -- Draw the NextBot
    self:DrawModel()
    
    -- Draw tactical information if player is close
    local player = LocalPlayer()
    if IsValid(player) and player:GetPos():Distance(self:GetPos()) < 500 then
        self:DrawTacticalInfo()
    end
    
    -- Draw stealth indicator
    self:DrawStealthIndicator()
end

function ENT:DrawTacticalInfo()
    local pos = self:GetPos() + Vector(0, 0, 80)
    local ang = LocalPlayer():EyeAngles()
    ang:RotateAroundAxis(ang:Up(), -90)
    ang:RotateAroundAxis(ang:Forward(), 90)
    
    cam.Start3D2D(pos, ang, 0.1)
        -- Draw tactical state
        local stateText = self:GetTacticalStateText()
        local stateColor = self:GetStateColor()
        
        draw.SimpleTextOutlined("TACTICAL STATE", "DermaDefault", 0, -20, stateColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
        draw.SimpleTextOutlined(stateText, "DermaDefault", 0, 0, stateColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
        
        -- Draw objective
        local objective = self:GetNWString("currentObjective", "patrol")
        draw.SimpleTextOutlined("OBJECTIVE: " .. string.upper(objective), "DermaDefault", 0, 20, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
        
        -- Draw stealth level
        local stealthLevel = self:GetNWFloat("stealthLevel", 1.0)
        local stealthBarWidth = 100
        local stealthBarHeight = 8
        
        -- Background
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawRect(-stealthBarWidth/2, 35, stealthBarWidth, stealthBarHeight)
        
        -- Stealth bar
        local stealthColor = self:GetStealthColor(stealthLevel)
        surface.SetDrawColor(stealthColor)
        surface.DrawRect(-stealthBarWidth/2, 35, stealthBarWidth * stealthLevel, stealthBarHeight)
        
        -- Border
        surface.SetDrawColor(255, 255, 255, 100)
        surface.DrawOutlinedRect(-stealthBarWidth/2, 35, stealthBarWidth, stealthBarHeight)
        
        draw.SimpleTextOutlined("STEALTH", "DermaDefault", 0, 50, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
    cam.End3D2D()
end

function ENT:DrawStealthIndicator()
    local stealthLevel = self:GetNWFloat("stealthLevel", 1.0)
    
    -- Update stealth indicator
    if CurTime() - lastStealthUpdate > 0.1 then
        stealthIndicator = stealthLevel
        lastStealthUpdate = CurTime()
    end
    
    -- Draw stealth particles around the NextBot
    if stealthLevel > 0.7 then
        self:DrawStealthParticles()
    end
end

function ENT:DrawStealthParticles()
    local pos = self:GetPos()
    local particleCount = 5
    
    for i = 1, particleCount do
        local offset = Vector(
            math.sin(CurTime() + i) * 30,
            math.cos(CurTime() + i) * 30,
            math.sin(CurTime() * 0.5 + i) * 20
        )
        
        local particlePos = pos + offset
        
        -- Draw stealth particle
        render.SetMaterial(Material("sprites/light_glow02_add"))
        render.DrawSprite(particlePos, 8, 8, Color(0, 100, 200, 100))
    end
end

function ENT:GetTacticalStateText()
    local state = self:GetNWInt("tacticalState", 1)
    
    if state == 1 then
        return "IDLE/RECON"
    elseif state == 2 then
        return "INVESTIGATE"
    elseif state == 3 then
        return "STALKING"
    elseif state == 4 then
        return "AMBUSH"
    elseif state == 5 then
        return "ENGAGE SUPPRESSED"
    elseif state == 6 then
        return "RETREAT/RESET"
    else
        return "UNKNOWN"
    end
end

function ENT:GetStateColor()
    local state = self:GetNWInt("tacticalState", 1)
    
    if state == 1 then
        return Color(0, 255, 0)      -- Green for idle
    elseif state == 2 then
        return Color(255, 255, 0)    -- Yellow for investigate
    elseif state == 3 then
        return Color(255, 165, 0)    -- Orange for stalking
    elseif state == 4 then
        return Color(255, 0, 0)      -- Red for ambush
    elseif state == 5 then
        return Color(255, 0, 255)    -- Magenta for engage
    elseif state == 6 then
        return Color(128, 128, 128)  -- Gray for retreat
    else
        return Color(255, 255, 255)  -- White for unknown
    end
end

function ENT:GetStealthColor(stealthLevel)
    if stealthLevel > 0.7 then
        return Color(0, 255, 0)      -- Green for high stealth
    elseif stealthLevel > 0.4 then
        return Color(255, 255, 0)    -- Yellow for medium stealth
    else
        return Color(255, 0, 0)      -- Red for low stealth
    end
end

-- Handle whisper effects
hook.Add("HUDPaint", "SplinterCellWhisperEffect", function()
    local player = LocalPlayer()
    if not IsValid(player) then return end
    
    -- Check for nearby Splinter Cell NextBots
    local nextbots = ents.FindByClass("nextbot_splinter_cell")
    for _, nextbot in pairs(nextbots) do
        if IsValid(nextbot) then
            local distance = player:GetPos():Distance(nextbot:GetPos())
            if distance < 200 then
                -- Create whisper effect
                nextbot:CreateWhisperEffect(player)
            end
        end
    end
end)

function ENT:CreateWhisperEffect(player)
    -- Create screen distortion effect
    local distance = player:GetPos():Distance(self:GetPos())
    local intensity = math.max(0, (200 - distance) / 200)
    
    if intensity > 0 then
        -- Apply screen shake
        local shake = math.sin(CurTime() * 10) * intensity * 2
        player:SetViewOffset(player:GetViewOffset() + Vector(shake, shake, 0))
        
        -- Create whisper text
        if CurTime() - self.whisperTimer > 3 then
            self.whisperTimer = CurTime()
            self:ShowWhisperText(player)
        end
    end
end

function ENT:ShowWhisperText(player)
    -- Show whisper text on screen
    local messages = {
        "You're being watched...",
        "I can see you...",
        "The shadows are my allies...",
        "Your footsteps betray you...",
        "Silence is golden...",
        "I am the night..."
    }
    
    local message = messages[math.random(1, #messages)]
    
    -- Create whisper notification
    notification.AddLegacy("[Whisper] " .. message, NOTIFY_GENERIC, 3)
    
    -- Play whisper sound
    surface.PlaySound("ambient/voices/m_scream1.wav")
end

-- Handle flash effects
hook.Add("RenderScreenspaceEffects", "SplinterCellFlashEffect", function()
    local player = LocalPlayer()
    if not IsValid(player) then return end
    
    -- Check for flash effects
    local nextbots = ents.FindByClass("nextbot_splinter_cell")
    for _, nextbot in pairs(nextbots) do
        if IsValid(nextbot) then
            local distance = player:GetPos():Distance(nextbot:GetPos())
            if distance < 150 then
                -- Apply flash effect
                nextbot:ApplyFlashEffect(player, distance)
            end
        end
    end
end)

function ENT:ApplyFlashEffect(player, distance)
    local intensity = math.max(0, (150 - distance) / 150)
    
    if intensity > 0 then
        -- Create flash overlay
        local flashColor = Color(255, 255, 255, intensity * 50)
        surface.SetDrawColor(flashColor)
        surface.DrawRect(0, 0, ScrW(), ScrH())
        
        -- Apply screen distortion
        local distortion = math.sin(CurTime() * 20) * intensity * 5
        player:SetViewOffset(player:GetViewOffset() + Vector(distortion, 0, 0))
    end
end

-- Cleanup on entity removal
function ENT:OnRemove()
    -- Clean up client-side effects
    self.stealthParticles = {}
    self.flashEffect = 0
    self.whisperTimer = 0
end
