#include <asm_setup.S>

#obviously liquidtex - thank you to nin0 for the original code, all i did was make it work with regular newer

.text
.extern nextSplashSubType

.extern continueBGpolyCreate
.global CheckRanOnce
CheckRanOnce:
	#save
	stwu sp, -0x80 (sp)
	mflr r0
	stw r0, 0x4(sp)
	stmw r2, 0x8 (sp)
	
	addis r6, r3, 0x2
	lbz r4, -0x5AFD(r6)
	
	cmpwi r4, 0
	beq notRanOnceYet
	
	#save liquidSettings from nybble 3-4
	lbz r4, 0x355(r3)
	lis r5, liquidSetting@h
	ori r5, r5, liquidSetting@l
	stb r4, 0x0(r5)
	
	# fix spriteFlagMask so it only uses nybble 1-2
	lbz r4, 0x354(r3)
	cmpwi r4, 0
	bne spriteFlagMaskCorrect 
	stw r4, 0x358(r3)
	stw r4, 0x35C(r3)
	
spriteFlagMaskCorrect:
	#restore
	lmw r2, 0x8 (sp)
	lwz r0, 0x4(sp)
	mtlr r0
	addi sp, sp, 0x80
	
	stwu r1, -0x60(r1)
	b continueBGpolyCreate

notRanOnceYet:
	li r4, 1
	stb r4, -0x5AFD(r6)
	
	lmw r2, 0x8 (sp)
	lwz r0, 0x4(sp)
	mtlr r0
	addi sp, sp, 0x80
	li r3, 0
	blr

.extern returnFromSelectDifferentLiquidsSet
.global SelectDifferentLiquidsSet
SelectDifferentLiquidsSet:
	lis r5, PTR_ARRAY_8031b7d0@h
	ori r5, r5, PTR_ARRAY_8031b7d0@l
	
	lbz r3, -0x7B(r29)
	mulli r3, r3, 28
	add r3, r3, r28
	lwzx r5, r5, r3

	addi r3, r6, 0x4
	b returnFromSelectDifferentLiquidsSet

.extern returnFromSelectDifferentLiquidsSet2
.global SelectDifferentLiquidsSet2
SelectDifferentLiquidsSet2:
	lis r5, PTR_ARRAY_8031b988@h
	ori r5, r5, PTR_ARRAY_8031b988@l
	
	lbz r3, -0x1BF(r24)
	mulli r3, r3, 20
	add r3, r3, r26
	lwzx r5, r5, r3
	addi r3, r6, 0x4
	b returnFromSelectDifferentLiquidsSet2

.extern returnFromSelectDifferentLavaDeco
.global SelectDifferentLavaDeco
SelectDifferentLavaDeco:
	lis r5, PTR_ARRAY_8031bb30@h
	ori r5, r5, PTR_ARRAY_8031bb30@l
	
	lbz r3, -0x1BF(r24)
	mulli r3, r3, 20
	add r3, r3, r26
	lwzx r5, r5, r3
	b returnFromSelectDifferentLavaDeco

.extern liquidSubTypes
.extern dWaterManager_c__add
.extern returnFromSaveLiquiSubTypesInNewArray
.global SaveLiquiSubTypesInNewArray
SaveLiquiSubTypesInNewArray:
	bl dWaterManager_c__add
	lis r4, liquidSubTypes@h
	ori r4, r4, liquidSubTypes@l
	lbz r6, 0x355(r27)
	stbx r6, r4, r3
	b returnFromSaveLiquiSubTypesInNewArray

.extern continueOriginalCheckWater

.extern returnFromSaveGlobalWaterSubType
.global SaveGlobalWaterSubType
SaveGlobalWaterSubType:
	lbz r5, 0x355(r30)
	stb r5, 0xBE7(r3)
	mr r3, r30
	b returnFromSaveGlobalWaterSubType

.extern returnFromSaveGlobalLavaSubType
.global SaveGlobalLavaSubType
SaveGlobalLavaSubType:
	stb r6, 0x2c(r5)
	lbz r3, 0x355(r30)
	stb r3, 0xBE7(r5)
	mr r3, r30
	b returnFromSaveGlobalLavaSubType

.extern returnFromGetLavaWavesSubType
.extern LavaWavesSubType
.global GetLavaWavesSubType
GetLavaWavesSubType:
	lis r3, LavaWavesSubType@ha
	lbz r3, LavaWavesSubType@l(r3)
	
	lis r31, nextSplashSubType@ha
	stb r3, nextSplashSubType@l(r31)

	li r3, 0x3
	b returnFromGetLavaWavesSubType

.extern returnFromSaveGlobalPoisonSubType
.global SaveGlobalPoisonSubType
SaveGlobalPoisonSubType:
	stb r0, 0x2c(r4)
	lbz r3, 0x355(r31)
	stb r3, 0xBE7(r4)
	mr r3, r31
	b returnFromSaveGlobalPoisonSubType

.extern returnFromLoadGlobalSubType
.global LoadGlobalSubType
LoadGlobalSubType:
	lbz r30, 0xBE7(r3)				#get subType
	lis r29, nextSplashSubType@h	#load last used sub type
	ori r29, r29, nextSplashSubType@l
	stb r30, 0x0(r29)
	lbz r3, 0x2c(r3)
	b returnFromLoadGlobalSubType

.extern returnFromPlayerUsePoisonSplashSubType
.global PlayerUsePoisonSplashSubType
PlayerUsePoisonSplashSubType:
	lis r6, nextSplashSubType@h						#load last used sub type
	ori r6, r6, nextSplashSubType@l
	lbz r6, 0x0(r6)
	mulli r6, r6, 4

	lis r4, PlayerPoisonWaves@h						#load last used sub type
	ori r4, r4, PlayerPoisonWaves@l
	lwzx r4, r4, r6

	b returnFromPlayerUsePoisonSplashSubType

.extern returnFromPlayerUseLavaSplashSubType
.global PlayerUseLavaSplashSubType
PlayerUseLavaSplashSubType:
	lis r6, nextSplashSubType@h						#load last used sub type
	ori r6, r6, nextSplashSubType@l
	lbz r6, 0x0(r6)
	mulli r6, r6, 4

	lis r4, PlayerLavaWaves@h						#load last used sub type
	ori r4, r4, PlayerLavaWaves@l
	lwzx r4, r4, r6

	b returnFromPlayerUseLavaSplashSubType

.extern returnFromIceUseLavaSplashSubType
.global IceUseLavaSplashSubType
IceUseLavaSplashSubType:
	lis r6, nextSplashSubType@h						#load last used sub type
	ori r6, r6, nextSplashSubType@l
	lbz r6, 0x0(r6)
	mulli r6, r6, 4

	lis r4, PlayerLavaWaves@h						#load last used sub type
	ori r4, r4, PlayerLavaWaves@l
	lwzx r3, r4, r6

	b returnFromIceUseLavaSplashSubType

.extern returnFromUseDifferentSplashEffects3
.global UseDifferentSplashEffects3
UseDifferentSplashEffects3:
	lis r6, nextSplashSubType@h						#load last used sub type
	ori r6, r6, nextSplashSubType@l
	lbz r6, 0x0(r6)
	mulli r6, r6, 4

	lis r4, poisonbig01@h						#load last used sub type
	ori r4, r4, poisonbig01@l
	lwzx r3, r4, r6

	b returnFromUseDifferentSplashEffects3

.extern returnFromUseDifferentSplashEffects4
.global UseDifferentSplashEffects4
UseDifferentSplashEffects4:
	lis r6, nextSplashSubType@h						#load last used sub type
	ori r6, r6, nextSplashSubType@l
	lbz r6, 0x0(r6)
	mulli r6, r6, 4

	lis r4, poisonbig02@h						#load last used sub type
	ori r4, r4, poisonbig02@l
	lwzx r3, r4, r6

	b returnFromUseDifferentSplashEffects4

.extern returnFromPodobooUseLavaSplashSetting
.global PodobooUseLavaSplashSetting
PodobooUseLavaSplashSetting:
	lbz r6, 0x5(r30)								#get second setting byte
	mulli r6, r6, 4

	lis r4, PodobooWaves@h						#load last used sub type
	ori r4, r4, PodobooWaves@l
	lwzx r3, r4, r6

	b returnFromPodobooUseLavaSplashSetting

.extern returnFromIceUsePoisonSplashSubType
.global IceUsePoisonSplashSubType
IceUsePoisonSplashSubType:
	lis r7, nextSplashSubType@h						#load last used sub type
	ori r7, r7, nextSplashSubType@l
	lbz r7, 0x0(r7)
	mulli r7, r7, 4

	lis r4, IcePoisonSplashes@h						#load last used sub type
	ori r4, r4, IcePoisonSplashes@l
	lwzx r4, r4, r7

	b returnFromIceUsePoisonSplashSubType


.extern returnFromUseDifferentSplashEffects
.global UseDifferentSplashEffects
UseDifferentSplashEffects:
	lis r4, PTR_aWm_en_waterwav_803118c8@h			#new array
	ori r4, r4, PTR_aWm_en_waterwav_803118c8@l

	lis r5, nextSplashSubType@h						#load last used sub type
	ori r5, r5, nextSplashSubType@l
	lbz r5, 0x0(r5)
	mulli r5, r5, 32
	
	add r4, r4, r5									#select sub type entry address
	
	lwzx r4, r4, r0									#grab effect name
	b returnFromUseDifferentSplashEffects

.extern returnFromUseDifferentSplashEffects2
.global UseDifferentSplashEffects2
UseDifferentSplashEffects2:
	lis r3, PTR_aWm_en_waterwav_803118c8@h			#new array
	ori r3, r3, PTR_aWm_en_waterwav_803118c8@l

	lis r7, nextSplashSubType@h						#load last used sub type
	ori r7, r7, nextSplashSubType@l
	lbz r7, 0x0(r7)
	mulli r7, r7, 32
	
	add r3, r3, r7									#select sub type entry address
	
	lwzx r3, r3, r0									#grab effect name
	b returnFromUseDifferentSplashEffects2


.extern doneWithLavaParticlesColor
.global LavaParticlesColor
LavaParticlesColor:
    lwz r4, 4(r17)
    rlwinm r4, r4, 24, 28, 31 # (this->settings >> 8) & 0xF
    # what a huge waste of space since i'm not even using this lmao


    # doOrangeLavaParticles:
    li r4, 0xFF # R
    li r5, 0xFF # G
    li r6, 0x00 # B

    li r7, 0xFF # R
    li r8, 0x00 # G
    li r9, 0x00 # B

    b setLavaParticlesColor

setLavaParticlesColor:
    stb r4, 0x574(r17)
    stb r5, 0x575(r17)
    stb r6, 0x576(r17)

    stb r7, 0x578(r17)
    stb r8, 0x579(r17)
    stb r9, 0x57A(r17)

    li r4, 0xFF
    stb r4, 0x57B(r17) # Restore instruction

    b doneWithLavaParticlesColor



.extern obj_waterfull, obj_waterhalf, obj_magma, obj_poisonwater, obj_quicksand, obj_envfog
.data
.align 4
.global PTR_ARRAY_8031b7d0
PTR_ARRAY_8031b7d0:
	.long obj_waterfull
	.long obj_waterhalf
	.long obj_magma
	.long obj_poisonwater
	.long obj_quicksand
	.long obj_envfog
	.long obj_envfog

	.long obj_waterfull
	.long obj_waterhalf
	.long obj_magma
	.long obj_sludge
	.long obj_quicksand
	.long obj_envfog
	.long obj_envfog

	.long obj_waterfull # too lazy to remove these two, so they're just default
	.long obj_waterhalf
	.long obj_magma
	.long obj_poisonwater
	.long obj_quicksand
	.long obj_envfog
	.long obj_envfog

	.long obj_waterfull
	.long obj_waterhalf
	.long obj_magma
	.long obj_poisonwater
	.long obj_quicksand
	.long obj_envfog
	.long obj_envfog

.extern obj_magmawave
.global PTR_ARRAY_8031b988
PTR_ARRAY_8031b988:
	.long obj_waterhalf
	.long obj_magma
	.long obj_poisonwater
	.long obj_magmawave
	.long obj_quicksand

	.long obj_waterhalf
	.long obj_magma
	.long obj_sludge
	.long obj_magmawave
	.long obj_quicksand

	.long obj_waterhalf
	.long obj_magma
	.long obj_poisonwater
	.long obj_magmawave
	.long obj_quicksand

	.long obj_waterhalf
	.long obj_magma
	.long obj_poisonwater
	.long obj_magmawave
	.long obj_quicksand

.extern aWm_en_waterwav, aWm_en_cmnwat_0, aWm_en_waterspl, aWm_en_firevani, aWm_en_cmnmag_1, aWm_en_magmaw_0, aWm_en_poisonin, aWm_en_poisonwa
.global PTR_aWm_en_waterwav_803118c8
PTR_aWm_en_waterwav_803118c8:
	.long aWm_en_waterwav
	.long aWm_en_cmnwat_0
	.long aWm_en_waterspl
	.long aWm_en_firevani
	.long aWm_en_cmnmag_1
	.long aWm_en_magmaw_0
	.long aWm_en_poisonin
	.long aWm_en_poisonwa
	
	.long aWm_en_waterwav
	.long aWm_en_cmnwat_0
	.long aWm_en_waterspl
	.long aWm_en_firevani
	.long aWm_en_cmnmag_1
	.long aWm_en_magmaw_0
	.long Wm_en_poisoninbig01green
	.long Wm_en_poisonwavegreen

	.long aWm_en_waterwav
	.long aWm_en_cmnwat_0
	.long aWm_en_waterspl
	.long aWm_en_firevani
	.long aWm_en_cmnmag_1
	.long aWm_en_magmaw_0
	.long aWm_en_poisonin
	.long aWm_en_poisonwa

.global poisonbig01
poisonbig01:
	.long aWm_en_poisonin
	.long Wm_en_poisoninbig01green
	.long aWm_en_poisonin

.global poisonbig02
poisonbig02:
	.long Wm_en_poisoninbig02
	.long Wm_en_poisoninbig02green
	.long Wm_en_poisoninbig02


.extern obj_magmadeco
.global PTR_ARRAY_8031bb30
PTR_ARRAY_8031bb30:
	.long obj_magmadeco
	.long obj_magmadeco
	.long obj_poisondeco
	.long obj_magmadeco
	.long obj_magmadeco
	
	.long obj_magmadeco
	.long obj_magmadeco
	.long obj_sludgedeco
	.long obj_magmadeco
	.long obj_magmadeco
	
	.long obj_magmadeco
	.long obj_magmadeco
	.long obj_poisondeco
	.long obj_magmadeco
	.long obj_magmadeco

PlayerPoisonWaves:
	.long aWm_en_poisonwa
	.long Wm_en_poisonwavegreen
	.long aWm_en_poisonwa

PlayerLavaWaves:				#also used for frozen enemies!
	.long aWm_en_magmaw_0
	.long aWm_en_magmaw_0
	.long aWm_en_magmaw_0

PodobooWaves:
	.long aWm_en_magmaw_0
	.long aWm_en_magmaw_0
	.long aWm_en_magmaw_0
	.long aWm_en_poisonwa
	.long Wm_en_poisonwavegreen

#PlayerWaterWaves:
#	.long aWm_en_poisonwa
#	.long aWm_en_magmaw_0
#	.long aWm_en_poisonwa

IcePoisonSplashes:
	.long Wm_ob_icepoison
	.long Wm_ob_icegreenpoison
	.long Wm_ob_icepoison
	

liquidSetting:
	.byte 0x00

obj_sludge:
	.string "g3d/obj_sludge.brres"

obj_sludgedeco:
	.string "g3d/obj_sludgedeco.brres"

obj_poisondeco:
	.string "g3d/obj_poisondeco.brres"

Wm_en_poisonwavegreen:
	.string "Wm_en_poisonwavegreen"

Wm_en_poisoninbig01green:
	.string "Wm_en_poisoninbig01green"

Wm_ob_icepoison: # what the heck even is this?
	.string "Wm_ob_icepoison"

Wm_ob_icegreenpoison:
	.string "Wm_ob_icegreenpoison"

Wm_en_poisoninbig02:
	.string "Wm_en_poisoninbig02"

Wm_en_poisoninbig02green:
	.string "Wm_en_poisoninbig02green"

obj_waterwave:
	.string "g3d/obj_waterwave.brres"

obj_poisonwave:
	.string "g3d/obj_poisonwave.brres"