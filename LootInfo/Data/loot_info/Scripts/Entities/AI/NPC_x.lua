Script.ReloadScript("SCRIPTS/Entities/AI/Shared/AIBase.lua");
Script.ReloadScript("SCRIPTS/Entities/AI/Shared/BasicAIActions.lua");

NPC_x = {
  ActionController = "Animations/Mannequin/ADB/kcd_male_controllerdefs.xml",
  AnimDatabase3P = "Animations/Mannequin/ADB/kcd_male_database.adb",
  OpponentMnTag = "relatedMale",
  CombatOpponentMnTag = "oppMale",

  UseMannequinAGState = true,

  Properties = {
    esNavigationType = "MediumSizedCharacters",
    sWH_AI_EntityCategory = "",
    bWH_Lootable = 1,
    bWH_PerceptorObject = 1,
    bWH_PerceptibleObject = 1,
    bWH_ListenerObject = 1,
    fileModel = "Objects/Characters/humans/skeleton/male.cdf",
    fileHitDeathReactionsParamsDataFile = "Libs/HitDeathReactionsData/HitDeathReactions_SkeletonMale.xml",
    esClothingConfig = "male",
    objFrozenModel = "",
    voiceType = "enemy",
    esFaction = "Civilians",
    useSpecialMovementTransitions = 1,
    perInstanceStreamingPriority = 0,
    CharacterSounds =
    {
      footstepEffect = "footsteps_npc",
      remoteFootstepEffect = "footsteps_npc",
      bFootstepGearEffect = 1,
      footstepIndGearAudioSignal_Walk = "",
      footstepIndGearAudioSignal_Run = "",
      foleyEffect = "foleys_npc",
    },
  },

  gameParams =
  {
    inertia = 0.0,
    inertiaAccel = 0.0,
    backwardMultiplier = 0.5,
    lookFOV = 150,
    minimumAngleForTurnWithoutDelay = 20,
  },
  AIMovementAbility =
  {
    allowEntityClampingByAnimation = 1,
    usePredictiveFollowing = 1,
    pathLookAhead = 1,
    walkSpeed = 2.0,
    runSpeed = 4.0,
    sprintSpeed = 6.4,
    maneuverSpeed = 1.5,
    b3DMove = 0,
    minTurnRadius = 0,
    maxTurnRadius = 3,
    pathSpeedLookAheadPerSpeed = -1.5,
    cornerSlowDown = 0.75,
    pathType = AIPATH_HUMAN,
    pathRadius = 0.25,
    passRadius = 0.25,

    distanceToCover = 0.5,
    inCoverRadius = 0.075,
    effectiveCoverHeight = 0.55,
    effectiveHighCoverHeight = 1.75,

    pathFindPrediction = 0.5,
    maxAccel = 2.0,
    maxDecel = 4.0,
    velDecay = 0.5,
    maneuverTrh = 2.0,
    resolveStickingInTrace = 1,
    pathRegenIntervalDuringTrace = 1,
    lightAffectsSpeed = 1,

    avoidanceAbilities = AVOIDANCE_ALL,
    pushableObstacleWeakAvoidance = true,
    pushableObstacleAvoidanceRadius = 0.4,
    lookIdleTurnSpeed = 30,
    lookCombatTurnSpeed = 50,
    aimTurnSpeed = -1,
    fireTurnSpeed = -1,
    directionalScaleRefSpeedMin = 1.0,
    directionalScaleRefSpeedMax = 8.0,

    AIMovementSpeeds =
    {
      Relaxed =
      {
        Slow = { 0.6, 0.6, 0.6 },
        Walk = { 1.1, 1.1, 1.1 },
        Run = { 3.5, 3.5, 3.5 },
        Sprint = { 5.0, 5.0, 5.0 },
      },
      Alerted =
      {
        Slow = { 0.8, 0.8, 0.8 },
        Walk = { 1.4, 1.4, 1.4 },
        Run = { 3.5, 3.5, 3.5 },
        Sprint = { 5.0, 5.0, 5.0 },
      },
      Combat =
      {
        Slow = { 0.8, 0.8, 0.8 },
        Walk = { 1.7, 1.7, 1.7 },
        Run = { 4.5, 4.5, 4.5 },
        Sprint = { 6.0, 6.0, 6.0 },
      },
      Crouch =
      {
        Slow = { 0.8, 0.8, 0.8 },
        Walk = { 1.3, 1.3, 1.3 },
        Run = { 2.0, 2.0, 2.0 },
        Sprint = { 2.0, 2.0, 2.0 },
      },
      LowCover =
      {
        Slow = { 0.9, 0.9, 0.9 },
        Walk = { 0.9, 0.9, 0.9 },
        Run = { 1.8, 1.8, 1.8 },
        Sprint = { 1.8, 1.8, 1.8 },
      },
      HighCover =
      {
        Slow = { 1.3, 1.3, 1.3 },
        Walk = { 1.3, 1.3, 1.3 },
        Run = { 1.8, 1.8, 1.8 },
        Sprint = { 1.8, 1.8, 1.8 },
      },
      Swim =
      {
        Slow = { 1.0, 1.0, 1.0 },
        Walk = { 1.0, 1.0, 1.0 },
        Run = { 3.5, 3.5, 3.5 },
        Sprint = { 5.0, 5.0, 5.0 },
      },
    },
  },
  melee =
  {
    damageRadius = 1.1,
  },
  collisionDamageThreshold = 2,
  -- JCDLootInfo -------------------------
  bSearched = 0,
  -- JCDLootInfo -------------------------
  lastCanTalkHintFlag = true,
}

-- JCDLootInfo -------------------------
function NPC_x:OnSave(table)
  table.bSearched = self.bSearched;
end

function NPC_x:OnLoad(table)
  self.bSearched = table.bSearched;
end

-- JCDLootInfo -------------------------

function NPC_x:OnResetCustom()
  self.isFree = true;
  self.lootable = self.Properties.bWH_Lootable ~= 0;
  self:ResetOnUsed();
  -- JCDLootInfo -------------------------
  self.bSearched = 0;
  -- JCDLootInfo -------------------------
end

function NPC_x:SetFree(rescuer)
  AI.Signal(SIGNALFILTER_SENDER, 0, "GET_UNTIED", self.id);
end

function NPC_x:IsUsableMsgChanged()
  local newHintType = BasicAIActions.GetCanTalkHintType(self);
  if (newHintType ~= lastCanTalkHintFlag) then
    lastCanTalkHintFlag = newHintType;
    return true;
  end

  return false;
end

mergef(NPC_x, AIBase, 1)
mergef(NPC_x, BasicAIActions, 1)
