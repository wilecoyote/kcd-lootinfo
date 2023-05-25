Script.ReloadScript("SCRIPTS/Entities/AI/Shared/BasicAI.lua");
Script.ReloadScript("SCRIPTS/Entities/actor/BasicActor.lua");

Hare_x = {
  ActionController = "Animations/Mannequin/ADB/wh_hare_controllerdefs.xml",
  AnimDatabase3P = "Animations/Mannequin/ADB/wh_hare_database.adb",

  UseMannequinAGState = true,

  defaultSoulArchetype = "Hare",
  defaultSoulClass = "hare",
  OpponentMnTag = "relatedHare",
  CombatOpponentMnTag = "oppHare",

  Properties = {
    esNavigationType = "MediumSizedCharacters",
    sWH_AI_EntityCategory = "",
    bWH_PerceptorObject = 1,
    bWH_PerceptibleObject = 1,
    bWH_ListenerObject = 0,
    NPC = {
      eiNPCCategory = 1,
      aianchorHome = "",
    },
    fileModel = "Objects/Characters/animals/hare/hare.cdf",
    fileHitDeathReactionsParamsDataFile = "Libs/HitDeathReactionsData/HitDeathReactions_Hare.xml",

    CharacterSounds =
    {
      footstepEffect = "footsteps_Hare",
      remoteFootstepEffect = "footsteps_Hare",
      bFootstepGearEffect = 1,
      footstepIndGearAudioSignal_Walk = "",
      footstepIndGearAudioSignal_Run = "",
      foleyEffect = "foley_Hare",
    },
  },

  collisionCapsule =
  {
    radius = 0.15,
    height = 0.3,
    pos    = { x = 0, y = 0.15, z = 0.3 },
    axis   = { x = 0, y = 1, z = 0 },
  },

  physicsParams =
  {
    mass = 1.5,

    Living =
    {
      mass = 1.5,
    },
  },

  gameParams =
  {
    stance =
    {
      normal = {
        stanceId = E_ACTORSTANCE_NORMAL,
        heightCollider = 0.5,
        heightPivot = 0.0,
        size = { x = 0.1, y = 0.0, z = 0.01 },
        viewOffset = { x = 0, y = 0.10, z = 1.625 },
        name = "normal",
        useCapsule = 0,
      },
    },

    inertia = 0.0,
    inertiaAccel = 0.0,

    backwardMultiplier = 0.5,

    jumpHeight = 1.0,
  },
  AIMovementAbility =
  {
    usePredictiveFollowing = 1,
    pathLookAhead = 1,
    walkSpeed = 1.5,
    runSpeed = 2.5,
    sprintSpeed = 7.0,

    b3DMove = 0,
    minTurnRadius = 0,
    maxTurnRadius = 3,
    pathSpeedLookAheadPerSpeed = -1.5,
    cornerSlowDown = 0.75,
    pathType = "AIPATH_HUMAN",
    pathRadius = 0.4,
    maneuverSpeed = 1.5,
    pathFindPrediction = 0.5,
    maxAccel = 2.0,
    maxDecel = 4.0,
    velDecay = 0.5,
    maneuverTrh = 2.0,
    resolveStickingInTrace = 1,
    pathRegenIntervalDuringTrace = 4,

    AIMovementSpeeds =
    {
      Relaxed =
      {
        Slow   = { 0.9, 0.8, 1.3 },
        Walk   = { 1.5, 1.3, 2.0 },
        Run    = { 2.5, 2.0, 3.0 },
        Sprint = { 7.0, 5.0, 8.0 },
      },
    },
  },


  melee =
  {
    melee_animations =
    {
    },


    damage = 0,
    damageSmall = 0,
    damageOffset = { x = 0, y = -2, z = 0 },
    damageRadius = 20,
    approachLookat = 0,
    alignTime = 0,
    damageTime = 0,
  },
  -- JCDLootInfo -------------------------
  bSearched = 0,
  -- JCDLootInfo -------------------------
}

-- JCDLootInfo -------------------------
function Hare_x:OnSave(table)
  table.bSearched = self.bSearched;
end

function Hare_x:OnLoad(table)
  self.bSearched = table.bSearched;
end

function Hare_x:bIsInventoryEmpty()
  if (self.inventory:GetCount() ~= 0) then
    return 0;
  else
    -- inv is empty --
    return 1;
  end
end

-- JCDLootInfo -------------------------

function Hare_x:OnReset(bFromInit, bIsReload)
  BasicActor.Reset(self, bFromInit, bIsReload);
  self:SetColliderMode(4);
  -- JCDLootInfo -------------------------
  self.bSearched = 0;
  -- JCDLootInfo -------------------------
end

function Hare_x:SetFree(rescuer)
  AI.Signal(SIGNALFILTER_SENDER, 0, "GET_UNTIED", self.id);
end

function Hare_x:OnResetCustom()
  self.isFree = true;
  self:ResetOnUsed();
  -- JCDLootInfo -------------------------
  self.bSearched = 0;
  -- JCDLootInfo -------------------------
end

function Hare_x:GetUsableMessage()
  if (self.actor:GetHealth() <= 0) then
    -- JCDLootInfo -------------------------
    local isEmpty
    if (self.bSearched == 1) then
      isEmpty = self:bIsInventoryEmpty();
      if (isEmpty == 1) then
        -- inv is empty --
        return "@ui_hud_loot_empty";
      else
        return "@ui_hud_loot_searched";
      end
    else
      return "@ui_hud_loot";
    end
    -- JCDLootInfo -------------------------
  end
end

function Hare_x:OnUsed(user)
  BroadcastEvent(self, "Used");
  AI.Signal(SIGNALFILTER_SENDER, 1, "USED", self.id);

  if (self.actor:GetHealth() <= 0) then
    XGenAIModule.LootBegin(self.soul:GetId());
    self.actor:RequestItemExchange(user.id);
    -- JCDLootInfo ---------------------
    self.bSearched = 1;
    -- JCDLootInfo ---------------------
  end
end

function Hare_x:IsUsable(user)
  if (not user) then
    return 0;
  end

  if (self.actor:GetHealth() <= 0) then
    return 1;
  end

  return 0;
end

Script.ReloadScript("SCRIPTS/Entities/AI/Shared/AIBase.lua");
mergef(Hare_x, AIBase, 1)
