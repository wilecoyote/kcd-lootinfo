Nest =
{
  Server = {},
  Client = {},

  Properties =
  {
    object_Model = "objects/structures/stork_nest/bird_nest.cgf",
    ParticleEffect = "",

    Sounds =
    {
      snd_Birds = "a_l_poi_birdnest",
    },

    Physics = {
      bPhysicalize       = 1,
      bRigidBody         = 1,
      bPushableByPlayers = 0,
      Density            = -1,
      Mass               = 1,
    },

    Database = {
      guidInventoryDBId = "0",
    },
  },


  Editor          =
  {
    Icon       = "Stash.bmp",
    ShowBounds = 1,
    IconOnTop  = 1,
  },

  nSoundId        = 0,
  inventoryId     = 0,
  hSoundTriggerID = nil,
  shotDown        = 0,
  -- JCDLootInfo -------------------------
  bSearched       = 0,
  -- JCDLootInfo -------------------------
}
function Nest:OnLoad(table)
  self:DoStopSound();
  self.shotDown = table.shotDown;
  -- JCDLootInfo -------------------------
  self.bSearched = table.bSearched;
  -- JCDLootInfo -------------------------
end

function Nest:OnSave(table)
  table.shotDown = self.shotDown;
  -- JCDLootInfo -------------------------
  table.bSearched = self.bSearched;
  -- JCDLootInfo -------------------------
end

function Nest:OnPropertyChange()
  EntityModule.LoadInventoryFromDB((self.Properties.Database.guidInventoryDBId), self.id);
  self:Reset();
  -- JCDLootInfo -------------------------
  self.bSearched = 0;
  -- JCDLootInfo -------------------------
end

function Nest:OnReset()
  EntityModule.LoadInventoryFromDB((self.Properties.Database.guidInventoryDBId), self.id);
  self:Reset();
  -- JCDLootInfo -------------------------
  self.bSearched = 0;
  -- JCDLootInfo -------------------------
end

function Nest:OnSpawn()
  self.inventoryId = EntityModule.AcquireInventory((self.Properties.Database.guidInventoryDBId), self.id);
  self:Reset();
  -- JCDLootInfo -------------------------
  self.bSearched = 0;
  -- JCDLootInfo -------------------------
end

function Nest:OnDestroy()
  EntityModule.ReleaseInventory(self.id);
  self.inventoryId = -1;
end

-- JCDLootInfo -------------------------
function Nest:bIsInventoryEmpty()
  if (not user) then
    return 0; -- canot be used by AI
  end

  if (self.inventory:GetCount() ~= 0) then
    return 0;
  else
    -- inv is empty --
    return 1;
  end
end

-- JCDLootInfo -------------------------

function Nest:Reset()
  if (self.Properties.object_Model ~= "") then
    self:LoadObject(0, self.Properties.object_Model);
  end

  self.hSoundTriggerID = AudioUtils.LookupTriggerID(self.Properties.Sounds.snd_Birds);

  self:PhysicalizeThis();
  self:DoStopSound();
  self:DoPlaySound();
  self.shotDown = 0;
  -- JCDLootInfo -------------------------
  self.bSearched = 0;
  -- JCDLootInfo -------------------------
end

function Nest:PhysicalizeThis()
  local Physics = self.Properties.Physics;
  EntityCommon.PhysicalizeRigid(self, 0, Physics, 0);
end

function Nest:IsUsable(user)
  return 1;
end

function Nest:GetUsableControl()
  return Game.GetActionControl("player", "use");
end

function Nest:GetActions(user, firstFast)
  if (user == nil) then
    return {};
  end

  output = {};
  -- JCDLootInfo -------------------------
  local isEmpty
  if (self.bSearched == 1) then
    isEmpty = self:bIsInventoryEmpty();
    if (isEmpty == 1) then
      -- inv is empty --
      AddInteractorAction(output, firstFast,
        Action():hint("@ui_open_nest_empty"):action("use"):func(Nest.OnUsed):interaction(inr_stashOpen));
    else
      AddInteractorAction(output, firstFast,
        Action():hint("@ui_open_nest_searched"):action("use"):func(Nest.OnUsed):interaction(inr_stashOpen));
    end
  else
    AddInteractorAction(output, firstFast,
      Action():hint("@ui_open_nest"):action("use"):func(Nest.OnUsed):interaction(inr_stashOpen));
  end
  -- JCDLootInfo -------------------------
  return output;
end

function Nest:Open(user)
  if (EntityModule.IsInventoryReadOnly(self.inventoryId)) then
    user.actor:OpenInventory(self.id, E_IM_StoreReadOnly, self.inventoryId, "");
  else
    user.actor:OpenInventory(self.id, E_IM_Store, self.inventoryId, "");
  end
  -- JCDLootInfo -------------------------
  self.bSearched = 1;
  -- JCDLootInfo -------------------------
  self:Event_Open();
end

function Nest:Close()
  self:Event_Close();
end

function Nest:OnInventoryClosed()
  self:Close();
end

function Nest:OnUsed(user, slot)
  if (user.soul:IsInCombatDanger()) then
    return;
  end
  ;

  if (user.player) then
    self:Open(user);
  end
end

function Nest:DoPlaySound()
  self:DoStopSound();

  if (self.hSoundTriggerID ~= nil) then
    self:ExecuteAudioTrigger(self.hSoundTriggerID, self:GetDefaultAuxAudioProxyID());
  end
end

function Nest:DoStopSound()
  if (self.hSoundTriggerID ~= nil) then
    self:StopAudioTrigger(self.hSoundTriggerID, self:GetDefaultAuxAudioProxyID());
  end
end

function Nest:StartParticleEffect(hit)
  Particle.SpawnEffect(self.Properties.ParticleEffect, hit.pos, hit.dir);
end

function Nest.Client:OnHit(hit)
  if (self.shotDown == 0) then
    local Physics = self.Properties.Physics;
    EntityCommon.PhysicalizeRigid(self, 0, Physics, 1);
    self:StartParticleEffect(hit);
    self:DoStopSound();
    self.shotDown = 1;
  end
end

function Nest:Event_Open()
end

;

function Nest:Event_Close()
end

;
function Nest:Event_Hide()
  self:Hide(1);
  self:ActivateOutput("Hide", true);
end

function Nest:Event_UnHide()
  self:Hide(0);
  self:ActivateOutput("UnHide", true);
end

Nest.FlowEvents =
{
  Inputs =
  {
    Close = { Nest.Event_Close, "bool" },
    Open = { Nest.Event_Open, "bool" },
    Hide = { Nest.Event_Hide, "bool" },
    UnHide = { Nest.Event_UnHide, "bool" },
  },
  Outputs =
  {
    Close = "bool",
    Open = "bool",
    Hide = "bool",
    UnHide = "bool",
  },
}
