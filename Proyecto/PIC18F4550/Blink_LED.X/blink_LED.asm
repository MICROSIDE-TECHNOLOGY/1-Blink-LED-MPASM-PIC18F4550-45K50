;====================================================================

	LIST P=18F4550 
	#include "P18f4550.INC" ;ENCABEZADO

;====================================================================
; Bits de configuracion
;--------------------------------------------------------------------

  CONFIG  PLLDIV = 5            ; PLL Prescaler Selection bits (Divide by 5 (20 MHz oscillator input))
  CONFIG  CPUDIV = OSC2_PLL3    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /2][96 MHz PLL Src: /3])
  CONFIG  USBDIV = 2            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes from the 96 MHz PLL divided by 2)
  CONFIG  FOSC = HSPLL_HS       ; Oscillator Selection bits (HS oscillator, PLL enabled (HSPLL))
  CONFIG  FCMEN = ON            ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor enabled)
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = SOFT            ; Brown-out Reset Enable bits (Brown-out Reset enabled and controlled by software (SBOREN is enabled))
  CONFIG  BORV = 1              ; Brown-out Reset Voltage bits (Setting 2 4.33V)
  CONFIG  VREGEN = ON           ; USB Voltage Regulator Enable bit (USB voltage regulator enabled)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

;====================================================================
; Macros
;--------------------------------------------------------------------

	#DEFINE	LED		 LATA,4  ;LED PIN A4

;====================================================================
; MEMORIA DE DATOS
;--------------------------------------------------------------------

	CBLOCK  0x00
	REG1
	REG2
	REG3
	ENDC

;====================================================================
; VECTOR DE INICIO
;--------------------------------------------------------------------

	ORG		0x2000
	GOTO		START
	
	ORG	  	0x2008
	RETFIE

	ORG	    	0x2018
	RETFIE

;====================================================================
; PROGRAMA PRINCIPAL
;--------------------------------------------------------------------
START	                      ; PUNTO DE ENTRADA DEL PROGRAMA EN REINICIO
	SETF	ADCON1	      ; PUERTO A SE CONFIGURA DIGITAL
	SETF	TRISA	      ; PUERTO A SE CONFIGURA COMO ENTRADAS
        BCF     TRISA,4       ; PIN RA4 SE CONFIGURA COMO SALIDA
        CLRF	LATA	      ; SE LIMPIA PUESRTO A
        
LOOP    BTG    LED	      ; CAMBIO DE ESTADO DE PIN RA4
        ; RETARDO 500mS ( 5 x Base 100mS)
	CALL 	DELAY_100MS	  ;
        CALL 	DELAY_100MS	  ; 
	CALL 	DELAY_100MS	  ;
	CALL 	DELAY_100MS	  ;
	CALL 	DELAY_100MS	  ;

	GOTO	LOOP
			
;====================================================================
; RETARDOS
;--------------------------------------------------------------------

DELAY_100MS			;100mS
	MOVLW	.17	        ;MUEVE LITERAL EN BASE 10 A WREG
	MOVWF	REG1		;MUEVE WREG A REG1
LOOP1	MOVLW	.204
	MOVWF	REG2
LOOP2	MOVLW	.114
	MOVWF	REG3
LOOP3	DECFSZ	REG3		;DECREMENTA REG3, OMITE "GOTO LOOP3" SI REG3 = 0
	GOTO	LOOP3
	DECFSZ	REG2
	GOTO	LOOP2
	DECFSZ	REG1
	GOTO	LOOP1
	RETURN
END