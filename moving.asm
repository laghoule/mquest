TITLE Girl Register 8086
.MODEL SMALL
.STACK 100h

.DATA
  ; Sprite 16x16
  include assets/girl.inc

.CODE
MAIN PROC
              MOV   AX, @DATA
              MOV   DS, AX

  ; Mode 13h
              MOV   AX, 0013h
              INT   10h
              MOV   AX, 0A000h
              MOV   ES, AX

  ; --- INITIALISATION DES REGISTRES ---
              MOV   BX, 150      ; BX = Position X
              MOV   BP, 90       ; BP = Position Y (On utilise BP car DX est cassé par MUL)

  ; Premier affichage
              CALL  DRAW_GIRL

  GAME_LOOP:
  ; 1. Attendre une touche
              MOV   AH, 00h
              INT   16h          ; AH = Scan Code

  ; 2. Sauvegarder la touche dans un registre sûr (SI n'est pas utilisé ici)
              MOV   SI, AX

  ; 3. Effacer Girl (utilise BX et BP actuels)
              CALL  ERASE_GIRL

  ; 4. Restaurer la touche depuis SI et tester
              MOV   AX, SI

              CMP   AH, 01h      ; ESC
              JE    FIN
              CMP   AH, 48h      ; Haut
              JE    M_UP
              CMP   AH, 50h      ; Bas
              JE    M_DOWN
              CMP   AH, 4Bh      ; Gauche
              JE    M_LEFT
              CMP   AH, 4Dh      ; Droite
              JE    M_RIGHT

              JMP   REDRAW       ; Touche inconnue -> on redessine juste

  M_UP:       DEC   BP           ; Y--
              JMP   REDRAW
  M_DOWN:     INC   BP           ; Y++
              JMP   REDRAW
  M_LEFT:     DEC   BX           ; X--
              JMP   REDRAW
  M_RIGHT:    INC   BX           ; X++

  REDRAW:
  ; 5. Dessiner à la nouvelle position (BX, BP)
              CALL  DRAW_GIRL
              JMP   GAME_LOOP

  FIN:
              MOV   AX, 0003h
              INT   10h
              MOV   AX, 4C00h
              INT   21h
MAIN ENDP

  ; --- DESSINER (Utilise BX pour X, BP pour Y) ---
DRAW_GIRL PROC
              PUSH  BX           ; Sauvegarder BX (X)
              PUSH  BP           ; Sauvegarder BP (Y)

  ; Calcul adresse : (BP * 320) + BX
              MOV   AX, BP
              MOV   CX, 320
              MUL   CX           ; DX:AX = BP * 320. Attention, DX est modifié !
              ADD   AX, BX
              MOV   DI, AX

              LEA   SI, p_dos_1    ; Source des données (nécessite DS correct)
              MOV   DX, 17       ; Hauteur (On peut utiliser DX maintenant, MUL est fini)

  D_L:
              PUSH  DI
              MOV   CX, 16
  D_P:
              LODSB              ; Charge DS:SI dans AL
              OR    AL, AL
              JZ    D_S
              MOV   ES:[DI], AL
  D_S:
              INC   DI
              LOOP  D_P
              POP   DI
              ADD   DI, 320
              DEC   DX
              JNZ   D_L

              POP   BP           ; Restaurer les registres de position
              POP   BX
              RET
DRAW_GIRL ENDP

  ; --- EFFACER (Utilise BX pour X, BP pour Y) ---
ERASE_GIRL PROC
              PUSH  BX
              PUSH  BP

              MOV   AX, BP
              MOV   CX, 320
              MUL   CX
              ADD   AX, BX
              MOV   DI, AX

              MOV   DX, 17       ; Hauteur
  E_L:
              PUSH  DI
              MOV   CX, 16
              MOV   AL, 0        ; Noir
  E_P:
              MOV   ES:[DI], AL  ; Ecrit directement
              INC   DI
              LOOP  E_P
              POP   DI
              ADD   DI, 320
              DEC   DX
              JNZ   E_L

              POP   BP
              POP   BX
              RET
ERASE_GIRL ENDP

END MAIN
