Script.ReloadScript("SCRIPTS/Entities/AI/Shared/BasicAI.lua");
Script.ReloadScript("SCRIPTS/Entities/actor/BasicActor.lua");

Horse_x = {
  ActionController = "Animations/Mannequin/ADB/kcd_horse_controllerdefs.xml",
  AnimDatabase3P = "Animations/Mannequin/ADB/kcd_horse_database.adb",

  UseMannequinAGState = true,

  defaultSoulArchetype = "Horse",
  defaultSoulClass = "horse",

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
    fileModel = "Objects/Characters/animals/horse/horse.cdf",
    fileHitDeathReactionsParamsDataFile = "Libs/HitDeathReactionsData/HitDeathReactions_Horse.xml",
    esClothingConfig = "horse_old",
    bNotPlayerMountable = 0,
    bNotPlayerInspectable = 0,
    bMountIsLegal = 0,

    CharacterSounds =
    {
      footstepEffect = "footsteps_horse",
      remoteFootstepEffect = "footsteps_horse",
      bFootstepGearEffect = 1,
      footstepIndGearAudioSignal_Walk = "",
      footstepIndGearAudioSignal_Run = "",
      foleyEffect = "foley_horse",
    },

    RopePhysics =
    {
      collDist = 0.1,
      noCollDist = 0.5,
      mass = 1,
      stiffness = 10,
      stiffnessAnim = 70,
      stiffnessDecayAnim = 0.75,
      friction = 0.2,
      dampingAnim = 0.2,
      maxTimeStep = 0.05,
      length = 1.67,
      targetPoseActive = 1,
      unprojLimit = 0.5,
      maxIter = 650,
      attachmentZone = 0,
      nSegments = 0,

      flags =
      {
        bApproximateVelocity = 0,
        bNoSolver = 0,
        bIgnoreAttachments = 0,
        bSubdivisionMode = 0,
        bNoTears = 0,
        bCollides = 0,
        bCollidesWithTerrain = 0,
        bCollidesWithAttachment = 1,
        bNoStiffnessWhenColliding = 0,
      },

      attachmentOffset = { x = 0, y = 0, z = 0 },
    },
  },

  simplifiedRootRotation = false,

  collisionCapsule =
  {
    radius = 0.4,
    height = 1,
    pos    = { x = 0, y = 0, z = 1.15 },
    axis   = { x = 0, y = 1, z = 0 },
  },

  actorCombatDimension =
  {
    size = { x = 0.5, y = 1.3, z = 0 }
  },

  physicsParams =
  {
    mass = 480.0,
    neckMass = 1.0,

    Living =
    {
      gravity = 30,

      mass = 480.0,

      min_slide_angle = 90.0,
      max_climb_angle = 50.0,
      min_fall_angle = 90.0,
      max_jump_angle = 40.0,

      inertia = 11.0,
      inertiaAccel = 11.0,
    },
  },

  gameParams =
  {
    stance =
    {
      normal = {
        stanceId = E_ACTORSTANCE_NORMAL,
        heightCollider = 1.3,
        heightPivot = 0.0,
        size = { x = 0.4, y = 0.4, z = 0.2 },
        name = "normal",
        useCapsule = 1,
      },
    },
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
    collisionAvoidanceParticipation = true,
    passRadius = 1.25,

    AIMovementSpeeds =
    {
      Relaxed =
      {
        Slow   = { 1.2, 0.9, 1.3 },
        Walk   = { 1.7, 1.3, 2.0 },
        Run    = { 2.3, 2.0, 2.6 },
        Sprint = { 6.8, 6.5, 7.1 },
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

  mountableByPlayer = true,
  inspectableByPlayer = true,
  mountIsLegal,
  maxMountDistance = 1.75,

  -- JCDLootInfo -------------------------
  bSearched = 0,
  -- JCDLootInfo -------------------------
}

-- JCDLootInfo -------------------------
function Horse_x:bIsInventoryEmpty()
  if (self.inventory:GetCount() ~= 0) then
    return 0;
  else
    -- inv is empty --
    return 1;
  end
end

-- JCDLootInfo -------------------------

function Horse_x:OnReset(bFromInit, bIsReload)
  BasicActor.Reset(self, bFromInit, bIsReload);
  self:SetColliderMode(4);
  self.mountableByPlayer = self.Properties.bNotPlayerMountable == 0
  self.inspectableByPlayer = self.Properties.bNotPlayerInspectable == 0
  self.mountIsLegal = self.Properties.bMountIsLegal == 1
  -- JCDLootInfo -------------------------
  self.bSearched = 0;
  -- JCDLootInfo -------------------------
end

function Horse_x:SetFree(rescuer)
  AI.Signal(SIGNALFILTER_SENDER, 0, "GET_UNTIED", self.id);
end

function Horse_x:OnResetCustom()
  self.isFree = true;
  self:ResetOnUsed();
  -- JCDLootInfo -------------------------
  self.bSearched = 0;
  -- JCDLootInfo -------------------------
end

function Horse_x:IsUsable(user)
  if (isFemale(user)) then
    return 0;
  end
  local myDirection = g_Vectors.temp_v1;
  local vecToPlayer = g_Vectors.temp_v2;
  local myPos = g_Vectors.temp_v3;

  myDirection = self:GetDirectionVector(0);

  user:GetWorldPos(vecToPlayer);
  self:GetWorldPos(myPos);

  FastDifferenceVectors(vecToPlayer, myPos, vecToPlayer);
  local len = LengthVector(vecToPlayer);

  if (len > self.maxMountDistance) then
    return 0;
  end

  NormalizeVector(vecToPlayer);

  local dp = dotproduct2d(myDirection, vecToPlayer);

  if (math.abs(dp) > 0.20) then
    return 1;
  end

  return 0;
end

function Horse_x:GetHintsTitle()
  if self.soul == nil then
    return "";
  end
  return "@" .. self.soul:GetNameStringId();
end

function Horse_x:ForceUsable(user)
  if (not user) then
    return false;
  end

  local vecToPlayer = g_Vectors.temp_v2;
  local myPos = g_Vectors.temp_v3;

  user:GetWorldPos(vecToPlayer);
  self:GetWorldPos(myPos);

  FastDifferenceVectors(vecToPlayer, myPos, vecToPlayer);
  local len = LengthVector(vecToPlayer);

  if (len > self.maxMountDistance) then
    return false;
  end

  if self.horse:HasRider() then
    return false;
  end

  return true;
end

function Horse_x:GetActions(user, firstFast)
  if (user == nil) then
    return {};
  end

  output = {};


  if self:IsUsable(user) > 0 then
    if self.actor:GetHealth() <= 0 then
      -- JCDLootInfo -------------------------
      local isEmpty
      if (self.bSearched == 1) then
        isEmpty = self:bIsInventoryEmpty();
        if (isEmpty == 1) then
          -- inv is empty --
          AddInteractorAction(output, firstFast,
            Action():hint("@ui_hud_loot_empty"):action("use"):func(Horse_x.OnLoot):interaction(inr_horseLoot))
        else
          AddInteractorAction(output, firstFast,
            Action():hint("@ui_hud_loot_searched"):action("use"):func(Horse_x.OnLoot):interaction(inr_horseLoot))
        end
      else
        AddInteractorAction(output, firstFast,
          Action():hint("@ui_hud_loot"):action("use"):func(Horse_x.OnLoot):interaction(inr_horseLoot))
      end
      -- JCDLootInfo -------------------------
      return output
    end
    if not self.horse:HasRider() and self.horse:IsMountable() and self.mountableByPlayer then
      local playerCanMount = user.player:CanMountHorse(self.id);

      if playerCanMount ~= MAT_Undefined then
        local isPlayerHorse   = user.player:GetHorseId() == self.id
        local isFreeToTake    = isPlayerHorse or self.mountIsLegal

        local mountStr        = pick(isFreeToTake, "@ui_hud_mount", "@ui_hud_mount_and_steal")
        local mountActionType = pick(isFreeToTake, AHT_PRESS, AHT_HOLD)
        local mountActionType = pick(isFreeToTake, AHT_PRESS, AHT_HOLD)
        AddInteractorAction(output, firstFast,
          Action():hint(mountStr):action("mount_horse"):hintType(mountActionType):func(Horse_x.OnMount):interaction(
          inr_horseMount):uiOrder(0):enabled(playerCanMount == MAT_Mount))
      end

      if self.inspectableByPlayer and not isPlayerHorse then
        AddInteractorAction(output, firstFast,
          Action():hint("@ui_hud_horse_inspect"):action("use_other"):func(Horse_x.OnInspect):interaction(
          inr_horseInspect):uiOrder(1))
      end
    end
  end

  return output;
end

function Horse_x:OnMount(user, slot)
  user.human:Mount(self.id);
end

function Horse_x:OnLoot(user, slot)
  XGenAIModule.LootBegin(self.soul:GetId());
  self.actor:RequestItemExchange(user.id);
  -- JCDLootInfo ---------------------
  self.bSearched = 1;
  -- JCDLootInfo ---------------------
end

function Horse_x:OnInspect(user, slot)
  user.player:HorseInspect(self.id);
end

function Horse_x:OnLoad(table)
  BasicActor.OnLoad(self, table);
  self.Properties.sharedSoulGuid = table.sharedSoulGuid;
  self.mountableByPlayer = table.mountableByPlayer;
  self.inspectableByPlayer = table.inspectableByPlayer;
  self.mountIsLegal = table.mountIsLegal;
  -- JCDLootInfo ---------------------
  self.bSearched = table.bSearched;
  -- JCDLootInfo ---------------------
end

function Horse_x:OnSave(table)
  BasicActor.OnSave(self, table);
  table.sharedSoulGuid = self.Properties.sharedSoulGuid;
  table.mountableByPlayer = self.mountableByPlayer;
  table.inspectableByPlayer = self.inspectableByPlayer;
  table.mountIsLegal = self.mountIsLegal;
  -- JCDLootInfo ---------------------
  table.bSearched = self.bSearched;
  -- JCDLootInfo ---------------------
end

function Horse_x:SetMountableByPlayer(mountable)
  self.mountableByPlayer = mountable
end

function Horse_x:SetInspectableByPlayer(inspectable)
  self.inspectableByPlayer = inspectable
end

function Horse_x:SetMountIsLegal(isLegal)
  self.mountIsLegal = isLegal
end

function Horse_x:IsMountLegal()
  return self.mountIsLegal
end

Script.ReloadScript("SCRIPTS/Entities/AI/Shared/AIBase.lua");
mergef(Horse_x, AIBase, 1)
