# Proyecto_Candado_Inteligente
Proyecto final de la materia Digital 1.

## OBJETIVO
El objetivo de este proyecto es la creación de un producto de seguridad, con la capacidad de ser desbloqueado de muchas maneras diferentes para poder brindar seguridad de una forma más versatil y rapida.
## PROTOCOLO

### I2S
El protocolo I2S es un protocolo muy sencillo de transferencia de audio digital. Caracterizado por su capacidad de enviar datos para canales duales de forma serial.

El protocolo, como se puede ver en el siguiente diagrama, solo necesita de tres hilos: uno para datos, otro para el reloj y otro para seleccionar la palabra o el frame (ponemos esta señal a 0 para enviar la muestra del canal izquierdo y a 1 para enviar la muestra del canal derecho).

<img src="http://avelino.atlantes.org/blog/images/dac_i2s_diagrama_tiempos.png" width = "750" >

Al tratarse de un protocolo de transferencia serie, si queremos emitir audio con calidad CD (16 bits a 44100 Hz estéreo) hace falta generar un reloj de:

![equation](https://latex.codecogs.com/gif.latex?freq%20%3D%2044100%20*%2016%20*%202%20%3D%201411200%20Hz)

El reloj de palabra permite al circuito receptor conocer si los datos que están siendo enviados pertenecen al canal 1 o al 2 ya que dos canales pueden ser enviados por la misma línea de datos. Para datos estéreo, la especificación I²S establece que la izquierda se transmite en la parte baja del ciclo del reloj de palabra, y la derecha en la parte alta. El reloj de palabra tiene un ciclo de reloj de 50%, y tiene la misma frecuencia que la razón de muestreo.

El primer bit transmitido después de una transición del reloj de palabra es el bit menos significativo de la palabra anterior.

Este protocolo constituye una forma muy fiel y robusta de transmisión de datos de audio.

## UART
La estructura interna de un módulo de comunicación UART consta principalmente de registros de corrimiento, oscilador variable (utilizado para generar el BAUD), los verificadores de las condiciones correspondiente y una lógica de control.
Los datos que se quieren transferir o recibir se agrupan en paquetes de datos, los cuales son transmitidos a través de un registro de desplazamiento. Esto hace que la velocidad a la que se transmiten viene dada por el BAUD especificado. La lógica de control es la encargada de agregar los bits de inicio y de final de transmisión.
En la figura 1 se puede apreciar en mayor detalle en proceso interno y como es manejado este módulo UART.
El bus de datos de transmisión cuenta con 10 bits, 8 bits son de datos, un bit de START y un bit de STOP. Para transmitir, primero se poner el carácter de 8 bits en la entrada data y se activa la señal START. Se comienza a transmitir por Tx. La señal READY se pone a 0 para indicar que la unidad está ocupada. Cuando el carácter se ha terminado de enviar, READY se pone de nuevo a 1. Simultáneamente, cuando la línea está en reposo y no se ha recibido nada, la señal RCV está a 0. Al recibirse el bit de START por Rx, el receptor comienza a funcionar, leyendo los siguientes bits y almacenándolos internamente en su registro de desplazamiento. En el instante t1, cuando se ha recibido el bit de STOP, el dato se captura y se saca por la salida data. En el siguiente ciclo de reloj, instante t2 (en el cronograma el tiempo se ha exagerado para que se aprecie), aparece un pulso de un ciclo de reloj de anchura (exagerado también en el dibujo) que permita capturar el dato en un registro externo.

El protocolo de comunicación UART (Universal Asynchronous Receiver Transmitter) funciona de forma dual, es decir, no cuenta con Maestro y Esclavo como la mayoría de protocolos.


<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/gene.PNG" width = "750" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/clktx.PNG" width = "750" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/j1soc.PNG" width = "750" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/caja.PNG" width = "500" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/cnpu.PNG" width = "750" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/addr_J1.png" width = "750" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/register_addr_uart.jpg" width = "400" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/bloquestx.PNG" width = "500" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/bloquesrx.PNG" width = "500" >



