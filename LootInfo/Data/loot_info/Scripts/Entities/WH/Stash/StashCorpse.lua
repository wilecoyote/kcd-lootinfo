Script.ReloadScript("SCRIPTS/Entities/WH/Stash/AnimStash.lua");

StashCorpse =
{
  Properties =
  {
    object_Model                  = "objects/default/primitive_cylinder_nodraw.cgf",

    Lock                          =
    {
      bLocked = 0,
      bCanLockPick = 1,
      fLockDifficulty = 1,
      bSendMessage = 0,
      guidItemClassId = "",
      bLockpickIsLegal = 0,
    },

    Physics                       = {
      bPhysicalize       = 1,
      bRigidBody         = 1,
      bPushableByPlayers = 0,
      Density            = -1,
      Mass               = -1,
    },

    Phase                         = {
      bChangeAfterPlayerInteract = 0,
      object_ModelAfterInteract = "",
    },

    Animation                     =
    {
      anim_Open = "",
      anim_Close = "",
      bOpenOnly = 0,
    },

    fUseDistance                  = 2.5,
    bSkipAngleCheck               = 1,
    fUseAngle                     = 0.7,
    fUseZOffset                   = 0,

    Database                      = {
      guidInventoryDBId = "0",
      iMinimalShopItemPrice = 0,
    },

    Script                        = {
      bTutorial = 0,
      bLootIsLegal = 0,
      Misc = '',
    },

    bInteractableThroughCollision = 0,
  },
  -- JCDLootInfo -------------------------
  bSearched  = 0,
  -- JCDLootInfo -------------------------
};


-- JCDLootInfo -------------------------
function StashCorpse:bIsInventoryEmpty()
  if (self.inventory:GetCount() ~= 0) then
    return 0;
  else
    -- inv is empty --
    return 1;
  end
end

-- JCDLootInfo -------------------------

function StashCorpse:GetActions(user, firstFast)
  if (user == nil) then
    return {};
  end

  local isUsable = self:IsUsable(user);
  if (firstFast and isUsable == 0) then
    return {};
  end

  output = {};

  local shopWUID = Shops.IsLinkedWithShop(self.id);

  if (self.bOpened == 1) then
    if AddInteractorAction(output, firstFast, Action():hint("@ui_hud_loot"):action("use"):func(Stash.OnUsed):interaction(inr_stashClose)) then
      return output;
    end
  else
    -- JCDLootInfo -------------------------
    local isEmpty
    if (self.bSearched == 1) then
      isEmpty = self:bIsInventoryEmpty();
      if (isEmpty == 1) then
        -- inv is empty --
        if AddInteractorAction(output, firstFast, Action():hint("@ui_hud_loot_empty"):action("use"):func(Stash.OnUsed):interaction(inr_stashOpen)) then
          return output;
        end
      else
        if AddInteractorAction(output, firstFast, Action():hint("@ui_hud_loot_searched"):action("use"):func(Stash.OnUsed):interaction(inr_stashOpen)) then
          return output;
        end
      end
    else
      if AddInteractorAction(output, firstFast, Action():hint("@ui_hud_loot"):action("use"):func(Stash.OnUsed):interaction(inr_stashOpen)) then
        return output;
      end
    end
    -- JCDLootInfo -------------------------
  end
  if ((self.nUserId == 0) and (self.Properties.Lock.bCanLockPick == 1) and ((self.bLocked == true) or ((self.bLocked == 1) or (Framework.IsValidWUID(Shops.IsLinkedWithShop(self.id)))))) then
    AddInteractorAction(output, firstFast,
      Action():hint("@ui_hud_lockpick"):action("use"):hintType(AHT_HOLD):func(Stash.OnUsedHold):interaction(
      inr_stashLockpick))
  end

  return output;
end

MakeDerivedEntityOverride(StashCorpse, Stash);
