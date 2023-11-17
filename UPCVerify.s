	AREA UPC_CHECK, CODE
ENTRY


UPC_LENGTH EQU 12                           ; We have to define the length of the valid UPC code to 12, because that is the given amount
ASCII_0 EQU 0x30                            ; Define the ASCII code for '0' to convert ASCII to integer


    LDR     R1, =UPC                        ; We begin by a loading the UPC Value into R1
    MOV     R0, #1                          ; We must mov a valid UPS into R0, incase, which is 1
    ADD     R2, R1, #UPC_LENGTH             ; R2 is being set to 12, this is because the UPC Length is 12 for a valid one
    MOV     R3, #0                          ; By moving 0 into R3, we use R3 to hold odd-posistioned digits
    
Calculate_Loop                              ; Loop through each digit in the UPC to calculate the check digit
    LDRB    R4, [R1], #1                    ; We must load the the ASCII digit into R4
    SUB     R4, R4, #ASCII_0                ; Converts  ASCII digit to an integer
    
    TST     R4, #1                          ; Test R4 for odd digit numbers
    BEQ     Even_Digit                      ; If it is not, then go to Even_Digit


    MOV     R5, #3                          ; The UPC algorithm says it must be multiplied by 3
    LSL     R4, R4, #1                      


Odd_Digit
    ADD     R3, R3, R4                      ; This will add the digit to the sum 
    B       continue


Even_Digit
    ADD     R2, R2, #-1                     ; This will allow the program to decrement the counter in R2    
    ADD     R3, R3, R4                      ; This will add the digit to the sum


continue
    CMP     R1, R2                          ; This will check if all 12 digits are processed
    BLT     Calculate_Loop                  ; If it is not, it will continue the loop


    AND     R4, R3, #0x0F                   ; Gets the least significant digit of the sum 
    BEQ     verified


    MOV     R0, #2                          ; INVALID UPC
UPC DCB "013800650738" ; Given Valid UPC
verified
    B verified
    END
