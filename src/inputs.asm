;-----------------------------------------------------------
; HANDLE_KEYBOARD_INPUT
; INPUT:  None
; Output: AL = 0 (nothing), 1 (mouvement), 2 (quit)
;-----------------------------------------------------------
HANDLE_KEYBOARD_INPUT PROC
  MOV AH, 01h             ; Read keyboard input buffer
  INT 16h
  JZ hki_no_input

  MOV AH, 00h             ; Read key pressed on keyboard
  INT 16h

  CMP AH, KEY_ESC
  JE hki_exit_game

  CMP AH, KEY_RIGHT
  JE hki_move_right

  CMP AH, KEY_LEFT
  JE hki_move_left

  CMP AH, KEY_UP
  JE hki_move_up

  CMP AH, KEY_DOWN
  JE hki_move_down

hki_no_input:
  MOV AL, 0
  RET

hki_move_right:
  CALL MOVE_MIA_RIGHT
  JMP hki_return

hki_move_left:
  CALL MOVE_MIA_LEFT
  JMP hki_return

hki_move_up:
  CALL MOVE_MIA_UP
  JMP hki_return

hki_move_down:
  CALL MOVE_MIA_DOWN

hki_return:
  MOV AL, 1
  RET

hki_exit_game:
  MOV AL, 2
  RET
HANDLE_KEYBOARD_INPUT ENDP
