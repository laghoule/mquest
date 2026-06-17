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
  XOR AX, AX                                  ; char_index = 0 (Mia)
  SHL AX, 1                                   ; Convert char_index to char_data_table offset
  MOV BX, AX
  MOV BX, [char_data_table + BX]              ; Get character data from char_data_table

  MOV AH, 01h                                 ; Read keyboard input buffer
  INT 16h                                     ; Read key pressed on keyboard
  JZ @hki_no_input                            ; No key pressed, skip to no input

  MOV AH, 00h                                 ; Read key pressed on keyboard
  INT 16h                                     ; And clear the keyboard buffer

  CMP AH, KEY_ESC                             ; Escape key
  JE @hki_exit_game                           ; We exit game

  CMP AH, KEY_MUTE                            ; m key
  JE @hki_mute_music                          ; We mute music

  CMP AH, KEY_RIGHT                           ; Right arrow key
  JE @hki_move_right                          ; We jump to move right

  CMP AH, KEY_LEFT                            ; Left arrow key
  JE @hki_move_left                           ; We jump to move left

  CMP AH, KEY_UP                              ; Up arrow key
  JE @hki_move_up                             ; We jump to move up

  CMP AH, KEY_DOWN                            ; Down arrow key
  JE @hki_move_down                           ; We jump to move down

@hki_no_input:
  MOV [BX].CHARACTER.ch_event.ev_redraw, 0    ; No input, no redraw
  MOV AL, 0                                   ; Return 0
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
  MOV [BX].CHARACTER.ch_event.ev_redraw, 1  ; Input received, set redraw flag
  MOV CL, pending_tick                      ; Pending tick count
  XOR AX, AX                                ; Mia character index
  CALL MOVE_CHAR                            ; Move character
  MOV AL, 1                                 ; Return 1
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
  MOV AL, 2                                 ; Return 2
  RET
HANDLE_KEYBOARD_INPUT ENDP
