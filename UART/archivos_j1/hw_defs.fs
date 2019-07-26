( Hardware port assignments )

h# FF00 constant mult_a  \ no cambiar estos tres
h# FF02 constant mult_b  \ hacen parte de otras
h# FF04 constant mult_p  \ definiciones

\ memory map multiplier:
h# 6700 constant multi_a	
h# 6702 constant multi_b
h# 6704 constant multi_init
h# 6706 constant multi_done
h# 6708 constant multi_pp_high
h# 670A constant multi_pp_low


\ memory map divider:
h# 6800 constant div_a		
h# 6802 constant div_b
h# 6804 constant div_init
h# 6806 constant div_done
h# 6808 constant div_c


\ memory map uart:
h# 6900 constant uart_data_in    \ escritura de datos 8 bits que van al periferico para ser transmitidos por tx  
h# 6902 constant uart_start    \ se escribe el estado de la señal de start para habilitar transmisión 
h# 6904 constant uart_ready     \ se corrobora si esta disponible para hacer transmisión con el estado de la señal de ready
h# 6906 constant uart_rcv	\ se corrobora si se ha recibido un dato de 8 bits con el estado de la señal de rcv
h# 6908 constant uart_data_out	\ se lee la información de 8 bits recibida por rx	


