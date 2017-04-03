#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <SDL/SDL.h>
#include <SDL/SDL_image.h>

#define ROWS 60
#define COLS 60
#define OFF 0
#define ON 1
#define BLACK 8, 0, 0, 0, 0
#define scr_width 600
#define scr_height 600
#define cell_width (scr_width / ROWS)
#define cell_height (scr_height / COLS)

/** Note to self:
  * Always refer to the board as board[x][y] as to follow the general
  * standard for specifying coordinates. When looping, y must be declared
  * first in the outer loop so that it represents the rows while x, declared
  * within the y loop becomes the variable representing each column value.
 */

/** Bugs
  * = Severity -> Low
  *   - When ROWS or COLS is greater than the other, only a squared area
  *     is actually updated or a segfault is fired.
 */

/** We must hold two copies of the board so that we can analyze board and make
  * changes to temp when killing/creating cells so that we don't cause changes
  * to the board to affect the following cells.
 */
char board[ROWS][COLS];
char temp[ROWS][COLS];
SDL_Rect cells[ROWS][COLS]; /* Stores positions of each cell for blits. */

void randomize_board(void);
void initialize_grid(SDL_Surface* screen);
void blit_board(SDL_Surface* bcell, SDL_Surface* screen);
int num_neighbours(int x, int y);
void update_board(void);
int clear_board(SDL_Surface* screen, Uint32 color);
int clear_cell(SDL_Surface* screen, int x, int y, Uint32 color);
void initialize_cells_array(void);

int main(void) {
    SDL_Init(SDL_INIT_VIDEO);
    SDL_WM_SetCaption("Juego de la vida - Arquitectura I (2016)", NULL);
    SDL_Event event;
    int breaker = 0;
    int paused = 1;

    SDL_Surface* screen = SDL_SetVideoMode(
                              scr_width, scr_height, 0,
                              SDL_SWSURFACE);
    if (! screen) {
        perror("SDL_SetVideoMode");
        return EXIT_FAILURE;
    }
    Uint32 bgcolor = SDL_MapRGB(screen->format, 0xFF, 0xFF, 0xFF);
    if (SDL_FillRect(screen, &(screen->clip_rect), bgcolor) == -1) {
        perror("SDL_FillRect");
        return EXIT_FAILURE;
    }
    initialize_cells_array();
    initialize_grid(screen);
    SDL_Surface* bcell = SDL_CreateRGBSurface(
                              SDL_SWSURFACE, cell_width, cell_height, BLACK);
    if (! bcell) {
        perror("BLACK SDL_CreateRGBSurface");
        return EXIT_FAILURE;
    }
    SDL_Flip(screen);
    while (1) { /* Infinite game loop. */
        /** The event loop handles any events in the poll/queue
          * even while paused.
         */
        while (SDL_PollEvent(&event)) {
            switch (event.type) {
                case SDL_QUIT:
                    breaker = 1;
                    break;
                case SDL_KEYDOWN:
                    /* Pause on enter/return key press. */
                    if (event.key.keysym.sym == SDLK_KP_ENTER ||
                        event.key.keysym.sym == SDLK_RETURN) {
                        paused = !paused;
                    /* Space causes the board to be randomized. */
                    } else if (event.key.keysym.sym == SDLK_SPACE) {
                        SDL_FillRect(screen, &(screen->clip_rect), bgcolor);
                        randomize_board();
                    /* Escape button also quits. */
                    } else if (event.key.keysym.sym == SDLK_ESCAPE) {
                        breaker = 1;
                        break;
                    /* Either shift button clears the screen. */
                    } else if (event.key.keysym.sym == SDLK_RSHIFT ||
                               event.key.keysym.sym == SDLK_LSHIFT) {
                        if (clear_board(screen, bgcolor) == -1) {
                            perror("clear_board");
                            return EXIT_FAILURE;
                        }
                    }
                    break;
                case SDL_MOUSEBUTTONDOWN:
                    /** The only mouse event we handle is the left click.
                      * If the cell being clicked is alive, kill it.
                      * Otherwise, give it life.
                     */
                    if (event.button.button == SDL_BUTTON_LEFT) {
                        if (event.button.y > (ROWS * cell_height)) break;
                        int tx = floor(event.button.x / cell_width);
                        int ty = floor(event.button.y / cell_height);
                        if (board[tx][ty] == OFF) {
                            board[tx][ty] = ON;
                            temp[tx][ty] = ON;
                            SDL_BlitSurface(
                                bcell,
                                &(bcell->clip_rect),
                                screen,
                                &cells[tx][ty]);
                        } else if (clear_cell(screen, tx, ty, bgcolor) == -1) {
                                perror("clear_cell");
                                return EXIT_FAILURE;
                        }
                    }
                    break;
                default: continue;
            }
            if (breaker)
                break;
        }
        if (breaker)
            break;
        /* Redraw the grid so it's not painted over by clear_cell. */
        initialize_grid(screen);
        blit_board(bcell, screen);
        SDL_Flip(screen);
        if (!paused) {
            update_board();
            SDL_Delay(250);
            SDL_FillRect(screen, &(screen->clip_rect), bgcolor);
        }
    }
    return EXIT_SUCCESS;
}

void randomize_board(void) {
    /* Clear the board then randomly set ~1/5 of them to ON. */
    memset((void *)board, OFF, ROWS * COLS);
    for (int y = 0; y < ROWS; y++) {
        for (int x = 0; x < COLS; x++) {
            if (rand() % 5 == 0) {
                board[x][y] = ON;
            }
            temp[x][y] = board[x][y];
        }
    }
}

void initialize_grid(SDL_Surface* screen) {
    /** Position horizontal and veritcal lines to form a grid to
      * make it easier to count cell spaces when trying to draw things.
     */
    SDL_Surface* linex = SDL_CreateRGBSurface( /* Vertical lines */
                              SDL_SWSURFACE, 1, scr_height, BLACK);
    SDL_Surface* liney = SDL_CreateRGBSurface( /* Horizontal lines */
                              SDL_SWSURFACE, scr_width, 1, BLACK);
    SDL_Rect pos_x;
    SDL_Rect pos_y;
    pos_x.y = pos_y.x = 0;
    for (int i = 0; i < scr_width / (cell_width); i++) {
        pos_x.x = cell_width + cell_width * i;
        SDL_BlitSurface(linex, &(linex->clip_rect), screen, &pos_x);
    }
    for (int i = 0; i < scr_height / (cell_height); i++) {
        pos_y.y = cell_height + cell_height * i;
        SDL_BlitSurface(liney, &(liney->clip_rect), screen, &pos_y);
    }
}

void blit_board(SDL_Surface* bcell, SDL_Surface* screen) {
    /* Blit all the live cells onto the board. */
    for (int y = 0; y < ROWS; y++) {
        for (int x = 0; x < COLS; x++) {
            if (board[x][y] == ON) {
                SDL_BlitSurface(
                    bcell,
                    &(bcell->clip_rect),
                    screen,
                    &cells[x][y]);
            }
        }
    }
}

int num_neighbours(int x, int y) {
    /** Count the number of live cells all around the cell given by
      * the position (x, y). Of course, this includes all diagonal, vertical,
      * and horizontal living cells. The program works using a toroidal array,
      * thus we must check to see if it is necessary to wrap to the other side
      * of the array in order to find cells that must be taken into account.
     */
    int num_adj = 0;
    int tmpy = y;
    int tmpx = x;

    if (y-1 < 0)
        tmpy = ROWS - 1;
    else
        tmpy = y - 1;
    if (board[x][tmpy] == ON) num_adj++;
    if (y+1 >= ROWS)
        tmpy = 0;
    else
        tmpy = y + 1;
    if (board[x][tmpy] == ON) num_adj++;
    if (x-1 < 0)
        tmpx = COLS - 1;
    else
        tmpx = x - 1;
    if (board[tmpx][y] == ON) num_adj++;
    if (x+1 >= COLS)
        tmpx = 0;
    else
        tmpx = x + 1;
    if (board[tmpx][y] == ON) num_adj++;
    if (y-1 < 0)
        tmpy = ROWS - 1;
    else
        tmpy = y - 1;
    if (x-1 < 0)
        tmpx = COLS - 1;
    else
        tmpx = x - 1;
    if (board[tmpx][tmpy] == ON) num_adj++;
    if (x+1 >= COLS)
        tmpx = 0;
    else
        tmpx = x + 1;
    if (board[tmpx][tmpy] == ON) num_adj++;
    if (y+1 >= ROWS)
        tmpy = 0;
    else
        tmpy = y + 1;
    if (x+1 >= COLS)
        tmpx = 0;
    else
        tmpx = x + 1;
    if (board[tmpx][tmpy] == ON) num_adj++;
    if (x-1 < 0)
        tmpx = COLS - 1;
    else
        tmpx = x - 1;
    if (board[tmpx][tmpy] == ON) num_adj++;
    return num_adj;
}

void update_board(void) {
    /** Detirmine which cells live and which die. Operate on temp so that
      * each change does not affect following changes, then copy temp into
      * the main board to be displayed.
     */
    int neighbours = 0;

    for (int y = 0; y < ROWS; y++) {
        for (int x = 0; x < COLS; x++) {
            neighbours = num_neighbours(x, y);
            if (neighbours < 2 && board[x][y] == ON) {
                temp[x][y] = OFF; /* Dies by underpopulation. */
            } else if (neighbours > 3 && board[x][y] == ON) {
                temp[x][y] = OFF; /* Dies by overpopulation. */
            } else if (neighbours == 3 && board[x][y] == OFF) {
                temp[x][y] = ON; /* Become alive because of reproduction. */
            }
            /* Otherwise the cell lives with just the right company. */
        }
    }
    for (int y = 0; y < ROWS; y++) {
        for (int x = 0; x < COLS; x++) {
            board[x][y] = temp[x][y];
        }
    }
}

int clear_board(SDL_Surface* screen, Uint32 color) {
    /* Simply set both the main and temporary boards to completely off. */
    for (int y = 0; y < ROWS; y++) {
        for (int x = 0; x < COLS; x++) {
            board[x][y] = OFF;
            temp[x][y] = OFF;
        }
    }
    return SDL_FillRect(screen, &(screen->clip_rect), color);
}

int clear_cell(SDL_Surface* screen, int x, int y, Uint32 color) {
    /* Clear a cell by coloring it white and setting the board pos. to off. */
    SDL_Rect rect;
    rect.x = cell_width * x;
    rect.y = cell_height * y;
    board[x][y] = OFF;
    temp[x][y] = OFF;
    return SDL_FillRect(screen, &rect, color);
}

void initialize_cells_array(void) {
    /** Initialize the array of SDL_Rect structs that store the cell
      * coordinates by iteratively calculating their successive positions.
     */
    for (int y = 0; y < ROWS; y++) {
        for (int x = 0; x < COLS; x++) {
            (cells[x][y]).x = (cell_width * x);
            (cells[x][y]).y = (cell_height * y);
        }
    }
}
