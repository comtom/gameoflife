;
; SDLA.inc (SDL API for WIN32)
;
; SDL 1.2.11 includes written by Raedwulf
; a.k.a. Tai Chi Minh Ralph Eastwood
;
; There's no warranty for the correctness nor completeness of this file
; However, please mail me at tcmreastwood@ntlworld.com if you spot
; any errors in here.
;
; Version Date: 07/11/2006 (dd/mm/yyyy)
;

import sdl,\
SDL_AddTimer,'SDL_AddTimer',\
SDL_AllocRW,'SDL_AllocRW',\
SDL_AudioDriverName,'SDL_AudioDriverName',\
SDL_AudioInit,'SDL_AudioInit',\
SDL_AudioQuit,'SDL_AudioQuit',\
SDL_BuildAudioCVT,'SDL_BuildAudioCVT',\
SDL_CDClose,'SDL_CDClose',\
SDL_CDEject,'SDL_CDEject',\
SDL_CDName,'SDL_CDName',\
SDL_CDNumDrives,'SDL_CDNumDrives',\
SDL_CDOpen,'SDL_CDOpen',\
SDL_CDPause,'SDL_CDPause',\
SDL_CDPlay,'SDL_CDPlay',\
SDL_CDPlayTracks,'SDL_CDPlayTracks',\
SDL_CDResume,'SDL_CDResume',\
SDL_CDStatus,'SDL_CDStatus',\
SDL_CDStop,'SDL_CDStop',\
SDL_ClearError,'SDL_ClearError',\
SDL_CloseAudio,'SDL_CloseAudio',\
SDL_CondBroadcast,'SDL_CondBroadcast',\
SDL_CondSignal,'SDL_CondSignal',\
SDL_CondWait,'SDL_CondWait',\
SDL_CondWaitTimeout,'SDL_CondWaitTimeout',\
SDL_ConvertAudio,'SDL_ConvertAudio',\
SDL_ConvertSurface,'SDL_ConvertSurface',\
SDL_CreateCond,'SDL_CreateCond',\
SDL_CreateCursor,'SDL_CreateCursor',\
SDL_CreateMutex,'SDL_CreateMutex',\
SDL_CreateRGBSurface,'SDL_CreateRGBSurface',\
SDL_CreateRGBSurfaceFrom,'SDL_CreateRGBSurfaceFrom',\
SDL_CreateSemaphore,'SDL_CreateSemaphore',\
SDL_CreateThread,'SDL_CreateThread',\
SDL_CreateYUVOverlay,'SDL_CreateYUVOverlay',\
SDL_Delay,'SDL_Delay',\
SDL_DestroyCond,'SDL_DestroyCond',\
SDL_DestroyMutex,'SDL_DestroyMutex',\
SDL_DestroySemaphore,'SDL_DestroySemaphore',\
SDL_DisplayFormat,'SDL_DisplayFormat',\
SDL_DisplayFormatAlpha,'SDL_DisplayFormatAlpha',\
SDL_DisplayYUVOverlay,'SDL_DisplayYUVOverlay',\
SDL_EnableKeyRepeat,'SDL_EnableKeyRepeat',\
SDL_EnableUNICODE,'SDL_EnableUNICODE',\
SDL_Error,'SDL_Error',\
SDL_EventState,'SDL_EventState',\
SDL_FillRect,'SDL_FillRect',\
SDL_Flip,'SDL_Flip',\
SDL_FreeCursor,'SDL_FreeCursor',\
SDL_FreeRW,'SDL_FreeRW',\
SDL_FreeSurface,'SDL_FreeSurface',\
SDL_FreeWAV,'SDL_FreeWAV',\
SDL_FreeYUVOverlay,'SDL_FreeYUVOverlay',\
SDL_GL_GetAttribute,'SDL_GL_GetAttribute',\
SDL_GL_GetProcAddress,'SDL_GL_GetProcAddress',\
SDL_GL_LoadLibrary,'SDL_GL_LoadLibrary',\
SDL_GL_Lock,'SDL_GL_Lock',\
SDL_GL_SetAttribute,'SDL_GL_SetAttribute',\
SDL_GL_SwapBuffers,'SDL_GL_SwapBuffers',\
SDL_GL_Unlock,'SDL_GL_Unlock',\
SDL_GL_UpdateRects,'SDL_GL_UpdateRects',\
SDL_GetAppState,'SDL_GetAppState',\
SDL_GetAudioStatus,'SDL_GetAudioStatus',\
SDL_GetClipRect,'SDL_GetClipRect',\
SDL_GetCursor,'SDL_GetCursor',\
SDL_GetError,'SDL_GetError',\
SDL_GetEventFilter,'SDL_GetEventFilter',\
SDL_GetGammaRamp,'SDL_GetGammaRamp',\
SDL_GetKeyName,'SDL_GetKeyName',\
SDL_GetKeyRepeat,'SDL_GetKeyRepeat',\
SDL_GetKeyState,'SDL_GetKeyState',\
SDL_GetModState,'SDL_GetModState',\
SDL_GetMouseState,'SDL_GetMouseState',\
SDL_GetRGB,'SDL_GetRGB',\
SDL_GetRGBA,'SDL_GetRGBA',\
SDL_GetRelativeMouseState,'SDL_GetRelativeMouseState',\
SDL_GetThreadID,'SDL_GetThreadID',\
SDL_GetTicks,'SDL_GetTicks',\
SDL_GetVideoInfo,'SDL_GetVideoInfo',\
SDL_GetVideoSurface,'SDL_GetVideoSurface',\
SDL_GetWMInfo,'SDL_GetWMInfo',\
SDL_Has3DNow,'SDL_Has3DNow',\
SDL_Has3DNowExt,'SDL_Has3DNowExt',\
SDL_HasAltiVec,'SDL_HasAltiVec',\
SDL_HasMMX,'SDL_HasMMX',\
SDL_HasMMXExt,'SDL_HasMMXExt',\
SDL_HasRDTSC,'SDL_HasRDTSC',\
SDL_HasSSE,'SDL_HasSSE',\
SDL_HasSSE2,'SDL_HasSSE2',\
SDL_Init,'SDL_Init',\
SDL_InitSubSystem,'SDL_InitSubSystem',\
SDL_JoystickClose,'SDL_JoystickClose',\
SDL_JoystickEventState,'SDL_JoystickEventState',\
SDL_JoystickGetAxis,'SDL_JoystickGetAxis',\
SDL_JoystickGetBall,'SDL_JoystickGetBall',\
SDL_JoystickGetButton,'SDL_JoystickGetButton',\
SDL_JoystickGetHat,'SDL_JoystickGetHat',\
SDL_JoystickIndex,'SDL_JoystickIndex',\
SDL_JoystickName,'SDL_JoystickName',\
SDL_JoystickNumAxes,'SDL_JoystickNumAxes',\
SDL_JoystickNumBalls,'SDL_JoystickNumBalls',\
SDL_JoystickNumButtons,'SDL_JoystickNumButtons',\
SDL_JoystickNumHats,'SDL_JoystickNumHats',\
SDL_JoystickOpen,'SDL_JoystickOpen',\
SDL_JoystickOpened,'SDL_JoystickOpened',\
SDL_JoystickUpdate,'SDL_JoystickUpdate',\
SDL_KillThread,'SDL_KillThread',\
SDL_Linked_Version,'SDL_Linked_Version',\
SDL_ListModes,'SDL_ListModes',\
SDL_LoadBMP_RW,'SDL_LoadBMP_RW',\
SDL_LoadFunction,'SDL_LoadFunction',\
SDL_LoadObject,'SDL_LoadObject',\
SDL_LoadWAV_RW,'SDL_LoadWAV_RW',\
SDL_LockAudio,'SDL_LockAudio',\
SDL_LockSurface,'SDL_LockSurface',\
SDL_LockYUVOverlay,'SDL_LockYUVOverlay',\
SDL_LowerBlit,'SDL_LowerBlit',\
SDL_MapRGB,'SDL_MapRGB',\
SDL_MapRGBA,'SDL_MapRGBA',\
SDL_MixAudio,'SDL_MixAudio',\
SDL_NumJoysticks,'SDL_NumJoysticks',\
SDL_OpenAudio,'SDL_OpenAudio',\
SDL_PauseAudio,'SDL_PauseAudio',\
SDL_PeepEvents,'SDL_PeepEvents',\
SDL_PollEvent,'SDL_PollEvent',\
SDL_PumpEvents,'SDL_PumpEvents',\
SDL_PushEvent,'SDL_PushEvent',\
SDL_Quit,'SDL_Quit',\
SDL_QuitSubSystem,'SDL_QuitSubSystem',\
SDL_RWFromConstMem,'SDL_RWFromConstMem',\
SDL_RWFromFP,'SDL_RWFromFP',\
SDL_RWFromFile,'SDL_RWFromFile',\
SDL_RWFromMem,'SDL_RWFromMem',\
SDL_ReadBE16,'SDL_ReadBE16',\
SDL_ReadBE32,'SDL_ReadBE32',\
SDL_ReadBE64,'SDL_ReadBE64',\
SDL_ReadLE16,'SDL_ReadLE16',\
SDL_ReadLE32,'SDL_ReadLE32',\
SDL_ReadLE64,'SDL_ReadLE64',\
SDL_RegisterApp,'SDL_RegisterApp',\
SDL_RemoveTimer,'SDL_RemoveTimer',\
SDL_SaveBMP_RW,'SDL_SaveBMP_RW',\
SDL_SemPost,'SDL_SemPost',\
SDL_SemTryWait,'SDL_SemTryWait',\
SDL_SemValue,'SDL_SemValue',\
SDL_SemWait,'SDL_SemWait',\
SDL_SemWaitTimeout,'SDL_SemWaitTimeout',\
SDL_SetAlpha,'SDL_SetAlpha',\
SDL_SetClipRect,'SDL_SetClipRect',\
SDL_SetColorKey,'SDL_SetColorKey',\
SDL_SetColors,'SDL_SetColors',\
SDL_SetCursor,'SDL_SetCursor',\
SDL_SetError,'SDL_SetError',\
SDL_SetEventFilter,'SDL_SetEventFilter',\
SDL_SetGamma,'SDL_SetGamma',\
SDL_SetGammaRamp,'SDL_SetGammaRamp',\
SDL_SetModState,'SDL_SetModState',\
SDL_SetModuleHandle,'SDL_SetModuleHandle',\
SDL_SetPalette,'SDL_SetPalette',\
SDL_SetTimer,'SDL_SetTimer',\
SDL_SetVideoMode,'SDL_SetVideoMode',\
SDL_ShowCursor,'SDL_ShowCursor',\
SDL_SoftStretch,'SDL_SoftStretch',\
SDL_ThreadID,'SDL_ThreadID',\
SDL_UnloadObject,'SDL_UnloadObject',\
SDL_UnlockAudio,'SDL_UnlockAudio',\
SDL_UnlockSurface,'SDL_UnlockSurface',\
SDL_UnlockYUVOverlay,'SDL_UnlockYUVOverlay',\
SDL_UnregisterApp,'SDL_UnregisterApp',\
SDL_UpdateRect,'SDL_UpdateRect',\
SDL_UpdateRects,'SDL_UpdateRects',\
SDL_UpperBlit,'SDL_UpperBlit',\
SDL_VideoDriverName,'SDL_VideoDriverName',\
SDL_VideoInit,'SDL_VideoInit',\
SDL_VideoModeOK,'SDL_VideoModeOK',\
SDL_VideoQuit,'SDL_VideoQuit',\
SDL_WM_GetCaption,'SDL_WM_GetCaption',\
SDL_WM_GrabInput,'SDL_WM_GrabInput',\
SDL_WM_IconifyWindow,'SDL_WM_IconifyWindow',\
SDL_WM_SetCaption,'SDL_WM_SetCaption',\
SDL_WM_SetIcon,'SDL_WM_SetIcon',\
SDL_WM_ToggleFullScreen,'SDL_WM_ToggleFullScreen',\
SDL_WaitEvent,'SDL_WaitEvent',\
SDL_WaitThread,'SDL_WaitThread',\
SDL_WarpMouse,'SDL_WarpMouse',\
SDL_WasInit,'SDL_WasInit',\
SDL_WriteBE16,'SDL_WriteBE16',\
SDL_WriteBE32,'SDL_WriteBE32',\
SDL_WriteBE64,'SDL_WriteBE64',\
SDL_WriteLE16,'SDL_WriteLE16',\
SDL_WriteLE32,'SDL_WriteLE32',\
SDL_WriteLE64,'SDL_WriteLE64',\
SDL_getenv,'SDL_getenv',\
SDL_iconv,'SDL_iconv',\
SDL_iconv_close,'SDL_iconv_close',\
SDL_iconv_open,'SDL_iconv_open',\
SDL_iconv_string,'SDL_iconv_string',\
SDL_lltoa,'SDL_lltoa',\
SDL_mutexP,'SDL_mutexP',\
SDL_mutexV,'SDL_mutexV',\
SDL_putenv,'SDL_putenv',\
SDL_revcpy,'SDL_revcpy',\
SDL_snprintf,'SDL_snprintf',\
SDL_strdup,'SDL_strdup',\
SDL_strlcat,'SDL_strlcat',\
SDL_strlcpy,'SDL_strlcpy',\
SDL_strtoull,'SDL_strtoull',\
SDL_ulltoa,'SDL_ulltoa',\
SDL_vsnprintf,'SDL_vsnprintf'

