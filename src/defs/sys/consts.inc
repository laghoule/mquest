; Tile width: 1 byte
; Tile height: 1 byte
; Number of pixel total: 2 bytes
; Number of tiles total: 1 byte
PIC_HDR_SIZE EQU 5      ; .pic file format

; Tile width: 1 byte
; Tile height: 1 byte
TIL_HDR_SIZE EQU 3      ; .til file format

; Scene width: 1 byte
; Scene height: 1 byte
MAP_HDR_SIZE EQU 2      ; .map file format

SCREEN_WIDTH    EQU 320
SCREEN_HEIGHT   EQU 200

; Video modes
; https://en.wikipedia.org/wiki/Mode_13h
VGA_ADDR        EQU 0A000h
TEXT_MODE       EQU 0003h


; Key scan codes
; https://www.fountainware.com/EXPL/bios_key_codes.htm
KEY_ESC   EQU 01h
KEY_UP    EQU 48h
KEY_DOWN  EQU 50h
KEY_LEFT  EQU 4Bh
KEY_RIGHT EQU 4Dh
KEY_MUTE  EQU 32h   ; m key
