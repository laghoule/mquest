; Tile width: 1 byte
; Tile height: 1 byte
; Number of pixel total: 1 byte
; Number of tiles total: 1 byte
; TODO: This is not a good idea, remove the header (regenerate assets)
PIC_HDR_SIZE EQU 4      ; .pic file format

SCREEN_WIDTH    EQU 320
SCREEN_HEIGHT   EQU 200

; Key scan codes
; https://www.fountainware.com/EXPL/bios_key_codes.htm
KEY_ESC   EQU 01h
KEY_UP    EQU 48h
KEY_DOWN  EQU 50h
KEY_LEFT  EQU 4Bh
KEY_RIGHT EQU 4Dh
KEY_MUTE  EQU 32h   ; m key
