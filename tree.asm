org 100h

;|====================================================|
;|=========ABDURRAHMAN ARDA DEMIR - 20250808628=======|
;|====================================================|

;|============================|
;|=========DATA SEGMENT=======|
;|============================|

charNum db 17   ; initial '*' number for tree
column db 30    ; starting col num of tree

row db 13       ; hold row pos for texts
col db 18       ; hold col pos for texts 

star_locs dw 100 dup(0) ; locations of '*' stored in a array 
star_qty  dw 0          ; number of total '*'s

jmp main        ; starting point, located at the very below of the program

;|============================|
;|=======HELPER FUNCTIONS=====|
;|============================|

cursor PROC         ; SETS THE CURSOR POSITION FOR TREE
    mov bh, 0       ; page zero
    mov dh, cl      ; row is the counter
    mov ah, 2       ; set cursor value
    mov dl, column  ; dl is the variable column loaded from data segment
    inc dl          ; inc dl by one
    mov [column], dl; save the new column value to its memory location
    int 10h         ; set the cursor
    inc dl          ; inc dl again
    RET             ; return
cursor ENDP  

print PROC          ; prints and decorates the tree
    xor cx, cx      ; clean the cx from garbage data
    Mov cl, charNum ; How many stars to print in this row?
    star_loop:
        push cx     ; Save cx by pushing it to stack
        
        ; Get Current Cursor Position in order to save location to array
        mov ah, 03h
        mov bh, 0
        int 10h     ; Returns row and col values
        
        ; Randomnes
        push dx     ; Save Cursor Pos, because int 1Ah destroys DX
        mov ah, 00h
        int 1Ah     ; Get Time
        mov bp, dx  ; Move randomness(clock time value) to BP register 
        pop dx      ; Restore Cursor Pos
        
        test bp, 00000100b  ; Check the 3th bit(index 2) of the time value, %25 Chance of decoration, test performs a AND operation if 0 ZF flag is 0 if not ZF is not set
        jnz print_green     ; If not zero, make it green
        
        cmp word ptr [star_qty], 100    ; check if the array is full or not
        jae print_green                 ; if full do not add decoration just print the tree
        
        ; Save Location to Array
        lea si, star_locs   ; load the location arrays address to si register   
        add si, [star_qty]  ; Offset by current count, we increase it 2*current star number
        add si, [star_qty]  ; add two times because, one star is 2 bytes because of its row and col value, so we need to increase index 2 bytes for every star
        mov [si], dx        ; Save Row and Col, to corrected index
        inc word ptr [star_qty] ; after addition increase star counter
        
        ; Pick Color
        test bp, 00010000b
        jz set_red
        mov bl, 0Fh     ; White
        jmp draw_star
    set_red:
        mov bl, 04h     ; Red
        jmp draw_star
        
    print_green:
        mov bl, 02h     ; Green
        
    draw_star:
        mov ah, 09h     ; Write Char with Attribute
        mov al, '*'
        mov cx, 1       ; Write 1 star
        int 10h
        
        ; Move Cursor Right
        mov ah, 02h     ; move cursor interrupt code
        inc dl          ; increment the column 
        int 10h
        
        pop cx          ; Restore cx
        loop star_loop
    
        ; Setup for next row logic
        mov al, charNum
        sub al, 2
        mov [charNum], al
        ret
print ENDP

;|===================================================NUMBERS======================|
ZERO PROC   ; PRINTS '0'
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h
    call three  ; CALLS A ***
    call two_sep; CALLS A * *
    call two_sep; CALLS A * *
    call two_sep; CALLS A * *
    call three  ; CALLS A ***
    sub dh, 5   ; GO BACK 5 UNITS UP FOR NEW CHARACTER 
    add dl, 4   ; GO RIGHT 4 UNITS FOR NEW CHARACTER
    mov [row], dh
    mov [col], dl            
    ret         
ZERO ENDP

TWO PROC    ; SAME AS 0, NOW ITS PRINTS 2
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h
    call three
    call oneRight
    call three
    call oneLeft
    call three
    sub dh, 5 
    add dl, 4
    mov [row], dh
    mov [col], dl            
    ret         
TWO ENDP

FIVE PROC   ; PRINTS A 5
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h
    call three
    call oneLeft
    call three
    call oneRight
    call three
    sub dh, 5 
    add dl, 4
    mov [row], dh
    mov [col], dl            
    ret         
FIVE ENDP

SIX PROC    ; PRINTS A 6
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h
    call three
    call oneLeft
    call three
    call two_sep
    call three
    sub dh, 5 
    add dl, 4
    mov [row], dh
    mov [col], dl            
    ret         
SIX ENDP

EIGHT PROC  ; PRINTS A 8
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h
    call three
    call two_sep
    call three
    call two_sep
    call three
    sub dh, 5 
    add dl, 4
    mov [row], dh
    mov [col], dl            
    ret         
EIGHT ENDP

;|===================================================CHARACTERS======================|
A PROC      ; PRINTS A
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h
    call oneMid
    call two_sep
    call three
    call two_sep
    call two_sep
    sub dh, 5 
    add dl, 2
    mov [row], dh
    mov [col], dl            
    ret         
A ENDP

E PROC      ; PRINTS E
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h
    call three
    call oneLeft
    call three
    call oneLeft
    call three
    sub dh, 5 
    add dl, 4
    mov [row], dh
    mov [col], dl            
    ret         
E ENDP

H PROC      ; PRINTS H
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h
    call two_sep
    call two_sep
    call three
    call two_sep
    call two_sep
    sub dh, 5 
    add dl, 2
    mov [row], dh
    mov [col], dl            
    ret         
H ENDP

N PROC      ; PRINTS N
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h
    call twoLeft
    call two_sep
    call two_sep
    call two_sep
    call two_sep
    sub dh, 5 
    add dl, 2
    mov [row], dh
    mov [col], dl            
    ret         
N ENDP

P PROC      ; PRINTS P
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h
    call three
    call two_sep
    call three
    call oneLeft
    call oneLeft
    sub dh, 5 
    add dl, 4
    mov [row], dh
    mov [col], dl            
    ret         
P ENDP

R PROC      ; PRINTS R
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h
    call three
    call two_sep
    call twoLeft
    call three
    call two_sep
    sub dh, 5 
    add dl, 2
    mov [row], dh
    mov [col], dl            
    ret         
R ENDP

W PROC      ; PRINTS W
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h
    call two_sep
    call two_sep
    call three
    call three
    call two_sep
    sub dh, 5 
    add dl, 2
    mov [row], dh
    mov [col], dl            
    ret         
W ENDP

Y PROC      ; PRINTS Y
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h
    call two_sep
    call two_sep
    call oneMid
    call oneMid
    call oneMid
    sub dh, 5 
    add dl, 3
    mov [row], dh
    mov [col], dl            
    ret         
Y ENDP

;|===========================================STAR CREATORS=============================|
three PROC      ; CREATES THE ***
    mov dh, row
    mov dl, col
    mov ah, 2   ;set
    int 10h     ;cursor
    Mov cl, 3
    MOV AH, 0AH 
    INT 10H
    inc dh
    mov [row], dh         
    ret         
three ENDP

twoleft PROC    ; CREATES THE **_
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h 
    Mov cl, 2
    MOV AH, 0AH 
    INT 10H
    inc dh
    mov [row], dh         
    ret         
twoleft ENDP

tworight PROC   ; CREATES THE _**
    mov dh, row
    mov dl, col
    inc dl
    mov ah, 2
    int 10h 
    Mov cl, 2
    MOV AH, 0AH 
    INT 10H
    inc dh
    mov [row], dh         
    ret         
tworight ENDP

two_sep PROC    ; CREATES THE *_*
    mov dh, row
    mov dl, col
    mov ah, 2
    int 10h 
    Mov cl, 1
    MOV AH, 0AH 
    INT 10H
    add dl, 2
    mov ah, 2
    int 10h
    Mov cl, 1
    MOV AH, 0AH 
    INT 10H
    inc dh
    mov [row], dh         
    ret         
two_sep ENDP

oneMid PROC     ; CREATES THE _*_
    mov dh, row
    mov dl, col
    inc dl
    mov ah, 2   ;set
    int 10h     ;cursor 
    Mov cl, 1
    MOV AH, 0AH 
    INT 10H
    inc dh
    mov [row], dh         
    ret         
oneMid ENDP

oneLeft PROC    ; CREATES THE *__
    mov dh, row
    mov dl, col
    mov ah, 2   ;set
    int 10h     ;cursor 
    Mov cl, 1
    MOV AH, 0AH 
    INT 10H
    inc dh
    mov [row], dh         
    ret         
oneLeft ENDP

oneRight PROC   ; CREATES THE __*
    mov dh, row
    mov dl, col
    add dl, 2
    mov ah, 2   ;set
    int 10h     ;cursor 
    Mov cl, 1
    MOV AH, 0AH 
    INT 10H
    inc dh
    mov [row], dh         
    ret         
oneRight ENDP

FLASH_LOOP PROC         ; flash logic
    mov cx, [star_qty]  ; load the star counter to cx
    cmp cx, 0           ; if cx is 0
    je done             ; jump to done, else continue from below line

    lea si, star_locs   ; load location array to si register

cycle:
    push cx             ; save cx

    mov dx, [si]        ; take the first star location

    ; move cursor to that location
    mov ah, 2
    mov bh, 0
    int 10h             ; Move cursor to the saved star location

    ; read char and color
    mov ah, 08h 
    int 10h             ; Read Character with Attribute at cursor location

    cmp ah, 04h         ; look if the star white or not
    je to_white         ; if equal to 04h go to white label
    cmp ah, 0Fh         ; if not white now look if it is red
    je to_red           ; if red go to red
    jmp next            ; none of them, jump to next label

to_white:
    mov bl, 0Fh         ; if it is white put the reds code to bl and jump to repaint label
    jmp repaint

to_red:                 ; if it is red put the whites code to bl and jump to repaint label
    mov bl, 04h

repaint:
    mov ah, 09h         ; just repaint the current star with the current color value
    mov cx, 1
    int 10h

next:                   ; add 2 to si register, same reason i mentioned at the print tree part, because of our location data is 16 bit, 8 for row, 8 for column
    add si, 2           ; we simply add 2 to index so it can indicate the actual next starts location data (memory blocks hold 8 bit, adding two to index = 2*8=16 bit jump)
    pop cx              ; recover cx
    loop cycle          ; loop

done:
    ret
FLASH_LOOP ENDP


DELAY PROC              ; DELAY
    mov ah, 00h
    int 1Ah             ; GET SYSTEM TIME
    mov bx, dx          ; Save the current time
    add bx, 1           ; define target time, since 1 tick is very slow (because i want real flashing light) it instantly will loop again, can be increase for slower flashes

wait:
    mov ah, 00h
    int 1Ah             ; Check the time again
    cmp dx, bx          ; Compare Current Time vs Target Time
    jl wait             ; If Current < Target, Just wait
    ret
DELAY ENDP


;|============================|
;|=========MAIN PROGRAM=======|
;|============================| 

main: 

    mov word ptr [star_qty], 0 ; initially star counter is 0

;|==============print the tree============|
    xor cx,cx   ; clean the counter register from garbage data
    MOV Cl, 9   ; main loop counter starts from 9, tree will have 9 layers
loopy:
    push cx     ; save the layer counter
    call cursor ; call the cursor procedure to set cursor for printing
    call print  ; now print the tree elements
    pop cx      ; restore the layer counter 
    loop loopy  ; loop

    xor cx,cx   ; clean the counter register from garbage data
    mov cx, 3   ; set cx to 3, this will be the height of the trees trunk
    mov dh, 10  ; row is 10, right after the tree ends
    mov dl, 38  ; column is 38 the middle of the tree
trunk:
    push cx     ; save the trunk height counter
    mov cx, 3   ; this is the numbger of elements we want to print, we want width 3 for trunk
    mov ah, 2   ;set
    int 10h     ;cursor
    MOV AH, 09H ; for printing with attribute
    MOV AL, '@' ; char is '@'
    MOV BH, 0H  ; page is 0
    mov bl, 00000110b   ; color is brown = 0110  
    INT 10H     ; the actual print interrupt
    inc dh      ; increment the row 
    pop cx      ; restore the trunk counter
    loop trunk  ; loop
    
;|=============print student number===========|
    MOV AL, '*' ; charater to print is '*'
    mov bh, 0   ; page is 0
    
    ; call the respective procedures to print student id
    call TWO
    call ZERO
    call TWO
    call FIVE
    call ZERO
    call EIGHT
    call ZERO
    call EIGHT
    call SIX
    call TWO
    call EIGHT
    
;|============print the 'happy new year'======|
    MOV AL, '*' ; charater to print is '*' 
    mov bh, 0   ; page is 0
    
    mov dh, 19  ; set the row for the happy new year text
    mov dl, 11  ; set the column 
    mov [row], dh   ; save row and
    mov [col], dl   ; column to their variables
    mov ah, 2   ;set
    int 10h     ;cursor 
    
    ; call the respective procedures to print characters
    call H
    call A
    call P
    call P
    call Y
    add dl, 3           ; after the first word increase row number by 3 for whitespace
    mov [col], dl
    call N
    call E
    call W
    add dl, 3           ; whitespace again
    mov [col], dl
    call Y
    call E
    call A
    call R
    
infinite_blink:         ; flashing loop
    call DELAY
    call FLASH_LOOP     ; Swap Red, White
    jmp infinite_blink  ; Do it forever
ret
