SCREEN_WIDTH    EQU 320
SCREEN_HEIGHT   EQU 200

TILE_WIDTH      EQU 16
TILE_HEIGHT     EQU 16
TILE_BY_X       EQU 20
TILE_BY_Y       EQU 12

CARACTER_WIDTH  EQU 16
CARACTER_HEIGHT EQU 17

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
