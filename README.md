# Proyecto_Candado_Inteligente
Proyecto final de la materia Digital 1.

## OBJETIVO
El objetivo de este proyecto es la creación de un producto de seguridad, con la capacidad de ser desbloqueado de muchas maneras diferentes para poder brindar seguridad de una forma ms versatil y rapida.
## PROTOCOLOS

### I2S
El protocolo I2S es un protocolo muy sencillo de transferencia de audio digital. Caracterizado por su capacidad de enviar datos para canales duales de forma serial.

El protocolo, como se puede ver en el siguiente diagrama, solo necesita de tres hilos: uno para datos, otro para el reloj y otro para seleccionar la palabra o el frame (ponemos esta señal a 0 para enviar la muestra del canal izquierdo y a 1 para enviar la muestra del canal derecho).

<img src="http://avelino.atlantes.org/blog/images/dac_i2s_diagrama_tiempos.png" width = "700" >

Al tratarse de un protocolo de transferencia serie, si queremos emitir audio con calidad CD (16 bits a 44100 Hz estéreo) hace falta generar un reloj de:

![equation](http://www.sciweavers.org/tex2img.php?eq=1%2Bsin%28mc%5E2%29&bc=White&fc=Black&im=jpg&fs=12&ff=arev&edit=)

![](https://github.com/sbetancourtp/Proyecto_Candado_Inteligente/blob/master/device.png)
