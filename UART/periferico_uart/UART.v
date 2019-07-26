module UART(
	input wire clk,		// Reloj del sistema(100MHz en Nexys 4)
	input wire rstn,	// Reset global
	input wire start,	// Nivel alto para transmitir
	input wire [7:0] data_tx,	// Recepción de datos a transmitir en paralelo
	output wire ready,	// Nivel alto listo para transmitir / nivel bajo ocupado (busy)
	output wire tx,		// Salida de datos serie
	input wire rx,		// Entrada de datos serie
	output wire [7:0] data_rx,	// Sacar dato rx serie mostrado en paralelo 
	output wire rcv		// Nivel alto dato recibido / Nivel bajo recibiendo dato
	);

uart_tx TX(
	.clk(clk),
	.rstn(rstn),
	.start(start),
	.data(data_tx),
	.tx(tx),
	.ready(ready)
	);

uart_rx RX(
	.clk(clk),
	.rstn(rstn),
	.rx(rx),
	.rcv(rcv),
	.data(data_rx)
	);

endmodule
