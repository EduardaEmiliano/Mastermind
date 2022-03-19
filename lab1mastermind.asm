.include "MACROSv21.s"

#########################################################################################
# USAR KEYBOARD MMIO PRA TENTAR UMA COR							#
# CARREGAR APENAS FRAME 0 NO BITMAP							#
# CHUTAR COR DE ACORDO COM O SEU CODIGO, CODIGOS PODEM SER VISTOS A PARTIR DA LINHA 193 #
#########################################################################################

.data
titulo: .string "MASTERMIND"
tentativas: .string "TENTATIVA: "
n: .string "TAMANHO DA SENHA: "
digitecor: .string "DIGITE CODIGO DA COR: "

senha: .word 0,0,0,0 						#PARA COLOCAR SENHA GERADA ALEATORIAMENTE
palpite: .word 0,0,0,0						#PARA COLOCAR SENHA SUGERIDA PELO USUARIO
.text

		
Cabecalho:	#TITULO
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

		addi s0, s0, 10				#TENTATIVAS PERMITIDAS
nivel:		addi s1, s1, 5 				#GUARDA NÍVEL DO JOGO (N)

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
		
		addi s3,s3,20				#PRÓXIMO DIGITO
		addi t3,t3,1				#SOMA O DIGITO
		
		#LIMPA PARA A PRÓXIMA COLUNA (SE NECESSÁRIO)
		sub a0,a0,a0
		sub a1,a1,a1
		sub a2,a2,a2
		sub a3,a3,a3
		sub a4,a4,a4
		j coluna

info:		#PRINTA NA TELA

infoCores:	li a7,104
		la a0,digitecor
		li a1,15
		li a2,190
		li a3,0x0038
		li a4,0
		ecall

		li s4,0
infoTent:	addi s4,s4,1
		li a7,101		
		mv a0,s4
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
			
		la s6,senha				#GUARDA A SENHA NO ARRAY S6
		jal ra,_gerarSenha
		la s7,palpite				#GUARDA O PALPITE DO USUARIO E3 S7
			
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
		li a2,189
		li a3,0x0038
		li a4,0
		mv t6,a0
		ecall
		
		#LIMPA REGISTRADORES PARA USÁ-LOS A SEGUIR
		sub a0,a0,a0
		sub a1,a1,a1
		sub a2,a2,a2
		sub a3,a3,a3
		
		li a7,147				#SYSCALL
		add a0,a0,s2
		add a1,a1,s3
		addi a2,a0,10
		add a3,a3,s3
		
		#VAI PARA A COR DESEJADA
		li t0,1
		beq t6,t0,VERMELHO
		li t0,2
		beq t6,t0,VERDE
		li t0,3
		beq t6,t0,AZUL
		li t0,4
		beq t6,t0,ROSA
		li t0,5
		beq t6,t0,AMARELO
		li t0,6
		beq t6,t0,ROXO
		
continua:	li a5,0
		ecall
		
		addi s3,s3,20
		addi t3,t3,1
		
		#LIMPA PARA A PRÓXIMA COLUNA (SE NECESSÁRIO)
		sub a0,a0,a0
		sub a1,a1,a1
		sub a2,a2,a2
		sub a3,a3,a3
		sub a4,a4,a4
		j coluna1
		
		
VERMELHO:	li a4,0x07070707
		j continua 					#VOLTA PRA CHAMAR A SYSCALL
VERDE:		li a4,0x20202020
		j continua
AZUL:		li a4,0x90909090
		j continua
ROSA:		li a4,0x44444444
		j continua
AMARELO:	li a4,0x77777777
		j continua
ROXO:		li a4,0x41414141
		j continua

verificacao:	#AQUI É A VERIFICACAO DA CORRESPONDENCIA ENTRE A SENHA GERADA ALEATORIAMENTE E A SUGERIDA PELO USUARIO
		#COMO NÃO CODEI ESSA PARTE, FICOU ESSE IF SIMPLES A SEGUIR:
		beq t0,s0,fim #SE TODAS AS COLUNAS JÁ FORAM PINTADAS, FIM
		j tabuleiro1 #SE NÃO, VOLTA PRA PINTAR A PROXIMA COLUNA
fim:		li a7,10
		ecall
		
		add s4,s4,s1
_gerarSenha:	#ESCOLHE A SENHA ALEATORIAMENTE
		li a7,42
		li a1,9
		ecall
		
		sb a0,0(s6)
		
		addi s6,s6,1
		addi s4,s4,-1
		bnez s4,_gerarSenha
		sub a0,a0,a0
		ret
		
.include "SYSTEMv21.s"







