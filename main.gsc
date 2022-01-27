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
