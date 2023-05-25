Script.ReloadScript("SCRIPTS/Entities/AI/Shared/BasicAI.lua");
Script.ReloadScript("SCRIPTS/Entities/actor/BasicActor.lua");
Script.ReloadScript("SCRIPTS/Entities/AI/Shared/BasicAIActions.lua");

Dog_x = {
  ActionController = "Animations/Mannequin/ADB/kcd_dog_controllerdefs.xml",
  AnimDatabase3P = "Animations/Mannequin/ADB/kcd_dog_database.adb",

  UseMannequinAGState = true,

  defaultSoulArchetype = "Dog",
  defaultSoulClass = "dog",
  OpponentMnTag = "relatedDog",
  CombatOpponentMnTag = "oppDog",

  Properties = {
    esNavigationType = "MediumSizedCharacters",
    sWH_AI_EntityCategory = "",
    bWH_Lootable = 1,
    bWH_PerceptorObject = 1,
    bWH_PerceptibleObject = 1,
    bWH_ListenerObject = 1,
    NPC = {
      eiNPCCategory = 1,
      aianchorHome = "",
    },
    fileModel = "Objects/Characters/animals/Dog/dog.cdf",
    fileHitDeathReactionsParamsDataFile = "Libs/HitDeathReactionsData/HitDeathReactions_Dog.xml",
    esClothingConfig = "dog",
    bNotPlayerMountable = 0,

    CharacterSounds =
    {
      footstepEffect = "footsteps_Dog",
      remoteFootstepEffect = "footsteps_Dog",
      bFootstepGearEffect = 1,
      footstepIndGearAudioSignal_Walk = "",
      footstepIndGearAudioSignal_Run = "",
      foleyEffect = "foley_Dog",
    },

    Script =
    {
      esDefaultBehavior = "none",
    },
  },

  physicsParams =
  {
    mass = 25,

    Living =
    {
      mass = 25,
      gravity = 30,
    },
  },

  collisionCapsule =
  {
    radius = 0.2,
    height = 0.4,
    pos    = { x = 0, y = 0, z = 0.45 },
    axis   = { x = 0, y = 1, z = 0 },
  },

  gameParams =
  {
    boneIDs =
    {
    },


    stance =
    {
      combat = {
        stanceId = E_ACTORSTANCE_COMBAT,
        heightCollider = 0.4,
        heightPivot = 0.0,
        size = { x = 0.1, y = 0.0, z = 0.01 },
        viewOffset = { x = 0, y = 0.10, z = 0.5 },
        name = "combat",
        useCapsule = 0,
      },
      normal = {
        stanceId = E_ACTORSTANCE_NORMAL,
        heightCollider = 0.4,
        heightPivot = 0.0,
        size = { x = 0.1, y = 0.0, z = 0.01 },
        viewOffset = { x = 0, y = 0.10, z = 0.5 },
        name = "normal",
        useCapsule = 0,
      },
      crouch = {
        stanceId = E_ACTORSTANCE_CROUCH,
        heightCollider = 0.4,
        heightPivot = 0.0,
        size = { x = 0.1, y = 0.0, z = 0.01 },
        viewOffset = { x = 0, y = 0.10, z = 0.5 },
        name = "crouch",
        useCapsule = 0,
      },
      carryCorpse = {
        stanceId = E_ACTORSTANCE_CARRYCORPSE,
        heightCollider = 0.4,
        heightPivot = 0.0,
        size = { x = 0.1, y = 0.0, z = 0.01 },
        viewOffset = { x = 0, y = 0.10, z = 0.5 },
        name = "carryCorpse",
        useCapsule = 1,
      },
    },

    inertia = 0.0,
    inertiaAccel = 0.0,

    backwardMultiplier = 0.5,

    jumpHeight = 1.0,

    lookFOV = 180,

    animatedCharacterTurnSpeedSmoothingTime = 0.2,
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

    dashPossibleCheckDistance = 12.0,
    dashPossibleCheckRequiredSpeedParam = 0.75,

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
function Dog_x:OnSave(table)
  table.bSearched = self.bSearched;
end

function Dog_x:OnLoad(table)
  self.bSearched = table.bSearched;
end

function Dog_x:bIsInventoryEmpty()
  if (self.inventory:GetCount() ~= 0) then
    return 0;
  else
    -- inv is empty --
    return 1;
  end
end

-- JCDLootInfo -------------------------

function Dog_x:SetFree(rescuer)
  AI.Signal(SIGNALFILTER_SENDER, 0, "GET_UNTIED", self.id);
end

function Dog_x:OnResetCustom()
  self.isFree = true;
  self.lootable = self.Properties.bWH_Lootable ~= 0;
  self:ResetOnUsed();
  self:SetColliderMode(4);
  -- JCDLootInfo -------------------------
  self.bSearched = 0;
  -- JCDLootInfo -------------------------
end

function Dog_x:GetUsableMessage()
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

function Dog_x:OnUsed(user)
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

function Dog_x:OnTalk(user, slotId)
  Log("OnTalk: %s->%s", EntityName(user), EntityName(self));
  self.actor:RequestDialog(user.id, '', false, true, true);
end

function Dog_x:GetActions(user, firstFast)
  if (user == nil) then
    return {};
  end

  output = {};

  if not self.actor:CanInteractWith(user.id) then
    return {};
  end

  local useAction = "use";

  if user.human:IsPickpocketing() == true then
    return {};
  end
  if self.actor:IsUnconscious() == false then
    if self.actor:GetHealth() > 0 then
      if (self.actor:CanTalk(user.id)) then
        local hintEnabledVal = self:GetCanTalkHintType();

        if AddInteractorAction(output, firstFast, Action():hint("@ui_hud_talk"):action("use"):hintClass(AHC_DOG):func(Dog_x.OnTalk):interaction(inr_talk):enabled(hintEnabledVal)) then
          return output;
        end
      end
    else
      if (self:AddLootAction(output, user, firstFast) == true) then
        return output;
      end
    end
  end

  return output;
end

function Dog_x:GetCanTalkHintType()
  local hintTypeVal = true;
  local bDialogRestricted = self.soul:IsDialogRestricted(player.id);
  local bIsInterruptibleByPlayer = DialogModule.IsDialogInterruptibleByPlayer(self.soul:GetId());
  local bIsInCombatDanger = player.soul:IsInCombatDanger();
  if (bDialogRestricted == true or bIsInterruptibleByPlayer == false or bIsInCombatDanger == true) then
    hintTypeVal = false;
  end

  return hintTypeVal;
end

function Dog_x:IsUsable(user)
  if (not user) then
    return 0;
  end

  if (self.actor:GetHealth() <= 0) then
    return 1;
  end

  return 0;
end

Script.ReloadScript("SCRIPTS/Entities/AI/Shared/AIBase.lua");
mergef(Dog_x, AIBase, 1)
mergef(Dog_x, BasicAIActions, 1)
