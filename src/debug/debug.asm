;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

DEBUG_BLIT_32X32 PROC
  PUSH ES
  PUSH DS
  PUSH SI
  PUSH DI
  PUSH CX
  PUSH DX

  MOV AX, 0A000h
  MOV ES, AX                  ; ES = VGA Screen
  MOV DI, 0
  MOV SI, OFFSET metatile_sp_buffer ; SI = Notre buffer 32x32

  MOV DX, 32                  ; Hauteur = 32 lignes
@dbg_line:
  PUSH DI
  MOV CX, 16                  ; 32 pixels / 2 = 16 words
  REP MOVSW                   ; Copie une ligne à l'écran
  POP DI
  ADD DI, 320                 ; Ligne suivante écran (320)
  DEC DX
  JNZ @dbg_line

  POP DX
  POP CX
  POP DI
  POP SI
  POP DS
  POP ES
  RET
DEBUG_BLIT_32X32 ENDP
