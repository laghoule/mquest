;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;-----------------------------------------------------------
; HANDLE_KEYBOARD_INPUT
; Description: Handles keyboard input for the game
; Register: AX, BX, CX, DX
; Input: None
; Output: AL = 0 (nothing), 1 (mouvement), 2 (quit)
; Modified: music_theme_active, mute_flag
;-----------------------------------------------------------
HANDLE_KEYBOARD_INPUT PROC
  XOR AX, AX
  SHL AX, 1
  MOV BX, AX
  MOV BX, [char_data_table + BX]

  MOV AH, 01h                                 ; Read keyboard input buffer
  INT 16h
  JZ @hki_no_input

  MOV AH, 00h                                 ; Read key pressed on keyboard
  INT 16h

  CMP AH, KEY_ESC
  JE @hki_exit_game

  CMP AH, KEY_MUTE                            ; m key
  JE @hki_mute_music

  CMP AH, KEY_RIGHT
  JE @hki_move_right

  CMP AH, KEY_LEFT
  JE @hki_move_left

  CMP AH, KEY_UP
  JE @hki_move_up

  CMP AH, KEY_DOWN
  JE @hki_move_down

@hki_no_input:
  MOV [BX].CHARACTER.ch_event.ev_redraw, 0  ; No input, no redraw
  MOV AL, 0
  RET

@hki_move_right:
  MOV DX, RIGHT_DIR
  JMP @hki_move

@hki_move_left:
  MOV DX, LEFT_DIR
  JMP @hki_move

@hki_move_up:
  MOV DX, UP_DIR
  JMP @hki_move

@hki_move_down:
  MOV DX, DOWN_DIR

@hki_move:
  MOV CL, pending_tick
  MOV [BX].CHARACTER.ch_event.ev_redraw, 1  ; Input received, redraw
  XOR AX, AX                                ; Mia character index
  CALL MOVE_CHAR
  MOV AL, 1
  RET

; Mute / Unmute the music
@hki_mute_music:
  CMP mute_flag, 1                          ; Don't mute music if the mute flag is set (e.g. from command-line arguments)
  JE @hki_no_input

  CMP music_theme_active, 1
  JE @F
  MOV music_theme_active, 1
  JMP @hki_no_input
@@:
  MOV music_theme_active, 0
  CALL MUTE_SPEAKER
  JMP @hki_no_input

@hki_exit_game:
  MOV AL, 2
  RET
HANDLE_KEYBOARD_INPUT ENDP
