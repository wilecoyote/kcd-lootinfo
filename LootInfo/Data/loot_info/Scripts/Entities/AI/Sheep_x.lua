Script.ReloadScript("SCRIPTS/Entities/AI/Shared/BasicAI.lua");
Script.ReloadScript("SCRIPTS/Entities/actor/BasicActor.lua");

Sheep_x = {
  ActionController = "Animations/Mannequin/ADB/wh_sheep_controllerdefs.xml",
  AnimDatabase3P = "Animations/Mannequin/ADB/wh_sheep_database.adb",

  UseMannequinAGState = true,

  defaultSoulArchetype = "Sheep",
  defaultSoulClass = "sheep",
  CombatOpponentMnTag = "oppSheep",

  Properties = {
    esNavigationType = "MediumSizedCharacters",
    sWH_AI_EntityCategory = "",
    bWH_PerceptorObject = 0,
    bWH_PerceptibleObject = 0,
    bWH_ListenerObject = 0,
    NPC = {
      eiNPCCategory = 1,
      aianchorHome = "",
    },
    fileModel = "Objects/Characters/animals/sheep/sheep_female.cdf",
    fileHitDeathReactionsParamsDataFile = "Libs/HitDeathReactionsData/HitDeathReactions_Sheep.xml",
    bNotPlayerMountable = 0,

    CharacterSounds =
    {
      footstepEffect = "footsteps_Sheep",
      remoteFootstepEffect = "footsteps_Sheep",
      bFootstepGearEffect = 1,
      footstepIndGearAudioSignal_Walk = "",
      footstepIndGearAudioSignal_Run = "",
      foleyEffect = "foley_Sheep",
    },
  },

  collisionCapsule =
  {
    radius = 0.25,
    height = 0.65,
    pos    = { x = 0, y = 0.1, z = 0.55 },
    axis   = { x = 0, y = 1, z = 0 },
  },

  physicsParams =
  {
    mass = 100,

    Living =
    {
      mass = 100,
    },
  },

  gameParams =
  {
    boneIDs =
    {
      BONE_HAND_R    = "Bip01 R Middle1",
      BONE_HAND_L    = "Bip01 L Middle1",
      BONE_SPINE_1   = "Bip01 Spine",
      BONE_SPINE_2   = "Bip01 Spine1",
      BONE_SPINE_3   = "Bip01 Spine2",
      BONE_HEAD      = "Bip01 Head",
      BONE_FOREARM_R = "Bip01 R Hand",
      BONE_FOREARM_L = "Bip01 L Hand",
      BONE_PELVIS    = "Bip01 Pelvis",
      BONE_NECK      = "Bip01 Neck",

      BONE_EYE_R     = "eye_right_bone",
      BONE_EYE_L     = "eye_left_bone",
    },


    stance =
    {
      normal = {
        stanceId = E_ACTORSTANCE_NORMAL,
        heightCollider = 0.4,
        heightPivot = 0.0,
        size = { x = 0.1, y = 0.0, z = 0.01 },
        viewOffset = { x = 0, y = 0.10, z = 0.5 },
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
function Sheep_x:OnSave(table)
  table.bSearched = self.bSearched;
end

function Sheep_x:OnLoad(table)
  self.bSearched = table.bSearched;
end

function Sheep_x:bIsInventoryEmpty()
  if (self.inventory:GetCount() ~= 0) then
    return 0;
  else
    -- inv is empty --
    return 1;
  end
end

-- JCDLootInfo -------------------------

function Sheep_x:OnReset(bFromInit, bIsReload)
  BasicActor.Reset(self, bFromInit, bIsReload);
  self:SetColliderMode(4);
  -- JCDLootInfo -------------------------
  self.bSearched = 0;
  -- JCDLootInfo -------------------------
end

function Sheep_x:SetFree(rescuer)
  AI.Signal(SIGNALFILTER_SENDER, 0, "GET_UNTIED", self.id);
end

function Sheep_x:OnResetCustom()
  self.isFree = true;
  self:ResetOnUsed();
  -- JCDLootInfo -------------------------
  self.bSearched = 0;
  -- JCDLootInfo -------------------------
end

function Sheep_x:GetUsableMessage()
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

function Sheep_x:OnUsed(user)
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

function Sheep_x:IsUsable(user)
  if (not user) then
    return 0;
  end

  if (self.actor:GetHealth() <= 0) then
    return 1;
  end

  return 0;
end

Script.ReloadScript("SCRIPTS/Entities/AI/Shared/AIBase.lua");
mergef(Sheep_x, AIBase, 1)
