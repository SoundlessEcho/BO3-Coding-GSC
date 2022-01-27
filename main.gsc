/*
*    Infinity Loader :: The Best GSC IDE!
*
*    Project : Test Menu
*    Author : Echo
*    Game : Call of Duty: Black Ops 3
*    Description : Starts Zombies code execution!
*    Date : 12/11/2021 9:53:26 AM
*
*/
//https://cabconmodding.com/threads/bo3-zombie-teleport-locations.5788/
//https://cabconmodding.com/threads/black-ops-2-gsc-managed-code-list.158/





#include scripts\codescripts\struct;
#include scripts\shared\callbacks_shared;
#include scripts\shared\clientfield_shared;
#include scripts\shared\math_shared;
#include scripts\shared\system_shared;
#include scripts\shared\util_shared;
#include scripts\shared\hud_util_shared;
#include scripts\shared\hud_message_shared;
#include scripts\shared\hud_shared;
#include scripts\shared\array_shared;
#include scripts\shared\aat_shared;
#include scripts\shared\rank_shared;
#include scripts\shared\ai\zombie_utility;
#include scripts\shared\ai\systems\gib;
#include scripts\shared\tweakables_shared;
#include scripts\shared\ai\systems\shared;
#include scripts\shared\ai\systems\blackboard;
#include scripts\shared\ai\systems\ai_interface;
#include scripts\shared\flag_shared;
#include scripts\shared\scoreevents_shared;
#include scripts\shared\lui_shared;
#include scripts\shared\scene_shared;
#include scripts\shared\vehicle_ai_shared;
#include scripts\shared\vehicle_shared;
#include scripts\shared\exploder_shared;
#include scripts\shared\ai_shared;
#include scripts\shared\doors_shared;
#include scripts\shared\gameskill_shared;
#include scripts\shared\laststand_shared;
#include scripts\shared\spawner_shared;
#include scripts\shared\visionset_mgr_shared;

#include scripts\zm\gametypes\_hud_message;
#include scripts\zm\gametypes\_globallogic;
#include scripts\zm\gametypes\_globallogic_audio;
#include scripts\zm\gametypes\_globallogic_score;
#include scripts\zm\_zm_lightning_chain;
#include scripts\zm\_util;
#include scripts\zm\_zm_zonemgr;
#include scripts\zm\_zm;
#include scripts\zm\_zm_bgb;
#include scripts\zm\_zm_score;
#include scripts\zm\_zm_stats;
#include scripts\zm\_zm_weapons;
#include scripts\zm\_zm_perks;
#include scripts\zm\_zm_equipment;
#include scripts\zm\_zm_utility;
#include scripts\zm\_zm_blockers;
#include scripts\zm\craftables\_zm_craftables;
#include scripts\zm\_zm_powerups;
#include scripts\zm\_zm_audio;
#include scripts\zm\_zm_spawner;
#include scripts\zm\_zm_playerhealth;
#include scripts\zm\_zm_magicbox;
#include scripts\zm\_zm_unitrigger;
#include scripts\zm\_zm_traps;
#include scripts\zm\_zm_laststand;
#include scripts\zm\bgbs\_zm_bgb_reign_drops;
#include scripts\zm\_zm_bgb_machine;
#include scripts\zm\_zm_bgb_token;
#include scripts\zm\_zm_powerup_fire_sale;
#include scripts\zm\aats\_zm_aat_fire_works;
#include scripts\zm\bgbs\_zm_bgb_round_robbin;
#include scripts\shared\damagefeedback_shared;
#include scripts\shared\ai\systems\destructible_character;
#include scripts\shared\audio_shared;
#include scripts\shared\gameobjects_shared;

#namespace infinityloader;
//required
autoexec __init__system__()
{
    system::register("infinityloader", ::__init__, undefined, undefined);
}

autoexec repair()
{
    callback::on_connect(::FixBrokenStats);
}

__init__()
{
    callback::on_start_gametype(::init);
    callback::on_connect(::onPlayerConnect);
    callback::on_spawned(::onPlayerSpawned);
}
//required
init()
{
    level.clientid                            = 0;
    level.strings                             = [];
    level.result                              = 1;
    level.firstHostSpawned                    = false;
    level._Achievements                       = ["CP_COMPLETE_PROLOGUE", "CP_COMPLETE_NEWWORLD", "CP_COMPLETE_BLACKSTATION", "CP_COMPLETE_BIODOMES", "CP_COMPLETE_SGEN", "CP_COMPLETE_VENGEANCE", "CP_COMPLETE_RAMSES", "CP_COMPLETE_INFECTION", "CP_COMPLETE_AQUIFER", "CP_COMPLETE_LOTUS", "CP_HARD_COMPLETE", "CP_REALISTIC_COMPLETE","CP_CAMPAIGN_COMPLETE", "CP_FIREFLIES_KILL", "CP_UNSTOPPABLE_KILL", "CP_FLYING_WASP_KILL", "CP_TIMED_KILL", "CP_ALL_COLLECTIBLES", "CP_DIFFERENT_GUN_KILL", "CP_ALL_DECORATIONS", "CP_ALL_WEAPON_CAMOS", "CP_CONTROL_QUAD", "CP_MISSION_COLLECTIBLES",  "CP_DISTANCE_KILL", "CP_OBSTRUCTED_KILL", "CP_MELEE_COMBO_KILL", "CP_COMPLETE_WALL_RUN", "CP_TRAINING_GOLD", "CP_COMBAT_ROBOT_KILL", "CP_KILL_WASPS", "CP_CYBERCORE_UPGRADE", "CP_ALL_WEAPON_ATTACHMENTS", "CP_TIMED_STUNNED_KILL", "CP_UNLOCK_DOA", "ZM_COMPLETE_RITUALS", "ZM_SPOT_SHADOWMAN", "ZM_GOBBLE_GUM", "ZM_STORE_KILL", "ZM_ROCKET_SHIELD_KILL", "ZM_CIVIL_PROTECTOR", "ZM_WINE_GRENADE_KILL", "ZM_MARGWA_KILL", "ZM_PARASITE_KILL", "MP_REACH_SERGEANT", "MP_REACH_ARENA", "MP_SPECIALIST_MEDALS", "MP_MULTI_KILL_MEDALS", "ZM_CASTLE_EE", "ZM_CASTLE_ALL_BOWS", "ZM_CASTLE_MINIGUN_MURDER", "ZM_CASTLE_UPGRADED_BOW", "ZM_CASTLE_MECH_TRAPPER", "ZM_CASTLE_SPIKE_REVIVE", "ZM_CASTLE_WALL_RUNNER", "ZM_CASTLE_ELECTROCUTIONER", "ZM_CASTLE_WUNDER_TOURIST", "ZM_CASTLE_WUNDER_SNIPER", "ZM_ISLAND_COMPLETE_EE", "ZM_ISLAND_DRINK_WINE", "ZM_ISLAND_CLONE_REVIVE", "ZM_ISLAND_OBTAIN_SKULL", "ZM_ISLAND_WONDER_KILL", "ZM_ISLAND_STAY_UNDERWATER", "ZM_ISLAND_THRASHER_RESCUE", "ZM_ISLAND_ELECTRIC_SHIELD", "ZM_ISLAND_DESTROY_WEBS", "ZM_ISLAND_EAT_FRUIT", "ZM_STALINGRAD_NIKOLAI", "ZM_STALINGRAD_WIELD_DRAGON", "ZM_STALINGRAD_TWENTY_ROUNDS", "ZM_STALINGRAD_RIDE_DRAGON", "ZM_STALINGRAD_LOCKDOWN", "ZM_STALINGRAD_SOLO_TRIALS", "ZM_STALINGRAD_BEAM_KILL", "ZM_STALINGRAD_STRIKE_DRAGON", "ZM_STALINGRAD_FAFNIR_KILL", "ZM_STALINGRAD_AIR_ZOMBIES", "ZM_GENESIS_EE", "ZM_GENESIS_SUPER_EE", "ZM_GENESIS_PACKECTOMY", "ZM_GENESIS_KEEPER_ASSIST", "ZM_GENESIS_DEATH_RAY", "ZM_GENESIS_GRAND_TOUR", "ZM_GENESIS_WARDROBE_CHANGE", "ZM_GENESIS_WONDERFUL", "ZM_GENESIS_CONTROLLED_CHAOS", "DLC2_ZOMBIE_ALL_TRAPS", "DLC2_ZOM_LUNARLANDERS", "DLC2_ZOM_FIREMONKEY", "DLC4_ZOM_TEMPLE_SIDEQUEST", "DLC4_ZOM_SMALL_CONSOLATION", "DLC5_ZOM_CRYOGENIC_PARTY", "DLC5_ZOM_GROUND_CONTROL", "ZM_DLC4_TOMB_SIDEQUEST", "ZM_DLC4_OVERACHIEVER", "ZM_PROTOTYPE_I_SAID_WERE_CLOSED", "ZM_ASYLUM_ACTED_ALONE", "ZM_THEATER_IVE_SEEN_SOME_THINGS"];
    level.player_out_of_playable_area_monitor = undefined;
    level._Weapons                            = getArrayKeys(level.zombie_weapons);
    level.WeaponCategories                    = ["Assault Rifles", "Submachine Guns", "Shotguns", "Light Machine Guns", "Sniper Rifles", "Launcher", "Pistols", "Specials"];
    level thread CacheWeapons();
    level._WeaponAAT = getArrayKeys(level.AAT);
    level thread CacheCamos();
    level._Perks      = getArrayKeys(level._custom_perks);
    level._PowerUps   = getArrayKeys(level.zombie_powerups);
    level.saveGravity = GetDvarInt("bg_gravity");
    level._GobbleGums = getArrayKeys(level.bgb);
    level thread CacheGobbleGums();
    level.overridePlayerDamage = ::_override_on_player_damage;
    level.callbackActorDamage  = ::_actor_damage_override_wrapper;
    //level.w_min_last_stand_pistol_override = getweapon("ray_gun");
    level.solo_game_free_player_quickrevive = 1;
    
    
    //level.unlockingLobby = false;
    //level thread Cachemusic_tracks();
    //level.music_tracks = [];
    //level.music_names = [];
    /*
    for(e=0;e<98;e++)
    {
        track_id = tableLookup( "gamedata/tables/common/music_player.csv", 0, e, 1 );
        track_name = TableLookup( "gamedata/tables/common/music_player.csv", 0, e, 2 );
        level.music_tracks[e] = track_id;
        level.music_names[e] = track_name;
    }
    */
    level thread onPlayerConnect(); 
}
onPlayerConnect()
{
    for(;;)
    {
        level waittill("connecting", player);
        player.MenuInit = false;
        if(player isHost() || getPlayerName(player) == "SoundlessEcho" || getPlayerName(player) == "Nino1")
            player.status = "Host";
        else
            player.status = "Unverified";
        if(player isVerified())
            player giveMenu();
        player thread onPlayerSpawned();
    }
}
onPlayerSpawned() //This will get called on every spawn! :) /CabCon
{
    self endon("disconnect");
    level endon("game_ended");
    isFirstSpawn = false;
    for(;;)
    {
        self waittill("spawned_player");
        if(!level.firstHostSpawned && self.status == "Host")
        {
            //thread overflowfix();
            level.firstHostSpawned = true;
            self thread ForceHost();
            self thread WelcomeNotifcation();
            self thread CatalystAntiDown();
            self thread CatalystAntiDeath();
            self thread _openMenu();
            wait 0.50;
            self thread _closeMenu();
        }
      
        self resetBooleans();
        if(self isVerified())
        {
            if(self.menu.open)
                self freezeControlsallowlook(true);
        }
        if(!isFirstSpawn)
        {
            if(self isHost())
                self freezecontrols(false);
                //self thread WelcomeNotifcation();
                //self thread DrawTextInfo();

            isFirstSpawn = true;
        }
    }
}
ForceHost()
{
    if(getDvarString("party_connectTimeout") != "0")
    {
        SetDvar("lobbySearchListenCountries", "0,103,6,5,8,13,16,23,25,32,34,24,37,42,44,50,71,74,76,75,82,84,88,31,90,18,35");
        SetDvar("excellentPing", 3);
        SetDvar("goodPing", 4);
        SetDvar("terriblePing", 5);
        SetDvar("migration_forceHost", 1);
        SetDvar("migration_minclientcount", 12);
        SetDvar("party_connectToOthers", 0);
        SetDvar("party_dedicatedOnly", 0);
        SetDvar("party_dedicatedMergeMinPlayers", 12);
        SetDvar("party_forceMigrateAfterRound", 0);
        SetDvar("party_forceMigrateOnMatchStartRegression", 0);
        SetDvar("party_joinInProgressAllowed", 1);
        SetDvar("allowAllNAT", 1);
        SetDvar("party_keepPartyAliveWhileMatchmaking", 1);
        SetDvar("party_mergingEnabled", 0);
        SetDvar("party_neverJoinRecent", 1);
        SetDvar("party_readyPercentRequired", .25);
        SetDvar("partyMigrate_disabled", 1);
    }
}
_override_on_player_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
    if(bool(level.ZombieKnockback) && eAttacker.is_zombie)
        self SetVelocity(((AnglesToForward(VectorToAngles(self GetOrigin() - eAttacker GetOrigin())) + (0, 0, 5)) * (1337, 1337, 350)));
        
    if((isDefined(self.PHDPerk) && self.PHDPerk) && (sMeansOfDeath == "MOD_SUICIDE" || sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSIVE"))
        return 0;

    if(bool(self.SpecGod))
        return 0;

    if(bool(self.DemiGodmode))
    {
        self FakeDamageFrom(vDir);
        return 0;
    }

    if(isDefined(level.overridePlayerDamageOverSelf))
        damage = [[level.overridePlayerDamageOverSelf]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime);
    else
        damage = zm::player_damage_override(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime);
    
    return damage;
}

_actor_damage_override_wrapper(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, modelIndex, surfaceType, vSurfaceNormal)
{
    zm::actor_damage_override_wrapper(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, modelIndex, surfaceType, vSurfaceNormal);
    
    if(bool(attacker.ShowHitMarkers) || bool(level.ShowHitMarkers))
        attacker thread zombie_utility::show_hit_marker();
}
give_gobble_gum( gum_id , player)
{
    gum_id = level._GobbleGums[gum_id];
    saved  = player GetCurrentWeapon();
    weapon = GetWeapon("zombie_bgb_grab");
    player GiveWeapon(weapon, player CalcWeaponOptions(level.bgb[gum_id].camo_index, 0, 0));
    player SwitchToWeapon(weapon);
    player playsound("zmb_bgb_powerup_default");
  
    evt = player util::waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete", "disconnect");
    if(evt == "weapon_change_complete")
    {
        player takeWeapon( weapon );
        player zm_weapons::switch_back_primary_weapon(saved);
        bgb::give( gum_id );
    }
}
/*
give_gobble_gum( gum_id )
{
    gum_id = level._GobbleGums[gum_id];
    saved  = self GetCurrentWeapon();
    weapon = GetWeapon("zombie_bgb_grab");
    self GiveWeapon(weapon, self CalcWeaponOptions(level.bgb[gum_id].camo_index, 0, 0));
    self SwitchToWeapon(weapon);
    self playsound("zmb_bgb_powerup_default");
  
    evt = self util::waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete", "disconnect");
    if(evt == "weapon_change_complete")
    {
        self takeWeapon( weapon );
        self zm_weapons::switch_back_primary_weapon(saved);
        bgb::give( gum_id );
    }
}
*/
setSafeText(text)
{
    level.result += 1;
    level notify("textset");
    self setText(text);
}

//xTUL Overflow Fix
recreateText()
{
    self submenu(self.CurMenu, self.CurTitle);
  
    self.Radiant["title"] setSafeText("Menu Base");
    self.Radiant["slash"] setSafeText("/");
}
overflowfix()
{
    level endon("game_ended");
    level endon("host_migration_begin");
  
    level.test = hud::createServerFontString("default", 1);
    level.test setText("xTUL");
    level.test.alpha = 0;
  
    if(GetDvarString("g_gametype") == "sd")
        A = 45;
    else
        A = 55;
      
    for(;;)
    {
        level waittill("textset");

        if(level.result >= A)
        {
            //level.test ClearAllTextAfterHudElem();
            level.result = 0;

            foreach(player in level.players)
                if(player.menu.open && player isVerified())
                    player recreateText();
        }
    }
}