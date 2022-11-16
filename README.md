# CalculadoraAssemblerMIPS
Práctica 1. Fundamentos del lenguaje ensamblador de MIPS
El objetivo de este trabajo es que el alumno adquiera soltura en la programación en lenguaje ensamblador y el manejo de subrutinas. Para el desarrollo de esta práctica se usará el emulador QtSpim.
1. Descripción del problema
Se desea realizar un programa denominado calculadora.s que funcionará con un menú de usuario. La descripción funcional del programa es la siguiente:
Menú. Cuando se ejecuta la aplicación, en la consola debe aparecer el siguiente texto: Programa CALCULADORA
Pulse la inicial para seleccionar operación:
     <S>uma
     <R>esta
     <P>roducto
     <D>ivisión
     <F>ibonaci
>
Selección. Cuando el usuario seleccione la opción deseada escribiendo el carácter correspondiente, el programa contestará solicitándole que introduzca los valores necesarios. Se solicitarán uno o dos números.
Si el usuario escribe un punto en lugar de una de las iniciales, el programa termina. Cualquier otro carácter que escriba será ignorado.
Entrada de valores y respuesta. Los valores se pedirán uno por uno. IMPORTANTE: Se pedirá el valor entero o “float” según se necesite (ver ejemplo de sesión).
Vuelta al menú. Tras mostrar el resultado de la operación en la consola, debe volver a aparecer el menú a la espera de la siguiente selección.
1
 
 Ejemplo de sesión.
Programa CALCULADORA
Pulse la inicial para seleccionar operación:
     <S>uma
     <R>esta
     <P>roducto
     <D>ivisión
     <F>ibonaci
>S
SUMA
Introduzca un valor entero: 33 Introduzca un valor real: 66.66 El resultado es: 99.66
Pulse la inicial para seleccionar operación:
     <S>uma
     <R>esta
     <P>roducto
     <D>ivisión
     <F>ibonaci
>F
FIBONACCI
Introduzca un valor entero: 5 El resultado es: 8
Pulse la inicial para seleccionar operación:
     <S>uma
     <R>esta
     <P>roducto
     <D>ivisión
     <F>ibonaci
>. FIN
 2
 
 Operaciones.
• suma: Esta función recibe dos parámetros. El primero es un entero y el segundo un float (número en coma flotante de simple precisión). La función devolverá el valor de la suma de los números. El resultado será un float.
• resta: Esta función recibe dos parámetros. El primero es un entero y el segundo un float (número en coma flotante de simple precisión). La función devolverá el valor de la resta de los números. El resultado será un float.
• producto: Esta función recibe dos parámetros. El primero es un entero y el segundo un float (número en coma flotante de simple precisión). La función devolverá el valor del producto de los números. El resultado será un float.
• división: Esta función recibe dos parámetros. El primero es un entero y el segundo un float (número en coma flotante de simple precisión). La función devolverá el valor de la división de los números. El resultado será un float.
• fibonacci: Esta función debe calcular y escribir en consola el término n de la serie de Fibonacci utilizando llamadas recursivas, donde n es el entero no negativo suministrado como dato (ver anexo en última página). Si el usuario escribe un número negativo, se ignora y se regresa al menú.
2. Análisis y planificación
a) Antes de empezar a programar en ensamblador, es necesario que cada miembro del grupo analice el problema individualmente y diseñe una posible estructura del programa escribiendo el algoritmo, indicando cómo se organizarían las subrutinas necesarias.
b) Cada miembro presentará en clase su planificación durante dos minutos (la fecha se indicará en la PDU).
c) Después de ver todos los diseños, los miembros del grupo acordarán la estructura final y se repartirán el trabajo de implementación, pruebas y documentación.
3. Implementación, pruebas y documentación
En esta parte del trabajo se juntarán los fragmentos de código para crear el programa completo, y se realizarán las pruebas pertinentes. Todo el proceso de desarrollo y las pruebas realizadas deben quedar documentados en una memoria que habrá que entregar junto con el código.
4. Material a entregar:
• memoria.doc: descripción de todas las tareas realizadas. La memoria debe describir el comportamiento de los programas (diagramas de flujo, algoritmos, etc.), así como
  3
 
 las principales decisiones de diseño. Además, en la memoria se debe incluir una descripción del proceso de trabajo en grupo, explicando cómo se han repartido las tareas y si ha habido desviaciones respecto a la planificación del punto 2.
• Calculadora.s: código fuente en ensamblador del programa Criterios de evaluación:
El trabajo recibirá dos calificaciones: una individual (5% de la calificación final de la asignatura) y una grupal (10% de la calificación final de la asignatura). Se evaluarán los siguientes puntos:
• Calificación grupal: funcionamiento correcto del programa (6 puntos), pruebas (3 puntos), calidad de la memoria (1 punto).
• Calificación individual: planificación previa de la práctica (3 puntos), cooperación con el resto de estudiantes y realización de las tareas encomendadas (5 puntos), conocimiento detallado del funcionamiento del programa final (2 puntos). Esta parte se podrá evaluar mediante entrevista personal con el equipo de trabajo.
Entrega del trabajo:
La entrega se realizará a través de la PDU. Se deberá subir el archivo Calculadora.zip que incluya todos los archivos. Sólo hace falta subirla una vez por cada equipo de prácticas. La fecha límite para la entrega se indicará en la PDU.
