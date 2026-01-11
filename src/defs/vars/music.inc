; --- Theme vars ---
music_theme_idx           DW 0    ; Which note we are playing
music_theme_tempo         DB 0    ; Duration counter
music_theme_active        DB 1    ; Mute flag (0 = mute, 1 = active)
music_theme_speed_counter DB 0    ; Speed counter

; --- Frequencies (PIT Dividers) ---
N_E4  EQU 3619  ; E4
N_G4  EQU 3044  ; G4
N_GS4 EQU 2875  ; G#4
N_A4  EQU 2712  ; A4
N_B4  EQU 2415  ; B4
N_C5  EQU 2280  ; C5
N_D5  EQU 2031  ; D5
N_E5  EQU 1809  ; E5
N_FS5 EQU 1612  ; F#5
N_G5  EQU 1522  ; G5
N_OFF EQU 0

; --- Greensleeves: Full Score ---
; Format: Frequency, Duration (in ticks multiplied by your music_theme_speed_counter)

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
