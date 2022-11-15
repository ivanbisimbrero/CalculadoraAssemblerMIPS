.data
caracterPunto: .byte '.'
letraS: .byte 'S'
letraR: .byte 'R'
letraP: .byte 'P'
letraD: .byte 'D'
letraF: .byte 'F'
.align 4
mensajeMenu: .asciiz "Programa CALCULADORA\n
Pulse la inicial para seleccionar operación:\n
<S>uma\n
<R>esta\n
<P>roducto\n
<D>ivisión\n
<F>ibonaci\n
\n
> "


.text
.globl main
main:
		li $a0 1
		lb $t0 caracterPunto

		jal mostrarMenu
		j fin

mostrarMenu:
		la $s0 letraS
        la $s1 letraR
		la $s2 letraP
        la $s3 letraD
    	la $s4 letraF
while:  

		la $a0 mensajeMenu
		li $v0 4
        syscall
        #Leo caracter--> Se guarda en $a0 el caracter 
        li $v0 8
        syscall
        #TO-DO: FUNC CALCULATOR (FIBONACCI XD Y EL RESTO TB JIJIJIJA-->USAR $a0)
        beq $a0 $s0 suma
        beq $a0 $s1 resta
        beq $a0 $s2 producto
        beq $a0 $s3 division
        beq $a0 $s4 fibonacci
        beq $a0 $t0 end_Menu
        j while
        
suma:
	#Leer de teclado nºs que le paso+ subrutina
resta:
 	#Leer de teclado nºs que le paso+ subrutina
producto:
	#Leer de teclado nºs que le paso+ subrutina
division:
	#Leer de teclado nºs que le paso+ subrutina
fibonacci:
	#Leer de teclado nºs que le paso+ subrutina
end_Menu:
		jr $ra
                
               
                
                
fin:	li $v0 10
		syscall
                
   