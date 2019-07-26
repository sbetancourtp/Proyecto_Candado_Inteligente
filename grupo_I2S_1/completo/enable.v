module enable (init, bclk, out_enable);

parameter size = 18;

input init;
input bclk;
output reg out_enable;

reg [8:0] count = 0;

always @(posedge init) begin

	repeat (size) @ (posedge bclk) begin
		if (count < size - 1) begin
			out_enable <= 1;
			count <= count + 1;
			end else begin
			out_enable <= 0;
			count <= 0;
		end
	end
end

endmodule
