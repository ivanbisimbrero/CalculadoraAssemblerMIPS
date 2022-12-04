    .data
# Reservamos el buffer del usuario
buffer: .space 10
.align 4
# no tenemos que utilizar la función .align ya que el total de bytes utilizado para guardar los chars es de 8 bytes y la siguiente dirección en la que se guarda el próximo dato es múltiplo de 4

# colocar un espacio de 4 bytes al entero num1, 4 bytes al float num2 y 8 bytes para el double resultado
numEntero: .space 4
numFloat: .space 4
resultado: .space 4

# cargar el mensaje que se muestra cuando se imprime el menú
mensajeMenu: .asciiz "\nPrograma CALCULADORA\n
Pulse la inicial para seleccionar operación:\n
<S>uma\n
<R>esta\n
<P>roducto\n
<D>ivisión\n
<F>ibonaci\n
\n
> "
.align 4

# cargar los mensajes para leer el entero, el real, mensaje que se muestra para el resultado y mensaje que se muestra para cuando se introduce un dato erróneo
mensajeEntero: .asciiz "Introduzca un valor entero: "
.align 4
mensajeFloat: .asciiz "Introduzca un valor real: "
.align 4
mensajeResultado: .asciiz "El resultado es: "
.align 4
mensajeError: .asciiz "ERROR. DATO INTRODUCIDO NO VÁLIDO"
.align 4
comment:.asciiz "FIN DE PROGRAMA\n"
.align 4
    .text
    .globl main
main:
    # Cargamos los distintos valores para
    # Prologo
    subu $sp, $sp, 4
    sw $ra ($sp)
    # Llamamos a la rutina menu para empezar a mostrar la pantalla del menú
    jal menu

    # cuando se ejecute la función end_Menu se vuelve a esta dirección
    j fin

menu:
    # Imprimimos por pantalla las opciones
    la $a0 mensajeMenu
    li $v0 4
    syscall
    #Leemos el caracter introducido por el usuario
    la $a0 buffer
    li $a1 5
    li $v0 8
    syscall
    lb $t7 buffer
    # Comparar el valor del caracter introducido por el usuario
    beq $t7 '.' end_Menu
    beq $t7 'S' case_suma
    beq $t7 'R' case_resta
    beq $t7 'P' case_producto
    beq $t7 'D' case_division
    beq $t7 'F' case_fibonacci
    j mostrar_error # si el usuario no introduce el carácter correcto se vuelve a mostrar el menú

#CASOS
case_suma:

subu $sp $sp 8
sw $ra ($sp) #Guardo direccion retorno menu

jal carga_valores
lw $a0 numEntero
lw $a1 numFloat
jal suma

lw $ra ($sp) #Recupero direccion retorno menu
addu $sp $sp 8
j mostrar_resultado_float

case_resta:
subu $sp $sp 8
sw $ra ($sp) #Guardo direccion retorno menu

jal carga_valores
lw $a0 numEntero
lw $a1 numFloat
jal resta

lw $ra ($sp)#Recupero direccion retorno menu
addu $sp $sp 8
j mostrar_resultado_float

case_producto:
subu $sp $sp 8
sw $ra ($sp) #Guardo direccion retorno menu

jal carga_valores
lw $a0 numEntero
lw $a1 numFloat
jal producto

lw $ra ($sp)#Recupero direccion retorno menu
addu $sp $sp 8
j mostrar_resultado_float

case_division:
subu $sp $sp 8
sw $ra ($sp) #Guardo direccion retorno menu

jal carga_valores
lw $a0 numEntero
lw $a1 numFloat
jal division

lw $ra ($sp)#Recupero direccion retorno menu
addu $sp $sp 8
j mostrar_resultado_float

case_fibonacci:
subu $sp $sp 8
sw $ra ($sp) #Guardo direccion retorno menu

jal read_int
move $a0, $v0 #Movemos el valor entero que deja en $v0 al parametro de entrada de fibonacci $a0
jal fibonacci
sw $v0 resultado #Guardamos el valor devuelto en resultado

lw $ra ($sp)#Recupero direccion retorno menu
addu $sp $sp 8
j mostrar_resultado_int

#Función que lee el valor entero
read_int:
la $a0 mensajeEntero
li $v0 4
syscall
li $v0 5
syscall
sw $v0 numEntero
jr $ra

#Función que lee el valor float
read_float:
la $a0 mensajeFloat
li $v0 4
syscall
li $v0 6
syscall
s.s $f0 numFloat
jr $ra

#Funcion para que cargue los valores
carga_valores:
#PROLOGO
subu $sp $sp 8
sw $ra ($sp)

jal read_int
jal read_float

#EPILOGO
lw $ra ($sp)
addu $sp $sp 8

# Almacenamos los valores
lw $t0 numEntero
l.s $f0 numFloat

jr $ra

suma:
#Pasamos el parametro de la funcion $a0 al coprocesador ($f1)
mtc1 $a0 $f1
cvt.s.w $f1 $f1
#Pasamos el parametro de la funcion $a1 al coprocesador ($f0)
mtc1 $a1 $f0
# Sumamos los dos floats
add.s $f2 $f0 $f1

# Almacenamos el resultado en la dirección de memoria resultado y lo devolvemos en $v0
s.s $f2 resultado
lw $v0 resultado

#Volvemos a la direccion de retorno
jr $ra

resta:
#Pasamos el parametro de la funcion $a0 al coprocesador ($f1)
mtc1 $a0 $f1
cvt.s.w $f1 $f1
#Pasamos el parametro de la funcion $a1 al coprocesador ($f0)
mtc1 $a1 $f0
# Restamos los dos floats
sub.s $f2 $f1 $f0

# Almacenamos el resultado en la dirección de memoria resultado y lo devolvemos en $v0
s.s $f2 resultado
lw $v0 resultado

#Volvemos a la direccion de retorno
jr $ra

producto:
#Pasamos el parametro de la funcion $a0 al coprocesador ($f1)
mtc1 $a0 $f1
cvt.s.w $f1 $f1
#Pasamos el parametro de la funcion $a1 al coprocesador ($f0)
mtc1 $a1 $f0
# Multiplicamos los dos floats
mul.s $f2 $f0 $f1

# Almacenamos el resultado en la dirección de memoria resultado y lo devolvemos en $v0
s.s $f2 resultado
lw $v0 resultado

#Volvemos a la direccion de retorno
jr $ra

division:
#Pasamos el parametro de la funcion $a0 al coprocesador ($f1)
mtc1 $a0 $f1
cvt.s.w $f1 $f1
#Pasamos el parametro de la funcion $a1 al coprocesador ($f0)
mtc1 $a1 $f0
# Dividimos los dos floats
div.s $f2 $f1 $f0

# Almacenamos el resultado en la dirección de memoria resultado y lo devolvemos en $v0
s.s $f2 resultado
lw $v0 resultado

#Volvemos a la direccion de retorno
jr $ra

# INICIO DE FIBONACCI
fibonacci:

# Inicio del prólogo
subu $sp, $sp, 24
sw $ra, 20($sp)
sw $s0, 16($sp)
sw $s1, 12($sp)
# Fin del prólogo

move $s0, $a0 # movemos el dato introducido por el usuario al registro $s0 o el valor de la primera llamada recursiva
li $v0, 1 # cargamos un 1 en $v0 como resultado en los casos que n=1, n=2
ble $s0, 2, fibonacciFin # si los valores introducidos son n=1 o n=2 entonces se salta al final de fibonacci
subu $a0, $s0, 1 # primer argumento en la suma de la secuencia de fibonacci (n-1), siendo n=$s0
jal fibonacci # hacemos una llamada recursiva a fibonacci hasta que $a0=1 ó $a0=2
move $s1, $v0 # almacenamos el valor de $v0 en $s1
subu $a0, $s0, 2 # segundo argumento en la suma de la secuencia de fibonacci (n-1), siendo n=$s0
jal fibonacci # hacemos una llamada recursiva a fibonacci hasta que $a0=1 ó $a0=2
add $v0, $s1, $v0 # sumamos los valores de fibonacci(n-1) y fibonacci(n-2)
fibonacciFin:
# Inicio del epílogo
lw $ra, 20($sp)
lw $s0, 16($sp)
lw $s1, 12($sp)
addu $sp, $sp, 24
jr $ra
# Fin del epílogo

# FIN DE FIBONACCI

mostrar_error:
la $a0 mensajeError
li $v0 4
syscall
j menu

mostrar_resultado_int:
la $a0 mensajeResultado
li $v0 4
syscall
lw $a0 resultado #Cargamos el resultado en $a0 para mostrarlo por pantalla
li $v0 1
syscall
j menu

mostrar_resultado_float:
mtc1 $v0 $f12
la $a0 mensajeResultado
li $v0 4
syscall
li $v0 2
syscall
j menu

end_Menu:
    #Mostramos el mensaje de fin de programa
    la $a0 comment
    li $v0 4
    syscall
    jr $ra    #Salimos de menu y volvemos al main
                 
fin:
    li $v0 10
    syscall
