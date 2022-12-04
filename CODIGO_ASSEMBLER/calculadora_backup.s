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
mensajeError: .asciiz "ERROR. DATO INTRODUCIDO NO VÁLIDO\n"
.align 4
comment:.asciiz "FIN DE PROGRAMA\n"
.align 4
    .text
    .globl main
main:
    # Cargamos los distintos valores para
    # Prologo
    subu $sp, $sp, 8
    sw $ra 4($sp)
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
    j mostrar_error # si el usuario no introduce el carácter correcto se vuelve a mostrar el menú

#CASOS 
case_suma:
    
    subu $sp $sp 8
    sw $ra 4($sp) #Guardo direccion retorno menu

    jal carga_valores
    jal suma

    lw $ra 4($sp) #Recupero direccion retorno menu
    addu $sp $sp 8
    j mostrar_resultado_float

case_resta:
    subu $sp $sp 8
    sw $ra 4($sp) #Guardo direccion retorno menu

    jal carga_valores
    jal resta

    lw $ra 4($sp)#Recupero direccion retorno menu
    addu $sp $sp 8
    j mostrar_resultado_float

case_producto:
    subu $sp $sp 8
    sw $ra 4($sp) #Guardo direccion retorno menu

    jal carga_valores
    jal producto

    lw $ra 4($sp)#Recupero direccion retorno menu
    addu $sp $sp 8
    j mostrar_resultado_float

case_division:
    subu $sp $sp 8
    sw $ra 4($sp) #Guardo direccion retorno menu

    jal carga_valores
    jal division

    lw $ra 4($sp)#Recupero direccion retorno menu
    addu $sp $sp 8
    j mostrar_resultado_float


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
    sw $ra 4($sp)

    jal read_int
    jal read_float

    #EPILOGO
    lw $ra 4($sp)
    addu $sp $sp 8

    # Leemos valores
    lw $t0 numEntero
    l.s $f0 numFloat

    # Pasamos el entero a float
    mtc1 $t0 $f1
    cvt.s.w $f1 $f1

    jr $ra

suma:
    # Sumamos los dos floats
    add.s $f2 $f0 $f1

    # Almacenamos el resultado en la dirección de memoria resultado
    s.s $f2 resultado

    # Imprimimos el resultado
    jr $ra

resta:
    # Restamos los dos floats
    sub.s $f2 $f1 $f0

    # Almacenamos el resultado
    mfc1 $t1 $f2
    sw $t1 resultado

    # Imprimimos el resultado
    j mostrar_resultado_float

producto:
    # Multiplicamos los dos floats
    mul.s $f2 $f0 $f1

    # Almacenamos el resultado en la dirección de memoria resultado
    mfc1 $t1 $f2
    sw $t1 resultado

    # Imprimimos el resultado
    j mostrar_resultado_float

division:
    # Dividimos los dos floats
    div.s $f2 $f1 $f0

    # Almacenamos el resultado
    mfc1 $t1 $f2
    sw $t1 resultado

    # Imprimimos el resultado
    j mostrar_resultado_float

mostrar_error:
    la $a0 mensajeError
    li $v0 4
    syscall
    j menu

mostrar_resultado_int:
    la $a0 mensajeResultado
    li $v0 4
    syscall
    move $a0 $v0 # almacenamos el valor de $v0 en $a0
    li $v0 1
    syscall
    j menu

mostrar_resultado_float:
    la $a0 mensajeResultado
    li $v0 4
    syscall
    l.s $f12 resultado
    li $v0 2
    syscall
    lw $ra ($sp)
    addu $sp $sp 8
    j menu

end_Menu:
    #Mostramos el mensaje de fin de programa
    la $a0 comment
    li $v0 4
    syscall
    lw $ra 4($sp)
    jr $ra    #Salimos de menu y volvemos al main
                 
fin:
    li $v0 10
    syscall
