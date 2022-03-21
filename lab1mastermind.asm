.include "MACROSv21.s"

#########################################################################################
# USAR KEYBOARD MMIO PRA TENTAR UMA COR							#
# CARREGAR APENAS FRAME 0 NO BITMAP							#
# CHUTAR COR DE ACORDO COM O SEU CODIGO, CODIGOS PODEM SER VISTOS A PARTIR DA LINHA 193 #
#########################################################################################

#########################################################################################
#CHEATS:										#
#PULAR ROUND POR INPUT LINHA 204							#
#PRINT SENHA LINHA 344,345								#
#########################################################################################

.data
titulo: .string "MASTERMIND"
tentativas: .string "TENTATIVA: "
n: .string "TAMANHO DA SENHA: "
digitecor: .string "DIGITE CODIGO DA COR: "
numPreto: .word 6
preto: 69,500,76,500,74,500,76,500,81,600,76,1000
numBranco: .word 7
branco: 69,500,76,500,74,500,76,500,79,600, 76,1000

.text
		li s0, 10	#MAX TENTATIVAS
		li s1, 4	#N-1 INICIAL
		li s6, 22	#DIST LINHAS
nivel:		
Cabecalho:	#LIMPA TABULEIRO
		li a7,48
		li a1,0
		li a0, 00
		ecall
		#TITULO
		li a7,104
		la a0,titulo
		li a1,0
		li a2,1
		li a3,0x0038
		li a4,0
		ecall
		#TENTATIVAS
		li a7,104
		la a0,tentativas
		li a1,0
		li a2,10
		li a3,0x0038
		li a4,0
		ecall
		#N
		li a7,104
		la a0,n
		li a1,0
		li a2,20
		li a3,0x0038
		li a4,0
		ecall
		#LINHA
		li a7,147
		li a0,320
		li a1,30
		li a2,639
		li a3,30
		li a4,0x0038
		li a5,0
		ecall
		
		
		addi s1, s1, 1 				#ATUALIZA NÍVEL DO JOGO (N)
		li t0,2
		beq s6,t0,pula
		addi s6, s6, -2
pula:

		#LIMPA PARA DESENHAR TABULEIRO
		sub a0,a0,a0
		sub a1,a1,a1
		sub a2,a2,a2
		sub a3,a3,a3

		li s2,305 				#X INICIAL PRA COMEÇAR A PINTAR AS LINHAS
		li t0,0 				#COLUNA QUE ESTÁ SENDO DESENHADA
tabuleiro:	beq t0,s0,info				#SE TUDO JÁ FOI DESENHADO COMEÇA O JOGO
		addi t0,t0,1 				#PROXIMA COLUNA
		li t3,0 				#DIGITOS DESENHADOS
		li s3,70 				#Y INICIAL PARA TODAS AS COLUNAS
		addi s2,s2,30
coluna:		beq t3,s1,tabuleiro 			#SE JÁ DESENHOU TODOS OS DIGITOS DA COLUNA
		
		li a7,147				#SYSCALL
		add a0,a0,s2
		add a1,a1,s3
		addi a2,a0,10
		add a3,a3,s3
		li a4,0x0038
		li a5,0
		ecall
		
		add s3,s3,s6				#PRÓXIMO DIGITO
		addi t3,t3,1				#SOMA O DIGITO
		
		#LIMPA PARA A PRÓXIMA COLUNA (SE NECESSÁRIO)
		sub a0,a0,a0
		sub a1,a1,a1
		sub a2,a2,a2
		sub a3,a3,a3
		sub a4,a4,a4
		j coluna

info:		#PRINTA NA TELA
infoOpcoes:	li a7, 101
		li a2, 190
		li a4, 0
		li a1, 0
		li t0, 2
		li t1, 0x0300
		
		li a0, 1	#1 = VERMELHO
		li a3,0x03FF
		ecall
		

loop:		mv a0, t0	#t0 = COR
		mul a3, t1,t0
		addi a3,a3,0xFF
		ecall
		beq t0,s1,infoCores
		addi t0,t0,1
		j loop
		
		
		
		

infoCores:	li a7,104
		la a0,digitecor
		li a1,15
		li a2,210
		li a3,0x0038
		li a4,0
		ecall


infoTent:	li a7,101		
		li a0, 1
		li a1,80
		li a2,10
		li a3,0x0038
		li a4,0
		ecall
		
		
infoSenha:	li a7,101
		mv a0,s1 				#S1 GUARDA O TAMANHO DA SENHA
		li a1,137				#SYSCALL
		li a2,20
		li a3,0x0038
		li a4,0
		ecall
			
		jal ra,gerarSenha
			
		li s2,305 				#X INICIAL PRA COMEÇAR A PINTAR AS LINHAS
		li t0,0 				#COLUNA QUE ESTÁ SENDO DESENHADA
tabuleiro1:	beq t0,s0,verificacao 			#SE JA FORAM TODAS AS TENTATIVAS
		addi t0,t0,1 				#PROXIMA COLUNA
		li t3,0 				#DIGITOS DESENHADOS
		li s3,70 				#Y INICIAL PARA TODAS AS COLUNAS
		addi s2,s2,30
				
		
coluna1:	beq t3,s1,verificacao 			#SE JÁ DESENHOU TODOS OS DIGITOS DA COLUNA
		
usuario:	#ESCOLHE A COR
		li a7,105				#SYSCALL
		ecall
		add t6,t6,a0				#GUARDA ESCOLHA EM T6
		
		#sb t6,0(s7)				#GUARDA ESCOLHA DO USUARIO EM S7 PRA COMPARAÇÃO COM SENHA
		#addi s7,s7,1
		
		#PRINTA A ESCOLHA DA COR NA TELA
		li a7,101				#SYSCALL
		li a1,188
		li a2,210
		li a3,0x0038
		li a4,0
		mv t6,a0
		ecall
		
		#DE NOVO SE VALOR INVALIDO
		ble t6, s1, aceito
		li a3,0x0000
		ecall
		j usuario
		
		
		#LIMPA REGISTRADORES PARA USÁ-LOS A SEGUIR
aceito:		sub a0,a0,a0
		sub a1,a1,a1
		sub a2,a2,a2
		sub a3,a3,a3
		
		#j nivel
		
		li a7,147				#SYSCALL
		add a0,a0,s2
		add a1,a1,s3
		addi a2,a0,10
		add a3,a3,s3
		
		#VAI PARA A COR DESEJADA
		li t1, 0x03
		mul a4, t1, t6
		mv t1, a4
		slli a4, a4, 8
		add a4,a4,t1
		slli a4, a4, 8
		add a4,a4,t1
		slli a4, a4, 8
		add a4,a4,t1
		
		
		li a5,0
		ecall
		
		#AUDIO DA COR
		li t1,12
		li a7,31
		li a1,600
		li a2,50
		li a3,127
		mul a0,t6,t1
		
		ecall
		
		add s3,s3,s6
		addi t3,t3,1
		
		mv a0, t6
		jal ra,processar
		
		#LIMPA PARA A PRÓXIMA COLUNA (SE NECESSÁRIO)
		sub a0,a0,a0
		sub a1,a1,a1
		sub a2,a2,a2
		sub a3,a3,a3
		sub a4,a4,a4
		j coluna1
		

verificacao:	#FEEDBACK DA COLUNA
		li a7, 101
		li a4, 0
		mv a1,s2		
		mv a0,s4
		li a2,34
		li a3,0x0038
		ecall
		
		la t5,numBranco		# define o endereço do número de notas
		lw t1,0(t5)		# le o numero de notas
		la t2,branco		# define o endereço das notas
		li t4,0			# zera o contador de notas
		li a2,68		# define o instrumento
		li a3,127		# define o volume

loopBranco:	beq t4,t1, fimBranco		# contador chegou no final? então  vá para FIM
		lw a0,0(t2)		# le o valor da nota
		lw a1,4(t2)		# le a duracao da nota
		li a7,31		# define a chamada de syscall
		ecall			# toca a nota
		mv a0,a1		# passa a duração da nota para a pausa
		li a7,32		# define a chamada de syscal 
		ecall			# realiza uma pausa de a0 ms
		addi t2,t2,8		# incrementa para o endereço da próxima nota
		addi t4,t4,1		# incrementa o contador de notas
		j loopBranco			# volta ao loop
	
fimBranco:
		li a7, 101
		li a4, 0				
		mv a1,s2
		mv a0,s5
		li a2,44
		li a3,0xFF00
		ecall
		
		la t5,numPreto		# define o endereço do número de notas
		lw t1,0(t5)		# le o numero de notas
		la t2,preto		# define o endereço das notas
		li t4,0			# zera o contador de notas
		li a2,68		# define o instrumento
		li a3,127		# define o volume

loopPreto:	beq t4,t1, fimPreto		# contador chegou no final? então  vá para FIM
		lw a0,0(t2)		# le o valor da nota
		lw a1,4(t2)		# le a duracao da nota
		li a7,31		# define a chamada de syscall
		ecall			# toca a nota
		mv a0,a1		# passa a duração da nota para a pausa
		li a7,32		# define a chamada de syscal 
		ecall			# realiza uma pausa de a0 ms
		addi t2,t2,8		# incrementa para o endereço da próxima nota
		addi t4,t4,1		# incrementa o contador de notas
		j loopPreto			# volta ao loop
	
fimPreto:
		
		mv t5, s5
		sub a0,a0,a0
		sub a1,a1,a1
		sub a2,a2,a2
		sub a3,a3,a3
		sub a4,a4,a4
		sub s5,s5,s5
		sub s4,s4,s4
		
		bne t5,s1,tentativa
		j nivel
tentativa:	beq t0,s0,fim

		#Atualiza TENTATIVA
		li a7,101		
		addi a0,t0,1
		li a1,80
		li a2,10
		li a3,0x0038
		li a4,0
		ecall

		j tabuleiro1

fim:		li a7,10
		ecall
		
gerarSenha:	li t0, 0		
_gerarSenha:	#ESCOLHE A SENHA ALEATORIAMENTE
		li a7,42
		mv a1,s1
		ecall
		addi a0,a0,1
		#li a7, 1
		#ecall
		
		addi sp, sp, -4
		
		sw a0 0(sp)
		
		addi t0, t0, 1
			
		bne t0, s1, _gerarSenha
		sub a0,a0,a0
		ret

processar:	#RECEBE a0(VALOR) t3(ORDEM) E ATUALIZA s4(PINOS BRANCOS) s5(PINOS PRETOS)
		li t2, 4
		mul t4, t2, s1
		
		add t1, sp, t4
		li t2, 0
				
_processar:	lw t4, -4(t1)
		addi t1,t1,-4
		addi t2,t2,1
		
		bne a0,t4,diferente
		bne t2,t3,lugarErrado
		addi s5,s5,1
		j diferente
lugarErrado:	addi s4, s4,1	
diferente:	beq t2, s1, processarEnd
		j _processar
processarEnd:
		ret
		
				
.include "SYSTEMv21.s"







