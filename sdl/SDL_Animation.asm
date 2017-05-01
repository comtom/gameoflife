    format PE GUI 4.0
    entry start

    include "..\include\win32ax.inc"

;------------------------------------------------------------------------------

section ".data" data readable writeable


    include "SDLD.inc"


    usesdef fix uses ebx ecx edx

    ; Screen attributes
    SCREEN_WIDTH = 520
    SCREEN_HEIGHT = 120
    SCREEN_BPP = 32

    ; The frames per second
    FRAMES_PER_SECOND = 25

    ; The dimensions of the hero
    HERO_WIDTH = 34
    HERO_HEIGHT = 45

    ; The direction of the hero
    HERO_RIGHT = 0
    HERO_LEFT = 1

    align 4

    quit dd FALSE

    ; The surfaces
    sky dd 0
    hero dd 0
    background dd 0
    stage dd 0
    screen dd 0

    sky.x dd 0
    sky.y dd 0
    background.x dd 0
    background.y dd 0
    stage.x dd 0
    stage.y dd 0
    hero.x dd 0

    ; The timer
    started dd 0
    startTicks dd 0

    ; The hero
    velocity dd 0
    frame dd 0
    status dd 0

    ; The hero sprite sheet
    heroLeft:
    dw 0, HERO_HEIGHT, HERO_WIDTH, HERO_HEIGHT
    dw HERO_WIDTH, HERO_HEIGHT, HERO_WIDTH, HERO_HEIGHT
    dw 2*HERO_WIDTH, HERO_HEIGHT, HERO_WIDTH, HERO_HEIGHT

    heroRight:
    dw 0, 0, HERO_WIDTH, HERO_HEIGHT
    dw HERO_WIDTH, 0, HERO_WIDTH, HERO_HEIGHT
    dw 2*HERO_WIDTH, 0, HERO_WIDTH, HERO_HEIGHT

    align 4

    ; The event structure
    event SDL_Event


;--------------------------------------------------------------------------------------------------

section ".code" code readable executable
start:

    ; Initialize
    stdcall init
    cmp eax, -1
    je .exit

    ; Load the files
    stdcall load_files
    cmp eax, -1
    je .exit

    ; Setup the hero
    stdcall hero.init

    ; While the user hasn't quit
    .while ( dword [quit] = FALSE )

	; Start the frame timer
	stdcall timer.start

	; While there's events to handle
	cinvoke SDL_PollEvent, event
	.if ( eax )

	    ; Handle events for the hero
	    stdcall hero.events

	    ; If the user has Xed out the window
	    .if ( byte [event.type] = SDL_QUIT )

		; Quit the program
		mov dword [quit], TRUE

	    .endif

	.endif

	; Blit surfaces on the screen
	stdcall apply_surface, dword [sky.x], dword [sky.y], dword [sky], dword [screen], NULL
	stdcall apply_surface, dword [background.x], dword [background.y], dword [background], dword [screen], NULL
	stdcall apply_surface, dword [stage.x], dword [stage.y], dword [stage], dword [screen], NULL

	; Move the hero
	stdcall hero.move

	; Show hero on the screen
	stdcall hero.show

	; Update the screen
	cinvoke SDL_Flip, dword [screen]
	cmp eax, -1
	je .exit

	; Cap the frame rate
	stdcall fps.get_ticks
	.if ( signed eax < 1000 / FRAMES_PER_SECOND )
	    mov ecx, 1000 / FRAMES_PER_SECOND
	    sub ecx, eax
	    cinvoke SDL_Delay, ecx
	.endif

    .endw

    ; Clean up
    stdcall clean_up

	.exit:
    ;invoke ExitProcess, 0
    ret

;--------------------------------------------------------------------------------------------------

proc load_files

    ; Load the sprite sheets

    stdcall load_image, "hero.png"
    mov dword [hero], eax

    stdcall load_image, "background.png"
    mov dword [background], eax

    stdcall load_image, "stage.png"
    mov dword [stage], eax

    stdcall load_image, "sky.png"
    mov dword [sky], eax

    .if ( dword [hero] = -1 | dword [background] = -1 | dword [stage] = -1 |  dword [sky] = -1	)
	mov eax, -1
	ret
    .endif

    mov eax, TRUE

    ret
endp

; /////////////////////////////////////////////////////////////////////////////////////////////////


; The hero


; /////////////////////////////////////////////////////////////////////////////////////////////////


proc hero.events

    ; If a key was pressed
    .if ( byte [event.type] = SDL_KEYDOWN )

	; Set the velocity
	.if ( dword [event.key.keysym.sym] = SDLK_RIGHT )
	    add dword [velocity], HERO_WIDTH/8

	.elseif ( dword [event.key.keysym.sym] = SDLK_LEFT )
	    sub dword [velocity], HERO_WIDTH/8

	.endif

    ; If a key was released
    .elseif ( byte [event.type] = SDL_KEYUP )

	; Set the velocity
	.if ( dword [event.key.keysym.sym] = SDLK_RIGHT )
	    sub dword [velocity], HERO_WIDTH/8

	.elseif ( dword [event.key.keysym.sym] = SDLK_LEFT )
	    add dword [velocity], HERO_WIDTH/8

	.endif

    .endif

    ret
endp

;--------------------------------------------------------------------------------------------------

proc hero.init

    ; Initialize movement variables
    mov dword [hero.x], SCREEN_WIDTH/2
    mov dword [velocity], 0

    ; Initialize animation variables
    mov dword [frame], 1
    mov dword [status], HERO_RIGHT

    ret
endp

;--------------------------------------------------------------------------------------------------

proc hero.move

    ; Move
    mov eax, [velocity]
    add [hero.x], eax

    ; Keep hero in bounds
    .if ( ( signed dword [hero.x] < 0 ) | ( signed dword [hero.x] > ( SCREEN_WIDTH-HERO_WIDTH ) ) )

	sub dword [hero.x], eax

    .endif

    ret
endp

;--------------------------------------------------------------------------------------------------

proc hero.show

    ; If hero is moving left
    .if ( signed dword [velocity] < 0 )

	; Set the animation to left
	mov dword [status], HERO_LEFT

	; Move to the next frame in the animation
	add dword [frame], 1

	; Move the stage
	add dword [stage.x], 4
	.if ( signed dword [stage.x] > 0 )
	    mov dword [stage.x], -SCREEN_WIDTH
	.endif

	; Move the background
	add dword [background.x], 2
	.if ( signed dword [background.x] > 0 )
	    mov dword [background.x], -SCREEN_WIDTH
	.endif

	; Move the sky
	add dword [sky.x], 1
	.if ( signed dword [sky.x] > 0 )
	    mov dword [sky.x], -SCREEN_WIDTH
	.endif

    ; If hero is moving right
    .elseif ( signed dword [velocity] > 0 )

	; Set the animation to right
	mov dword [status], HERO_RIGHT

	; Move to the next frame in the animation
	add dword [frame], 1

	; Move the stage
	sub dword [stage.x], 4
	.if ( signed dword [stage.x] <= -SCREEN_WIDTH )
	    mov dword [stage.x], 0
	.endif

	; Move the background
	sub dword [background.x], 2
	.if ( signed dword [background.x] <= -SCREEN_WIDTH )
	    mov dword [background.x], 0
	.endif

	; Move the sky
	sub dword [sky.x], 1
	.if ( signed dword [sky.x] <= -SCREEN_WIDTH )
	    mov dword [sky.x], 0
	.endif

    ; If hero standing
    .else

	; Restart the animation
	mov dword [frame], 1

    .endif

    ; Loop the animation
    .if ( dword [frame] >= 3 )

	mov dword [frame], 0

    .endif

    ; Show the hero
    .if ( dword [status] = HERO_RIGHT )

	imul eax, dword [frame], sizeof.SDL_Rect
	add eax, heroRight
	stdcall apply_surface, dword [hero.x], SCREEN_HEIGHT - HERO_HEIGHT - 10, dword [hero], dword [screen], eax

    .elseif ( dword [status] = HERO_LEFT )

	imul eax, dword [frame], sizeof.SDL_Rect
	add eax, heroLeft
	stdcall apply_surface, dword [hero.x], SCREEN_HEIGHT - HERO_HEIGHT - 10, dword [hero], dword [screen], eax

    .endif

    ret
endp

; /////////////////////////////////////////////////////////////////////////////////////////////////


; The timer


; /////////////////////////////////////////////////////////////////////////////////////////////////

proc timer.start usesdef

    ; Initialize the variables
    mov dword [started], TRUE

    cinvoke SDL_GetTicks
    mov dword [startTicks], eax

    ret
endp

;--------------------------------------------------------------------------------------------------

proc timer.stop

    ; Stop the timer
    mov dword [started], FALSE

    ret
endp

;--------------------------------------------------------------------------------------------------

proc fps.get_ticks usesdef

    ; If the timer is running
    .if ( dword [started] = TRUE )

	; Return the current time minus the start time
	cinvoke SDL_GetTicks
	sub eax, dword [startTicks]
	ret

    .endif

    ; If the timer isn't running
    xor eax, eax

    ret
endp


; /////////////////////////////////////////////////////////////////////////////////////////////////


; SDL Basic


; /////////////////////////////////////////////////////////////////////////////////////////////////


proc init usesdef

    ; Initialize all SDL subsystems
    cinvoke SDL_Init, SDL_INIT_EVERYTHING
    .if ( eax = -1 )
	ret
    .endif

    ; Set up the screen
    cinvoke SDL_SetVideoMode, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_BPP, SDL_SWSURFACE
    mov dword [screen], eax
    .if ( eax = NULL )
	mov eax, -1
	ret
    .endif

    ; Set the window caption
    cinvoke SDL_WM_SetCaption, "Arquitectura I - TP 2016", NULL

    mov eax, TRUE

    ret
endp

;--------------------------------------------------------------------------------------------------

proc clean_up usesdef

    ; Free the surfaces
    cinvoke SDL_FreeSurface, dword [sky]
    cinvoke SDL_FreeSurface, dword [background]
    cinvoke SDL_FreeSurface, dword [stage]
    cinvoke SDL_FreeSurface, dword [hero]

    ; Quit SDL
    cinvoke SDL_Quit

    ret
endp

;--------------------------------------------------------------------------------------------------

proc apply_surface usesdef,\
    x:dword, y:dword, source:dword, destination:dword, clip:dword

    ; Holds offsets
    local dstRect SDL_Rect

    ; Get offsets
    mov ax, word [x]
    mov word [dstRect.x], ax
    mov cx, word [y]
    mov word [dstRect.y], cx

    ; Blit
    cinvoke SDL_UpperBlit, dword [source], dword [clip], dword [destination], addr dstRect

    ret
endp

;--------------------------------------------------------------------------------------------------

proc load_image usesdef,\
    filename:dword

    local loadedImage dd 0
    local optimizedImage dd 0
    local colorKey dd 0

    ; The image that's loaded
    cinvoke IMG_Load, dword [filename]
    mov dword [loadedImage], eax

    ; If the image loaded
    .if ( eax <> NULL )

	; Create an optimized surface
	cinvoke SDL_DisplayFormat, dword [loadedImage]
	mov dword [optimizedImage], eax

	; Free the old surface
	cinvoke SDL_FreeSurface, dword [loadedImage]

	; If the surface was optimized
	.if ( dword [optimizedImage] <> NULL )

	    ; Color key surface
	    mov eax, dword [optimizedImage]
	    mov eax, dword [eax+SDL_Surface.format]
	    cinvoke SDL_MapRGB, eax, 0, 0xFF, 0xFF
	    mov dword [colorKey], eax
	    cinvoke SDL_SetColorKey, dword [optimizedImage], SDL_SRCCOLORKEY, dword [colorKey]

	.endif

    .endif

    ; Return the optimized surface
    mov eax, dword [optimizedImage]
    ret
endp


;--------------------------------------------------------------------------------------------------

section ".idata" import data readable writeable

    library\
    user32,"user32.dll",\
    sdl,"sdl.dll",\
    sdl_image,"sdl_image.dll"

    include "..\include\api\kernel32.inc"
    include "..\include\api\user32.inc"
    include "SDLA.inc"

    import sdl_image,\
    IMG_Load,"IMG_Load"
