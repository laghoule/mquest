TITLE Animations of a pixel art girl
.MODEL SMALL
.8086
.STACK 100h

.DATA
  ; Girl animations sprite data
  INCLUDE assets/anim.inc

.CODE
MAIN PROC
  ; Initialize data segment
  MOV AX, @DATA
  MOV DS, AX

  ; Initialize mode 13h with bios call
  ; VGA memory at 0A000h
  MOV AX, 13h
  INT 10h
  MOV AX, 0A000h
  MOV ES, AX

  CALL GAME_LOOP

  ; Return to text mode
  MOV AX, 0003h
  INT 10h

  ; Return to dos
  MOV AX, 4C00h
  INT 21h

MAIN ENDP

GAME_LOOP PROC
  ; Save registers
  PUSH AX
  PUSH BX
  PUSH CX
  PUSH DX

NEXT_KEY:
  ; Get keyboard input
  ; Wait for a key press, this is a blocking call
  ; TODO: Implement the 01h interrupt (non-blocking)
  MOV AH, 00h
  INT 16h

  ; -- Key handling --
  ; https://www.fountainware.com/EXPL/bios_key_codes.htm
  CMP AH, 01h       ; Escape key
  JE EXIT_GAME

  CMP AH, 4Dh       ; Right arrow key
  JE RIGHT_DIRECTION

  CMP AH, 4Bh       ; Left arrow key
  JE LEFT_DIRECTION

  CMP AH, 48h       ; Up arrow key
  JE UP_DIRECTION

  CMP AH, 50h       ; Down arrow key
  JE DOWN_DIRECTION
  
  JMP NEXT_KEY      ; Other key press, ignore

RIGHT_DIRECTION:
LEFT_DIRECTION:
UP_DIRECTION:
DOWN_DIRECTION:

EXIT_GAME:

  ; Restore registers
  POP DX
  POP CX
  POP BX
  POP AX
  
  RET
GAME_LOOP ENDP

END MAIN
