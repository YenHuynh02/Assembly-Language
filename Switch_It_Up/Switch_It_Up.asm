; Switch_It_Up.asm

#include C:\68HCS12\registers.inc

; Author: Yen Huynh
; S/N: 041068712
; Date: July 19, 2023

; Purpose:      To Display Patterns Associated with SW2, SW3, SW4 and SW5 on
;               LEDs on Port B on Dragon 12+ Trainer

; Operation:    Once the SW number has been determined, the pattern unique to it
;               is output on Port B (PORTB) by calling the internal subprocess
;               Display_Value, which also delays the output by 1/8 sec in order
;               to avoid flicker between values. The program then Loops back to
;               the beginning to get another SW value and the process
;               loops forever.

;                Note that if no switches are pressed, the display
;               remains blank. See code for SW5
;
FLICKER_DELAY   equ     125     ; 125 ms or 1/8 of a second
STACK           equ     $2000

; When one of switch S2 - S4 is pressed, these values are input on Port H (PTH)
; Note that only ONE bit can be a zero (0) at any one time
SW2_VAL equ     %11110111
SW3_VAL equ     %11111011
SW4_VAL equ     %11111101
SW5_VAL equ     %11111110

; These are the values to be output on Port B Leds (PORTB)
ALL_OFF equ     %00000000
PATTERN_2 equ   %00000010
PATTERN_3 equ   %00000011
PATTERN_4 equ   %00000100
PATTERN_5 equ   %00000101

        org     $2000
Start   lds     #STACK
        jsr     Config_SWs_and_LEDs

LEDsOff ldab    #ALL_OFF
        jsr     Display_Value   ; to LEDs
Get_SW  ldaa    PTH             ; get data from Switches

SW2     cmpa    #SW2_VAL        ; Is SW2 presssed? bit 3 = 0 ?
        bne     SW3             ; No, get another SW value
        ldab    #PATTERN_2      ; Yes, so set up to display Switch #: 2 base 2
        jsr     Display_Value   ; to LEDs
        bra     Get_SW          ; check again for presseed switch

SW3     cmpa    #SW3_VAL
        bne     SW4
        ldab    #PATTERN_3
        jsr     Display_Value   ; jump to the display switch
        bra     Get_SW
        
SW4     cmpa    #SW4_VAL
        bne     SW5
        ldab    #PATTERN_4
        jsr     Display_Value
        bra     Get_SW
        
SW5     cmpa    #SW5_VAL
        bne     LEDsOff
        ldab    #PATTERN_5
        jsr     Display_Value
        bra     Get_SW

Display_Value
        stab    PORTB           ; Value to LEDs
        ldaa    #FLICKER_DELAY  ; Delay 1/8 th of a second
        jsr     Delay_ms        ; to avoid flicker
        rts

#include C:\68HCS12\Lib\Config_SWs_and_LEDs.asm
#include C:\68HCS12\Lib\Delay_ms.asm

        end