1. Make sure of your Crowbar settings be like:
   - Output to: "Subfolder (of MDL input)", "dec_0.74"
   - Re-Create Files: "Group into QCI files": Checked
2. Unpack VPK using vpk.exe or with other method.
3. Go to *YourAddon\materials\vgui* , rename 3 VTF files (Panel, Incap, Lobby portraits) to s.vtf, i.vtf, l.vtf respectively.
4. Move that 3 VTF files to *2_Portraits*.
   - If your VTF file is dynamic, please modify **VTFframerate.ini** inside the folder:
     Example: s.vtf is 15fps, l.vtf is 10fps, i.vtf is static, the ini files will be like:

;PortraitType,FPS
s,15.00
i,10.00
;l,0.00



1. 把要转换的人物 VPK 解包；
2. 打开 解包目录\materials\vgui\，分别把正常、倒地、大厅3个头像 VTF 文件重命名为 s.vtf，i.vtf，l.vtf（注意扩展名问题，别弄成s.vtf.vtf了！！！）；
3. 重命名好的 3 个文件，移动到工具目录 Portraits 文件夹；
 - 如果你的头像是动态的，请打开文件夹内的 VTFframerate.ini，将对应头像的行的第一个冒号注释去掉，然后将 0.00 改成该头像的帧率（单位fps）：
   比如正常头像是15fps的，就把“;s,0.00”改成“s,15.00”，其它头像以此类推。
   注意第一行不需要动，修改后记得保存。