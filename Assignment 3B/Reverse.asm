; Reverse.asm

; Modified by:          Yen Huynh
; Student Number(s):    041068712
; Course:               CST8216 Winter 2021
; Date:                 July 30th, 2023
;
; Purpose       To copy and reverse and array, while performing the following
;               additional operations to decrypt the Secret Message. After
;               reading in a value, we decrypt the value by
;                a. dividing the value by 3
;               b. then adding 32 to the value
;               c. storing the value

; Decryption Constants
DIVISOR         equ     3       ; Value in supplied array will be divided by
                                ; this value
ADDED_VALUE     equ     32      ; Divided value will have 32 added to it

                org     $1000
Source_Array
#include A3B_Array.txt
End_Source_Array
                org        $1020                        ; Secret Message will appear
                                                        ; starting here
Destination_Array
                ds      End_Source_Array-Source_Array   ; auto calculate Array Size
End_Destination_Array

                org     $2000
                lds     #$2000                  ; Initialize Stack
                
                ldx    #Source_Array            ; Point to Start of the Source Array
                ldy    #End_Destination_Array   ; Point to End Destination Array
                
Restart         ldab   1, x+                    ; Read value from source array
                pshx                            ; Push stack
                ldx    #DIVISOR                 ; Load value will be divided
                idiv                            ; D divided by X
                exg    x,b                      ; Exchange value
                addb   #ADDED_VALUE             ; Add 32 to the value
                pulx                            ; Pull stack
                stab   1,y-                     ; Store value in destination array
                cpx    #End_Source_Array        ; Compare if it equal
                bne    #Restart                 ; No, restart
                end                             ; Yes, end