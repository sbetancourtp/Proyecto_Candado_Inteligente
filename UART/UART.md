# UART
La estructura interna de un módulo de comunicación UART consta principalmente de registros de corrimiento, oscilador variable (utilizado para generar el BAUD), los verificadores de las condiciones correspondiente y una lógica de control.
Los datos que se quieren transferir o recibir se agrupan en paquetes de datos, los cuales son transmitidos a través de un registro de desplazamiento. Esto hace que la velocidad a la que se transmiten viene dada por el BAUD especificado. La lógica de control es la encargada de agregar los bits de inicio y de final de transmisión.
En la figura 1 se puede apreciar en mayor detalle en proceso interno y como es manejado este módulo UART.

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/uart.PNG" width = "750" >

El protocolo de comunicación UART (Universal Asynchronous Receiver Transmitter) funciona de forma dual, es decir, no cuenta con Maestro y Esclavo como la mayoría de protocolos.

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/gene.PNG" width = "750" >

En donde CLK es el reloj del sistema, RSTN es un reset negado, cuando RSTN es 0, se hace un reset síncrono de la unidad de transmisión, START es el bit de comienzo de la transmisión. Cuando está a 1, se captura el carácter que entra por data y se empieza a enviar, DATA es el dato de 8 bits enviado o recibido, Tx es la salida serie del dato. Conecta con la línea de transmisión, READY es el estado de la transmisión; cuando READY es 1, la unidad está lista para transmitir. Y empezará en cuanto START se ponga a 1. Si READY es 0 la unidad está ocupada con el envío de un carácter, Rx es la línea de recepción serie; por donde llegan los datos en serie, RCV es la notificación de carácter recibido; es un pulso de 1 ciclo de ancho.
El bus de datos de transmisión cuenta con 10 bits, 8 bits son de datos, un bit de START y un bit de STOP. Para transmitir, primero se poner el carácter de 8 bits en la entrada data y se activa la señal START. Se comienza a transmitir por Tx. La señal READY se pone a 0 para indicar que la unidad está ocupada. Cuando el carácter se ha terminado de enviar, READY se pone de nuevo a 1. Simultáneamente, cuando la línea está en reposo y no se ha recibido nada, la señal RCV está a 0. Al recibirse el bit de START por Rx, el receptor comienza a funcionar, leyendo los siguientes bits y almacenándolos internamente en su registro de desplazamiento. En el instante t1, cuando se ha recibido el bit de STOP, el dato se captura y se saca por la salida data. En el siguiente ciclo de reloj, instante t2 (en el cronograma el tiempo se ha exagerado para que se aprecie), aparece un pulso de un ciclo de reloj de anchura (exagerado también en el dibujo) que permita capturar el dato en un registro externo.

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/clktx.PNG" width = "750" >
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/clkrx.PNG" width = "750" >

Esta interfaz es muy cómoda. Para usar UART $T_x y R_x$ en nuestros diseños, sólo hay que conectar la salida data a la entrada de datos de un registro y la señal RCV usarla como habilitación. El dato recibido se capturará automáticamente. Esta señal RCV también la podemos usar en los controladores para saber cuándo se ha recibido un dato nuevo. 

## Especificaciones

A la hora de definir el protocolo de comunicación UART, es de suma importancia indicar la velocidad de operación, la cual es medida en BAUDios. Esta medida nos permite especificar cuántos bits por segundo se van a transmitir y se configura mediante un registro de propósito específico, que varía dependiendo del lenguaje de programación utilizado, en nuestro caso Verilog. Otro de los factores a definir, son cuántos bits de parada se agregaran al final de cada paquete de datos y si habrá o no bit de paridad. En nuestro caso lo definimos de la siguiente forma:

    8 bits de datos
    1 bit de inicio
    1 bit de parada
    Sin paridad
    9600 Baud de velocidad de transmisión
    
El módulo GPS planteado a utilizar es el Neo-6-m el cual se comunicará mediante protocolo UART al FPGA. Mediante un pulsador se habilitará la recepción del paquete de datos por parte del FPGA para así guardar en registros la señal enviada por el módulo GPS. 
Para el funcionamiento apropiado del Neo 6 M, este debe alimentarse con 5V, conectar el pin neutro Gnd y conectar los dos pines de transmisión y recepción $T_x$ y $R_x$ al puerto de comunicación UART de nuestro FPGA. 
El módulo GPS que se va a utilizar envía los datos mediante una cadena de caracteres, por lo tanto es necesario agregar un módulo decodificador que permita interpretar de manera precisa los datos de interés, en nuestro caso la latitud y longitud actual de nuestro dispositivo. 
Por último, cada vez que el pulsador GPS es utilizado, los datos nuevos obtenidos se sobre-escriben a los antiguos para así mantener la información de ubicación actualizada. Esta a su vez, puede ser enviada a los distintos módulos planteados para el proyecto de ser necesario. 

## Caja negra
El proyecto en una vista general cuenta con el siguiente esquema de caja negra, con la definición de cada una de las variables de entrada y de salida.

    io\_din, presente en el procesador, datos de entrada.
    io\_dout, presente en el procesador, datos de salida a los periféricos.
    io\_addr, presente en el procesador, dirección de cada periférico.
    io\_rd, presente en el procesador, lectura de datos.
    io\_wr, presente  en el procesador, escritura de datos. 
    d\_in, presente en cada periférico, datos de entrada del procesador.
    cs, selecciona el periférico a utilizar.
    rd, lectura de datos en los periféricos.
    wr, escritura de datos en los periféricos.
    d\_out, salida de datos de cada periférico.
    
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/j1soc.PNG" width = "500" >

Dentro de esta caja negra, encontramos el procesador J1 que selecciona las funciones del proyecto y podemos notar, las cajas negras de cada uno de los periféricos, NFC, I2S, SPI, UART como también un decodificador. Estas cajas negras del periférico son externas para fusionarse con el procesador, pero la del módulo UART como tal, la vemos a continuación con sus variables definidas. 

    START como inicialización
    CLK reloj del sistema
    RSTN es el reset 
    DATA Tx Bus de datos de 8 bit de entrada
    DATA Rx Bus de datos de 8 bit de salida 
    Tx Transmisión de datos
    Rx Recepción de datos 
    READY Variable para saber el estado del sistema (ocupado, libre) 
    RCV Recepción de datos 
    Tx Es la transmisión de los datos, que va conectada posteriormente a la entrada del GPS
    Rx Es la recepción de los datos, que viene conectada de la salida del GPS
    
Tenemos entonces el siguiente esquema de caja negra del módulo UART

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/caja.PNG" width = "750" >

Y también la caja negra del periférico UART que es el conectado al procesador J1.

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/cnpu.PNG" width = "500" >

## Diagramas de flujo
### Transmisión Tx

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/WhatsApp%20Image%202019-07-26%20at%2014.13.08(1).jpeg" heigth = "400" >

### Recepción Rx

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/WhatsApp%20Image%202019-07-26%20at%2014.13.08.jpeg" heigth = "400" >

## Máquina de estados
### Transmisión Tx
Se tienen las siguientes entradas
    RSTN: Para limpiar el contador
    CLK: Reloj del módulo para lograr la sincronía
    START: Señal que indica que empieza la transmisión de un caracter, 1 bit.
    BITc: Contador de caracteres, es la salida del contador de 4 bits. Indica el caracter que se está enviando. 
Las micro-órdenes que genera son 
    BAUDEN: Activa el temporizador de bits.
    LOAD: Carga el registro de desplazamiento.
    READY: Indica cuando se ha terminado de transmitir.
    
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/WhatsApp%20Image%202019-07-26%20at%2014.13.07(1).jpeg" width = "500" >

Como se puede ver tiene tres estados principales

    IDLE: Estado de reposo. Permanece en este estado indefinidamente, hasta que se activa la orden START para empezar a enviar el bus de datos.
    START: Comienzo de transmisión de un caracter.
    TRANS: Transmitiendo dato hasta que se active READY e indica que se deja dejó de transmitir.

### Recepción Rx
Como se puede ver tiene cuatro estados principales

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/WhatsApp%20Image%202019-07-26%20at%2014.13.07.jpeg" width = "500" >

    IDLE: Estado de reposo. Esperando a recibir el bit de START por Rx. En cuanto se recibe se pasa al siguiente estado.
    RCV: Recibiendo datos. Se activa el temporizador de bits mediante la micro-orden BAUDGEN y se van recibiendo todos los bits, que se almacenan en el registro de desplazamiento. Cuando se han recibido 10 bits (1 de START + 8 de datos + 1 de STOP) la salida del contador (bitc) estará a 10 y se pasa al siguiente estado.
    LOAD: Almacenamiento del dato recibido. Se activa la micro-orden load para guardar el dato recibido (8 bits) en el registro de datos.
    DAV: (Data Available). Señalización de que existe un dato disponible. Se pone a uno la señal RCV para que los circuitos externos puedan capturar el dato.
    
## Diagrama de bloques

Este diagrama se divide en la ruta de datos (Data Path) y el controlador (Máquina de estados) 

### Transmisión Tx

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/bloquestx.PNG" width = "500" >

Hay dos microórdenes que genera el controlador: BAUDEN y LOAD, con las que activa el temporizador de bits y la carga del registro de desplazamiento respectivamente. Load también se usa para poner a cero el contador de bits.
El dato a transmitir se recibe por data, y se registra para cumplir con las normas del diseño síncrono. El controlador genera también la señal READY para indicar cuándo se ha terminado de transmitir.

### Recepción Rx

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/bloquesrx.PNG" width = "500" >

La señal Rx se registra, para cumplir con las normas de diseño asíncrono, y se introduce por el bit más significativo de un registro de desplazamiento de 10 bits. El desplazamiento se realiza cuando llega un pulso por la señal $CLK_{BAUD}$, proveniente del generador de baudios. Este generador sólo funciona cuando la micro-orden BAUDEN está activada.
Un contador de 4 bits realiza la cuenta de los bits recibidos (cuenta cada pulso de $CLK_{BAUD}$). Se pone a 0 con la microórden CLEAR.
Por último tenemos el controlador, que genera las microórdenes BAUDGEN, LOAD, CLEAR y la señal de interfaz RCV. La señal load se activa para que el dato recibido se almacene en el registro de datos de 8 bits, de manera que se mantenga estable durante la recepción del siguiente carácter.\\
$BAUDEN_Rx$ es el generador de baudios para recepción. El receptor tiene su propio generador de baudios que es diferente al del transmisor. En el transmisor, al activar su generador con la micro-orden BAUDEN, emite inmediatamente un pulso. Sin embargo, en el receptor, se emite en la mitad del periodo. De esta forma se garantiza que el dato se lee en la mitad del periodo, donde es mucho más estable (y la probabilidad de error es menor).

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/WhatsApp%20Image%202019-07-26%20at%2014.13.06.jpeg" width = "500" >

En el cronograma se puede ver cómo al recibir el flanco de bajada del bit de START BAUDEN se activa, para que comience a funcionar el reloj del receptor. Sin embargo, hasta que no ha alcanzado la mitad del periodo de bit no se pone a 1. A partir de entonces, los pulsos coinciden con la mitad de los periodos de los bits recibidos

## Banco de pruebas

Se hace uso de CuteCom, que es un terminal serial gráfico, como minicom.
Actualmente se ejecuta en Linux.
Está dirigido principalmente a desarrolladores de hardware u otras personas que necesitan un terminal para hablar con sus dispositivos. Es un software gratuito y se distribuye bajo la Licencia Pública General de GNU versión 2, que puede encontrar en el archivo COPYING. Está escrito usando la biblioteca Qt por Trolltech. Siga este enlace para visitar la página del proyecto sourceforge.
CuteCom no usa las autotools (autoconf, automake, libtool, etc.) En su lugar, "configure" es simplemente un script de envoltura que llama a qmake.
## Software - Hardware
Con el periférico UART funcionando correctamente y haciendo la unión con SPI, I2S e I2C (Figura 5) se envían desde software las siguientes instrucciones al J1 para que este funcione como se es deseado.

<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/register_addr_uart.jpg" width = "400" >
 
<img src="https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/UART/addr_J1.png" width = "550" >
