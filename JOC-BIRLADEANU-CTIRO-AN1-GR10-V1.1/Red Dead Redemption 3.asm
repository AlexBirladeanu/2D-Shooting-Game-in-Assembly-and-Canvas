.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date

; Realizator: Bîrlădeanu Alexandru-Gabriel
; Sectia: CTI RO
; Grupa 302110

window_title DB "Red dead redemption 3",0
area_width EQU 1000
area_height EQU 600
area DD 0

counter DD 0 ; numara evenimentele de tip timer
counter_left DD 0
counter_right DD 0
arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20
pozitie_y1 DD 61
shooting_position1 DD 61
previous_shooting_position1 DD 61
bullet1_timer DD 9
bullet1_x DD 301
pozitie_y2 DD 381
shooting_position2 DD 381
previous_shooting_position2 DD 381
bullet2_timer DD 20
bullet2_x DD 661
up_or_down1 DD 0
up_or_down2 DD 0
;map 24x9
coloana_map EQU 23
linie_map EQU 8
x0 EQU 61
y0 EQU 980
elements_on_one_line EQU 24 
new_symbol_height EQU 40
new_symbol_width EQU 40

symbol_width EQU 10
symbol_height EQU 20
blue EQU 0000cch

difficulty_mode DD 5
easy_dif_enable DD 0
normal_dif_enable DD 1
impossible_dif_enable DD 0
c1 DD 3
c2 DD 3
c3 DD 3
c4 DD 3
c5 DD 3
c6 DD 3
c7 DD 3
c8 DD 3
current_cactus DD 0
shot DD 0
sterge_glont DD 0
map DD	0, 0, 0, 0, 3, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0
	DD	0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0
	DD	0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0
	DD	0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0
	DD	0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0
	DD	0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0
	DD	0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0
	DD	0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0
	DD	0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 2, 0, 3, 0, 0, 0, 0
	
include digits.inc
include letters.inc
include new.inc

.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_symbol proc
	push ebp
	mov ebp, esp
	pusha
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	sub eax,0
	lea esi, symbols
	mov ebx, new_symbol_width
	mul ebx
	mov ebx, new_symbol_height
	mul ebx
	add esi, eax
	mov ecx, new_symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, new_symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, new_symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_maro
	cmp byte ptr [esi], 1
	je simbol_pixel_negru
	cmp byte ptr [esi], 2
	je simbol_pixel_maro_inchis
	cmp byte ptr [esi], 3
	je simbol_pixel_verde
	cmp byte ptr [esi], 4
	je simbol_pixel_portocaliu
	cmp byte ptr [esi], 5
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_maro:
	mov dword ptr [edi], 996633h
	jmp simbol_pixel_next
simbol_pixel_negru:
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_maro_inchis:
	mov dword ptr [edi], 4D2F13h
	jmp simbol_pixel_next
simbol_pixel_portocaliu:
	mov dword ptr [edi], 0FFC176h
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi],0FFFFFFh
	jmp simbol_pixel_next
simbol_pixel_verde:
	mov dword ptr [edi], 23BA13h
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_symbol endp

make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_maro
	cmp byte ptr [esi], 1
	je simbol_pixel_negru
simbol_pixel_maro:
	mov dword ptr [edi], 996633h
	jmp simbol_pixel_next
simbol_pixel_negru:
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp


make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

make_symbols_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_symbol
	add esp, 16
endm

build_map macro x0, y0
	mov  ecx, 0
	mov  ebp, 0
	mov  edi, 0
	mov  esi, 0
start_building:
	cmp ecx, linie_map
		jg end_build_map
	cmp ebp, coloana_map
		jg next_line
	mov eax, ecx
	mov ebx, elements_on_one_line
	mul ebx
	add eax, ebp
	mov ebx, 4
	mul ebx
	mov ebx, eax
	mov eax, ebp
	mov esi, new_symbol_width
	mul esi
	add eax, x0
	mov esi, eax
	mov eax, ecx
	mov edi, new_symbol_width
	mul edi
	add eax, y0
	mov edi, eax
	make_symbols_macro map[ebx], area, esi, edi
	add ebp, 1
	jmp start_building

	next_line:
		mov ebp, 0
		add ecx, 1
		jmp start_building
	end_build_map:
		mov ecx,0
		mov ebp,0
		mov eax,0
		mov edi,0
endm


; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 0;rep stosd
	push area
	call memset
	add esp, 12
	jmp afisare_litere
	
evt_click:
	verificare_easy_dif:
	mov eax, [ebp+arg2]
	cmp eax,160
	jl verificare_normal_dif
	cmp eax,200
	jg verificare_normal_dif
	mov eax, [ebp+arg3]
	cmp eax,490
	jl verificare_normal_dif
	cmp eax,510
	jg verificare_normal_dif
	mov easy_dif_enable,1
	mov normal_dif_enable,0
	mov impossible_dif_enable,0
	make_symbols_macro 18, area, 280, 470
	make_symbols_macro 19, area, 280, 510
	make_symbols_macro 19, area, 280, 550
	
	verificare_normal_dif:
	mov eax, [ebp+arg2]
	cmp eax,160
	jl verificare_impossible_dif
	cmp eax,220
	jg verificare_impossible_dif
	mov eax, [ebp+arg3]
	cmp eax,530
	jl verificare_impossible_dif
	cmp eax,550
	jg verificare_impossible_dif
	mov normal_dif_enable,1
	mov easy_dif_enable,0
	mov impossible_dif_enable,0
	make_symbols_macro 19, area, 280, 470
	make_symbols_macro 18, area, 280, 510
	make_symbols_macro 19, area, 280, 550
	
	verificare_impossible_dif:
	mov eax, [ebp+arg2]
	cmp eax,160
	jl verificare_buton_shoot
	cmp eax,260
	jg verificare_buton_shoot
	mov eax, [ebp+arg3]
	cmp eax,570
	jl verificare_buton_shoot
	cmp eax,590
	jg verificare_buton_shoot
	mov impossible_dif_enable,1
	mov easy_dif_enable,0
	mov normal_dif_enable,0
	make_symbols_macro 19, area, 280, 470
	make_symbols_macro 19, area, 280, 510
	make_symbols_macro 18, area, 280, 550
	
	verificare_buton_shoot:
	mov eax, [ebp+arg2]
	cmp eax,380
	jl verificare_buton_dodge
	cmp eax,540
	jg verificare_buton_dodge
	mov eax, [ebp+arg3]
	cmp eax,475
	jl verificare_buton_dodge
	cmp eax,555
	jg verificare_buton_dodge
		activare_buton_shoot:
	mov shot,1
	mov eax,pozitie_y1
	mov shooting_position1,eax
	
	verificare_buton_dodge:
	mov eax, [ebp+arg2]
	cmp eax,540
	jl afisare_litere
	cmp eax,620
	jg afisare_litere
	mov eax, [ebp+arg3]
	cmp eax,475
	jl afisare_litere
	cmp eax,555
	jg afisare_litere
		activare_buton_dodge:	
	cmp up_or_down1,0
	je switch_to_up
	cmp up_or_down1,1
	je switch_to_down
	
	switch_to_up:
		mov up_or_down1,1
		jmp afisare_litere
	switch_to_down:
		mov up_or_down1,0
		jmp afisare_litere
	
evt_timer:
	cmp counter,0
	je build_the_map
	continue:
	cmp counter,15
	jl check_score
	make_text_macro ' ',area,461,61
	make_text_macro ' ',area,471,61
	make_text_macro ' ',area,481,61
	make_text_macro ' ',area,491,61
	make_text_macro ' ',area,501,61
	make_text_macro ' ',area,511,61
	make_text_macro ' ',area,521,61
	make_text_macro ' ',area,531,61
	check_score:
	mov eax,counter_left
	cmp eax,5
	je you_won
	mov eax,counter_right
	cmp eax,5
	je you_lost
	
	inc counter	
;left player
check_first_cactus:
	cmp shooting_position1,81
	jl check_second_cactus
	cmp shooting_position1,121
	jg check_second_cactus
	cmp bullet1_timer,4
	jne check_second_cactus
	cmp c1,0
	je end_cactus
	cmp c1,3
	jne c1_is_not_3
	make_symbols_macro 4,area,501,101
	mov c1,4
	mov bullet1_timer,9
	jmp end_cactus
c1_is_not_3:
	cmp c1,4
	jne c1_is_not_3_or_4
	make_symbols_macro 5,area,501,101
	mov c1,5
	mov bullet1_timer,9
	jmp end_cactus
c1_is_not_3_or_4:
	make_symbols_macro 0,area,501,101
	mov c1,0
	mov bullet1_timer,9
	jmp end_cactus

check_second_cactus:
	cmp shooting_position1,141
	jl check_third_cactus
	cmp shooting_position1,161
	jg check_third_cactus
	cmp bullet1_timer,4
	jne check_third_cactus
	cmp c2,0
	je end_cactus
	cmp c2,3
	jne c2_is_not_3
	make_symbols_macro 4,area,501,141
	mov c2,4
	mov bullet1_timer,9
	jmp end_cactus
c2_is_not_3:
	cmp c2,4
	jne c2_is_not_3_or_4
	make_symbols_macro 5,area,501,141
	mov c2,5
	mov bullet1_timer,9
	jmp end_cactus
c2_is_not_3_or_4:
	make_symbols_macro 0,area,501,141
	mov c2,0
	mov bullet1_timer,9
	jmp end_cactus
check_third_cactus:
cmp shooting_position1,181
	jl check_fourth_cactus
	cmp shooting_position1,201
	jg check_fourth_cactus
	cmp bullet1_timer,4
	jne check_fourth_cactus
	cmp c3,0
	je end_cactus
	cmp c3,3
	jne c3_is_not_3
	make_symbols_macro 4,area,501,181
	mov c3,4
	mov bullet1_timer,9
	jmp end_cactus
c3_is_not_3:
	cmp c3,4
	jne c3_is_not_3_or_4
	make_symbols_macro 5,area,501,181
	mov c3,5
	mov bullet1_timer,9
	jmp end_cactus
c3_is_not_3_or_4:
	make_symbols_macro 0,area,501,181
	mov c3,0
	mov bullet1_timer,9
	jmp end_cactus
check_fourth_cactus:
	cmp shooting_position1,221
	jl check_fifth_cactus
	cmp shooting_position1,241
	jg check_fifth_cactus
	cmp bullet1_timer,4
	jne check_fifth_cactus
	cmp c4,0
	je end_cactus
	cmp c4,3
	jne c4_is_not_3
	make_symbols_macro 4,area,501,221
	mov c4,4
	mov bullet1_timer,9
	jmp end_cactus
c4_is_not_3:
	cmp c4,4
	jne c4_is_not_3_or_4
	make_symbols_macro 5,area,501,221
	mov c4,5
	mov bullet1_timer,9
	jmp end_cactus
c4_is_not_3_or_4:
	make_symbols_macro 0,area,501,221
	mov c4,0
	mov bullet1_timer,9
	jmp end_cactus
check_fifth_cactus:
	cmp shooting_position1,261
	jl check_sixth_cactus
	cmp shooting_position1,281
	jg check_sixth_cactus
	cmp bullet1_timer,4
	jne check_sixth_cactus
	cmp c5,0
	je end_cactus
	cmp c5,3
	jne c5_is_not_3
	make_symbols_macro 4,area,501,261
	mov c5,4
	mov bullet1_timer,9
	jmp end_cactus
c5_is_not_3:
	cmp c5,4
	jne c5_is_not_3_or_4
	make_symbols_macro 5,area,501,261
	mov c5,5
	mov bullet1_timer,9
	jmp end_cactus
c5_is_not_3_or_4:
	make_symbols_macro 0,area,501,261
	mov c5,0
	mov bullet1_timer,9
	jmp end_cactus
check_sixth_cactus:
	cmp shooting_position1,301
	jl check_seventh_cactus
	cmp shooting_position1,321
	jg check_seventh_cactus
	cmp bullet1_timer,4
	jne check_seventh_cactus
	cmp c6,0
	je end_cactus
	cmp c6,3
	jne c6_is_not_3
	make_symbols_macro 4,area,501,301
	mov c6,4
	mov bullet1_timer,9
	jmp end_cactus
c6_is_not_3:
	cmp c6,4
	jne c6_is_not_3_or_4
	make_symbols_macro 5,area,501,301
	mov c6,5
	mov bullet1_timer,9
	jmp end_cactus
c6_is_not_3_or_4:
	make_symbols_macro 0,area,501,301
	mov c6,0
	mov bullet1_timer,9
	jmp end_cactus
check_seventh_cactus:
cmp shooting_position1,341
	jl check_8_cactus
	cmp shooting_position1,361
	jg check_8_cactus
	cmp bullet1_timer,4
	jne check_8_cactus
	cmp c7,0
	je end_cactus
	cmp c7,3
	jne c7_is_not_3
	make_symbols_macro 4,area,501,341
	mov c7,4
	mov bullet1_timer,9
	jmp end_cactus
c7_is_not_3:
	cmp c7,4
	jne c7_is_not_3_or_4
	make_symbols_macro 5,area,501,341
	mov c7,5
	mov bullet1_timer,9
	jmp end_cactus
c7_is_not_3_or_4:
	make_symbols_macro 0,area,501,341
	mov c7,0
	mov bullet1_timer,9
	jmp end_cactus
check_8_cactus:	
	cmp shooting_position1,381
	jl end_cactus
	cmp shooting_position1,401
	jg end_cactus
	cmp bullet1_timer,4
	jne end_cactus
	cmp c8,0
	je end_cactus
	cmp c8,3
	jne c8_is_not_3
	make_symbols_macro 4,area,501,381
	mov c8,4
	mov bullet1_timer,9
	jmp end_cactus
c8_is_not_3:
	cmp c8,4
	jne c8_is_not_3_or_4
	make_symbols_macro 5,area,501,381
	mov c8,5
	mov bullet1_timer,9
	jmp end_cactus
c8_is_not_3_or_4:
	make_symbols_macro 0,area,501,381
	mov c8,0
	mov bullet1_timer,9
	jmp end_cactus

end_cactus:
	cmp shot,1
	je shoot
		stop_bullet1:
	cmp bullet1_timer,9
	jne move_bullet1
	mov bullet1_timer,20
	make_symbols_macro 0,area,bullet1_x,shooting_position1
		check_if_opponent_hit:
	mov eax,pozitie_y2
	add eax,39
	cmp shooting_position1 , eax
	jg move_bullet1
	mov eax,pozitie_y2
	sub eax,39
	cmp shooting_position1,eax
	jl move_bullet1
	cmp bullet1_x,661
	jne move_bullet1
	inc counter_left ;raise left score
	
		move_bullet1:
	cmp bullet1_timer,8
	jg deplasare
	make_symbols_macro 0, area,bullet1_x, shooting_position1
	add bullet1_x,40
	make_symbols_macro 20, area,bullet1_x, shooting_position1
	inc bullet1_timer
	
	deplasare:
	cmp up_or_down1,0
	je deplasare_jos
	cmp up_or_down1,1
	je deplasare_sus

	deplasare_jos:
		mov eax,pozitie_y1
		cmp eax,381
		je deplasare_sus
		mov up_or_down1,0
		make_symbols_macro 0,area,261,eax
		add eax,20
		add pozitie_y1,20
		make_symbols_macro 1,area,261,eax
		jmp right_player
	deplasare_sus:
		mov eax,pozitie_y1
		cmp eax,61
		je deplasare_jos
		mov up_or_down1,1
		make_symbols_macro 0,area,261,eax
		sub eax,20
		sub pozitie_y1,20
		make_symbols_macro 1,area,261,eax
		jmp right_player
	shoot:
		mov shot,0
		
		make_symbols_macro 0, area,bullet1_x, previous_shooting_position1
		mov bullet1_x,301 
		make_symbols_macro 20, area,301, shooting_position1
		mov bullet1_timer,0
		mov eax,shooting_position1
		mov previous_shooting_position1,eax
		jmp deplasare
	
right_player:
check_cactus1_enemy:
	cmp shooting_position2,81
	jl check_cactus2_enemy
	cmp shooting_position2,121
	jg check_cactus2_enemy
	cmp bullet2_timer,4
	jne check_cactus2_enemy
	cmp c1,0
	je end_cactus_enemy
	cmp c1,3
	jne c1_is_not_3_enemy
	make_symbols_macro 4,area,501,101
	mov c1,4
	mov bullet2_timer,10
	jmp end_cactus_enemy
c1_is_not_3_enemy:
	cmp c1,4
	jne c1_is_not_3_or_4_enemy
	make_symbols_macro 5,area,501,101
	mov c1,5
	mov bullet2_timer,10
	jmp end_cactus_enemy
c1_is_not_3_or_4_enemy:
	make_symbols_macro 0,area,501,101
	mov c1,0
	mov bullet2_timer,10
	jmp end_cactus_enemy
check_cactus2_enemy:
	cmp shooting_position2,141
	jl check_cactus3_enemy
	cmp shooting_position2,161
	jg check_cactus3_enemy
	cmp bullet2_timer,4
	jne check_cactus3_enemy
	cmp c2,0
	je end_cactus_enemy
	cmp c2,3
	jne c2_is_not_3_enemy
	make_symbols_macro 4,area,501,141
	mov c2,4
	mov bullet2_timer,10
	jmp end_cactus_enemy
c2_is_not_3_enemy:
	cmp c2,4
	jne c2_is_not_3_or_4_enemy
	make_symbols_macro 5,area,501,141
	mov c2,5
	mov bullet2_timer,10
	jmp end_cactus_enemy
c2_is_not_3_or_4_enemy:
	make_symbols_macro 0,area,501,141
	mov c2,0
	mov bullet2_timer,10
	jmp end_cactus_enemy
check_cactus3_enemy:
cmp shooting_position2,181
	jl check_cactus4_enemy
	cmp shooting_position2,201
	jg check_cactus4_enemy
	cmp bullet2_timer,4
	jne check_cactus4_enemy
	cmp c3,0
	je end_cactus_enemy
	cmp c3,3
	jne c3_is_not_3_enemy
	make_symbols_macro 4,area,501,181
	mov c3,4
	mov bullet2_timer,10
	jmp end_cactus_enemy
c3_is_not_3_enemy:
	cmp c3,4
	jne c3_is_not_3_or_4_enemy
	make_symbols_macro 5,area,501,181
	mov c3,5
	mov bullet2_timer,10
	jmp end_cactus_enemy
c3_is_not_3_or_4_enemy:
	make_symbols_macro 0,area,501,181
	mov c3,0
	mov bullet2_timer,10
	jmp end_cactus_enemy
check_cactus4_enemy:
cmp shooting_position2,221
	jl check_cactus5_enemy
	cmp shooting_position2,241
	jg check_cactus5_enemy
	cmp bullet2_timer,4
	jne check_cactus5_enemy
	cmp c4,0
	je end_cactus_enemy
	cmp c4,3
	jne c4_is_not_3_enemy
	make_symbols_macro 4,area,501,221
	mov c4,4
	mov bullet2_timer,10
	jmp end_cactus_enemy
c4_is_not_3_enemy:
	cmp c4,4
	jne c4_is_not_3_or_4_enemy
	make_symbols_macro 5,area,501,221
	mov c4,5
	mov bullet2_timer,10
	jmp end_cactus_enemy
c4_is_not_3_or_4_enemy:
	make_symbols_macro 0,area,501,221
	mov c4,0
	mov bullet2_timer,10
	jmp end_cactus_enemy
check_cactus5_enemy:
cmp shooting_position2,261
	jl check_cactus6_enemy
	cmp shooting_position2,281
	jg check_cactus6_enemy
	cmp bullet2_timer,4
	jne check_cactus6_enemy
	cmp c5,0
	je end_cactus_enemy
	cmp c5,3
	jne c5_is_not_3_enemy
	make_symbols_macro 4,area,501,261
	mov c5,4
	mov bullet2_timer,10
	jmp end_cactus_enemy
c5_is_not_3_enemy:
	cmp c5,4
	jne c5_is_not_3_or_4_enemy
	make_symbols_macro 5,area,501,261
	mov c5,5
	mov bullet2_timer,10
	jmp end_cactus_enemy
c5_is_not_3_or_4_enemy:
	make_symbols_macro 0,area,501,261
	mov c5,0
	mov bullet2_timer,10
	jmp end_cactus_enemy
check_cactus6_enemy:
cmp shooting_position2,301
	jl check_cactus7_enemy
	cmp shooting_position2,321
	jg check_cactus7_enemy
	cmp bullet2_timer,4
	jne check_cactus7_enemy
	cmp c6,0
	je end_cactus_enemy
	cmp c6,3
	jne c6_is_not_3_enemy
	make_symbols_macro 4,area,501,301
	mov c6,4
	mov bullet2_timer,10
	jmp end_cactus_enemy
c6_is_not_3_enemy:
	cmp c6,4
	jne c6_is_not_3_or_4_enemy
	make_symbols_macro 5,area,501,301
	mov c6,5
	mov bullet2_timer,10
	jmp end_cactus_enemy
c6_is_not_3_or_4_enemy:
	make_symbols_macro 0,area,501,301
	mov c6,0
	mov bullet2_timer,10
	jmp end_cactus_enemy
check_cactus7_enemy:
cmp shooting_position2,341
	jl check_cactus8_enemy
	cmp shooting_position2,361
	jg check_cactus8_enemy
	cmp bullet2_timer,4
	jne check_cactus8_enemy
	cmp c7,0
	je end_cactus_enemy
	cmp c7,3
	jne c7_is_not_3_enemy
	make_symbols_macro 4,area,501,341
	mov c7,4
	mov bullet2_timer,10
	jmp end_cactus_enemy
c7_is_not_3_enemy:
	cmp c7,4
	jne c7_is_not_3_or_4_enemy
	make_symbols_macro 5,area,501,341
	mov c7,5
	mov bullet2_timer,10
	jmp end_cactus_enemy
c7_is_not_3_or_4_enemy:
	make_symbols_macro 0,area,501,341
	mov c7,0
	mov bullet2_timer,10
	jmp end_cactus_enemy
check_cactus8_enemy:
cmp shooting_position2,381
	jl end_cactus_enemy
	cmp shooting_position2,401
	jg end_cactus_enemy
	cmp bullet2_timer,4
	jne end_cactus_enemy
	cmp c8,0
	je end_cactus_enemy
	cmp c8,3
	jne c8_is_not_3_enemy
	make_symbols_macro 4,area,501,381
	mov c8,4
	mov bullet2_timer,10
	jmp end_cactus_enemy
c8_is_not_3_enemy:
	cmp c8,4
	jne c8_is_not_3_or_4_enemy
	make_symbols_macro 5,area,501,381
	mov c8,5
	mov bullet2_timer,10
	jmp end_cactus_enemy
c8_is_not_3_or_4_enemy:
	make_symbols_macro 0,area,501,381
	mov c8,0
	mov bullet2_timer,10
	jmp end_cactus_enemy
end_cactus_enemy:
	
	cmp easy_dif_enable,1
	je set_easy_dif
	cmp normal_dif_enable,1
	je set_normal_dif
	cmp impossible_dif_enable,1
	je set_impossible_dif
	
	set_easy_dif:
	mov edx,pozitie_y2
	cmp shooting_position1,edx
	jle deplasare_sus2
	mov edx,pozitie_y2
	cmp shooting_position1,edx
	jg deplasare_jos2
	
	set_impossible_dif:
	cmp bullet1_timer,9
	jg deplasare_automata2
	check_opponent:
	mov edx,pozitie_y2
	cmp shooting_position1,edx
	jle deplasare_jos2
	mov edx,pozitie_y2
	cmp shooting_position1,edx
	jg deplasare_sus2
	
	set_normal_dif:
	deplasare_automata2:
	cmp up_or_down2,0
	je deplasare_jos2
	cmp up_or_down2,1
	je deplasare_sus2
	
	deplasare_jos2:
		cmp pozitie_y2,381
		je deplasare_sus2
		mov up_or_down2,0
		mov ecx,pozitie_y2
		make_symbols_macro 0,area,701,ecx
		add ecx,20
		add pozitie_y2,20
		make_symbols_macro 2,area,701,ecx
		jmp check_to_shoot
	deplasare_sus2:
		cmp pozitie_y2,61
		je deplasare_jos2
		mov up_or_down2,1
		mov ecx,pozitie_y2
		make_symbols_macro 0,area,701,ecx
		sub ecx,20
		sub pozitie_y2,20
		make_symbols_macro 2,area,701,ecx
		jmp check_to_shoot
	
		check_to_shoot:
	cmp bullet2_timer,10
	jle check_if_player_left_hit; sa nu isi anuleze glontul adica sa nu traga daca glontul initial nu a ajuns pana la sfarsit
		cazul1:
	cmp up_or_down1,0
	jne cazul2
	mov eax,pozitie_y2
	sub eax,pozitie_y1
	mov ebx,eax
	cmp ebx,142
	jl cazul2
	cmp ebx,218
	jg cazul2
	mov bullet2_timer,0
	mov eax,pozitie_y2
	mov shooting_position2,eax
		cazul2:
	cmp up_or_down1,1
	jne cazul3
	mov eax,pozitie_y1
	sub eax,pozitie_y2
	mov ebx,eax
	cmp ebx,142
	jl cazul3
	cmp ebx,218
	jg cazul3
	mov bullet2_timer,0
	mov eax,pozitie_y2
	mov shooting_position2,eax
		cazul3:	
	cmp up_or_down1,1
	jne cazul4
	mov eax,pozitie_y2
	cmp pozitie_y1,eax
	jg cazul4
	sub eax,61
	mov ebx,eax
	cmp ebx,142
	jl cazul4
	cmp ebx,218
	jg cazul4
	mov bullet2_timer,0
	mov eax,pozitie_y2
	mov shooting_position2,eax
		cazul4:
	cmp up_or_down1,0
	jne check_if_player_left_hit
	mov eax,pozitie_y1
	cmp pozitie_y2,eax
	jg check_if_player_left_hit
	mov ebx,381
	mov eax,pozitie_y2
	sub ebx,eax
	cmp ebx,142
	jl check_if_player_left_hit
	cmp ebx,218
	jg check_if_player_left_hit
	mov bullet2_timer,0
	mov eax,pozitie_y2
	mov shooting_position2,eax
		
		check_if_player_left_hit:
	cmp bullet2_timer,10
	jne missed
	mov eax,pozitie_y1
	add eax,39
	cmp shooting_position2 , eax
	jg missed
	mov eax,pozitie_y1
	sub eax,39
	cmp shooting_position2,eax
	jl missed
	cmp bullet2_x,301
	jne missed
	inc counter_right ;raise right score
missed:	
	cmp bullet2_timer,0
	je enemy_shoot
	cmp bullet2_timer,10
	jne move_bullet2
	mov bullet2_timer,20
	make_symbols_macro 0,area,bullet2_x,shooting_position2
	
		move_bullet2:
	cmp bullet2_timer,9
	jg afisare_litere
	make_symbols_macro 0, area,bullet2_x, shooting_position2
	sub bullet2_x,40
	make_symbols_macro 21, area,bullet2_x, shooting_position2
	inc bullet2_timer
	jmp afisare_litere
	
	enemy_shoot:
		make_symbols_macro 0, area,bullet2_x, previous_shooting_position2
		mov bullet2_x,661 
		make_symbols_macro 21, area,661, shooting_position2
		inc bullet2_timer
		mov eax,shooting_position2
		mov previous_shooting_position2,eax
		jmp afisare_litere
	
	you_won:
	mov counter_left,0
	mov counter_right,0
	mov counter,0
	mov bullet1_timer,20
	;stergem jucatorii si gloantele din locul unde au ramas cand s a incheiat partida
	make_symbols_macro 0,area,701,pozitie_y2
	make_symbols_macro 0,area,261,pozitie_y1
	make_symbols_macro 0, area,bullet1_x, previous_shooting_position1

	
	make_text_macro 'Y',area,461,61
	make_text_macro 'O',area,471,61
	make_text_macro 'U',area,481,61
	make_text_macro ' ',area,491,61
	make_text_macro 'W',area,501,61
	make_text_macro 'O',area,511,61
	make_text_macro 'N',area,521,61
	make_symbols_macro 3,area,501,101
	make_symbols_macro 3,area,501,141
	make_symbols_macro 3,area,501,181
	make_symbols_macro 3,area,501,221
	make_symbols_macro 3,area,501,261
	make_symbols_macro 3,area,501,301
	make_symbols_macro 3,area,501,341
	make_symbols_macro 3,area,501,381
	mov c1,3
	mov c2,3
	mov c3,3
	mov c4,3
	mov c5,3
	mov c6,3
	mov c7,3
	mov c8,3
	mov pozitie_y1,61
	mov pozitie_y2,381
	jmp continue
	
	you_lost:
	mov counter_left,0
	mov counter_right,0
	mov counter,0
	mov bullet1_timer,20
	;stergem jucatorii si gloantele din locul unde au ramas cand s a incheiat partida
	make_symbols_macro 0,area,701,pozitie_y2
	make_symbols_macro 0,area,261,pozitie_y1
	make_symbols_macro 0, area,bullet1_x, previous_shooting_position1
	
	make_text_macro 'Y',area,461,61
	make_text_macro 'O',area,471,61
	make_text_macro 'U',area,481,61
	make_text_macro ' ',area,491,61
	make_text_macro 'L',area,501,61
	make_text_macro 'O',area,511,61
	make_text_macro 'S',area,521,61
	make_text_macro 'T',area,531,61
	make_symbols_macro 3,area,501,101
	make_symbols_macro 3,area,501,141
	make_symbols_macro 3,area,501,181
	make_symbols_macro 3,area,501,221
	make_symbols_macro 3,area,501,261
	make_symbols_macro 3,area,501,301
	make_symbols_macro 3,area,501,341
	make_symbols_macro 3,area,501,381
	mov c1,3
	mov c2,3
	mov c3,3
	mov c4,3
	mov c5,3
	mov c6,3
	mov c7,3
	mov c8,3
	mov pozitie_y1,61
	mov pozitie_y2,381
	jmp continue
	
	build_the_map:
	build_map 21,61
	make_text_macro 'D', area,  40,530
	make_text_macro 'I', area,  50,530
	make_text_macro 'F', area,  60,530
	make_text_macro 'F', area,  70,530
	make_text_macro 'I', area,  80,530
	make_text_macro 'C', area,  90,530
	make_text_macro 'U', area,  100,530
	make_text_macro 'L', area,  110,530
	make_text_macro 'T', area,  120,530
	make_text_macro 'Y', area,  130,530
	
	make_text_macro 'E', area,  160,490
	make_text_macro 'A', area,  170,490
	make_text_macro 'S', area,  180,490
	make_text_macro 'Y', area,  190,490
	
	make_text_macro 'N', area,  160,530
	make_text_macro 'O', area,  170,530
	make_text_macro 'R', area,  180,530
	make_text_macro 'M', area,  190,530
	make_text_macro 'A', area,  200,530
	make_text_macro 'L', area,  210,530
	
	make_text_macro 'I', area,  160,570
	make_text_macro 'M', area,  170,570
	make_text_macro 'P', area,  180,570
	make_text_macro 'O', area,  190,570
	make_text_macro 'S', area,  200,570
	make_text_macro 'S', area,  210,570
	make_text_macro 'I', area,  220,570
	make_text_macro 'B', area,  230,570
	make_text_macro 'L', area,  240,570
	make_text_macro 'E', area,  250,570

	make_symbols_macro 19, area, 280, 470
	make_symbols_macro 18, area, 280, 510
	make_symbols_macro 19, area, 280, 550
	jmp continue
afisare_litere:
	;afisam valoarea counter-ului din stanga (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter_left
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 170, 460
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 160, 460
	;cifra sutelor
	; mov edx, 0
	; div ebx
	; add edx, '0'
	;make_text_macro edx, area, 180, 460
	
	;afisam valoarea counter-ului din dreapta (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter_right
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 960, 460
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 950, 460
	;cifra sutelor
	; mov edx, 0
	; div ebx
	; add edx, '0'
	;make_text_macro edx, area, 970, 460
	
	
;cadrannul de joc este de la x=21 la x=980
;cadrannul de joc este de la y=61 la y=420
;cadrannul de joc este de 960x360
;titlu	
	make_text_macro ' ', area, 295, 30
	make_text_macro ' ', area, 305, 30
	make_text_macro ' ', area, 315, 30
	make_text_macro ' ', area, 325, 30
	make_text_macro ' ', area, 335, 30
	make_text_macro ' ', area, 345, 30
	make_text_macro ' ', area, 355, 30
	make_text_macro ' ', area, 365, 30
	make_text_macro ' ', area, 375, 30
	make_text_macro 'R', area, 385, 30
	make_text_macro 'E', area, 395, 30
	make_text_macro 'D', area, 405, 30
	make_text_macro ' ', area, 415, 30
	make_text_macro 'D', area, 425, 30
	make_text_macro 'E', area, 435, 30
	make_text_macro 'A', area, 445, 30
	make_text_macro 'D', area, 455, 30
	make_text_macro ' ', area, 465, 30
	make_text_macro 'R', area, 475, 30
	make_text_macro 'E', area, 485, 30
	make_text_macro 'D', area, 495, 30
	make_text_macro 'E', area, 505, 30
	make_text_macro 'M', area, 515, 30
	make_text_macro 'P', area, 525, 30
	make_text_macro 'T', area, 535, 30
	make_text_macro 'I', area, 545, 30
	make_text_macro 'O', area, 555, 30	
	make_text_macro 'N', area, 565, 30
	make_text_macro ' ', area, 575, 30
	make_text_macro '3', area, 585, 30
	make_text_macro ' ', area, 595, 30
	make_text_macro ' ', area, 605, 30
	make_text_macro ' ', area, 615, 30
	make_text_macro ' ', area, 625, 30
	make_text_macro ' ', area, 635, 30
	make_text_macro ' ', area, 645, 30
	make_text_macro ' ', area, 655, 30
	make_text_macro ' ', area, 665, 30
	make_text_macro ' ', area, 675, 30
	make_text_macro ' ', area, 685, 30
	make_text_macro ' ', area, 695, 30
	
;score text
	make_text_macro ' ', area,  40,460
	make_text_macro 'Y', area,  50,460
	make_text_macro 'O', area,  60,460
	make_text_macro 'U', area,  70,460
	make_text_macro 'R', area,  80,460
	make_text_macro ' ', area,  90,460
	make_text_macro 'S', area, 100,460
	make_text_macro 'C', area, 110,460
	make_text_macro 'O', area, 120,460
	make_text_macro 'R', area, 130,460
	make_text_macro 'E', area, 140,460
	make_text_macro ' ', area, 150,460
	
	make_text_macro ' ', area, 820,460
	make_text_macro 'E', area, 830,460
	make_text_macro 'N', area, 840,460
	make_text_macro 'E', area, 850,460
	make_text_macro 'M', area, 860,460
	make_text_macro 'Y', area, 870,460
	make_text_macro ' ', area, 880,460
	make_text_macro 'S', area, 890,460
	make_text_macro 'C', area, 900,460
	make_text_macro 'O', area, 910,460
	make_text_macro 'R', area, 920,460
	make_text_macro 'E', area, 930,460
	make_text_macro ':', area, 940,460

;butoane
;shoot
	make_symbols_macro 10, area, 380, 475
	make_symbols_macro 11, area, 420, 475
	make_symbols_macro 12, area, 460, 475
	make_symbols_macro 13, area, 500, 475
	make_symbols_macro 14, area, 380, 515
	make_symbols_macro 15, area, 420, 515
	make_symbols_macro 16, area, 460, 515
	make_symbols_macro 17, area, 500, 515
	
;dodge	
	make_symbols_macro 6, area, 540, 475
	make_symbols_macro 8, area, 580, 475
	make_symbols_macro 7, area, 540, 515
	make_symbols_macro 9, area, 580, 515

final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
