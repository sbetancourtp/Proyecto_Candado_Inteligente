module peripheral_uart(clk, rst, d_in, cs, addr, rd, wr, d_out, tx, rx);
  
  input wire clk;
  input wire rst;
  input wire [15:0]d_in; // dato de entrada desde procesador para transmitir
  input wire cs; // bit que habilita en módulo 
  input wire [3:0]addr; // Direcciones en registro
  input wire rd; // bit que habilita la lectura
  input wire wr; // bit que habilita la escritura 
  input wire rx; // recepción serial

  output reg[15:0]d_out; // dato de entrada desde dispositivo externo que se la pasa al procesador 
  output wire tx; // transmisión serial

//------------------------------------ Registros y cables-------------------------------

reg [4:0] s; 	//selector mux_4  and demux_4
reg [7:0] data_tx;
wire [7:0] data_rx; // Data out 
reg start;
wire rcv, ready;

//------------------------------------ Registros y cables-------------------------------


always @(*) begin//----Decodificador de direcciones------------------
case (addr)
// Transmisión
4'h0:begin s = (cs && wr) ? 5'b00001 : 5'b00000 ;end // Ingreso o envío del dato a transmitir
4'h2:begin s = (cs && wr) ? 5'b00010 : 5'b00000 ;end // Se habilita la señal de start 
4'h4:begin s = (cs && rd) ? 5'b00100 : 5'b00000 ;end // Se verifica la señal de ready

// Recepción
4'h6:begin s = (cs && rd) ? 5'b01000 : 5'b00000 ;end // Se verifica si existe un dato para su recepción
4'h8:begin s = (cs && rd) ? 5'b10000 : 5'b00000 ;end // Se envía el dato recibido al procesador

default:begin s=5'b00000 ; end
endcase
end//-----------------Decodificador de direcciones--------------------





always @(negedge clk) begin//-------------------- Escritura de registros

data_tx = (s[0]) ? d_in[7:0] : data_tx; // Asigna el dato al registro interno de la transmisión UART
start = (s[1]) ? d_in[0] : start; // Flag de busy para UART RX

end//------------------------------------------- escritura de registros	




always @(negedge clk) begin//-----------------------mux_4 :  multiplexa salidas del periferico
case (s)
5'b00100: d_out[0]= ready; // Se asigna señal ready para su verificación de estado en el procesador
5'b01000: d_out[0]= rcv; // Se asigna señal rcv para su verificación de estado en el procesador
5'b10000: d_out[7:0] = data_rx; // Se asigna el dato recibido data_rx a la señal que va hacia el procesador
default: d_out=0;
endcase
end//----------------------------------------------mux_4

UART UART(.clk(clk), .rstn(rst), .start(start), .data_tx(data_tx), .ready(ready), .tx(tx), .rx(rx), .data_rx(data_rx), .rcv(rcv));

endmodule
