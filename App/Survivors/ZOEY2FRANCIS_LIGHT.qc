$modelname "survivors/survivor_biker_light.mdl"

$include "1_main.qci"

$animation "@dlc1_intro_male_leanup_corrective_animation" "ANIMS\@dlc1_intro_male_leanup_corrective_animation.smd"
$animation "@dlc1_intro_male_leanleft_corrective_animation" "ANIMS\@dlc1_intro_male_leanleft_corrective_animation.smd"
$animation "@dlc1_intro_male_headnod_corrective_animation" "ANIMS\@dlc1_intro_male_headnod_corrective_animation.smd"
$animation "@dlc1_intro_male_handflipR_corrective_animation" "ANIMS\@dlc1_intro_male_handflipR_corrective_animation.smd"
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
$sequence "proportions" {
	"a_proportions"
	autoplay
	predelta
	fadein 0.2
	fadeout 0.2
}
