; --- Theme vars ---
music_theme_idx           DW 0    ; Which note we are playing
music_theme_tempo         DB 0    ; Duration counter
music_theme_active        DB 1    ; Mute flag (0 = mute, 1 = active)
music_theme_speed_counter DB 0    ; Speed counter


; --- Greensleeves: Full Score ---
; Format: Frequency, Duration (in ticks multiplied by music_theme_speed_counter)

greensleeves_data LABEL WORD
  ; --- VERSE (Alas, my love...) ---
  DW N_A4, 2, N_C5, 4, N_D5, 2, N_E5, 3, N_FS5, 1, N_E5, 2
  DW N_D5, 4, N_B4, 2, N_G4, 3, N_A4, 1, N_B4, 2
  DW N_C5, 4, N_A4, 2, N_A4, 3, N_GS4, 1, N_A4, 2
  DW N_B4, 4, N_GS4, 2, N_E4, 6

  DW N_A4, 2, N_C5, 4, N_D5, 2, N_E5, 3, N_FS5, 1, N_E5, 2
  DW N_D5, 4, N_B4, 2, N_G4, 3, N_A4, 1, N_B4, 2
  DW N_C5, 4, N_GS4, 2, N_A4, 3, N_B4, 1, N_GS4, 2
  DW N_A4, 6, N_A4, 6

  ; --- CHORUS (Greensleeves was all my joy...) ---
  DW N_G5, 6, N_G5, 3, N_FS5, 1, N_E5, 2
  DW N_D5, 4, N_B4, 2, N_G4, 3, N_A4, 1, N_B4, 2
  DW N_C5, 4, N_A4, 2, N_A4, 3, N_GS4, 1, N_A4, 2
  DW N_B4, 4, N_GS4, 2, N_E4, 6

  DW N_G5, 6, N_G5, 3, N_FS5, 1, N_E5, 2
  DW N_D5, 4, N_B4, 2, N_G4, 3, N_A4, 1, N_B4, 2
  DW N_C5, 4, N_GS4, 2, N_A4, 3, N_B4, 1, N_GS4, 2
  DW N_A4, 6, N_A4, 6

  DW N_OFF, 12            ; Small pause before restarting the loop

GREENSLEEVES_LEN EQU 53   ; Total number of notes (words / 2)
