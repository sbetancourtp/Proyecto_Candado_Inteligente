module i2s (main_clk, rst, init, busy, data, dout,bclk);

input main_clk;
input rst;
input [15:0] data;
output dout;
output busy;
input init;
output bclk;

wire w_div_clk;
wire w_div_clk_2;

wire w_pwm;

wire [15:0] w_fifo_to_bus;

wire [15:0] w_data;

wire w_enable;

wire wz1 = 1'bz;
wire wz2 = 1'bz;
wire wz3 = 1'bz;
wire wz4 = 1'bz;

assign bclk = w_div_clk;
assign w_data = data;

reg enable;

reg [8:0] count = 0;
/*
always @(posedge init) begin

	repeat (16) @ (posedge main_clk) begin
		if (count < 15) begin
			enable <= 1;
			count <= count + 1;
			end else begin
			enable <= 0;
			count <= 0;
		end
	end
end
*/
enable enab(.init(init),.bclk(w_div_clk),.out_enable(w_enable));

div_freq2 subreloj2 (.clk(main_clk),.reset(rst),.clkout(w_div_clk_2));

div_freq subreloj (.clk(main_clk),.reset(rst),.clkout(w_div_clk));

fifo16bit_two memoria (.clk(w_div_clk_2),.data(w_data),.rst(rst),.rd(wz1),.wr(wz2),.full(wz3),.empty(wz4),.dataout(w_fifo_to_bus));

paral_serial bus (.clk(w_div_clk),.enable(w_enable),.reset(rst),.din(w_fifo_to_bus),.dout(dout),.busy(busy));


endmodule
