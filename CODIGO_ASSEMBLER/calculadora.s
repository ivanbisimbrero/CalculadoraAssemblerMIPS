.data
caracterPunto: .byte '.'
.align 4
caracter: .space 1
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

lbu $t0 caracterPunto

jal mostrarMenu
j fin

mostrarMenu:		
				while:  beq $a0 $t0 end_Menu

				la $a0 mensajeMenu
				li $v0 4
                syscall
                #Leo caracter--> Se guarda en $a0 el caracter 
                li $v0 8
                syscall
                sb $a0 caracter
                #TO-DO: FUNC CALCULATOR (FIBONACCI XD Y EL RESTO TB JIJIJIJA)
                j while
				end_Menu:
              	jr $ra
                
               
                
                
fin:						li $v0 10
								syscall