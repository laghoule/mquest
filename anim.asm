TITLE Animations of a pixel art girl
.MODEL SMALL
.8086
.STACK 100h

.DATA
  ; Girl animations sprite data
  INCLUDE assets/anim.inc

  pos_x DW 150
  pos_y DW 90

  width_screen DW 320
  height_screen DW 200

  width_sprite DW 16
  height_sprite DW 17

  curr_sprite DB g_front_1   ; Front animation for starting point
  anim_state DB 0            ; 0, 1, 2 (three animations state)

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

; --- Game loop ---
GAME_LOOP PROC
  ; Save registers
  PUSH AX BX CX DX SI DI

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
  POP AX BX CX DX SI DI
  RET
GAME_LOOP ENDP

; -- Erase girl animation --
ERASE_GIRL PROC
  ; Save registers
  PUSH AX BX CX DX SI DI

  ; Clear direction flag
  CLD

  ; Calcul DI = (pos_y * 320) + pos_x
  ; Memory address of the sprite
  MOV AX, pos_y
  MUL width_screen      ; This can be optimized (costly on 8086)
  ADD AX, pos_x
  MOV DI, AX            ; First pixel of the sprite

  MOV AL, 00h           ; Black color (screen background)
  MOV DX, height_sprite

ERASE_LINE:
  PUSH DI                ; Save DI (begin of line)
  MOV  CX, width_sprite  ; Width of the sprite
  REP  STOSB             ; Fill the line with black pixels (MOV ES:DI AL | INC DI | DEC CX)
  POP  DI                ; Restore DI (begin of line)

  ADD DI, width_screen   ; Move to next line
  DEC DX                 ; Decrement height
  
  JNZ ERASE_LINE         ; If height > 0, repeat

  ; Restore registers
  POP AX BX CX DX SI DI
  RET
ERASE_GIRL

END MAIN
