module div_freq #(
              parameter   fi     = 100000000,        //<- fFPGA/2=fi  
              parameter   fs	 = 600000     //<- flckout=fs
  )(input clk, output reg clkout,input reset);





reg [31:0] count;
initial count<= fi/fs;

always @(posedge  clk)
begin
	if (reset) 
	begin
	
	count <= fi/fs;
	clkout <=0;
	end
	else 	
	begin
	;
		
		if (count==0)begin
			clkout <=~clkout;
			count <= fi/fs;
		end	
		else begin
		count <=count-1;
		end

	end
end


endmodule
