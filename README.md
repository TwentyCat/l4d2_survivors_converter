<h1 align="center">
  <br>
  <img src="https://github.com/TwentyCat/l4d2_survivors_converter/blob/main/git_screenshots/cover.png" alt="L4D2 Survivors Converter" width="300">
  <br>
  L4D2 Survivors Converter
  <br>
</h1>

# Description

This tool provides you a fast method to convert models among eight Left 4 Dead 2 Survivors.

![](https://github.com/TwentyCat/l4d2_survivors_converter/blob/main/git_screenshots/screen.png)





# System Requirement

Windows 7, 8, 10, 11 and above, x64 based.





# Structure

7 Folders, 4 BATs.

1. Folder *Materials*: Stores materials (portraits not included).
2. Folder *Portraits*: Stores portraits (other materials not included).
3. Folder *Survivors*: Stores compiling files for survivor model, besides a temp QCI file (1_main.qci).
4. Folder *Weapons*: Stores compiling files for weapon model, besides a temp QCI file (1_main.qci).
5. Folder *OUTPUTS*: Stores outputed addon folders.
6. Folder *LOGS*: Stores error logs.
7. Folder *App*: Stores tool files.

8. *StartCompile.bat*: The main program.
9. *PerformCleanup.bat*: Clear compiling files, but not program config and 1_main.qci(s).
10. *PerformReset.bat*: Clear compiling files, including program config and 1_main.qci(s).
11. *AutoPlacing.bat*: The optional program for automatic extracting and deploying compiling files from a VPK file.





# Attention!

1. > ⚠ Do not upload or publish ANY addons created by this tool to ANY website, unless you're the owner of that containing model, or granted permission from the original author. After publishment, you must obey relevant user agreements of website. Creator of this tool is not responsible for your illegal behavior. ⚠
2. Do not modify the structure and app files of the tool, unless you know what to do.
3. The AutoPlacing.bat can only pick one character from Nick to Francis inside a VPK, if the VPK contains multiple characters.
4. The survivor will be in T-pose when it doesn't match any animations. This tool also contains a set of new animation for T-posing. You can go inside the App folder, replace *ANIMS* folder with *NEWANIMS* folder, and *TANIMS* folder for rollback.
5. Please re-download this tool when you encounter errors cause by the tools itself.





# Copyright

- BATs by 20Cat [https://steamcommunity.com/id/20cat](https://steamcommunity.com/id/20cat) Github: https://github.com/TwentyCat/l4d2_survivors_converter

- NekoMDL Compiler by Starfelll https://steamcommunity.com/sharedfiles/filedetails/?id=3142607978
- Crowbar Commandline by mrglaster (Modified default configs) https://github.com/mrglaster/Source-models-decompiler-cmd





# User Guide 1 (Simple, Recommended)

## Requisites

 - Your VPK addon

## Steps

1. Drag your VPK file into AutoPlacing.bat.
2. Follow the instructions on screen.
3. When finished, you can see outputs in *5_OUTPUT* . Please modify them as you need, and re-pack them with vpk.exe (or with other method).
4. See error logs in *6_LOGS* , if it failed to compile.





# User Guide 2 (Fully Manual)

## Requisites

 - Crowbar 0.74
 - Notepad2 (or other text editor)
 - Your compiling files

## Steps

1. Make sure of your Crowbar settings be like:
 - Output to: "Subfolder (of MDL input)", "dec_0.74"
 - Re-Create Files: "Group into QCI files": Checked

![](https://github.com/TwentyCat/l4d2_survivors_converter/blob/main/git_screenshots/crowbar_settings.png)

2. Unpack VPK using vpk.exe or with other method.
3. Go to *YourAddon\materials\vgui* , rename 3 VTF files (Panel, Incap, Lobby portraits) to s.vtf, i.vtf, l.vtf respectively.
4. Move that 3 VTF files to *2_Portraits*.
5. Delete folder *YourAddon\materials\vgui*, and move all items inside folder *YourAddon\materials* to *1_Materials*.
6. Go to *YourAddon\models\survivors*, decompile MDL file using Crowbar.
7. Go to *YourAddon\models\survivors\dec_0.74\survivor_xxx_anims* , move 2 SMDs (a_proportions.smd、a_proportions_corrective_animation.smd) to upper folder (*YourAddon\models\survivors\dec_0.74*).
(Step 7 can be skipped, if your survivor model doesn't have proportions)
8. Move all SMDs, VRD, VTA files in *YourAddon\models\survivors\dec_0.74* to *3_Survivors*.
9. Open QC file in *YourAddon\models\survivors\dec_0.74* using Notepad2:
 - Go to the bottom of QC, check up the last line of $includemodels, remember what animation of the MDL using.
	
	| Animation      | Character        |
	| -------------- | ---------------- |
	| anim_gambler   | Nick             |
	| anim_producer  | Rochelle         |
	| anim_coach     | Coach            |
	| anim_mechanic  | Ellis            |
	| anim_namvet    | Bill             |
	| anim_teenangst | Zoey             |
	| anim_biker     | Francis or Louis |
	
 - Delete these lines at the top:
	
	```c++
	// Created by Crowbar 0.7x
	$modelname "survivors\survivor_xxx.mdl"
	```
	
 - Delete these 4 kinds of relevant lines at the bottom:
	
	```c++
	$animation {xxx}
	$sequence {xxx}
	$declaresequence xxx
	$includemodel xxx
	```
	
	(Also means delete from the next line of the first $weightlist or $ikautoplaylock line, until the end of QC)

After done, the QC code will be like:

```c++
// $modelname "survivors/survivor_gambler.mdl"
// Delete upper codes end from this line

$model "Survivor" "xxx.smd" { ...
	}
$bodygroup "xxx" {	...
}
// other codes in the middle
// other codes in the middle
// other codes in the middle

$sectionframes 30 287

$poseparameter "body_pitch" -90 90 loop 360
$poseparameter "body_yaw" -90 90 loop 360
$poseparameter "head_pitch" -90 90 loop 360
$poseparameter "head_yaw" -90 90 loop 360

$ikchain "rhand" "ValveBiped.Bip01_R_Hand" knee 0.707 0.707 0
$ikchain "lhand" "ValveBiped.Bip01_L_Hand" knee 0.707 0.707 0
$ikchain "rfoot" "ValveBiped.Bip01_R_Foot" knee 0.707 -0.707 0
$ikchain "lfoot" "ValveBiped.Bip01_L_Foot" knee 0.707 -0.707 0
$ikchain "ikclip" "ValveBiped.weapon_bone_Clip" knee 0.707 -0.707 0

$ikautoplaylock "rfoot" 1 0.1
$ikautoplaylock "lfoot" 1 0.1

// Delete bottom codes start from this line

$weightlist "xxx" {}
$animation "xxx" "xxx.smd" {fps xxx}
$includemodel "xxx.mdl"
```


10. Copy the rest of QC contents into *3_Survivors\1_main.qci* and save.

11. Go to *YourAddon\models\weapons\arms*, decompile MDL file using Crowbar.

12. Go to *YourAddon\models\weapons\arms\dec_0.74\survivor_xxx_anims* , move 2 SMDs (a_proportions.smd, a_proportions_corrective_animation.smd) to upper folder (*YourAddon\models\survivors\dec_0.74*).
    **(Step 7 can be skipped, if your survivor model doesn't have proportions)**

13. Move all SMDs, VRD files in *YourAddon\models\weapons\arms\dec_0.74* to *4_Weapons*.

14. Open QC file in *YourAddon\models\weapons\arms\dec_0.74* using Notepad2:

     - Delete these lines at the top:

       ```c++
       // Created by Crowbar 0.7x
       $modelname "weapons\arms\v_arms_xxx.mdl"
       ```

     - Delete these $sequence lines at the bottom.


    After done, the QC code will be like:

    ```c++
    // $modelname "weapons\arms\v_arms_xxx.mdl"
    // Delete upper codes end from this line
    
    $bodygroup "arms"
    {
    	studio "shoubi.smd"
    }
    
    // other codes in the middle
    // other codes in the middle
    // other codes in the middle
    
    // Delete bottom codes start from this line
    
    $sequence "reference" {
    	"v_arms_gambler_new_anims\reference.smd"
    	fadein 0.2
    	fadeout 0.2
    	fps 30
    }
    ```

    

15. Copy the rest of QC contents into *4_Weapons\1_main.qci* and save.

16. Double click StartCompile.bat, and follow the instructions on screen.

17. When finished, you can see outputs in *5_OUTPUT*. Please modify them as you need, and re-pack them with vpk.exe (or with other method).

18. See error logs in *6_LOGS*, if it failed to compile.

