`include "baudgen.vh"

module UART_TB();

//-- Baudios con los que realizar la simulacion
localparam BAUD = `B9600;

//-- Tics de reloj para envio de datos a esa velocidad
//-- Se multiplica por 2 porque el periodo del reloj es de 2 unidades
localparam BITRATE = (BAUD << 1);

//-- Tics necesarios para enviar una trama serie completa, mas un bit adicional
localparam FRAME = (BITRATE * 11);

//-- Tiempo entre dos bits enviados
localparam FRAME_WAIT = (BITRATE * 4);

reg clk = 0;
reg rstn = 1;
reg start = 0;
reg [7:0] data_tx = 0;
reg rx = 1;

wire ready;
wire tx;
wire [7:0] data_rx;
wire rcv;

UART test(
	.clk(clk),
	.rstn(rstn),
	.start(start),
	.data_tx(data_tx),
	.ready(ready),
	.tx(tx),
	.rx(rx),
	.data_rx(data_rx),
	.rcv(rcv)
	);


always 
	#1 clk <= ~clk;

initial begin

  //-- Fichero donde almacenar los resultados
  $dumpfile("UART_TB.vcd");
  $dumpvars(0, UART_TB);

  #1 rstn <= 1;

  //-- Prueba modulo de transmisión
  #FRAME_WAIT rstn <= 0;
	      data_tx <= 8'b00011000;	
  #FRAME_WAIT start <= 1;
  #(BITRATE * 2)    start <= 0;
  #FRAME
  //-- Prueba modulo de recepción 
  #BITRATE rx <=0;
  #BITRATE rx <=0;
  #BITRATE rx <=1;
  #BITRATE rx <=0;
  #BITRATE rx <=1;
  #BITRATE rx <=1;
  #BITRATE rx <=1;
  #BITRATE rx <=1;
  #BITRATE rx <=0;
  #BITRATE rx <=1;
  #FRAME_WAIT;
  #BITRATE rx <=0;
  #BITRATE rx <=1;
  #BITRATE rx <=1;
  #BITRATE rx <=1;
  #BITRATE rx <=0;
  #BITRATE rx <=0;
  #BITRATE rx <=1;
  #BITRATE rx <=1;
  #BITRATE rx <=1;
  #BITRATE rx <=1;
  #FRAME_WAIT;
  $display("FIN de la simulacion");
  $finish;
end

endmodule
