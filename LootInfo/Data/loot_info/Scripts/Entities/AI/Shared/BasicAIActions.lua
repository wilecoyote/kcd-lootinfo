BasicAIActions = {}

function BasicAIActions:GetNpcName()
  return self.soul:GetNameStringId();
end

function BasicAIActions:GetHintsTitle()
  -- JCDLootInfo -------------------------
  -- Alive and unconscious
  if self.actor:GetHealth() > 0 and self.actor:IsUnconscious() == true then
    return "@" .. self:GetNpcName() .. " @ui_body_unconscious";
  elseif self.actor:GetHealth() <= 0 then
    return "@" .. self:GetNpcName() .. " @ui_body_dead";
  else
    return "@" .. self:GetNpcName();
  end
  -- JCDLootInfo -------------------------
end

function BasicAIActions:ForceUsable(user)
  if (not user) then
    return false;
  end

  if not self.actor:CanInteractWith(user.id) then
    return false;
  end

  return true;
end

-- JCDLootInfo -------------------------
function BasicAIActions:bIsInventoryEmpty()
  if (self.inventory:GetCount() ~= 0) then
    return 0;
  else
    -- inv is empty --
    return 1;
  end
end

-- JCDLootInfo -------------------------

-- when firstFast is true method returns only first action
function BasicAIActions:GetActions(user, firstFast)
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
  if self.actor:GetHealth() > 0 and self.actor:IsUnconscious() == false then
    local canKill = user.actor:CanStealthKill(self.id);
    if (canKill == SAT_KillEnabled or canKill == SAT_KillDisabled) then
      if AddInteractorAction(output, firstFast,
            Action():hint("@ui_hud_stealth_kill"):action("attack3"):hintType(AHT_HOLD):func(BasicAIActions.OnStealthKill):interaction(inr_stealthKill):enabled(canKill == SAT_KillEnabled)) then
        return output;
      end
    end

    local canKnockout = user.actor:CanStealthKnockout(self.id);
    if (canKnockout == SAT_KnockoutEnabled or canKnockout == SAT_KnockoutDisabled) then
      if AddInteractorAction(output, firstFast, Action():hint("@ui_hud_knock_out"):action("attack3"):func(BasicAIActions.OnKnockout):interaction(inr_knockOut):enabled(canKnockout == SAT_KnockoutEnabled)) then
        return output;
      end
    end

    local canPullDown = user.actor:CanHorsePullDown(self.id);
    if (canPullDown == HPS_Enabled or canPullDown == HPS_Disabled) then
      if AddInteractorAction(output, firstFast, Action():hint("@ui_hud_horse_pulldown"):action("attack3"):func(BasicAIActions.OnHorsePullDown):interaction(inr_pullDown):enabled(canPullDown == HPS_Enabled)) then
        return output;
      end
    end

    local canHuntAttack = user.actor:CanHuntAttack(self.id);
    if (canHuntAttack == HAS_Enabled or canHuntAttack == HAS_Disabled) then
      if AddInteractorAction(output, firstFast, Action():hint("@ui_hud_hunt_attack"):action("attack3"):func(BasicAIActions.OnHuntAttack):interaction(inr_huntAttack):enabled(canHuntAttack == HAS_Enabled)) then
        return output;
      end

      if QuestSystem.IsObjectiveCompleted('q_tutorials', 'huntAttack') == false then
        XGenAIModule.SendMessageToEntity(player.this.id, 'tutorial:huntAttack', "isAvailable(true)");
      end
    end

    if (self.actor:CanTalk(user.id)) then
      local hintEnabledVal = self:GetCanTalkHintType();

      if AddInteractorAction(output, firstFast, Action():hint("@ui_hud_talk"):action("use"):func(BasicAIActions.OnTalk):interaction(inr_talk):enabled(hintEnabledVal)) then
        return output;
      end
    end

    if ((not user.soul:IsInCombatDanger()) and user.soul:HaveSkill('pickpocketing') and self.human:CanBeRobbed() and not (user.player:IsSitting() or user.player:IsLaying()) and not isFemale(user)) then
      if AddInteractorAction(output, firstFast,
            Action():hint("@ui_hud_basic_steal"):action("use"):hintType(AHT_HOLD):func(BasicAIActions.OnPickpocketing):interaction(inr_steal)) then
        return output;
      end
    end
  else
    if (user.actor:CanGrabCorpse(self.id) and GetEntityScriptProperty(self, "disableGrabBody") == nil and not isFemale(user)) then
      if AddInteractorAction(output, firstFast, Action():hint("@ui_hud_grab"):action("attack3"):func(BasicAIActions.OnGrabCorpse):interaction(inr_pickupCorpse)) then
        return output;
      end
    end

    local canMercyKill = user.actor:CanDoMercyKill(self.id);
    if (canMercyKill == MKS_Enabled or canMercyKill == MKS_Disabled) then
      local hint = "@ui_hud_mercy_kill";
      if (self.actor:IsUnconscious() == true) then
        hint = "@ui_hud_mercy_kill_unconscious";
      end
      if AddInteractorAction(output, firstFast, Action():hint(hint):action("attack3"):hintType(AHT_HOLD):func(BasicAIActions.OnMercyKill):interaction(inr_mercyKill):enabled(canMercyKill == MKS_Enabled)) then
        return output;
      end
    end

    if (self:AddLootAction(output, user, firstFast) == true) then
      return output;
    end
  end

  return output;
end

function BasicAIActions:AddLootAction(output, user, firstFast)
  if self.lootable and user.actor:CanLoot(self.id) then
    local hType;
    if self.soul:IsPublicEnemy() then
      hType = AHT_PRESS
    else
      hType = AHT_HOLD
    end

    local reason
    if self.actor:GetHealth() > 0 then
      reason = "@ui_body_unconscious"
    else
      reason = "@ui_body_dead"
    end

    -- JCDLootInfo -------------------------
    local isEmpty
    if (self.bSearched == 1) then
      isEmpty = self:bIsInventoryEmpty(user);
      if (isEmpty == 1) then
        -- inv is empty --
        if AddInteractorAction(output, firstFast, Action():hint("@ui_hud_loot_empty"):action("use"):hintType(hType):func(BasicAIActions.OnLoot):interaction(inr_loot)) then
          return true;
        end
      else
        if AddInteractorAction(output, firstFast, Action():hint("@ui_hud_loot_searched"):action("use"):hintType(hType):func(BasicAIActions.OnLoot):interaction(inr_loot)) then
          return true;
        end
      end
    else
      if AddInteractorAction(output, firstFast, Action():hint("@ui_hud_loot"):action("use"):hintType(hType):func(BasicAIActions.OnLoot):interaction(inr_loot)) then
        return true;
      end
    end
    -- JCDLootInfo -------------------------				
  end

  return false;
end

function BasicAIActions:GetCanTalkHintType()
  local hintTypeVal = true;
  local bDialogRestricted = self.soul:IsDialogRestricted(player.id);
  local bIsInterruptibleByPlayer = DialogModule.IsDialogInterruptibleByPlayer(self.soul:GetId());
  local bIsInCombatDanger = player.soul:IsInCombatDanger();
  if (bDialogRestricted == true or bIsInterruptibleByPlayer == false or bIsInCombatDanger == true) then
    hintTypeVal = false;
  end

  return hintTypeVal;
end

function BasicAIActions:OnTalk(user, slotId)
  Log("OnTalk: %s->%s", EntityName(user), EntityName(self));
  self.human:RequestDialog(user.id, '', false, true, true);
end

function BasicAIActions:OnStealthKill(user, slotId)
  Log("OnStealthKill: %s->%s", EntityName(user), EntityName(self));
  user.actor:RequestStealthKill(self.id);
end

function BasicAIActions:OnKnockout(user, slotId)
  Log("OnKnockout: %s->%s", EntityName(user), EntityName(self));
  user.actor:RequestKnockOut(self.id);
end

function BasicAIActions:OnHorsePullDown(user, slotId)
  Log("OnHorsePullDown: %s->%s", EntityName(user), EntityName(self));
  user.actor:RequestHorsePullDown(self.id);
end

function BasicAIActions:OnHuntAttack(user, slotId)
  Log("OnHuntAttack: %s->%s", EntityName(user), EntityName(self));
  user.actor:RequestHuntAttack(self.id);
end

function BasicAIActions:OnMercyKill(user, slotId)
  Log("OnMercyKill: %s->%s", EntityName(user), EntityName(self));
  user.actor:RequestMercyKill(self.id);
end

function BasicAIActions:OnLoot(user, slotId)
  Log("OnLoot: %s->%s", EntityName(user), EntityName(self));
  XGenAIModule.LootBegin(self.soul:GetId());
  self.actor:RequestItemExchange(user.id);
  -- JCDLootInfo ---------------------
  self.bSearched = 1;
  -- JCDLootInfo ---------------------
end

function BasicAIActions:OnGrabCorpse(user, slotId)
  Log("OnGrabCorpse: %s->%s", EntityName(user), EntityName(self));
  user.actor:RequestGrabCorpse(self.id);
end

function BasicAIActions:OnPickpocketing(user, slotId)
  Log("OnPickpocketing: %s->%s", EntityName(user), EntityName(self));
  user.human:RequestPickpocketing(self.id, 0);
end
