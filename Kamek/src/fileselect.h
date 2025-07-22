#ifndef FILESELECT_H
#define FILESELECT_H

#include <common.h>
#include <game.h>
#include "fileload.h"

// String constants
const char* const CDHolderGroup      = "CDHolderGroup";
const char* const NormalExitStr      = "<Normal> %d-%d\n";
const char* const SecretExitStr      = "<Secret> %d-%d\n";
const char* const StarCoinCount      = "StarCoinCount";
const char* const ExitCount          = "ExitCount";
const char* const Picture_00         = "Picture_00";
const char* const FSStateDebugStr    = "State: %s\n";
const char* const FSDummyBrlanName   = "fileSelectBase_18_DummyAnim.brlan";
const char* const FSDummyGroup       = "DummyGroup";
const char* const FSDummyPane        = "DummyPane";
const char* const A00_window         = "A00_window";
const char* const ShowEraseCopy      = "fileSelectBase_18_ShowEraseCopy.brlan";
const char* const HideEraseCopy      = "fileSelectBase_18_HideEraseCopy.brlan";
const char* const N_posFile1_00      = "N_posFile1_00";

// Float constant
const float NewSCCWidth = 100.0f;

// Out_Stuff structure
struct OutStuff {
    u32 starCoinCount;
    u32 exitCount;
};
extern OutStuff Out_Stuff;

// Title and world name buffers
const u16 DFTitle[] = { 'F','i','l','e',' ','X',0 };
u16 ConvertedWorldName[32] = {0}; // 12+12+8 shorts = 32

const u16 WarpZoneName[] = { 'W','a','r','p',' ','Z','o','n','e',0 };

// Default save file info data
#ifdef FALLING_LEAF
const char DefaultSavefileInfoData_Name[16] = "Unknown Island";
#else
const char DefaultSavefileInfoData_Name[16] = "Henri's Island";
#endif

struct DefaultSavefileInfoDataStruct {
    char name[16];
    u8 reserved1[11];
    u8 reserved2[6];
    u32 color1;
    u32 color2;
    u32 color3;
    u32 color4;
    u32 color5;
    u32 color6;
    u16 shortVal;
    u8 byteVal1;
    u8 byteVal2;
    u8 byteVal3;
    u8 byteVal4;
    u8 byteVal5;
    u8 byteVal6;
    u8 byteVal7;
    u8 byteVal8;
};

const DefaultSavefileInfoDataStruct DefaultSavefileInfoData = {
    // name
    #ifdef FALLING_LEAF
    "Unknown Island",
    #else
    "Henri's Island",
    #endif
    // reserved1
    {0,0,0,0,0,0,0,0,0,0,0},
    // reserved2
    {0,0,0,0,0,0},
    // colors
    0xFFFF99FF, 0x1FB423FF,
    0x173714FF, 0x3C9135FF,
    0xFFFF99FF, 0x1FB423FF,
    // shortVal
    0x75,
    // bytes
    0x2E, 0xB,
    1, 1,
    0, 10
};

const u32 DefaultSavefileInfoDataEnd = 0;

#endif // FILESELECT_H