; BCD_Counter.asm
; Author:               D. Haley, Faculty
; Modified by:          Yen Huynh
; Student Number(s):    041068712
; Course:               CST8216 Winter 2021
; Date:                 July 29th, 2023
;
; Purpose       BCD Counter $00 - $15 (BCD) using Hex Displays
;               and a single register, Accumulator A, for the count
;               The range of counting can be altered by changing the
;               FIRST_BCD and END_BCD constants
;
; ***** DO NOT CHANGE ANY CODE BETWEEN THESE MARKERS *****
; Library Routines  - to be used in your solution
;

#include C:\68hcs12\registers.inc

Config_Hex_Displays         equ        $2117
Delay_Ms                    equ        $211F
Hex_Display                 equ        $2139
Extract_Msb                 equ        $2144
Extract_Lsb                 equ        $2149

; Program Constants - to be used in your solution
STACK           equ     $2000
                                ; Port P (PPT) Display Selection Values
DIGIT3_PP0      equ     %1110   ; Left-most display MSB
DIGIT2_PP1      equ     %1101   ; 2nd from left-most display LSB

; Delay Subroutine Value  - to be used in your solution
DVALUE  equ     #250            ; Delay value (base 10) 0 - 255 ms
                                ; 125 = 1/8 second <- good for Dragon12 Board

; ***** END OF DO NOT CHANGE ANY CODE BETWEEN THESE MARKERS *****

; BCD Count constants  - to be used in your solution
; Changing these values will change the Starting and End BCD counts

FIRST_BCD        equ     $00     ; Starting BCD count
END_BCD          equ     $15     ; Ending BCD count0

        org     $2000
Start   lds     #STACK          ; Initialize the Stack

        jsr     Config_HEX_Displays ; Use the Hex Displays to display the count
Reloop  ldaa    #FIRST_BCD
Loop	cmpa    #END_BCD        ; If $15 = $15
        bhi     Reloop          ; Value = $00
        psha                    ; Save the number of First BCD
        jsr     Extract_Msb     ; Jump to Most Significant Bits and destroyed LSB
        ldab    #DIGIT3_PP0     ; Display left-most MSB
        jsr     Hex_Display     ; Display Digit on Hex
        ldaa    #DVALUE         ; Set the value of the time
        jsr     Delay_Ms        ; Delay with the time just set
        pula                    ; Retrieve the number of First BCD

        psha                    ; Save the number of First BCD
        jsr     Extract_Lsb     ; Jump to Least Significant Bits
        ldab    #DIGIT2_PP1     ; Display 2nd from left-most LSB
        jsr     Hex_Display     ; Display Digit on Hex
        ldaa    #DVALUE         ; Set the value of the time
        jsr     Delay_Ms        ; Delay with the time just set
        pula                    ; Retrieve the number of First BCD
        adda    #$01            ; In BCD, if $10 = %0001 0000 which is invalid, plus $01 to display $11 or %0001 0001
        daa                     ; Decimal adjustment in BCD
        bra     Loop            ; Endless Loop
        end