module peripheral_i2c(
  
  input clk,
  input rst,
  input [15:0] d_in,
  input cs,
  input [3:0] addr, // 4 LSB from j1_io_addr
  input rd,
  input wr,
  output reg [7:0] d_out,
  
  output sda,//sd
  output scl//blck
  );

//------------------------------------ regs and wires-------------------------------

reg [5:0] s; 	//selector mux_4  and write registers
reg [7:0] data_in;
reg init = 0;
wire busy;
reg data_out;	
//------------------------------------ regs and wires-------------------------------
always @(*) begin//---address_decoder--------------------------

  case (addr)
    4'h0:begin s = (cs && wr) ? 6'b000001 : 6'b000000 ;end //inil
    4'h2:begin s = (cs && wr) ? 6'b000010 : 6'b000000 ;end //data_in

    4'h4:begin s = (cs && rd) ? 6'b000100 : 6'b000000 ;end //busy
    4'h6:begin s = (cs && rd) ? 6'b001000 : 6'b000000 ;end//leo dato
  default:begin s = 6'b000000 ; end
  endcase
end//-----------------address_decoder--------------------------

always @(negedge clk) begin//-------------------- escritura de registros 
  init    = (s[0]) ? d_in : init;	//Write Registers
  data_in  = (s[1]) ? d_in[15:8] : data_in;	//Write Registers
end//------------------------------------------- escritura de registros 

always @(negedge clk) begin//-----------------------mux_4 :   multiplexa salidas del periferico
  case (s)
    6'b000100: d_out[0] = busy ;
    6'b001000: d_out[0] = data_out;
  default: d_out   = 0 ;
  endcase
end//-------------------------------------mux_4

i2c_controller i2c(.clk(clk),.rst(rst),.init(init),.data(data_in),.data_out(data_out),.bussy(busy),.sda(sda),.scl(scl));

endmodule
