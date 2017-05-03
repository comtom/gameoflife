    format PE GUI 4.0
    entry start

    include "include\win32ax.inc"

section ".data" data readable writeable
    include "SDLD.inc"

    ; tamaño cuadricula
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

    screen SDL_Surface

    ;screen dd 0
    breaker dd 0
    paused  dd 1
    quit    dd FALSE

    bgcolor dd 0
    color   dd 0

section ".code" code readable executable
start:
    cinvoke SDL_Init, SDL_INIT_VIDEO

    ; Set up the screen
    cinvoke SDL_SetVideoMode, SCR_WIDTH, SCR_HEIGHT, SCREEN_BPP, SDL_SWSURFACE
    mov dword [screen], eax

    ; Set the window caption
    cinvoke SDL_WM_SetCaption, "Juego de la vida - Arquitectura I (2016)", NULL

    ;cinvoke SDL_MapRGB screen->format, 0xFF, 0xFF, 0xFF
    cinvoke SDL_MapRGB, dword [screen], 0xFF, 0xFF, 0xFF
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
	    stdcall procesar_eventos

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

proc procesar_eventos
    ; realiza acciones ante ciertos eventos de teclado/mouse
    ; dibujar o borrar pixel cuando se hace clic
    ; aleatorizar tablero
    ; iniciar/pausar/reanudar la simulacion

    ; evento del teclado
    .if ( byte [event.type] = SDL_KEYDOWN )

	; Set the velocity
	.if ( dword [event.key.keysym.sym] = SDLK_KP_ENTER )
	    ; pausar/reanudar
	    ;paused = !paused;

	.elseif ( dword [event.key.keysym.sym] = SDLK_SPACE )
	    cinvoke SDL_FillRect, dword [screen], dword [screen], dword [color]
	    stdcall randomize_board

	.elseif ( dword [event.key.keysym.sym] = SDLK_ESCAPE )
	    ; sale de la aplicacion
	    mov [quit], TRUE
	.elseif ( dword [event.key.keysym.sym] = SDLK_LSHIFT )
	    ; limpia la pantalla
	    stdcall clear_board, screen, bgcolor

	.endif

    ; evento del mouse
    .elseif ( byte [event.type] = SDL_MOUSEBUTTONDOWN )

	.if ( dword [event.key.keysym.sym] = SDL_BUTTON_LEFT )

	.endif


    .endif

    ret
endp

proc randomize_board
    ; limpia la cuadricula y enciende aleatoriamente algunas celdas

    ret
endp


proc initialize_grid, screen
    ; inicializa la cuadricula

    cinvoke SDL_CreateRGBSurface, SDL_SWSURFACE, 1, SCR_HEIGHT, BLACK
    mov dword edx, eax

    cinvoke SDL_CreateRGBSurface, SDL_SWSURFACE, SCR_WIDTH, 1, BLACK
    mov dword edx, eax

    ; SDL_Rect pos_x;
    ; SDL_Rect pos_y;
    ; pos_x.y = pos_y.x = 0;
    ; for (int i = 0; i < scr_width / (cell_width); i++) {
    ;	  pos_x.x = cell_width + cell_width * i;
    ;	  SDL_BlitSurface(linex, &(linex->clip_rect), screen, &pos_x);
    ; }

    ; mov      DWORD PTR _i$2[ebp], 0
    ; jmp      SHORT ini_go

    ; ini_ciclo1:
    ; mov      ecx, DWORD PTR _i$2[ebp]
    ; add      ecx, 1
    ; mov      DWORD PTR _i$2[ebp], ecx

    ; ini_go:
    ; cmp      DWORD PTR _i$2[ebp], 60  ; 0000003cH
    ; jge      ini_ciclo2
    ; imul     edx, DWORD PTR _i$2[ebp], 10
    ; add      edx, 10		  ; 0000000aH
    ; mov      DWORD PTR _pos_x$[ebp], edx
    ; invoke
    ; jmp      ini_ciclo1



    ; for (int i = 0; i < scr_height / (cell_height); i++) {
    ;	  pos_y.y = cell_height + cell_height * i;
    ;	  SDL_BlitSurface(liney, &(liney->clip_rect), screen, &pos_y);
    ; }

    ; ini_ciclo2:
    ; mov      DWORD PTR _i$1[ebp], 0
    ; jmp      ini_siempre
    
    ; ini_siempre:
    ; cmp      DWORD PTR _i$1[ebp], 60  ; 0000003cH
    ; jge      ini_ciclo2
    ; imul     ecx, DWORD PTR _i$1[ebp], 10
    ; add      ecx, 10		  ; 0000000aH
    ; mov      DWORD PTR _pos_y$[ebp], ecx
    ; mov      eax, DWORD PTR _i$1[ebp]
    ; add      eax, 1
    ; mov      DWORD PTR _i$1[ebp], eax

    ret
endp


proc blit_board, bcell, screen
    ; refresca la cuadricula del tablero

    ret
endp


proc num_neighbours, x, y
    ; calcula el nro de vecinos de una celda

    ret
endp


proc update_board
    ret
endp


proc clear_board, screen, color
    ; borra las dos matrices (recorre la matriz y pone todas sus celdas en OFF)
    ; devuelve pantalla en blanco

    cinvoke SDL_FillRect,  [screen], [screen], [color]
    ret
endp


proc clear_cell, screen, x, y, color
    ; apaga una celda (la pinta de blanco)

    ret
endp


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
