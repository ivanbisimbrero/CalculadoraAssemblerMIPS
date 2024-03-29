# SECCIÓN DE DATOS
    .data
# Reservamos el buffer del usuario
buffer: .space 10
.align 4
# Utilizamos la función .align ya que el total de bytes utilizado para guardar el buffer de entrada es de 10 bytes y la siguiente dirección en la que se guarda el próximo dato no es múltiplo de 4. Este mismo proceso lo seguiremos para los mensajes mostrados por pantalla

# colocar un espacio de 4 bytes al entero num1, 4 bytes al float num2 y 4 bytes para el float resultado
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
<F>ibonacci\n
\n
> "
.align 4

# Cargamos los mensajes para introducir el entero y el real, mensaje que se muestra para el resultado,  mensaje que se muestra para cuando se introduce un dato erróneo y mensaje para indicar el fin del programa
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

# SECCIÓN DE DATOS
    .text
.globl main
    main:

    # Prólogo
    subu $sp $sp 8
    sw $ra 4($sp)
    # Fin del prólogo

    # Llamamos a la rutina menu para empezar a mostrar la pantalla del menú
    jal menu
    
    # Epílogo
    lw $ra 4($sp)
    addu $sp $sp 8
    # Fin del epílogo

    # Cuando se ejecute la función con etiqueta 'end_Menu' se vuelve a esta dirección
    j fin

# Función que muestra el menú
menu:
    # Imprimimos por pantalla las opciones
    la $a0 mensajeMenu
    li $v0 4
    syscall
    # Leemos el carácter introducido por el usuario
    la $a0 buffer
    li $a1 5
    li $v0 8
    syscall
    lb $t7 buffer
    # Comparamos el valor del carácter introducido por el usuario
    beq $t7 '.' end_Menu
    beq $t7 'S' case_suma
    beq $t7 'R' case_resta
    beq $t7 'P' case_producto
    beq $t7 'D' case_division
    beq $t7 'F' case_fibonacci
    jal mostrar_error # Si el usuario no introduce el carácter correcto se vuelve a mostrar el menú
    j fin

#CASOS: SUMA, RESTA, PRODUCTO, DIVISIÓN Y SECUENCIA DE FIBONACCI

# CASO 'S'
case_suma:
    # Llamamos a la carga de valores
    jal carga_valores
    
    # Pasamos a como parámetros ($a0,$a1) el valor del entero y del float
    lw $a0 numEntero
    lw $a1 numFloat

    # Realizamos la suma de los parámetros $a0 y $a1
    jal suma

    # Mostramos el resultado por pantalla
    j mostrar_resultado_float

# CASO 'R'
case_resta:

    # Llamamos a la carga de valores
    jal carga_valores

    # Pasamos a como parámetros ($a0,$a1) el valor del entero y del float
    lw $a0 numEntero
    lw $a1 numFloat

    # Realizamos la resta de los parámetros $a0 y $a1
    jal resta

    # Mostramos el resultado por pantalla
    j mostrar_resultado_float

# CASO 'P'
case_producto:

    # Llamamos a la carga de valores
    jal carga_valores

    # Pasamos a como parámetros ($a0,$a1) el valor del entero y del float
    lw $a0 numEntero
    lw $a1 numFloat
    
    # Realizamos el producto de los parámetros $a0 y $a1
    jal producto

    # Mostramos el resultado por pantalla
    j mostrar_resultado_float

# CASO 'D'
case_division:

    jal carga_valores
    lw $a0 numEntero
    lw $a1 numFloat
    jal division

    j mostrar_resultado_float

# CASO 'F'
case_fibonacci:
    
    # Leemos el valor del entero
    jal read_int
    
    # Movemos el valor entero que deja en $v0 al parametro de entrada de fibonacci a $a0
    move $a0, $v0
    
    # Obtenemos el valor en la secuencia de Fibonacci del entero introducido
    jal fibonacci
    
    #Guardamos el valor devuelto en resultado
    sw $v0 resultado
    
    # Mostramos el resultado por pantalla
    j mostrar_resultado_int

# Función que lee el valor entero introducido por el usuario
read_int:
    la $a0 mensajeEntero
    li $v0 4
    syscall
    li $v0 5
    syscall
    sw $v0 numEntero
    jr $ra

#Función que lee el valor float introducido por el usuario
read_float:
    la $a0 mensajeFloat
    li $v0 4
    syscall
    li $v0 6
    syscall
    s.s $f0 numFloat
    jr $ra

# Funcion para que cargue los valores
carga_valores:
    
    # Inicio del prólogo
    subu $sp $sp 8
    sw $ra 4($sp)
    # Fin del prólogo

    jal read_int
    jal read_float
    
    # Almacenamos los valores
    lw $t0 numEntero
    l.s $f0 numFloat
    
    # Inicio del epílogo
    lw $ra 4($sp)
    addu $sp $sp 8
    # Fin del epílogo

    # Volvemos a la rutina 'case_<nombre_operacion>'
    jr $ra

suma: # RUTINA TERMINAL

    # Inicio del prólogo
    subu $sp $sp 24
    sw $a0 20($sp)
    sw $a1 16($sp)
    s.s $f0 12($sp)
    s.s $f1 8($sp)
    s.s $f2 4($sp)
    # Fin del prólogo

    #Pasamos el parametro de la funcion $a0 al coprocesador ($f1)
    mtc1 $a0 $f0
    cvt.s.w $f0 $f0
    #Pasamos el parametro de la funcion $a1 al coprocesador ($f0)
    mtc1 $a1 $f1
    # Sumamos los dos floats
    add.s $f2 $f0 $f1

    # Almacenamos el resultado en la dirección de memoria resultado y lo devolvemos en $v0
    s.s $f2 resultado
    lw $v0 resultado

    # Inicio del epílogo
    l.s $f2 4($sp)
    l.s $f1 8($sp)
    l.s $f0 12($sp)
    lw $a1 16($sp)
    lw $a0 20($sp)
    addu $sp $sp 24
    # Fin del epílogo

    #Volvemos a la direccion de retorno
    jr $ra

resta: # RUTINA TERMINAL
    # Inicio del prólogo
    subu $sp $sp 24
    sw $a0 20($sp)
    sw $a1 16($sp)
    s.s $f0 12($sp)
    s.s $f1 8($sp)
    s.s $f2 4($sp)
    # Fin del prólogo

    # Pasamos el parámetro de la funcion $a0 al coprocesador ($f1)
    mtc1 $a0 $f1
    cvt.s.w $f1 $f1
    #Pasamos el parámetro de la funcion $a1 al coprocesador ($f0)
    mtc1 $a1 $f0
    # Restamos los dos floats
    sub.s $f2 $f1 $f0

    # Almacenamos el resultado en la dirección de memoria resultado y lo devolvemos en $v0
    s.s $f2 resultado
    lw $v0 resultado

    # Inicio del epílogo
    l.s $f2 4($sp)
    l.s $f1 8($sp)
    l.s $f0 12($sp)
    lw $a1 16($sp)
    lw $a0 20($sp)
    addu $sp $sp 24
    # Fin del epílogo

    #Volvemos a la direccion de retorno
    jr $ra

producto: # RUTINA TERMINAL

    # Inicio del prólogo
    subu $sp $sp 24
    sw $a0 20($sp)
    sw $a1 16($sp)
    s.s $f0 12($sp)
    s.s $f1 8($sp)
    s.s $f2 4($sp)
    # Fin del prólogo
    
    # Pasamos el parametro de la función $a0 al coprocesador ($f1)
    mtc1 $a0 $f1
    cvt.s.w $f1 $f1
    # Pasamos el parámetro de la función $a1 al coprocesador ($f0)
    mtc1 $a1 $f0
    # Multiplicamos los dos floats
    mul.s $f2 $f0 $f1

    # Almacenamos el resultado en la dirección de memoria resultado y lo devolvemos en $v0
    s.s $f2 resultado
    lw $v0 resultado

    # Inicio del epílogo
    l.s $f2 4($sp)
    l.s $f1 8($sp)
    l.s $f0 12($sp)
    lw $a1 16($sp)
    lw $a0 20($sp)
    addu $sp $sp 24
    # Fin del epílogo

    #Volvemos a la direccion de retorno
    jr $ra

division: # RUTINA TERMINAL

    # Inicio del prólogo
    subu $sp $sp 24
    sw $a0 20($sp)
    sw $a1 16($sp)
    s.s $f0 12($sp)
    s.s $f1 8($sp)
    # Fin del prólogo

    # Pasamos el parámetro de la función $a0 al coprocesador ($f1)
    mtc1 $a0 $f1
    cvt.s.w $f1 $f1
    # Pasamos el parámetro de la función $a1 al coprocesador ($f0)
    mtc1 $a1 $f0
    # Dividimos los dos floats
    div.s $f2 $f1 $f0

    # Almacenamos el resultado en la dirección de memoria resultado y lo devolvemos en $v0
    s.s $f2 resultado
    lw $v0 resultado

    # Inicio del epílogo
    l.s $f2 4($sp)
    l.s $f1 8($sp)
    l.s $f0 12($sp)
    lw $a1 16($sp)
    lw $a0 20($sp)
    addu $sp $sp 24
    # Fin del epílogo

    # Volvemos a la dirección de retorno
    jr $ra

# INICIO DE FIBONACCI

fibonacci: # RUTINA NO TERMINAL

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
    lw $s1, 12($sp)
    lw $s0, 16($sp)
    lw $ra, 20($sp)
    addu $sp, $sp, 24
    # Fin del epílogo
    jr $ra

# FIN DE FIBONACCI

mostrar_error: # RUTINA TERMINAL
    # Mostramos el mensaje del error
    la $a0 mensajeError
    li $v0 4
    syscall
    
    # Volvemos a mostrar el menú
    j menu

mostrar_resultado_int: # RUTINA TERMINAL
    la $a0 mensajeResultado
    li $v0 4
    syscall
    lw $a0 resultado # Cargamos el resultado en $a0 para mostrarlo por pantalla
    li $v0 1
    syscall
    j menu

mostrar_resultado_float: # RUTINA TERMINAL
    mtc1 $v0 $f12
    la $a0 mensajeResultado
    li $v0 4
    syscall
    li $v0 2
    syscall
    j menu

end_Menu:
    # Mostramos el mensaje de fin de programa
    la $a0 comment
    li $v0 4
    syscall
    
    # Recuperamos la memoria de retorno al main
    lw $ra 4($sp)
    
    # Salimos de menu y volvemos al main
    jr $ra
             
fin:
    li $v0 10
    syscall
