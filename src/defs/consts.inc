SCREEN_WIDTH  EQU 320
SCREEN_HEIGHT EQU 200

CARACTER_WIDTH  EQU 16
CARACTER_HEIGHT EQU 16

; Key scan codes
; https://www.fountainware.com/EXPL/bios_key_codes.htm
KEY_ESC       EQU 01h
KEY_UP        EQU 48h
KEY_DOWN      EQU 50h
KEY_LEFT      EQU 4Bh
KEY_RIGHT     EQU 4Dh

; Default screen background
COLOR_BLACK   EQU 0 ; FIXME: should be background color

; VGA memory at 0A000h
VGA_ADDR      EQU 0A000h
