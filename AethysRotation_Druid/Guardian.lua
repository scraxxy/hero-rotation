--- ============================ HEADER ============================
--- ======= LOCALIZE =======
  -- Addon
  local addonName, addonTable = ...;
  -- AethysCore
  local AC = AethysCore;
  local Cache = AethysCache;
  local Unit = AC.Unit;
  local Player = Unit.Player;
  local Target = Unit.Target;
  local Spell = AC.Spell;
  local Item = AC.Item;
  -- AethysRotation
  local AR = AethysRotation;
  -- Lua
  


--- ============================ CONTENT ============================
--- ======= APL LOCALS =======
  local Everyone = AR.Commons.Everyone;
  local Druid = AR.Commons.Druid;
  -- Spells
  if not Spell.Druid then Spell.Druid = {}; end
  Spell.Druid.Guardian = {
    -- Racials
    
    -- Abilities
    FrenziedRegeneration = Spell(22842),
    GoreBuff             = Spell(93622),
    GoryFur              = Spell(201671),
    Ironfur              = Spell(192081),
    Mangle               = Spell(33917),
    Maul                 = Spell(6807),
    Moonfire             = Spell(8921),
    MoonfireDebuff       = Spell(164812),
    Regrowth             = Spell(8936),
    SwipeBear            = Spell(213771),
    SwipeCat             = Spell(106785),
    ThrashBear           = Spell(77758),
    ThrashBearDebuff     = Spell(192090),
    ThrashCat            = Spell(106830),
    -- Talents
    BalanceAffinity      = Spell(197488),
    BloodFrenzy          = Spell(203962),
    Brambles             = Spell(203953),
    BristlingFur         = Spell(155835),
    Earthwarden          = Spell(203974),
    EarthwardenBuff      = Spell(203975),
    FeralAffinity        = Spell(202155),
    GalacticGuardian     = Spell(203964),
    GalacticGuardianBuff = Spell(213708),
    GuardianofElune      = Spell(155578),
    GuardianofEluneBuff  = Spell(213680),
    Incarnation          = Spell(102558),
    LunarBeam            = Spell(204066),
    Pulverize            = Spell(80313),
    PulverizeBuff        = Spell(158792),
    RestorationAffinity  = Spell(197492),
    SouloftheForest      = Spell(158477),
    -- Artifact
    RageoftheSleeper     = Spell(200851),
    -- Defensive
    SurvivalInstincts    = Spell(61336),
    Barkskin             = Spell(22812),
    -- Utility
    Growl                = Spell(6795),
    SkullBash            = Spell(106839),
    -- Affinity
    FerociousBite        = Spell(22568),
    HealingTouch         = Spell(5185),
    LunarStrike          = Spell(197628),
    Rake                 = Spell(1822),
    RakeDebuff           = Spell(155722),
    Rejuvenation         = Spell(774),
    Rip                  = Spell(1079),
    Shred                = Spell(5221),
    SolarWrath           = Spell(197629),
    Starsurge            = Spell(197626),
    Sunfire              = Spell(197630),
    SunfireDebuff        = Spell(164815),
    Swiftmend            = Spell(18562),
    -- Shapeshift
    BearForm             = Spell(5487),
    CatForm              = Spell(768),
    MoonkinForm          = Spell(197625),
    TravelForm           = Spell(783),
    -- Legendaries
    
    -- Misc
    
    -- Macros
    
  };
  local S = Spell.Druid.Guardian;
  -- Items
  if not Item.Druid then Item.Druid = {}; end
  Item.Druid.Guardian = {
    -- Legendaries
    
  };
  local I = Item.Druid.Guardian;
  -- Rotation Var
  
  -- GUI Settings
  local Settings = {
    General = AR.GUISettings.General,
    Commons = AR.GUISettings.APL.Druid.Commons,
    Guardian = AR.GUISettings.APL.Druid.Guardian
  };


--- ======= ACTION LISTS =======
  


--- ======= MAIN =======
  local function APL ()
    -- Unit Update
    AC.GetEnemies(8); -- Thrash & Swipe (TODO: Balance Affinity, see Outlaw)
    Everyone.AoEToggleEnemiesUpdate();
    -- Defensives
    
    -- Out of Combat
    if not Player:AffectingCombat() then
      -- Flask
      -- Food
      -- Rune
      -- PrePot w/ Bossmod Countdown
      -- Opener
      if Everyone.TargetIsValid() then
        if S.Mangle:IsCastable(5) then
          if AR.Cast(S.Mangle) then return ""; end
        end
        if S.ThrashBear:IsCastable(8) then
          if AR.Cast(S.ThrashBear) then return ""; end
        end
        if S.SwipeBear:IsCastable(8) then
          if AR.Cast(S.SwipeBear) then return ""; end
        end
      end
      return;
    end
    -- In Combat
    if Everyone.TargetIsValid() then
      -- # Executed every time the actor is available.
      -- actions=auto_attack
      -- actions+=/blood_fury
      -- actions+=/berserking
      -- actions+=/arcane_torrent
      -- actions+=/use_item,slot=trinket2
      -- actions+=/incarnation
      -- actions+=/rage_of_the_sleeper
      -- actions+=/lunar_beam
      -- actions+=/frenzied_regeneration,if=incoming_damage_5s%health.max>=0.5|health<=health.max*0.4
      if S.FrenziedRegeneration:IsCastable() and Player:Rage() > 10 and Player:HealthPercentage() <= 60 and not Player:Buff(S.FrenziedRegeneration) then
        if AR.Cast(S.FrenziedRegeneration, {true, false}) then return ""; end
      end
      -- actions+=/bristling_fur,if=buff.ironfur.stack=1|buff.ironfur.down
      -- actions+=/ironfur,if=(buff.ironfur.up=0)|(buff.gory_fur.up=1)|(rage>=80)
      if S.Ironfur:IsCastable() and Player:Rage() >= S.Ironfur:Cost() and (not Player:Buff(S.Ironfur) or Player:Buff(S.GoryFur) or Player:Rage() >= 80) then
        if AR.Cast(S.Ironfur, {true, false}) then return ""; end
      end
      -- actions+=/moonfire,if=buff.incarnation.up=1&dot.moonfire.remains<=4.8
      if S.Moonfire:IsCastable(40) and Player:Buff(S.Incarnation) and Target:DebuffRefreshableP(S.MoonfireDebuff, 4.8) then
        if AR.Cast(S.Moonfire) then return ""; end
      end
      -- actions+=/thrash_bear,if=buff.incarnation.up=1&dot.thrash.remains<=4.5
      if S.ThrashBear:IsCastable(8) and Player:Buff(S.Incarnation) and Target:DebuffRefreshableP(S.ThrashBearDebuff, 4.5) then
        if AR.Cast(S.ThrashBear) then return ""; end
      end
      -- actions+=/mangle
      if S.Mangle:IsCastable(5) then
        if AR.Cast(S.Mangle) then return ""; end
      end
      -- actions+=/thrash_bear
      if S.ThrashBear:IsCastable(8) then
        if AR.Cast(S.ThrashBear) then return ""; end
      end
      -- actions+=/pulverize,if=buff.pulverize.up=0|buff.pulverize.remains<=6
      -- actions+=/moonfire,if=buff.galactic_guardian.up=1&(!ticking|dot.moonfire.remains<=4.8)
      -- actions+=/moonfire,if=buff.galactic_guardian.up=1
      -- actions+=/moonfire,if=dot.moonfire.remains<=4.8
      if S.Moonfire:IsCastable(40) and (Player:Buff(S.GalacticGuardianBuff) or Target:DebuffRefreshableP(S.MoonfireDebuff, 4.8)) then
        if AR.Cast(S.Moonfire) then return ""; end
      end
      -- actions+=/swipe_bear
      if S.SwipeBear:IsCastable(8) then
        if AR.Cast(S.SwipeBear) then return ""; end
      end
      return;
    end
  end

  AR.SetAPL(104, APL);


--- ======= SIMC =======
--- Last Update: 09/24/2017

-- # Executed every time the actor is available.
-- actions=auto_attack
-- actions+=/blood_fury
-- actions+=/berserking
-- actions+=/arcane_torrent
-- actions+=/use_item,slot=trinket2
-- actions+=/incarnation
-- actions+=/rage_of_the_sleeper
-- actions+=/lunar_beam
-- actions+=/frenzied_regeneration,if=incoming_damage_5s%health.max>=0.5|health<=health.max*0.4
-- actions+=/bristling_fur,if=buff.ironfur.stack=1|buff.ironfur.down
-- actions+=/ironfur,if=(buff.ironfur.up=0)|(buff.gory_fur.up=1)|(rage>=80)
-- actions+=/moonfire,if=buff.incarnation.up=1&dot.moonfire.remains<=4.8
-- actions+=/thrash_bear,if=buff.incarnation.up=1&dot.thrash.remains<=4.5
-- actions+=/mangle
-- actions+=/thrash_bear
-- actions+=/pulverize,if=buff.pulverize.up=0|buff.pulverize.remains<=6
-- actions+=/moonfire,if=buff.galactic_guardian.up=1&(!ticking|dot.moonfire.remains<=4.8)
-- actions+=/moonfire,if=buff.galactic_guardian.up=1
-- actions+=/moonfire,if=dot.moonfire.remains<=4.8
-- actions+=/swipe_bear