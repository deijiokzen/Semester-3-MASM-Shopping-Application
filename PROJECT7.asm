TITLE PROJECT

includelib winmm.lib
INCLUDE Irvine32.inc
INCLUDE macros.inc
PlaySound PROTO,
        pszSound:PTR BYTE, 
        hmod:DWORD, 
        fdwSound:DWORD

BUFFER_SIZE =4000
ID_MAX = 10
	Last_Name_Limit= 70
	TRUE = 1
	FALSE = 0


PERSONNEL STRUCT
	ID_NUMBER BYTE ID_MAX DUP(0)
	Last_Name BYTE Last_Name_Limit DUP(0)
	Next_Node DWORD 0
PERSONNEL ENDS

EntryTotalSize = (SIZEOF PERSONNEL.Last_Name + SIZEOF PERSONNEL.ID_NUMBER)

.data
buffer BYTE BUFFER_SIZE DUP(?)
var BYTE BUFFER_SIZE DUP(0)

filename    BYTE 80 DUP(0)
fileHandle  HANDLE ?

name1 BYTE "OL.txt",0,
		   "OLT.txt",0,
		   "DC.txt",0,
		   "FM.txt",0,
		   "T.txt",0,
		   "E.txt",0,
		   "G.txt",0,
		   "FI.txt",0,
		   "GI.txt",0,
		   "LL.txt",0,
		   "BR.txt",0
name_index BYTE 0, 7, 15, 22, 29, 35, 41,47,54,61,68


promptBad BYTE "Invalid input, please enter again",0
choice_display BYTE "Your Choice Is:",0
file BYTE "t.wav",0
file2 BYTE "d.wav",0


table WORD 189d, 235d,  35d, 100d,  80d
	  WORD 235d, 255d,  80d,  30d, 120d
	  WORD 180d, 120d, 175d,  30d, 125d
	  WORD 180d, 120d, 200d, 250d, 245d
	  WORD 480d, 130d, 560d, 320d, 120d
TotalSum DWORD 0

Find_String BYTE 80 DUP(0)
Names_  BYTE "VEGIES@",
		     "KOBE BEEF SLICES@",
		     "FROZEN FRUIT@",
		     "WHOLEMEAL BREAD@",
		     "DAIRY MILK@",
             "JOKER@",
		     "BEAR@",
		     "PLASTIC WORM@",
		     "MINI CAR@",
		     "LEGO SET@",
             "CALCULATORS@",
			 "REMOTE@",
		     "ELECTRONIC KIT@",
		     "BULBS@",
		     "ELECTRIC RACKETS@",
             "DART BOARD@",
		     "CHESS BOARD@",
             "FOOTBALL@",
			 "TENNIS RACKET@",
			 "54 CARD PACKET@",0
Names_2 BYTE  "PVC PIPES@", 
			  "TRASH CAN@",
			  "STAINLESS STEAL FAUCET@",
			  "PAINT SUPPLY@",
			  "CLEANING BROOM@",0
			  
BILLING_STATEMENT BYTE "HERE'S WHAT YOU ORDERED, AND THE TOTAL BILL:",0Ah,0Ah,0
TOTAL_ BYTE 0Ah, "YOUR TOTAL IS:",0Ah,0
BILL_INDEXED BYTE 25 DUP(0)

frequencies byte 25,25,25,25,25
strings byte "FOOD",0,"TOYS",0,"ELECT",0,"GAME",0,"GENIT",0
highest byte 0
temp byte ?

  hStdIn    dd 0
    nRead     dd 0

    _INPUT_RECORD STRUCT
        EventType   WORD ?
        WORD ?                    ; For alignment
        UNION
            KeyEvent              KEY_EVENT_RECORD          <>
            MouseEvent            MOUSE_EVENT_RECORD        <>
            WindowBufferSizeEvent WINDOW_BUFFER_SIZE_RECORD <>
            MenuEvent             MENU_EVENT_RECORD         <>
            FocusEvent            FOCUS_EVENT_RECORD        <>
          ENDS
    _INPUT_RECORD ENDS

    InputRecord _INPUT_RECORD <>

    ConsoleMode dd 0
    Msg db "Click! ",0
    Msg2 db "Esc ",0
;-----------------------------------------------------------------------------------------------------;
hHeap DWORD ?
dwBytes DWORD ?
dwFlags DWORD HEAP_ZERO_MEMORY

	PERSONNEL_TITLE BYTE " --- ENTER A NEW PERSONNEL --- ",0
	NODE_CREATE_NEW_MESSAGE BYTE "DO YOU WANT TO ENTER A NEW PERSONNEL RECORD ? Y/N: ",0
	PERSONNEL_ID_MESSAGE BYTE "ENTER THE PERSONNEL ID: ",0
	CUSTOMER_LAST_NAME BYTE "ENTER THE LAST NAME OF PERSONNEL: ",0
	NONE_FOUND_1 BYTE " --- THERE ARE NO PERSONNEL RECORDS IN MEMORY ---",0
	TITLE_MESSAGE BYTE "---- LINKED LIST CONTENTS ----",0
	CUSTOMER_ID_DISPLAY BYTE "PERSONNEL ID: ",0
	CUSTOMER_NAME_DISPLAY BYTE "PERSONNEL LAST NAME: ",0

spacer BYTE "-------------------------------",0
	
	Personnel_Search_Msg BYTE " --- PERSONNEL SEARCH --- ",0
	Get_Searched_ID BYTE "PLEASE ENTER THE PERSONNEL ID YOU WISH TO DISPLAY: ",0
	FOUND_DISPLAY BYTE " --- PERSONNEL FOUND ---",0
	DELETE_MESSAGE BYTE " --- AND REMOVED ---",0
	notFOUND_DISPLAY BYTE "PERSONNEL COULD NOT BE FOUND IN RECORDS !!!!",0
	NEW_INFO_MESSAGE BYTE " --- NEW PERSONNEL INFO ---",0
	PERSONNEL_UPDATED_AFTER BYTE " --- PERSONNEL DATA SUCCESFULLY UPDATED --- ",0

row BYTE 0
column BYTE 24
	ID_NUMBERber BYTE (ID_MAX+1) DUP(0)
	Last_Name BYTE (Last_Name_Limit+1) DUP(0)
	INPUT_ALPHA BYTE ?
	Searched_ID BYTE (ID_MAX+1) DUP(0)
	Head_Pointer DWORD ?
	TAIL_POINTER DWORD ?
	Current_Node DWORD ?
	Previous_Node DWORD ?
	Next_Node DWORD ?
	FOUND_BOOLEAN BYTE FALSE
THIS_PERSONNEL PERSONNEL {}
.code
Find_SS PROTO FILE_:PTR DWORD, INDEX:PTR BYTE
Submenu PROTO Menu_No:PTR BYTE, Item_No:PTR BYTE 
filesummon PROTO, fileindex:PTR BYTE, colordisplay:PTR DWORD, posX: PTR BYTE, posY: PTR BYTE, isCoordinateBased:PTR BYTE, shouldClearScreen: PTR BYTE
copySTRING PROTO, index:PTR BYTE
copyBuffer PROTO, posX:PTR BYTE, posY:PTR BYTE
bufferclean PROTO
main PROC
	mov edx,0
	call mouse_detector
	invoke filesummon, 0, (yellow+(red*16)),0,0,0,1 ;-------FILE NAME INDEX, COLOR OF TEXT+BACKGROUND, COORDINATES FOR X, COORDINATES FOR Y, IF COORDINATES APPLY, CLEAR SCREEN?------;
	invoke filesummon, 1, (white+(red*16)),15,2,1,0
	;INVOKE PlaySound, OFFSET file, NULL, 00020000h
	invoke filesummon, 10, (black+(white*16)),0,0,0,1
loop_initial_choice:
	call mouse_detector
.IF ((eax >= 44 && eax <=78 && ebx==30) || (eax >= 59 && eax <=62 && ebx==31))
    jmp _starter 
.ELSEIF(!(eax >= 41 && eax <=80 && ebx==25) && !(eax >= 58 && eax <=63 && ebx==26))
	jmp loop_initial_choice
.ENDIF
INVOKE GetProcessHeap
	mov hHeap,eax
	mov dwBytes,SIZEOF PERSONNEL
	mov eax,white+(red*16)
	call SetTextColor
	call Create_NewNode
	mov Head_Pointer,eax
Ent_:
	mov eax,TAIL_POINTER
	mov Current_Node,eax
	call programMenu
	call Selection_CALL
	cmp INPUT_ALPHA, 'F'
jne Ent_
	call crlf
	call mouse_detector
ENDOFPROGRAM: 
exit 

_starter:
	invoke filesummon, 2, (white+( gray*16)),0,0,0,1
	mov edx, offset choice_display
_starter1:
	call mouse_detector
    cmp ebx,11
	jne check_2
	cmp eax,73
	jl check_2
	cmp eax,79
	jg check_2
	jmp Option1
check_2:
	cmp ebx,12
	jne check_3
	cmp eax,73
	jl check_3
	cmp eax,79
	jg check_3
	jmp Option2
check_3:
	cmp ebx,13
	jne check_4
	cmp eax,73
	jl check_4
	cmp eax,86
	jg check_4
	jmp Option3
check_4:
	cmp ebx,14
	jne check_5
	cmp eax,73
	jl check_5
	cmp eax,90
	jg check_5
	jmp Option4
check_5:
	cmp ebx,15
	jne check_6
	cmp eax,73
	jl check_6
	cmp eax,88
	jg check_6
	jmp Option5
check_6:
	cmp ebx,16
	jne check_7
	cmp eax,73
	jl check_7
	cmp eax,102
	jg check_7
	jmp Option6
check_7:
	cmp ebx,17
	jne check_8
	cmp eax,73
	jl check_8
	cmp eax,88
	jg check_8
	jmp Option7
check_8:
	cmp ebx,18
	jne _starter1
	cmp eax,73
	jl _starter1
	cmp eax,80
	jg _starter1
	jmp Option8

	Option1:
	invoke filesummon, 3, (white+( cyan*16)),0,0,0,1
	Option_Selector:
	call mouse_detector
	cmp ebx, 34
	jne _else1
	cmp eax, 28
	jl Option_Selector
	cmp eax, 75
	jg Option_Selector
	invoke Submenu, 1, 1
	jmp Option_Selector
_else1:	
	cmp ebx, 35
	jne _else2
	cmp eax, 28
	jl Option_Selector
	cmp eax, 75
	jg Option_Selector
	invoke Submenu, 1, 2
	jmp Option_Selector
_else2:
	cmp ebx, 36
	jne _else3
	cmp eax, 28
	jl Option_Selector
	cmp eax, 85
	jg Option_Selector
	invoke Submenu, 1, 3
	jmp Option_Selector
_else3:
	cmp ebx, 37
	jne _else4
	cmp eax, 28
	jl Option_Selector
	cmp eax, 75
	jg Option_Selector
	invoke Submenu, 1, 4
	jmp Option_Selector
_else4:
	cmp ebx, 38
	jne _else5
	cmp eax, 28
	jl Option_Selector
	cmp eax, 74
	jg Option_Selector
	invoke Submenu, 1, 5
	jmp Option_Selector
_else5:
	cmp ebx, 39
	jne Option_Selector
	cmp eax, 28
	jl Option_Selector
	cmp eax, 53
	jg Option_Selector
	jmp _starter
;-------------------------------------------------------------------;
	Option2:
	invoke filesummon, 4, (white+( magenta*16)),0,0,0,1
	Option2Selector:
	call mouse_detector
	cmp eax,45
	jl Option2Selector
	cmp ebx,14
	jne _else6	
	cmp eax,76
	jg Option2Selector
	invoke Submenu, 2, 1
	jmp Option2Selector
_else6:
	cmp eax,45
	jl Option2Selector
	cmp ebx,15
	jne _else7	
	cmp eax,76
	jg Option2Selector
	invoke Submenu, 2, 2
	jmp Option2Selector
_else7:
	cmp eax,45
	jl Option2Selector
	cmp ebx,16
	jne _else8
	cmp eax,75
	jg Option2Selector
	invoke Submenu, 2, 3
	jmp Option2Selector
_else8:
	cmp eax,45
	jl Option2Selector
	cmp ebx,17
	jne _else9
	cmp eax,75
	jg Option2Selector
	invoke Submenu, 2, 4
	jmp Option2Selector
_else9:
	cmp eax,45
	jl Option2Selector
	cmp ebx,18
	jne _else10
	cmp eax,76
	jg Option2Selector
	invoke Submenu, 2, 5
	jmp Option2Selector
_else10:
	cmp eax,45
	jl Option2Selector
	cmp ebx,19
	jne Option2Selector
	cmp eax,71
	jg Option2Selector
	jmp _starter
	
	;-------------------------------------------------------------------;
	Option3:
	invoke filesummon, 5, (white+(blue*16)),0,0,0,1
	Option3Selector:
	call mouse_detector
	cmp eax, 67
	jl Option3Selector
	cmp ebx,15
	jne _else11
	cmp eax, 103
	jg Option3Selector
	invoke Submenu, 3, 1
	jmp Option3Selector
_else11:
	cmp eax, 67
	jl Option3Selector
	cmp ebx,16
	jne _else12
	cmp eax, 103
	jg Option3Selector
	invoke Submenu, 3, 2
	jmp Option3Selector
_else12:
	cmp eax, 67
	jl Option3Selector
	cmp ebx,17
	jne _else13
	cmp eax, 103
	jg Option3Selector
	invoke Submenu, 3, 3
	jmp Option3Selector
_else13:
	cmp eax, 67
	jl Option3Selector
	cmp ebx,18
	jne _else14
	cmp eax, 102
	jg Option3Selector
	invoke Submenu, 3, 4
	jmp Option3Selector
_else14:
	cmp eax, 67
	jl Option3Selector
	cmp ebx,19
	jne _else15
	cmp eax, 103
	jg Option3Selector
	invoke Submenu, 3, 5
	jmp Option3Selector
_else15:
	cmp eax, 67
	jl Option3Selector
	cmp ebx,20
	jne Option3Selector
	cmp eax, 93
	jg Option3Selector
	jmp _starter
	

;-------------------------------------------------------------------;
	Option4:
	invoke filesummon, 6, (white+(black*16)),0,0,0,1
	Option4Selector:
	call mouse_detector
	cmp eax, 20
	jl Option4Selector
	cmp ebx, 19
	jne _else16
	cmp eax, 46
	jg Option4Selector
	invoke Submenu, 4, 1
	jmp Option4Selector
_else16:
	cmp eax, 20
	jl Option4Selector
	cmp ebx, 23
	jne _else17
	cmp eax, 46
	jg Option4Selector
	invoke Submenu, 4, 2
	jmp Option4Selector
_else17:
	cmp eax, 20
	jl Option4Selector
	cmp ebx, 27
	jne _else18
	cmp eax, 46
	jg Option4Selector
	invoke Submenu, 4, 3
	jmp Option4Selector
_else18:
	cmp eax, 20
	jl Option4Selector
	cmp ebx, 31
	jne _else19
	cmp eax, 46
	jg Option4Selector
	invoke Submenu, 4, 4
	jmp Option4Selector
_else19:
	cmp eax, 20
	jl Option4Selector
	cmp ebx, 36
	jne _else20
	cmp eax, 46
	jg Option4Selector
	invoke Submenu, 4, 5
	jmp Option4Selector
_else20:
	cmp eax, 20
	jl Option4Selector
	cmp ebx, 40
	jne Option4Selector
	cmp eax, 48
	jg Option4Selector
	jmp _starter
	;-------------------------------------------------------------------;
	Option5:
	invoke filesummon, 8, (white+(brown*16)),0,0,0,1
	Option5Selector:
	call mouse_detector
	cmp eax, 43
	jl Option5Selector
	cmp ebx,34
	jne _else21
	cmp eax, 77
	jg Option5Selector
	invoke Submenu, 5, 1
	jmp Option5Selector
_else21:
	cmp eax, 43
	jl Option5Selector
	cmp ebx,35
	jne _else22
	cmp eax, 77
	jg Option5Selector
	invoke Submenu, 5, 2
	jmp Option5Selector
_else22:
	cmp eax, 43
	jl Option5Selector
	cmp ebx,36
	jne _else23
	cmp eax, 77
	jg Option5Selector
	invoke Submenu, 5, 3
	jmp Option5Selector
_else23:
	cmp eax, 43
	jl Option5Selector
	cmp ebx,37
	jne _else24
	cmp eax, 77
	jg Option5Selector
	invoke Submenu, 5, 4
	jmp Option5Selector
_else24:
	cmp eax, 43
	jl Option5Selector
	cmp ebx,38
	jne _else25
	cmp eax, 77
	jg Option5Selector
	invoke Submenu, 5, 5
	jmp Option5Selector
_else25:
	cmp eax, 43
	jl Option5Selector
	cmp ebx,39
	jne Option5Selector
	cmp eax, 68
	jg Option5Selector
	jmp _starter
	
;-------------------------------------------------------------------;
	Option6:
	mov  eax, (cyan+(black*16))
	call SetTextColor
	call Clrscr
	call graph_
	call mouse_detector

	jmp _starter

;-------------------------------------------------------------------;
	Option7:
	invoke filesummon, 7, (white+(red*16)),0,0,0,1
	call PrintBill
	call mouse_detector
	call mouse_detector
	jmp _starter
	;INVOKE PlaySound, OFFSET file2, NULL, 00020000h

	Option8:
ENDIT:
exit
main ENDP
graph_ PROC Uses ecx eax esi
	mov ecx,lengthof frequencies
	mov eax,0
	mov esi,0
L1:
	mov al,frequencies[esi]
	cmp al,highest
	JNG compare
	mov highest,al
	compare:
	inc esi
	loop L1
	mov al,highest
	mov ecx,0
	mov cl,highest
L2:
	mov temp,cl
	mov esi,0
	mov ecx,0
	mov cl,lengthof frequencies
L3:
	mov ebx,0
	mov bl,frequencies[esi]
	cmp bl,temp
JL printspace
	mov al," "	
	call writechar
	mov al,219d
	call writechar
	call writechar
	mov al," "
	call writechar
	mov al,9
	call writechar
	jmp Loopcall1
	printspace:
	mov al," "
	call writechar
	call writechar
	call writechar
	mov al,9
	call writechar
	Loopcall1:
	inc esi
	Loop L3
	call crlf
	mov cl,temp
	Loop L2
	mov ecx,5
	mov esi,offset strings
L4:
	mov edx,esi
	call writestring
	mov al,9
	call writechar
	invoke Str_length,esi
	inc eax
	add esi,eax
	Loop L4
	ret
graph_ ENDP
MakeZero PROC 
	mov ecx, 80
	mov ebx,0
L1:
	mov Find_String[ebx],0
	inc ebx
LOOP L1
ret 
MakeZero ENDP
PrintBill PROC
	lea edx, BILLING_STATEMENT
	call WriteString 
	mov ebx,0
	MOV ecx,25
L1:
	push ecx
	push ebx
	mov al, BILL_INDEXED[ebx]
	cmp al,0
je _ahead 
	cmp ebx, 19
ja File2_
	invoke Find_SS, ADDR Names_, ebx
jmp Printing_
File2_:
	push ebx 
	sub ebx, 20
	invoke Find_SS, ADDR Names_2, ebx
	pop ebx
Printing_:
	lea edx, Find_String 
	call WriteString
	mov al, ' '
	call WriteChar 
	mov al, BILL_INDEXED[ebx]
	call WriteDec 
	mov al,'x'
	call WriteChar
	call crlf
	call MakeZero
	_ahead:

pop ebx 
inc ebx
pop ecx
LOOP L1

lea edx, TOTAL_
call WriteString 
mov al, '$'
call WriteChar
mov eax, [TotalSum]
call WriteDec

ret 
PrintBill ENDP

Submenu PROC Menu_No:PTR BYTE, Item_No:PTR BYTE 
	mov eax, [Item_No]
	dec eax
	push eax 
	imul eax, eax, 2
	mov ebx, [Menu_No]
	dec ebx
	mov edx,0
	cmp frequencies[ebx],dl
	je Finish_It
	mov dl,1
	sub frequencies[ebx],dl
	imul ebx, ebx, sizeof table
	push ebx 
	add ebx, eax 
	movzx eax, table[ebx]
	add [TotalSum],eax 
	pop ebx 
	mov eax, ebx 
	mov cx,2
	mov edx,0
	div cx 
	mov ebx, eax 
	pop eax 
	add ebx, eax 
	add BILL_INDEXED[ebx],1
Finish_It:
ret 8
Submenu ENDP

Find_SS PROC FILE_:PTR DWORD, INDEX:PTR BYTE 

	mov esi, [FILE_]
	mov eax,[INDEX]

	cmp eax,0 
	je Copy_

	mov eax,[esi]
	mov dl, [esi]
	cmp dl, '@'
	je Again_
	mov eax, [INDEX]
	inc esi
	invoke Find_SS, esi, eax 
	ret 8
	Again_:
	inc esi 
	mov eax, [INDEX]
	dec eax 
	invoke Find_SS,esi, eax  
	ret 8
	Copy_:
	CLD 
	lea edi, Find_String
	backer_:
	lodsb
	cmp al, '@'
	je out_
	stosb 
	jmp backer_
	out_: 
ret 8
Find_SS ENDP

filesummon PROC, fileindex:PTR BYTE, colordisplay:PTR DWORD, posX: PTR BYTE, posY: PTR BYTE, isCoordinateBased:PTR BYTE,shouldClearScreen: PTR BYTE
	call bufferclean
	mov dx,0
	call Gotoxy
	invoke copySTRING,[fileindex]
	mov esi, colordisplay

	mov	edx,OFFSET filename
	call	OpenInputFile
	mov	fileHandle,eax

	cmp	eax,INVALID_HANDLE_VALUE		; error opening file?
	jne	file_ok					; no: skip
	mWrite <"Cannot open file",0dh,0ah>
	jmp	quit						; and quit
file_ok:

	mov	edx,OFFSET buffer
	mov	ecx,BUFFER_SIZE
	call	ReadFromFile
	jnc	check_buffer_size			; error reading?
	mWrite "Error reading file. "		; yes: show error message
	call	WriteWindowsMsg
	jmp	close_file
	
check_buffer_size:
	cmp	eax,BUFFER_SIZE			; buffer large enough?
	jb	buf_size_ok				; yes
	mWrite <"Error: Buffer too small for the file",0dh,0ah>
	jmp	quit						; and quit
	
buf_size_ok:	
	mov	buffer[eax],0		; insert null terminator
	;mWrite "File size: "
	;call	WriteDec			; display file size
	;call	Crlf

; Display the buffer.
	;mWrite <"Buffer:",0dh,0ah,0dh,0ah>

	mov	edx,OFFSET buffer	; display the buffer
	mov  eax,[colordisplay]
    call SetTextColor

	mov al, BYTE PTR [shouldClearScreen]
	cmp al,0
	je NoClear
	
	call Clrscr

	NoClear:
	
	mov al, BYTE PTR [isCoordinateBased]
	cmp al,0
	jne IsCoordinate

	call	WriteString
	call	Crlf
	jmp close_file


	IsCoordinate:
	invoke copyBuffer,[posX],[posY]



close_file:
	mov	eax,fileHandle
	call CloseFile



quit:

	ret 
filesummon ENDP



copySTRING PROC, index:PTR BYTE
	mov edx, [index]
	PUSHAD
	mov edi, OFFSET filename
	mov ebx, OFFSET name1
	mov esi, lengthof name1-1
	mov ecx, esi
	L1:
	movzx eax, name_index[edx] ;----------------------------WHICH FILE OFFSET--------------------------------;
	neg ecx
	add eax, esi
	add eax,ecx
	mov al,name1[eax]
	mov BYTE PTR filename[esi][ecx],al
	neg ecx
	Loop L1
	POPAD
	ret
copySTRING ENDP


copyBuffer PROC, posX:PTR BYTE, posY:PTR BYTE
	
	local variable:BYTE
	mov edx,0
	mov dh, BYTE PTR [posX]
	mov dl, BYTE PTR [posY]
	call Gotoxy
	push edx

	mov ecx, BUFFER_SIZE
	lea esi, buffer
	lea edi, variable

	L1:
	mov al, [esi]
	inc esi

	cmp al, 0Ah
	je outer
	mov [edi], al
	mov edx,edi
	call writechar
;loopit:
Loop L1
ret

outer:
	pop edx
	mov dl, BYTE PTR [posY]
	inc dh
	push edx
	call Gotoxy

Loop L1	

ret
copyBuffer ENDP



bufferclean PROC
	mov edi, offset buffer
	mov esi, offset var

	mov ecx, lengthof buffer
	rep movsb
	
ret
bufferclean ENDP
mouse_detector PROC
    invoke GetStdHandle,STD_INPUT_HANDLE
    mov   hStdIn,eax

    invoke GetConsoleMode, hStdIn, ADDR ConsoleMode
    mov eax, 0090h          ; ENABLE_MOUSE_INPUT | DISABLE_QUICK_EDIT_MODE | ENABLE_EXTENDED_FLAGS
    invoke SetConsoleMode, hStdIn, eax

    .WHILE InputRecord.KeyEvent.wVirtualKeyCode != VK_ESCAPE

        invoke ReadConsoleInput,hStdIn,ADDR InputRecord,1,ADDR nRead

        movzx  eax,InputRecord.EventType
        cmp eax, MOUSE_EVENT
        jne no_mouse
        test InputRecord.MouseEvent.dwButtonState, 1 ; 1 for left click 2 for right click 
        jz no_mouse

        lea edx, Msg
        Call WriteString
        jmp done

        no_mouse:
    .ENDW

    lea edx, Msg2
    Call WriteString
ret 
    done:
    mov eax, ConsoleMode
    invoke SetConsoleMode, hStdIn, eax
    movzx eax,InputRecord.MouseEvent.dwMousePosition.x 
    movzx ebx, InputRecord.MouseEvent.dwMousePosition.y
ret 
mouse_detector ENDP 
Create_NewNode PROC
	INVOKE heapAlloc, hHeap, dwFlags, dwBytes
	mov TAIL_POINTER,eax
ret

Create_NewNode ENDP


Add_TWO_COLUMN PROC
	add row,2
	mov dl,column
	mov dh,row
	call gotoxy
	ret
Add_TWO_COLUMN ENDP

programMenu PROC
	invoke filesummon, 9, (white+( blue*16)),0,0,0,1
ret
programMenu ENDP

Selection_CALL PROC
	
	call mouse_detector
	
.IF (eax >= 41 &&  eax <= 68 && ebx ==10)
	call show_contents
.ELSEIF (eax >= 41 &&  eax <= 63 && ebx ==11)
	call getSearch
	call mouse_detector
.ELSEIF (eax >= 41 &&  eax <= 60 && ebx ==12)
	call getData
	call moveToHeap
	call mouse_detector
.ELSEIF (eax >= 41 &&  eax <= 68 && ebx ==13)
	call getSearch
 .IF (FOUND_BOOLEAN == 1)
	call update
 .ENDIF
	call mouse_detector
.ELSEIF (eax >= 41 &&  eax <= 59 && ebx ==14)
	call getSearch
 .IF (FOUND_BOOLEAN == 1)
	call deleteNode
 .ENDIF
 .ELSEIF (eax >= 41 &&  eax <= 47 && ebx ==15)
exit

.ENDIF
ret
Selection_CALL ENDP




show_contents PROC
	mov edi,Head_Pointer
	mov ebx,00h
	call Clrscr
	mov edx,OFFSET TITLE_MESSAGE
	call writeString
	call Crlf
	call Crlf
DISPLAYSTART:
	cmp [edi+EntryTotalSize],ebx
	je NO_MORE_CONTENTS_TO_SHOW
	mov eax,[edi]
	mov Previous_Node,eax
	call displayPERSONNEL
	add edi,SIZEOF THIS_PERSONNEL.Last_Name
	mov edi,[edi]
	mov Current_Node,edi
	JMP DISPLAYSTART

NO_MORE_CONTENTS_TO_SHOW: 
	call mouse_detector
ret
show_contents ENDP

displayPERSONNEL PROC
	call Crlf
	mov edx,OFFSET CUSTOMER_ID_DISPLAY
	call writeString
	mov edx,edi
	call writeString
	call Crlf
	mov edx,OFFSET CUSTOMER_NAME_DISPLAY
	call writeString
	add edi,SIZEOF THIS_PERSONNEL.ID_NUMBER
	mov edx,edi
	call writeString
	call Crlf
	mov edx,OFFSET spacer
	call writeString
	call Crlf
	ret
displayPERSONNEL ENDP


getData PROC
	call Clrscr
	mov edx,OFFSET PERSONNEL_TITLE
	call writeString
	call Crlf
	call Crlf
	mov edx,OFFSET PERSONNEL_ID_MESSAGE
	call writeString
	mov edx,OFFSET THIS_PERSONNEL.ID_NUMBER
	mov ecx,ID_MAX
	call readString
	mov edx,OFFSET CUSTOMER_LAST_NAME
	call writeString
	mov edx,OFFSET THIS_PERSONNEL.Last_Name
	mov ecx,Last_Name_Limit
	call readString
	call Create_NewNode
	mov eax,TAIL_POINTER
	mov THIS_PERSONNEL.Next_Node,eax
ret
getData ENDP

moveToHeap PROC
	mov esi,OFFSET THIS_PERSONNEL
	mov edi,Current_Node
	INVOKE Str_copy, ADDR THIS_PERSONNEL.ID_NUMBER, edi
	add edi,SIZEOF THIS_PERSONNEL.ID_NUMBER
	INVOKE Str_copy, ADDR THIS_PERSONNEL.Last_Name, edi
	add edi,SIZEOF THIS_PERSONNEL.Last_Name
	mov eax,(PERSONNEL PTR [esi]).Next_Node
	mov [edi],eax
	ret
moveToHeap ENDP

getSearch PROC
	call ClrScr
	mov ebx,00h
	mov edi,Head_Pointer
	cmp [edi+EntryTotalSize],ebx
je NOTHING

	mov edx,OFFSET Personnel_Search_Msg
	call writestring
	call Crlf
	mov edx,OFFSET Get_Searched_ID
	call writeString
	mov edx,OFFSET Searched_ID
	mov ecx,ID_MAX
	call readString
	call searchList
	jmp endproc

NOTHING:
	mov FOUND_BOOLEAN,FALSE
	mov edx,OFFSET NONE_FOUND_1
	call writeString
	call mouse_detector
ENDPROC:
	call crlf
ret
getSearch ENDP


searchList PROC
call ClrScr
	mov edi,Head_Pointer
	mov ebx,00h
	mov Previous_Node,edi
SEARCH_IN_LOOP:
	mov eax,[edi]
	INVOKE Str_compare, ADDR Searched_ID, edi
	je FOUND
	mov Previous_Node,edi
	add edi,EntryTotalSize
	mov edi,[edi]
	cmp [edi+EntryTotalSize],ebx
je NOT_FOUND

jmp SEARCH_IN_LOOP
FOUND:
	mov FOUND_BOOLEAN,TRUE
	mov Current_Node,edi
	Call Crlf
	mov edx,OFFSET FOUND_DISPLAY
	call writeString
	call displayPERSONNEL
jmp EXIT_1

NOT_FOUND:
	mov FOUND_BOOLEAN,FALSE
	call Crlf
	mov edx,OFFSET notFOUND_DISPLAY
	call writeString
	call Crlf
EXIT_1: 

ret
searchList ENDP



update PROC
	mov dl,0
	mov dh,6
	call Gotoxy
	mov edx,OFFSET NEW_INFO_MESSAGE
	call WriteString
	call Crlf
	mov edx,OFFSET PERSONNEL_ID_MESSAGE
	call writeString
	mov edx,OFFSET THIS_PERSONNEL.ID_NUMBER
	mov ecx,ID_MAX
	call readString
	mov edx,OFFSET CUSTOMER_LAST_NAME
	call writeString
	mov edx,OFFSET THIS_PERSONNEL.Last_Name
	call readString
	mov edi,Current_Node
	INVOKE Str_copy, ADDR THIS_PERSONNEL.ID_NUMBER, edi
	add edi,SIZEOF THIS_PERSONNEL.ID_NUMBER
	INVOKE Str_copy, ADDR THIS_PERSONNEL.Last_Name, edi
	add edi,SIZEOF THIS_PERSONNEL.Last_Name
	call crlf
	mov edx,OFFSET PERSONNEL_UPDATED_AFTER
	call writestring
	call crlf

ret
update ENDP



deleteNode PROC
	mov edi,Current_Node
	add edi,EntryTotalSize
	mov eax,[edi]
	mov Next_Node,eax
	mov edi,Current_Node
	.if(edi == Head_Pointer)
	mov Head_Pointer,eax
	.endif
	mov edi,Previous_Node
	add edi,EntryTotalSize
	mov eax,Next_Node
	mov [edi],eax
	mov edi,Current_Node
INVOKE heapFree, hHeap, dwFlags, edi
call Crlf

mov edx,OFFSET DELETE_MESSAGE
	call writeString
	call Crlf
call mouse_detector
ret
deleteNode ENDP


end main


