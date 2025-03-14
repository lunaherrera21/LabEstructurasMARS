.data
    mensajeSolicitarCantidad: .asciiz "Ingrese la cantidad de números a comparar (mínimo 3, máximo 5): "  # Mensaje para solicitar la cantidad de números
    mensajeError: .asciiz "Cantidad inválida. Debe ser entre 3 y 5.\n"  # Mensaje de error si la cantidad no es válida
    mensajeIngresarNumero: .asciiz "Ingrese un número: "  # Mensaje para solicitar un número
    mensajeMenor: .asciiz "El número menor es: "  # Mensaje para mostrar el número menor
    saltoLinea: .asciiz "\n"  # Salto de línea

.text
.globl main

main:
    # Solicitar la cantidad de números a comparar
    li $v0, 4                   # Prepara la syscall para imprimir cadena (código 4)
    la $a0, mensajeSolicitarCantidad  # Carga la dirección del mensaje en $a0
    syscall                     # Ejecuta la syscall para imprimir el mensaje

    li $v0, 5                   # Prepara la syscall para leer un entero (código 5)
    syscall                     # Ejecuta la syscall, el entero leído se almacena en $v0
    move $t0, $v0               # Guarda la cantidad de números en $t0

    # Verificar si la cantidad es válida (entre 3 y 5)
    li $t1, 3                   # Carga el valor mínimo permitido (3) en $t1
    li $t2, 5                   # Carga el valor máximo permitido (5) en $t2
    blt $t0, $t1, errorCantidad  # Si la cantidad es menor que 3, salta a errorCantidad
    bgt $t0, $t2, errorCantidad  # Si la cantidad es mayor que 5, salta a errorCantidad

    # Pedir el primer número y asumirlo como el menor
    li $v0, 4                   # Prepara la syscall para imprimir cadena (código 4)
    la $a0, mensajeIngresarNumero  # Carga la dirección del mensaje en $a0
    syscall                     # Ejecuta la syscall para imprimir el mensaje

    li $v0, 5                   # Prepara la syscall para leer un entero (código 5)
    syscall                     # Ejecuta la syscall, el entero leído se almacena en $v0
    move $t3, $v0               # Guarda el primer número como el menor en $t3

    # Loop para leer los siguientes números y encontrar el menor
    li $t4, 1                   # Inicializa el contador de números ingresados en 1 (ya ingresamos 1)

loop:
    bge $t4, $t0, mostrarMenor  # Si ya se ingresaron todos los números, salta a mostrarMenor
    
    # Pedir número
    li $v0, 4                   # Prepara la syscall para imprimir cadena (código 4)
    la $a0, mensajeIngresarNumero  # Carga la dirección del mensaje en $a0
    syscall                     # Ejecuta la syscall para imprimir el mensaje

    li $v0, 5                   # Prepara la syscall para leer un entero (código 5)
    syscall                     # Ejecuta la syscall, el entero leído se almacena en $v0
    move $t5, $v0               # Guarda el número ingresado en $t5

    # Comparar con el menor actual
    bge $t5, $t3, continuar     # Si el número ingresado no es menor, salta a continuar
    move $t3, $t5               # Si es menor, actualiza el menor en $t3

continuar:
    addi $t4, $t4, 1            # Incrementa el contador de números ingresados
    j loop                      # Salta de vuelta al inicio del loop

mostrarMenor:
    # Mostrar mensaje "El número menor es: "
    li $v0, 4                   # Prepara la syscall para imprimir cadena (código 4)
    la $a0, mensajeMenor         # Carga la dirección del mensaje en $a0
    syscall                     # Ejecuta la syscall para imprimir el mensaje

    # Mostrar el número menor
    li $v0, 1                   # Prepara la syscall para imprimir un entero (código 1)
    move $a0, $t3               # Mueve el número menor a $a0
    syscall                     # Ejecuta la syscall para imprimir el número menor

    # Imprimir un salto de línea
    li $v0, 4                   # Prepara la syscall para imprimir cadena (código 4)
    la $a0, saltoLinea           # Carga la dirección del salto de línea en $a0
    syscall                     # Ejecuta la syscall para imprimir el salto de línea

    j fin                       # Salta a fin para terminar el programa

errorCantidad:
    # Mostrar mensaje de error
    li $v0, 4                   # Prepara la syscall para imprimir cadena (código 4)
    la $a0, mensajeError         # Carga la dirección del mensaje de error en $a0
    syscall                     # Ejecuta la syscall para imprimir el mensaje de error
    j main                      # Salta de vuelta a main para solicitar la cantidad nuevamente

fin:
    li $v0, 10                  # Prepara la syscall para terminar el programa (código 10)
    syscall                     # Ejecuta la syscall para terminar el programa