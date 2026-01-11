;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; -----------------------------------------------------------------
; INIT_MUSIC_THEME
; Description: Initializes the music theme by setting the initial
; values for the music theme index, tempo, and speed counter.
; Input: SI (music data pointer)
; Output: None
; -----------------------------------------------------------------
INIT_MUSIC_THEME PROC
  MOV music_theme_idx, 0
  MOV music_theme_tempo, 0
  MOV music_theme_speed_counter, 0

  ; Immediately play the first note in the music data table.
  MOV BX, 0
  MOV AX, [SI + BX] ; TODO: replace with music_theme_data
  CALL SET_SPEAKER_FREQ
  RET
INIT_MUSIC_THEME ENDP

; -------------------------------------------------------
; SET_SPEAKER_FREQ
; Description: Plays a note on the PC Speaker
; Input: AX = Frequency to play (0 to mute the speaker)
; Output: None
; -------------------------------------------------------
SET_SPEAKER_FREQ PROC
  OR AX, AX         ; Check if the frequency is zero.
  JZ @spf_mute      ; If the frequency is zero, mute the speaker.

  ; ---------------------------------------------------------------------------
  ; PIT DIVIDER DEFINITION
  ; The PC Speaker is driven by the Intel 8253 PIT (Programmable Interval Timer).
  ; The PIT receives a base clock frequency of 1,193,181 Hz.
  ; To produce a specific note, we send a 16-bit 'Divider' to Port 42h.
  ; Formula: DIVIDER = 1,193,181 / Target_Frequency_Hz
  ; Example: Middle C (261.63 Hz) -> 1,193,181 / 261.63 = 4560 (11D0h)
  ; More information: https://en.wikipedia.org/wiki/Intel_8253
  ; ---------------------------------------------------------------------------

  PUSH AX           ; Save the frequency value
  MOV AL, 0B6h      ; Configure PIT Channel 2 for Mode 3
  OUT 43h, AL       ; Send the command byte to the PIT control address
  POP AX            ; Restore the frequency value
  OUT 42h, AL       ; Send the low byte of the divider to the pit  base clock frequency
  MOV AL, AH
  OUT 42h, AL       ; Send the high byte of the divider

  IN AL, 61h        ; Enable the speaker gate
  OR AL, 03h        ; Set the speaker gate bit
  OUT 61h, AL       ; Enable the speaker gate
  RET

@spf_mute:
  CALL MUTE_SPEAKER ; We mute the speaker
  RET
SET_SPEAKER_FREQ ENDP

;---------------------------------------------------------------------------
; UPDATE_MUSIC_THEME
; Description: Updates the music theme by advancing the music theme index,
; tempo, and speed counter.
; Input: SI (music data pointer)
; Output: None
;--------------------------------------------------------------------------
UPDATE_MUSIC_THEME PROC
  SAVE_REGS

  ; Control the speed of the music theme
  INC music_theme_speed_counter
  CMP music_theme_speed_counter, 20
  JL @umt_skipping                      ; Skip updating the music theme if the speed counter is less than 20
  MOV music_theme_speed_counter, 0      ; Reset the speed counter

  INC music_theme_tempo

  ; Retrieve the duration of the current note.
  MOV BX, music_theme_idx               ; Load the music theme index into BX
  ADD BX, BX                            ; Index * 2
  ADD BX, BX                            ; Index * 4
  MOV AX, [SI + BX + 2]  ; Load note duration (data in AL)

  CMP music_theme_tempo, AL             ; Compare the current tempo with the note duration
  JL @umt_skipping                      ; The current note is still playing.

  ; --- The current note has finished, advance to the next one ---
  MOV music_theme_tempo, 0              ; Reset the tempo counter
  INC music_theme_idx                   ; Increment the music theme index (next note)
  CMP music_theme_idx, GREENSLEEVES_LEN ; Check if we've reached the end of the song
  JNE @umt_play                         ; If not, jump to play the next note
  MOV music_theme_idx, 0                ; Loop back to the beginning of the song.

@umt_play:
  MOV BX, music_theme_idx               ; Load the music theme index into BX
  ADD BX, BX                            ; Inxex * 2
  ADD BX, BX                            ; Index * 4
  MOV AX, [SI + BX]      ; Get the new note's frequency
  CALL SET_SPEAKER_FREQ                 ; Immediately send the new frequency to the speaker

@umt_skipping:
  RESTORE_REGS
  RET
UPDATE_MUSIC_THEME ENDP

;----------------------------------
; MUTE_SPEAKER
; Description: Mute the PC Speaker
; Inputs: None
; Outputs: None
; ---------------------------------
MUTE_SPEAKER PROC
  IN AL, 61h       ; Read the current status of the speaker control port.
  AND AL, 0FCh     ; Clear bits 0 and 1 to disable the speaker.
  OUT 61h, AL      ; Apply the changes to the speaker control port.
  RET
MUTE_SPEAKER ENDP
