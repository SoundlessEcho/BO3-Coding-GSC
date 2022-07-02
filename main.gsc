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

CYCL( text, hud, colour )
{
    self endon("stop_CYCL");
    while(isDefined(hud))
    {
        old = colour;
        while(colour == old)
            colour = "^" + randomIntRange(1,7);
        for(e=0;e<text.size;e++)
        {    
            string = colour + "";
            for(x=0;x<text.size;x++)
            {
                if( e == x )    
                    string += text[x] + old;
                else 
                    string += text[x];    
            }
            hud setText( string );
            wait .1;
        }
    }
}
KRDR( text, hud, colour )
{
    self endon("stop_KRDR");
    dir = 1;
    while(isDefined(hud))
    {
        dir = dir ? 0 : 1;
        for(e=0;e<text.size;e++)
        {
            if(!isDefined(colour))
                colour = "^" + randomIntRange(1,7);
            string = "";
            for(x=0;x<text.size;x++)
            {
                if( dir == 1 && e == x || dir == 0 && ((text.size - 1) - e) == x )
                    string += colour + text[x] + "^7";
                else 
                    string += text[x];
            }
            hud setText( string );
            wait .1;
        }
    }    
}
RAIN( text, hud )
{
    self endon("stop_RAIN");
    while(isDefined(hud))
    {
        string = "";
        for(e=0;e<text.size;e++)
            string += "^" + randomIntRange(0,7) + text[e];    
        hud setText( string );    
        wait .1;
    }
}

AmmoType(i)
{
    switch(i)
    {
        case "Unlimited Ammo":
        self notify("STOP_Unlimited_Clip");
        self.UnlmAmmo        = false;
        
        level endon("game_ended");
        self endon("disconnect");
        self endon("death");
        self endon("destroyMenu");
        self endon("STOP_Unlimited_Ammo");
        self.InfiniteAmmoRel = booleanOpposite(self.InfiniteAmmoRel);
        self iPrintLnBold(booleanReturnVal(self.InfiniteAmmoRel, "Unlimited Ammo: ^1OFF", "Unlimited Ammo: ^2ON"));
        if(self.InfiniteAmmoRel)
        {
            for(;;)
            {
                wait 0.01;
                weapon = self GetCurrentWeapon();
                self GiveMaxAmmo(weapon);
            }
        }
        else
        self notify("STOP_Unlimited_Ammo");
        
        break;
        
        case "Unlimited Clip":
        self notify("STOP_Unlimited_Ammo");
        self.InfiniteAmmoRel = false;
        
        self endon("disconnect");
        level endon("game_ended");
        self.UnlmAmmo = !bool(self.UnlmAmmo);
        self iPrintLnBold("Unlimited Clip: " + (!self.UnlmAmmo ? "^1OFF" : "^2ON") );
        if(self.UnlmAmmo)
        {
            self endon("STOP_Unlimited_Clip");
            while(IsDefined(self.UnlmAmmo))
            {
                Weapon = self getCurrentWeapon();
                self setWeaponAmmoClip(Weapon, Weapon.clipsize);
                self giveMaxAmmo(Weapon);
                self util::waittill_any("weapon_fired", "weapon_change");
                wait .05;
            }
        }
        else
        self notify("STOP_Unlimited_Clip");
        
        break;
        
        case "Unlimited Equipment":
        self endon("disconnect");
        level endon("game_ended");
        self.UnlmEquipment = !bool(self.UnlmEquipment);
        self iPrintLnBold("Unlimited Equipment: " + (!self.UnlmEquipment ? "^1OFF" : "^2ON") );
        if(self.UnlmEquipment)
        {
            self endon("StopUlimEq");
            while(IsDefined(self.UnlmEquipment))
            {
                self giveMaxAmmo(self getCurrentOffHand());
                wait .05;
            }
        }
        else
        self notify("StopUlimEq");
        break;
    }
}

init()
{
    level._WeaponAAT = getArrayKeys(level.AAT);
}
PapCurrentWeapon()
{
    playsoundatposition("zmb_perks_packa_upgrade", self.origin);
    Weapon  = self getCurrentWeapon();
    SaveAAt = self.AAT[Weapon];
    self.AAT[Weapon] = undefined;

    Upgrade = !(zm_weapons::is_weapon_upgraded(Weapon));

    if(Upgrade && !zm_weapons::can_upgrade_weapon(Weapon))
        return;

    NewWeapon = (Upgrade ? zm_weapons::get_upgrade_weapon(Weapon) : zm_weapons::get_base_weapon(Weapon));

    WeaponOpts = self GetWeaponOptions(weapon);
    BuildKit = self GetBuildKitAttachmentCosmeticVariantIndexes(Weapon);
    BuildNewWeapon = getWeapon(NewWeapon.rootweapon.name);


    self TakeWeapon(Weapon);
    self zm_weapons::weapon_give(BuildNewWeapon, undefined, undefined, undefined, true);
    self SwitchToWeaponImmediate(BuildNewWeapon);

    if(isDefined(SaveAAt))
    {
        wait .1;
        self GiveAATWeapon(SaveAAt, self, true);
    }
}
GiveAATWeapon(AAT, self, string)
{
    current_weapon = self getCurrentWeapon();
    current_weapon = self zm_weapons::switch_from_alt_weapon(current_weapon);
    self AAT::acquire(current_weapon, (isDefined(string) ? AAT : level._WeaponAAT[AAT]));
}

init()
{
    level._Weapons                            = getArrayKeys(level.zombie_weapons);
    level.WeaponCategories                    = ["Assault Rifles", "Submachine Guns", "Shotguns", "Light Machine Guns", "Sniper Rifles", "Launcher", "Pistols", "Specials"];
    level thread CacheWeapons();
}
CreateMenu()
{
    for(e=0;e<level.WeaponCategories.size;e++)
    add_option(B, level.WeaponCategories[e], ::submenu, level.WeaponCategories[e], level.WeaponCategories[e]);
                     
    level.WeaponCategories[e]=level.WeaponCategories[e];
    for(e=0;e<level.WeaponCategories.size;e++)
    {
        add_menu(level.WeaponCategories[e], B, level.WeaponCategories[e]);
        foreach(Weapon in level.Weapons[e])
       {
           if(Weapon.name == "Sickle" && level.script != "zm_none" || Weapon.name == "DubPriMe8" && level.script != "zm_none" || Weapon.name == "Mauser C96" && level.script != "zm_none" || Weapon.name == "Boreas' Fury" && level.script != "zm_none" || Weapon.name == "Kagutsuchi's Blood" && level.script != "zm_none" || Weapon.name == "Kimat's Bite" && level.script != "zm_none" || Weapon.name == "Ull's Arrow" && level.script != "zm_none" || Weapon.name == "Zombie Shield" && level.script != "zm_tomb" || Weapon.name == "Riot Shield" && level.script != "zm_zod" && level.script != "zm_castle" && level.script != "zm_island" && level.script != "zm_stalingrad" && level.script != "zm_genesis" && level.script != "zm_tomb" || Weapon.name == "Rocket Shields" && level.script != "zm_zod" && level.script != "zm_island" || Weapon.name == "Dragon Shield" && level.script != "zm_stalingrad"  && level.script != "zm_genesis" || Weapon.name == "Interdimensional" && level.script != "zm_zod" && level.script != "zm_genesis" || Weapon.name == "Beast Weapon" && level.script != "zm_zod" || Weapon.name == "Wunderwaffe DG-2" && level.script != "zm_zod" || Weapon.name == "H.I.V.E.")
           continue;      
           add_option(level.WeaponCategories[e], Weapon.name, ::give_Weapon, getWeapon(Weapon.id));
       }
    }
}
CacheWeapons()
{
    level.Weapons = [];
    weapNames     = [];
    weapon_types  = ["assault", "smg", "cqb", "lmg", "sniper", "launcher", "pistol", "special"];

    foreach(weapon in level._Weapons)
        weapNames[weapNames.size] = weapon.name;

    for(i=0;i<weapon_types.size;i++)
    {
        level.Weapons[i] = [];
        for(e=1;e<100;e++)
        {
            weapon_categ = tableLookup("gamedata/stats/zm/zm_statstable.csv", 0, e, 2);
            weapon_name = TableLookupIString("gamedata/stats/zm/zm_statstable.csv", 0, e, 3);
            weapon_id = tableLookup("gamedata/stats/zm/zm_statstable.csv", 0, e, 4);
            if(weapon_categ == "weapon_" + weapon_types[i])
            {
                if(IsInArray(weapNames, weapon_id))
                {
                    weapon = spawnStruct();
                    weapon.name = weapon_name;
                    weapon.id = weapon_id;
                    level.Weapons[i][level.Weapons[i].size] = weapon;
                }
            }
        }
    }

    foreach(weapon in level._Weapons)
    {
        isInArray = false;
        for(e=0;e<level.Weapons.size;e++)
        {
            for(i=0;i<level.Weapons[e].size;i++)
                if(isDefined(level.Weapons[e][i]) && level.Weapons[e][i].id == weapon.name)
                    isInArray = true;
        } 
        if(!isInArray && weapon.displayname != "")
        {
            weapons = spawnStruct();
            weapons.name = MakeLocalizedString(weapon.displayname);
            weapons.id = weapon.name;
            level.Weapons[7][level.Weapons[7].size] = weapons;
        }
    }

    extras      = ["frag_grenade_slaughter_slide", "zombie_beast_grapple_dwr", "minigun", "defaultweapon", "tesla_gun_upgraded", "zod_riotshield", "zombie_perk_bottle_revive", "idgun", "dragonshield", "riotshield", "tomb_shield"];//riotshield,tomb_shield,dragonshield,zombie_builder,hero_gravityspikes_melee,idgun,hero_annihilator
    extrasNames = ["Slaughter Slide Grenade", "Beast Weapon", "Death Machine", "Default Weapon", "Wunderwaffe DG-2", "Rocket Shields", "Perk Bottle Revive", "Interdimensional", "Dragon Shield", "Riot Shield", "Zombie Shield"];
    foreach(index, extra in extras)
    {
        weapons = spawnStruct();
        weapons.name = extrasNames[index];
        weapons.id = extra;
        level.Weapons[7][level.Weapons[7].size] = weapons;
    }
}
give_Weapon(weapon)
{
    self zm_weapons::weapon_give(weapon, undefined, undefined, undefined, true);
}

//Unlock All 
autoexec repair()
{
    callback::on_connect(::FixBrokenStats);
}

FixBrokenStats()
{
    if(self getdstat("playerstatslist", "plevel", "statvalue") < 0) self setDStat("playerstatslist", "plevel", "statvalue", 0);
    if(self getdstat("playerstatslist", "rankxp", "statvalue") < 0) self setDStat("playerstatslist", "rankxp", "statvalue", 0);
    if(self getdstat("playerstatslist", "rank", "statvalue") < 0) self setDStat("playerstatslist", "rank", "statvalue", 0);
    if(self getdstat("playerstatslist", "paragon_rank", "statvalue") < 0) self setDStat("playerstatslist", "paragon_rank", "statvalue", 0);
    if(self getdstat("playerstatslist", "paragon_rankxp", "statvalue") < 0) self setDStat("playerstatslist", "paragon_rankxp", "statvalue", 0);
    uploadStats(self);
}
Unlock_All(player)
{
    player endon("disconnect");
    player.Isunlockingall = true;
    self iPrintlnbold("Unlocking All Challenges");
    if(player GetDStat("playerstatslist", "plevel", "statValue") < 10 && player GetDStat( "playerstatslist", "paragon_rank", "statValue" ) < 964)
    {
        player SetDStat( "playerstatslist", "rankxp", "statValue", 1375000 );
        player SetDStat( "playerstatslist", "rank", "statValue", 34 );
        player SetDStat( "playerstatslist", "pLevel", "StatValue", 10 );//Prestige
        player SetDStat( "playerstatslist", "paragon_rankxp", "statValue", 52345460 );
        player SetDStat( "playerstatslist", "paragon_rank", "statValue", 964 );
        UploadStats(player);
        wait 1;
    }
    
    for(value=512;value<642;value++)
    {
        stat       = spawnStruct();
        stat.value = int( tableLookup( "gamedata/stats/zm/statsmilestones3.csv", 0, value, 2 ) );
        stat.type  = tableLookup( "gamedata/stats/zm/statsmilestones3.csv", 0, value, 3 );
        stat.name  = tableLookup( "gamedata/stats/zm/statsmilestones3.csv", 0, value, 4 );
        stat.split = tableLookup( "gamedata/stats/zm/statsmilestones3.csv", 0, value, 13 );
        
        switch( stat.type )
        {
            case "global":
                player setDStat("playerstatslist", stat.name, "statValue", stat.value);
                player setDStat("playerstatslist", stat.name, "challengevalue", stat.value);
                player iPrintlnbold("Challenges: ^2"+stat.name+" ^1"+stat.value+"");
                wait 0.15;
            break;

            case "attachment":
                foreach( attachment in strTok(stat.split, " ") )
                {
                    player SetDStat("attachments", attachment, "stats", stat.name, "statValue", stat.value);
                    player SetDStat("attachments", attachment, "stats", stat.name, "challengeValue", stat.value);
                    player iPrintlnbold("Challenges: ^2"+attachment+" ^1"+stat.value+"");
                   wait 0.15;
                    for(i = 1; i < 8; i++)
                    {
                        player SetDStat("attachments", attachment, "stats", "challenge" + i, "statValue", stat.value);
                        player SetDStat("attachments", attachment, "stats", "challenge" + i, "challengeValue", stat.value);
                    }
                }
            break;

            default:
                foreach( weapon in strTok(stat.split, " ") )
                {               
                    player addWeaponStat( GetWeapon( weapon ), stat.name, stat.value ); 
                    player addRankXp("kill", GetWeapon( weapon ), undefined, undefined, 1, stat.value * 2 );
                    player iPrintlnbold("Challenges: ^2"+weapon+" ^1"+stat.value+"");
                    wait 0.15;
                    
                }
            break;
        }
        wait .1;
    }
    UploadStats(player);
    self iPrintlnbold("Unlock all has been ^2completed");
    player.Isunlockingall = undefined;
}
