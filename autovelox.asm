.data

.byte 0x0, 0x0			#celle in e out
.word 500000000			#frequenza di clock del processore


.text

main:		li $t7, 62500000		#attesa 25 ms nel r.temp
		add $t8, $zero, $t7		#attesa 25 ms nel reg
		li $t7, 250000000	
		add $t9, $zero, $t7		#attesa 1 s
		add $s0, $zero, $zero		#primo VAL calcola ciclidicpu per misurare temp di sett a 1 c. 7e6

PRIMAC:		lb $s1, 0x10010000		#s1 cont. il byte IN 
		andi $t1, $s1, 128		#essendo 1 aposto 7,2^7
		beq $t1, $zero PRIMAC

SECONDAC:	lb $s1, 0x10010000
		addi $s0, $s0, 1
		andi $t1, $s1, 192
		beq $t1, $zero, SECONDAC

		sll $s0,$s0,2			#tempo*4
		
		lw $s2, 0x10010010		#legge word con freq cl
		div $s0, $s2
		mflo $t2			#t2 cont variaz. di temp
		addi $t3, $zero, 1		#t3 cont spazio 1 m
		div $t3, $t2
		mflo $s2			#s2 cont vel nel segment
		
		slti $t3, $s2, 50
		bne $t3, $zero CASO1		#CASO1 vel<50

		slti $t3, $s2, 55
		bne $t3, $zero CASO2		#CASO2 50<vel<55

		slti $t3, $s2, 60
		bne $t3, $zero CASO3		#CASO3 55<vel<60

CASO4:		addi $t9, $t9, -1		#CASO4 vel>60
		bne $t9, $zero, CASO4
		addi $s3, $zero, 56		#56=2^3+2^4+2^5 cellea 1			
		li $t7, 0x10010001
		add $s4, $zero, $t7		#SCRIVO OUT  					
		sb $s3, 0($s4)			#s3 contiene valore cell			
		j FINE

CASO1:		j FINE				#nessuna infrazione

CASO2:		addi $t9, $t9, -1		#CASO2 50<vel<55
		bne $t9, $zero, CASO2
		addi $s3, $zero, 24		#24=2^3+2^4 cellea 1				
		li $t7, 0x10010001
		add $s4, $zero, $t7		#SCRIVO OUT  					
		sb $s3, 0($s4)			#s3 contiene valore cell			
		j FINE

CASO3:		addi $t9, $t9, -1		#CASO3 55<vel<60
		bne $t9, $zero, CASO3
		addi $s3, $zero, 40		#40=2^3+2^5 cellea 1

		li $t7, 0x10010001
		add $s4, $zero, $t7		#SCRIVO OUT  					
		sb $s3, 0($s4)			#s3 contiene valore cell			
		j FINE

FINE:		addi $t8, $t8, -1		#attesa 25 ms 
		bne $t8, $zero, FINE		#ricontrolla segmento
		j main

	

		
