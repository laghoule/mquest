SCREEN_WIDTH    EQU 320
SCREEN_HEIGHT   EQU 200

TILE_WIDTH      EQU 16
TILE_HEIGHT     EQU 16
TILE_COLS       EQU 20
TILE_ROWS       EQU 12

CARACTER_WIDTH  EQU 16
CARACTER_HEIGHT EQU 17

DOWN_DIR        EQU 0
UP_DIR          EQU 1
LEFT_DIR        EQU 2
RIGHT_DIR       EQU 3

; Key scan codes
; https://www.fountainware.com/EXPL/bios_key_codes.htm
KEY_ESC         EQU 01h
KEY_UP          EQU 48h
KEY_DOWN        EQU 50h
KEY_LEFT        EQU 4Bh
KEY_RIGHT       EQU 4Dh

; Default screen background
COLOR_BLACK     EQU 0 ; FIXME: should be background color

; Video modes
; https://en.wikipedia.org/wiki/Mode_13h
VGA_ADDR        EQU 0A000h
TEXT_MODE       EQU 0003h
