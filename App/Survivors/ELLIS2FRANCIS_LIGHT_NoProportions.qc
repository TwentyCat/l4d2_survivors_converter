$modelname "survivors/survivor_biker_light.mdl"

$include "1_main.qci"

$poseparameter "body_pitch" -90 90 loop 360
$poseparameter "body_yaw" -90 90 loop 360
$poseparameter "head_pitch" -90 90 loop 360
$poseparameter "head_yaw" -90 90 loop 360

$ikchain rhand "valvebiped.Bip01_R_Hand" Z 0 knee 0.707 0.707 0
$ikchain lhand "valvebiped.Bip01_L_Hand" Z 0 knee 0.707 0.707 0
$ikchain rfoot "valvebiped.Bip01_R_Foot" Z 0 knee 0.707 -0.707 0 pad 5 center 4 0 0
$ikchain lfoot "valvebiped.Bip01_L_Foot" Z 0 knee 0.707 -0.707 0 pad 5 center 4 0 0
$ikchain ikclip "ValveBiped.weapon_bone_Clip" Z 0 knee 0.707 -0.707 0

$ikautoplaylock rfoot 1.0 0.1
$ikautoplaylock lfoot 1.0 0.1

$animation "@dlc1_intro_male_leanup_corrective_animation" "ANIMS\@dlc1_intro_male_leanup_corrective_animation.smd"
$animation "@dlc1_intro_male_leanleft_corrective_animation" "ANIMS\@dlc1_intro_male_leanleft_corrective_animation.smd"
$animation "@dlc1_intro_male_headnod_corrective_animation" "ANIMS\@dlc1_intro_male_headnod_corrective_animation.smd"
$animation "@dlc1_intro_male_handflipR_corrective_animation" "ANIMS\@dlc1_intro_male_handflipR_corrective_animation.smd"

$sequence "CustomModel" {
	"ANIMS\CustomModel.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}
$sequence "animHack" {
	"ANIMS\animHack.smd"
	fadein 0.2
	fadeout 0.2
	hidden
	fps 30
}
$sequence "dlc1_intro_male_idle" {
	"ANIMS\dlc1_intro_male_idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
$sequence "dlc1_intro_male_leanup" {
	"ANIMS\dlc1_intro_male_leanup.smd"
	activity "ACT_DLCINTRO_01" -1
	delta
	subtract "@dlc1_intro_male_leanup_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}
$sequence "dlc1_intro_male_leanleft" {
	"ANIMS\dlc1_intro_male_leanleft.smd"
	activity "ACT_DLCINTRO_02" -1
	delta
	subtract "@dlc1_intro_male_leanleft_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}
$sequence "dlc1_intro_male_headnod" {
	"ANIMS\dlc1_intro_male_headnod.smd"
	activity "ACT_DLCINTRO_03" -1
	delta
	subtract "@dlc1_intro_male_headnod_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}
$sequence "dlc1_intro_male_handflipR" {
	"ANIMS\dlc1_intro_male_handflipR.smd"
	activity "ACT_DLCINTRO_04" -1
	delta
	subtract "@dlc1_intro_male_handflipR_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}
$sequence "ragdoll" {
	"ANIMS\ragdoll.smd"
	activity "ACT_DIERAGDOLL" 1
	fadein 0.2
	fadeout 0.2
	fps 30
}
