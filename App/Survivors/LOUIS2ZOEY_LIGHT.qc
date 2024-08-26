$modelname "survivors/survivor_teenangst_light.mdl"

$include "1_main.qci"

$animation "@dlc1_intro_zoey_shrug_corrective_animation" "ANIMS\@dlc1_intro_zoey_shrug_corrective_animation.smd"
$animation "@dlc1_intro_zoey_shout_corrective_animation" "ANIMS\@dlc1_intro_zoey_shout_corrective_animation.smd"
$animation "@dlc1_intro_zoey_headshake_corrective_animation" "ANIMS\@dlc1_intro_zoey_headshake_corrective_animation.smd"
$animation "@dlc1_intro_zoey_handflipR_corrective_animation" "ANIMS\@dlc1_intro_zoey_handflipR_corrective_animation.smd"
$animation "@dlc1_intro_zoey_head_gesture_corrective_animation" "ANIMS\@dlc1_intro_zoey_head_gesture_corrective_animation.smd"
$animation "@dlc1_intro_zoey_generator_point_corrective_animation" "ANIMS\@dlc1_intro_zoey_generator_point_corrective_animation.smd"
$animation "a_proportions_corrective_animation" "a_proportions_corrective_animation.smd" {
	fps 30
}
$animation "a_proportions" "a_proportions.smd" {
	fps 30
	subtract "a_proportions_corrective_animation" 0
}

$sequence "CustomModel" {
	"ANIMS\CustomModel.smd"
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
$sequence "dlc1_intro_zoey_idle" {
	"ANIMS\dlc1_intro_zoey_idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
$sequence "dlc1_intro_zoey_shrug" {
	"ANIMS\dlc1_intro_zoey_shrug.smd"
	activity "ACT_DLCINTRO_ZOEY_01" -1
	delta
	subtract "@dlc1_intro_zoey_shrug_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}
$sequence "dlc1_intro_zoey_shout" {
	"ANIMS\dlc1_intro_zoey_shout.smd"
	activity "ACT_DLCINTRO_ZOEY_02" -1
	delta
	subtract "@dlc1_intro_zoey_shout_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}
$sequence "dlc1_intro_zoey_headshake" {
	"ANIMS\dlc1_intro_zoey_headshake.smd"
	activity "ACT_DLCINTRO_ZOEY_03" -1
	delta
	subtract "@dlc1_intro_zoey_headshake_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}
$sequence "dlc1_intro_zoey_handflipR" {
	"ANIMS\dlc1_intro_zoey_handflipR.smd"
	activity "ACT_DLCINTRO_ZOEY_04" -1
	delta
	subtract "@dlc1_intro_zoey_handflipR_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}
$sequence "dlc1_intro_zoey_head_gesture" {
	"ANIMS\dlc1_intro_zoey_head_gesture.smd"
	activity "ACT_DLCINTRO_ZOEY_05" -1
	delta
	subtract "@dlc1_intro_zoey_head_gesture_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}
$sequence "dlc1_intro_zoey_generator_point" {
	"ANIMS\dlc1_intro_zoey_generator_point.smd"
	activity "ACT_DLCINTRO_ZOEY_06" -1
	delta
	subtract "@dlc1_intro_zoey_generator_point_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}
$sequence "proportions" {
	"a_proportions"
	autoplay
	predelta
	fadein 0.2
	fadeout 0.2
}