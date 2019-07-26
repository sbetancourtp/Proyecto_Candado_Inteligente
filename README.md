# Proyecto_Candado_Inteligente
Proyecto final de la materia Digital 1.

<img src="https://assets.pcmag.com/media/images/442565-master-lock-4401dlh-outdoor-bluetooth-lock.jpg?width=333&height=245" width = "500" >

## OBJETIVO
El objetivo de este proyecto es la creación de un producto de seguridad, con la capacidad de ser desbloqueado de muchas maneras diferentes para poder brindar seguridad de una forma más versatil y rapida.
## PROTOCOLOS UTILIZADOS

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

El protocolo de comunicación UART (Universal Asynchronous Receiver Transmitter) funciona de forma dual, es decir, no cuenta con Maestro y Esclavo como la mayoría de protocolos.

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/gene.PNG" width = "750" >

En donde CLK es el reloj del sistema, RSTN es un reset negado, cuando RSTN es 0, se hace un reset síncrono de la unidad de transmisión, START es el bit de comienzo de la transmisión. Cuando está a 1, se captura el carácter que entra por data y se empieza a enviar, DATA es el dato de 8 bits enviado o recibido, Tx es la salida serie del dato. Conecta con la línea de transmisión, READY es el estado de la transmisión; cuando READY es 1, la unidad está lista para transmitir. Y empezará en cuanto START se ponga a 1. Si READY es 0 la unidad está ocupada con el envío de un carácter, Rx es la línea de recepción serie; por donde llegan los datos en serie, RCV es la notificación de carácter recibido; es un pulso de 1 ciclo de ancho.

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/clktx.PNG" width = "750" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/j1soc.PNG" width = "750" >

Dentro de esta caja negra, encontramos el procesador J1 que selecciona las funciones del proyecto y podemos notar, las cajas negras de cada uno de los periféricos, NFC, I2S, SPI, UART como también un decodificador. Estas cajas negras del periférico son externas para fusionarse con el procesador, pero la del módulo UART como tal, la vemos a continuación con sus variables definidas. 

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/caja.PNG" width = "500" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/cnpu.PNG" width = "750" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/addr_J1.png" width = "750" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/register_addr_uart.jpg" width = "400" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/bloquestx.PNG" width = "500" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/bloquesrx.PNG" width = "500" >



