/* 
 * Do not change Module name 
*/
module paral_serial(clk, reset, din, dout, enable, busy);
  
  input reset;
  input clk;
  input enable;
  output reg busy;
  input [15:0] din;
  output dout;
  
  //reg [4:0] count2 = 0;
  
  reg [4:0] count = 0;

  reg [15:0] registers;

  assign dout = registers [15];
/*

--hacer un ciclo que esté al mismo nivel del if de reseteo
--pedir ayuda cuando llegue a la casa

*/
    always @ (negedge clk, posedge reset) begin
		
		if (reset) begin
			registers = 0;
			count = 0;
			busy = 0;
		end
		
		if (enable) begin

			if (count == 0) begin
				registers <= din;
				busy = 1;
			end else if (count < 17) begin
				registers <= registers << 1;
				busy = 1;    
			end else begin
				count = 0;	
				busy = 0;
			end

			count = count + 1;

			//if (registers == 0) begin
			//	count = count - 1;
			//end
		
		end else begin
			count = 0;
		end
				
    end


endmodule
