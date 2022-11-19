	.data
# cargar caracteres que debe introducir el usuario
caracterPunto: .byte '.'
letraS: .byte 'S'
letraR: .byte 'R'
letraP: .byte 'P'
letraD: .byte 'D'
letraF: .byte 'F'
.align 4

# alocar un espacio de 4 bytes al entero num1 y 4 bytes al float num2
num1: .space 4
num2: .space 4

# cargar el mensaje que se muestra con se imprime el menú
mensajeMenu: .asciiz "Programa CALCULADORA\n
Pulse la inicial para seleccionar operación:\n
<S>uma\n
<R>esta\n
<P>roducto\n
<D>ivisión\n
<F>ibonaci\n
\n
> "

# cargar el mensaje que se muestra cuando se imprime el resultado
mensajeResultado: .asciiz "El resultado es: "

	.text
	.globl main
main:
	li $a0 1
	lb $t0 caracterPunto
	jal mostrarMenu
	j fin

cargar_menu:
	la $s0 letraS
        la $s1 letraR
	la $s2 letraP
        la $s3 letraD
    	la $s4 letraF
	j while
	
mostrar_resultado:
	la $a0 
mostrar_menu:  

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
        beq $a0 $t0 endMenu
        j mostrarMenu
        
suma:
	#Leer de teclado nºs que le paso + subrutina
resta:
 	lw $t0 num1
	l.s $f0 num2
	mtc1 $t0 $f1 
	cvt.s.w $f2 $f1
	sub $f2 $f2 $f0
	sw $f2 resultado
producto:
	#Leer de teclado nºs que le paso + subrutina
division:
	#Leer de teclado nºs que le paso + subrutina
fibonacci:
	#Leer de teclado nºs que le paso + subrutina
end_menu:
	jr $ra # volver a la tercera rutina de la etiqueta main
                
               
                
                
fin:	li $v0 10
		syscall
                
   
