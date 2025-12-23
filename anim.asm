TITLE Animations of a pixel art girl
.MODEL SMALL
.8086
.STACK 100h

; Useful macros
INCLUDE defs/macros.inc

.DATA
  INCLUDE defs/consts.inc
  INCLUDE assets/anim.inc   ; animations sprite data

  pos_x DW 150
  pos_y DW 90

  curr_sprite DW OFFSET g_front_1   ; Front animation for starting point
  anim_state  DB 0                  ; 0, 1, 2 (three animations state)

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
  SAVE_REGS

NEXT_KEY:
  ; Get keyboard input
  ; Wait for a key press, this is a blocking call
  ; TODO: Implement the 01h interrupt (non-blocking)
  MOV AH, 00h
  INT 16h

  ; -- Key handling --
  ; https://www.fountainware.com/EXPL/bios_key_codes.htm
  CMP AH, KEY_ESC
  JE EXIT_GAME

  CMP AH, KEY_RIGHT
  JE RIGHT_DIRECTION

  CMP AH, KEY_LEFT
  JE LEFT_DIRECTION

  CMP AH, KEY_UP
  JE UP_DIRECTION

  CMP AH, KEY_DOWN
  JE DOWN_DIRECTION

  ; Other key press, ignore
  JMP NEXT_KEY

RIGHT_DIRECTION:
  CALL ERASE_GIRL

LEFT_DIRECTION:
  CALL ERASE_GIRL

UP_DIRECTION:
  CALL ERASE_GIRL

DOWN_DIRECTION:
  CALL ERASE_GIRL

EXIT_GAME:
  RESTORE_REGS
  RET
GAME_LOOP ENDP

; --- Erase girl ---
ERASE_GIRL PROC
  SAVE_REGS
  CLD ; Clear direction flag, ensure right direction for STOBS operation

  ; Calcul DI = (pos_y * 320) + pos_x
  ; Memory address of the sprite
  MOV AX, pos_y
  MOV BX, SCREEN_WIDTH
  MUL BX                ; This can be optimized (costly on 8086)
  ADD AX, pos_x
  MOV DI, AX            ; First pixel of the sprite

  MOV AL, 00h           ; Black color (screen background)
  MOV DX, GIRL_HEIGHT

ERASE_LINE:
  PUSH DI                ; Save DI (begin of line)
  MOV  CX, GIRL_WIDTH    ; Width of the sprite
  REP  STOSB             ; Fill the line with black pixels (MOV ES:DI AL | INC DI | DEC CX)
  POP  DI                ; Restore DI (begin of line)

  ADD DI, SCREEN_WIDTH   ; Move to next line
  DEC DX                 ; Decrement height

  JNZ ERASE_LINE         ; If height > 0, repeat

  RESTORE_REGS
  RET
ERASE_GIRL ENDP

; --- Draw girl right direction ---
DRAW_GIRL_RIGHT PROC
  SAVE_REGS

  RESTORE_REGS
  RET
DRAW_GIRL_RIGHT ENDP

END MAIN
