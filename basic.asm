TITLE Mario Sprite 8086
.MODEL SMALL
.STACK 100h

.DATA
   testing LABEL BYTE
   INCLUDE assets\testing.inc

.CODE
MAIN PROC
             MOV   AX, @DATA
             MOV   DS, AX

  ; Mode 13h
             MOV   AX, 0013h
             INT   10h

             MOV   AX, 0A000h
             MOV   ES, AX

  ; Position (X=150, Y=90)
             MOV   AX, 90
             MOV   BX, 320
             MUL   BX
             ADD   AX, 150
             MOV   DI, AX

             LEA   SI, testing
             MOV   DX, 16       ; 16 lignes

  DRAW_Y:    
             PUSH  DI
             MOV   CX, 10       ; 16 pixels
  DRAW_X:    
             LODSB              ; Charger pixel de Mario
             OR    AL, AL       ; Est-ce que c'est 0 (transparent) ?
             JZ    SKIP_PIXEL   ; Si oui, on ne dessine pas
             MOV   ES:[DI], AL  ; Sinon, on affiche
  SKIP_PIXEL:
             INC   DI
             LOOP  DRAW_X
    
             POP   DI
             ADD   DI, 320      ; Ligne suivante
             DEC   DX
             JNZ   DRAW_Y

  ; Attendre une touche
             MOV   AH, 00h
             INT   16h

  ; Mode texte
             MOV   AX, 0003h
             INT   10h

             MOV   AX, 4C00h
             INT   21h
MAIN ENDP
END MAIN
