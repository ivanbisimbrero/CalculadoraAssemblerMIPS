	.data
# cargar caracteres que debe introducir el usuario
caracterPunto: .byte '.'
letraS: .byte 'S'
letraR: .byte 'R'
letraP: .byte 'P'
letraD: .byte 'D'
letraF: .byte 'F'
.align 4

# alocar un espacio de 4 bytes al entero num1, 4 bytes al float num2 y 8 bytes para el double resultado 
numEntero: .space 4
numFloat: .space 4
resultado: .space 8

# cargar el mensaje que se muestra cuando se imprime el menú
mensajeMenu: .asciiz "Programa CALCULADORA\n
Pulse la inicial para seleccionar operación:\n
<S>uma\n
<R>esta\n
<P>roducto\n
<D>ivisión\n
<F>ibonaci\n
\n
> "

# cargar los mensajes para leer el entero, el real, mensaje que se muestra para el resultado y mensaje que se muestra para cuando se introduce un dato erróneo
mensajeEntero: .asciiz "Introduzca un valor entero: "
mensajeFloat: .asciiz "Introduzca un valor real: "
mensajeResultado: .asciiz "El resultado es: "
mensajeError: .asciiz "ERROR. DATO INTRODUCIDO NO VÁLIDO" 

.text
.globl main

main:
	la $s0 caracterPunto
	la $s1 letraS
        la $s2 letraR
	la $s3 letraP
        la $s4 letraD
    	la $s5 letraF
	jal menu
	j fin
	
menu:  
	# Imprimimos por pantalla las opciones
	la $a0 mensajeMenu
	li $v0 4
        syscall
        # Leemos el caracter introducido por el usuario
        li $v0 8
        syscall
        # TO-DO funciones suma y producto del mario YJUJUJUJUJ 
	beq $a0 $s0 endMenu
	beq $a0 $s1 suma
        beq $a0 $s2 resta
        beq $a0 $s3 producto
        beq $a0 $s4 division
        beq $a0 $s5 fibonacci
        j menu # si el usuario no introduce el carácter correcto se vuelve a mostrar el menú

read_int:
	 la $a0 mensajeEntero
	 li $v0 4
	 syscall
	 li $v0 5
	 syscall
	 sw $v0 numEntero
	 jr $ra

read_float: 
	 la $a0 mensajeFloat
	 li $v0 4
	 syscall
	 li $v0 6
	 syscall
	 sw $v0 numFloat
	 jr $ra

carga_valores:
	# Leemos los valores
	jal read_int
	jal read_float

	# Almacenamos valores
	lw $t0 numEntero
	l.s $f0 numFloat

	# Pasamos el entero a float
	mtc1 $t0 $f1
	cvt.s.w $f1 $f1 

	jr $ra

suma:
	# Llamamos a la función que carga los valores
	jal carga_valores

	# Sumamos los dos floats
	add.d $f2 $f0 $f1

	# Almacenamos el resultado en la dirección de memoria resultado 
	sw $f2 resultado

	# Imprimimos el resultado
	j mostrar_resultado

resta:
	# Llamamos a la función que carga los valores
	jal carga_valores

	# Restamos los dos floats
	sub.s $f2 $f2 $f0

	# Almacenamos el resultado
	sw $f2 resultado

	# Imprimimos el resultado
	j mostrar_resultado

producto:
	# Llamamos a la función que carga los valores
	jal carga_valores

	# Multiplicamos los dos floats
	mult.d $f2 $f0 $f1

	# Almacenamos el resultado en la dirección de memoria resultado
	sw $f2 resultado

	# Imprimimos el resultado
	j mostrar_resultado

division:
	# Llamamos a la función que carga los valores
	jal carga_valores

	# Dividimos los dos floats
	div.d $f2 $f2 $f0

	# Almacenamos el resultado
	sw $f2 resultado

	# Imprimimos el resultado
	j mostrar_resultado

fibonacci:
	lw $t0 numEntero
	ble $t0 0 menu
	jal fibo
	sw $v0 resultado
	j mostrar_resultado

fibo_start:
	subu $sp $sp 8
	sw $ra ($sp)
	sw $s6 4($sp)
	
	move $v0 $t0
	ble $t0 0 mostrar_error # si es <=0 muestra un error
	ble $t0 2 fibo_end # si es 1||2 carga un 1 como resultado y muestra el resultado
	
	# obtenemos n-1
	move $s6 $t0 # en el caso de que fuera un 2 se muestra como resultado un 2
	subu $t0 $t0 1
	jal fibo_start
	
	# obtenemos n-2
	move $t0 $s6 
	subu $t0 $t0 2
	move $s6 $v0
	jal fibo_start
	
	# (n-1)+(n-2)
	add $v0 $v0 $s6 
	j mostrar_resultado
	
fibo_end:
	lw $ra ($sp)
	lw $s6 4($sp)
	addu $sp $sp 8
	jr $ra
	
mostrar_error:
	la $a0 mensajeError
	li $v0 4
	syscall
	//TO-DO Mostrar el mensaje de error de forma temporal
	j menu

mostrar_resultado:
	la $a0 mensajeResultado
	li $v0 4
	syscall
	lw $a0 resultado
	li $v0 1
	syscall
	j menu
	
end_menu:
	jr $ra # volver a la tercera rutina de la etiqueta main       
                     
fin:	
	li $v0 10
	syscall
                
   
