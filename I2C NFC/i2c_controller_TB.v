module i2c_controller_TB;
	// Inputs
	reg clk;
	reg rst;
	reg [7:0] data_in;
	reg init;
	//reg rw;

	// Outputs
	wire data_out;
	wire bussy;
	wire sda;
	wire scl;

	// Instantiate the Unit Under Test (UUT)
	i2c_controller uut (
		.clk(clk), 
		.rst(rst), 
		.init(init), 
		.data(data_in), 
		//.rw(rw), 
		.data_out(data_out), 
		.bussy(bussy), 
		.sda(sda), 
		.scl(scl)
	);
	
	/*	
	i2c_slave_controller slave (
    .sda(sda), 
    .scl(scl)
    );
	*/
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		init = 0;
		#20;
		rst = 0;		
		
		#100;
        
		init = 1;
		data_in = 8'b01010101;
		
		#4000
		//if (bussy) begin
		//	init = init;
		//end 
		
		init = 0;
		
		#100;
		//rst = 1;		
		
	end
	always clk = #1 ~clk;


	initial begin: TEST_CASE
	$dumpfile("i2c_controller_TB.vcd");
	$dumpvars(-1, uut);
	#100000 $finish;
	end    

endmodule

