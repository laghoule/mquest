TITLE Mario VSync 8086
.MODEL SMALL
.STACK 100h

.DATA
  ; Sprite 16x16
  mario DB 0,0,0,4,4,4,4,4,0,0,0,0,0,0,0,0
        DB 0,0,4,4,4,4,4,4,4,4,4,0,0,0,0,0
        DB 0,0,6,6,6,15,15,6,15,0,0,0,0,0,0,0
        DB 0,6,15,6,15,15,15,6,15,15,15,0,0,0,0,0
        DB 0,6,15,6,6,15,15,15,6,15,15,15,0,0,0,0
        DB 0,0,6,15,15,15,15,6,6,6,6,0,0,0,0,0
        DB 0,0,0,15,15,15,15,15,15,15,0,0,0,0,0,0
        DB 0,0,4,4,1,4,4,4,0,0,0,0,0,0,0,0
        DB 0,4,4,4,1,4,4,1,4,4,4,0,0,0,0,0
        DB 4,4,4,4,1,1,1,1,4,4,4,4,0,0,0,0
        DB 15,15,4,1,14,1,1,14,1,4,15,15,0,0,0,0
        DB 15,15,15,1,1,1,1,1,1,15,15,15,0,0,0,0
        DB 15,15,1,1,1,1,1,1,1,1,15,15,0,0,0,0
        DB 0,0,1,1,1,0,0,1,1,1,0,0,0,0,0,0
        DB 0,6,6,6,0,0,0,0,6,6,6,0,0,0,0,0
        DB 6,6,6,6,0,0,0,0,6,6,6,6,0,0,0,0

.CODE
MAIN PROC
               MOV   AX, @DATA
               MOV   DS, AX

               MOV   AX, 0013h
               INT   10h
               MOV   AX, 0A000h
               MOV   ES, AX

  ; Initialisation des registres de position
               MOV   BX, 150       ; X
               MOV   BP, 90        ; Y

               CALL  DRAW_MARIO

  GAME_LOOP:
               MOV   AH, 00h
               INT   16h           ; Attente touche
               MOV   SI, AX        ; Sauvegarde touche

  ; --- C'EST ICI QUE LA MAGIE OPERE ---
  ; On attend le début du V-Blank avant de toucher à l'écran
               CALL  WAIT_RETRACE

  ; Maintenant le faisceau est remonté, on a quelques millisecondes
  ; pour effacer et redessiner sans que personne ne le voie.

               CALL  ERASE_MARIO

               MOV   AX, SI
               CMP   AH, 01h
               JE    FIN
               CMP   AH, 48h
               JE    M_UP
               CMP   AH, 50h
               JE    M_DOWN
               CMP   AH, 4Bh
               JE    M_LEFT
               CMP   AH, 4Dh
               JE    M_RIGHT
               JMP   REDRAW

  M_UP:        DEC   BP
               JMP   REDRAW
  M_DOWN:      INC   BP
               JMP   REDRAW
  M_LEFT:      DEC   BX
               JMP   REDRAW
  M_RIGHT:     INC   BX

  REDRAW:
               CALL  DRAW_MARIO
               JMP   GAME_LOOP

  FIN:
               MOV   AX, 0003h
               INT   10h
               MOV   AX, 4C00h
               INT   21h
MAIN ENDP

  ; --- PROCEDURE DE SYNCHRONISATION ---
WAIT_RETRACE PROC
               MOV   DX, 03DAh     ; Port d'état d'entrée VGA

  ; Si on est déjà dans le VSync, on attend qu'il finisse
  ; (pour être sûr de choper le DÉBUT du prochain)
@WAIT_END:
               IN    AL, DX
               TEST  AL, 8         ; Bit 3 = Retrace Verticale
               JNZ   @WAIT_END     ; Tant que c'est 1, on attend

  ; On attend que le VSync commence
@WAIT_START:
               IN    AL, DX
               TEST  AL, 8
               JZ    @WAIT_START   ; Tant que c'est 0, on attend

               RET
WAIT_RETRACE ENDP

  ; --- DESSIN ---
DRAW_MARIO PROC
               PUSH  BX
               PUSH  BP
               MOV   AX, BP
               MOV   CX, 320
               MUL   CX
               ADD   AX, BX
               MOV   DI, AX
               LEA   SI, mario
               MOV   DX, 16
  D_LOOP:
               PUSH  DI
               MOV   CX, 16
  D_PIX:
               LODSB
               OR    AL, AL
               JZ    D_SKIP
               MOV   ES:[DI], AL
  D_SKIP:
               INC   DI
               LOOP  D_PIX
               POP   DI
               ADD   DI, 320
               DEC   DX
               JNZ   D_LOOP
               POP   BP
               POP   BX
               RET
DRAW_MARIO ENDP

  ; --- EFFACEMENT ---
ERASE_MARIO PROC
               PUSH  BX
               PUSH  BP
               MOV   AX, BP
               MOV   CX, 320
               MUL   CX
               ADD   AX, BX
               MOV   DI, AX
               MOV   DX, 16
  E_LOOP:
               PUSH  DI
               MOV   CX, 16
               MOV   AL, 0
  E_PIX:
               MOV   ES:[DI], AL
               INC   DI
               LOOP  E_PIX
               POP   DI
               ADD   DI, 320
               DEC   DX
               JNZ   E_LOOP
               POP   BP
               POP   BX
               RET
ERASE_MARIO ENDP

END MAIN
