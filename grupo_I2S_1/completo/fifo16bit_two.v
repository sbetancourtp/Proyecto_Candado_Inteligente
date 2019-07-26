module fifo16bit_two #(

		parameter mem_file_name = "data.mem",
		parameter TAM_FIFO =44099 

)(
		input clk,
		input [15:0] data,
		output reg [15:0] dataout,
		output reg empty,
		output reg full,
                input rd,
                input wr,
                input rst
);

//declaración memoria fifo

reg [15:0] fifo [0:TAM_FIFO];

//declaración contadores

reg [15:0] tp;
reg [15:0] cp;

//assign fifo = data;

always @ (posedge clk, posedge rst)begin


	if (rst) begin
        //empty <=1;
	full <= 0;
	tp = 16'h0;
	cp = 16'h0;
	dataout = 16'hFFFF;

	end 
	else begin

	//if(!wr & rd & !empty) begin

		dataout = fifo[tp];
		tp = tp + 1;
		full <= 0;
		if (tp == TAM_FIFO)
		    tp = 0;
                if (tp == cp)
		    empty <= 1;
		

	//end

	/*
	if(wr & !rd & !full) begin
		fifo[cp]=data;
		cp = cp + 1;
		empty <=0;      
		if (cp==TAM_FIFO)
		   tp=0;
        	if (cp ==tp-1)
		    full <=1;
 

	end
	*/
	end
end




initial 
begin
	if (mem_file_name != "none")
	begin: data_loading
		$readmemh(mem_file_name, fifo);
	end
end

endmodule
