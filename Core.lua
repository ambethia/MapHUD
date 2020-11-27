local ADDON, NS = ...
_G[ADDON] = NS

NS.isActive = false

local MapHUD = CreateFrame("Frame", ADDON .. "Frame")
NS.frame = MapHUD

function NS:Toggle()
  if self.isActive then
    self:Disable()
  else
    self:Enable()
  end
end

function NS:Enable()
  self.isActive = true
  -- print("MapHUD enabled.")
  -- Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8X8")

  local p = {}
  p.point, p.relativeTo, p.relativePoint, p.xOfs, p.yOfs = Minimap:GetPoint()
  NS.originalMinimapPosition = p

  Minimap:ClearAllPoints()
  Minimap:SetPoint("BOTTOM", MainMenuBar, "TOP", 0, 24)

  Minimap:SetScale(3)
  Minimap:SetAlpha(0.33)
  C_Minimap.SetIgnoreRotateMinimap(false)

  for _, frame in ipairs(NS.hiddenFrames) do
    if frame:GetName() ~= "Minimap" then
      frame:Hide()
    end
  end
end

function NS:Disable()
  self.isActive = false
  -- print("MapHUD disabled.")
  -- Minimap:SetMaskTexture("Interface\\Masks\\CircleMask")

  for _, frame in ipairs(NS.hiddenFrames) do
    if frame:GetName() ~= "Minimap" then
      frame:Show()
    end
  end

  Minimap:ClearAllPoints()
  local p = NS.originalMinimapPosition
  Minimap:SetPoint(p.point, p.relativeTo, p.relativePoint, p.xOfs, p.yOfs)

  Minimap:SetScale(1)
  Minimap:SetAlpha(1)
  C_Minimap.SetIgnoreRotateMinimap(true)
  
  if not HasNewMail() then
    MiniMapMailFrame:Hide()
  end
end

MapHUD:SetScript("OnEvent", function(self, event, ...)
  if self[event] then return self[event](self, ...); end
end)


MapHUD:RegisterEvent("PLAYER_ENTERING_WORLD")
if not IsAddOnLoaded("Blizzard_TimeManager") then
  LoadAddOn("Blizzard_TimeManager")
end

function MapHUD:PLAYER_ENTERING_WORLD()
  NS.hiddenFrames = {
    MinimapCluster:GetChildren(),
    MinimapBackdrop,
    MinimapBorderTop,
    Minimap:GetChildren()
  }

  self:UnregisterEvent("PLAYER_ENTERING_WORLD")
  self.PLAYER_ENTERING_WORLD = nil
end

BINDING_NAME_MAPHUD_TOGGLE = "Toggle MapHUD"