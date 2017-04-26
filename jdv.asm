    format PE GUI 4.0
    entry start

    include "include\win32ax.inc"

section ".data" data readable writeable
    include "SDLD.inc"

    ; tamaÃ±o cuadricula
    ROWS = 60
    COLS = 60

    ; constantes misc
    COFF = 0
    CON = 1

    ; tamaño pantalla
    SCR_WIDTH = 600
    SCR_HEIGHT = 600
    SCREEN_BPP = 32
    cell_width = (SCR_WIDTH / ROWS)
    cell_height = (SCR_HEIGHT / COLS)

    BLACK dd 0

    ; The frames per second
    FRAMES_PER_SECOND = 25

    event SDL_Event
    bcell SDL_Surface

    screen dd 0
    breaker dd 0
    paused dd 1
    quit dd FALSE

    bgcolor dd 0

section ".code" code readable executable
start:
    cinvoke SDL_Init, SDL_INIT_VIDEO

    ; Set up the screen
    cinvoke SDL_SetVideoMode, SCR_WIDTH, SCR_HEIGHT, SCREEN_BPP, SDL_SWSURFACE
    mov dword [screen], eax

    ; Set the window caption
    cinvoke SDL_WM_SetCaption, "Juego de la vida - Arquitectura I (2016)", NULL

    ;cinvoke SDL_MapRGB screen->format, 0xFF, 0xFF, 0xFF
    cinvoke SDL_MapRGB, eax, 0xFF, 0xFF, 0xFF
    mov dword [bgcolor], eax

    ;initialize_cells_array();
    stdcall initialize_cells_array

    ;initialize_grid(screen);
    stdcall initialize_grid, dword [screen]

    cinvoke SDL_CreateRGBSurface, SDL_SWSURFACE, cell_width, cell_height, BLACK
    mov dword [bcell], eax

    cinvoke SDL_Flip, dword [screen]
    cmp eax, -1
    je .exit

    ; While the user hasn't quit
    .while ( dword [quit] = FALSE )

	; While there's events to handle
	cinvoke SDL_PollEvent, event
	.if ( eax )

	    ; If the user has Xed out the window
	    .if ( byte [event.type] = SDL_QUIT )

		; Quit the program
		mov dword [quit], TRUE

	    .endif

	.endif

	; Update the screen
	cinvoke SDL_Flip, dword [screen]
	cmp eax, -1
	je .exit

	; Cap the frame rate
	.if ( signed eax < 1000 / FRAMES_PER_SECOND )
	    mov ecx, 1000 / FRAMES_PER_SECOND
	    sub ecx, eax
	    cinvoke SDL_Delay, ecx
	.endif

    .endw

    ; cierra la aplicacion
    .exit:
	cinvoke SDL_Quit
	;invoke ExitProcess, 0
	ret

; -----------------------------------
; procedimientos

proc randomize_board
     ; limpia la cuadricula y enciende aleatoriamente algunas celdas
      ret
endp


proc initialize_grid, screen
     ; inicializa la cuadricula

     ret
endp


; proc blit_board,\
;     SDL_Surface* bcell, SDL_Surface* screen
;     ; refresca la cuadricula del tablero

; endp


; proc num_neighbours,\
;     int x, int y
;     ; calcula el nro de vecinos de una celda
; endp


; proc update_board
; endp


; proc clear_board,\
;     SDL_Surface* screen, Uint32 color
;     ; borra toda la cuadricula

; endp


; proc clear_cell,\
;     SDL_Surface* screen, int x, int y, Uint32 color
;     ; apaga una celda (la pinta de blanco)

; endp


proc initialize_cells_array
     ; Inicializa el arreglo SDL_Rect para almacenar las celdas

     ret
endp


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