format PE GUI 4.0
entry start

include "include\win32ax.inc"

section ".data" data readable writeable
    include "SDLD.inc"

    ; tamaño cuadricula
    ROWS = 60
    COLS = 60

    ; constantes misc
    OFF = 0
    ON = 1
    BLACK 8, 0, 0, 0, 0

    ; tamaño pantalla
    scr_width = 600
    scr_height = 600
    cell_width = (scr_width / ROWS)
    cell_height = (scr_height / COLS)


section ".code" code readable executable
start:


    ; cierra la aplicacion
    .exit:
    invoke ExitProcess, 0
    ret


proc randomize_board
    ; limpia la cuadricula y enciende aleatoriamente algunas celdas

endp


proc initialize_grid,\
    SDL_Surface* screen
    ; inicializa la cuadricula

endp


proc blit_board,\
    SDL_Surface* bcell, SDL_Surface* screen
    ; refresca la cuadricula del tablero

endp


proc num_neighbours,\
    int x, int y
    ; calcula el nro de vecinos de una celda
endp


proc update_board
endp


proc clear_board,\
    SDL_Surface* screen, Uint32 color
    ; borra toda la cuadricula

endp


proc clear_cell,\
    SDL_Surface* screen, int x, int y, Uint32 color
    ; apaga una celda (la pinta de blanco)

endp


proc initialize_cells_array
    ; Inicializa el arreglo SDL_Rect para almacenar las celdas

endp


section ".idata" import data readable writeable

    library\
    user32,"user32.dll",\
    sdl,"sdl.dll",\

    include "include\kernel32.inc"
    include "include\user32.inc"
    include "SDLA.inc"

    import sdl_image,\
    IMG_Load,"IMG_Load"
