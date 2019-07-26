module i2c_controller(clk,rst,init,data,data_out,bussy,sda,scl);
	input  clk;
	input rst;
	input  init;	
	input [7:0] data;//incluye el bit rw
	output reg [7:0]data_out;
	output bussy;
	inout sda;
	inout scl;
	
	localparam IDLE =      8'b00000000;
	localparam START =     8'b00000001;
	localparam ADDRESS =   8'b00000010;
	localparam READ_ACK =  8'b00000100;
	localparam WRITE_DATA= 8'b00001000;
	localparam WRITE_ACK = 8'b00010000;
	localparam READ_DATA = 8'b00100000;
	localparam READ_ACK2 = 8'b01000000;
	localparam STOP =      8'b10000000;
	
	localparam Div = 249; //400kHz
	localparam pwm = 163; //65% low
	localparam pwm2 = 81;
	
	reg [7:0] state;
	reg [7:0] saved_addr;
	reg [7:0] saved_data = 8'b10001010;
	reg [7:0] counter=0;
	reg sda_enable;
	reg sda_out;
	reg scl_enable = 0;
	reg i2c_clk;
	reg sda_clk;
	 
	assign bussy = (scl_enable == 1) ? 1 : 0;
	assign scl = (scl_enable == 0 ) ? 1 : i2c_clk;
	assign sda = (sda_enable == 1) ? sda_out : 'bz;
	
	
	reg [9:0] count = 0;
	
	always @(posedge clk, posedge rst) begin
		if (rst==1) begin
			count = 0;
			i2c_clk = 1;
			sda_clk = 1;
		end else begin
			if (count < Div) count = count + 1;
			else count = 0;
			
			if(count < pwm2)begin
				i2c_clk = 0;
				sda_clk = 1;
			end else if(count >= pwm2 && count <= pwm)begin 
				i2c_clk = 0;
				sda_clk = 0;
			end	
			else begin
				i2c_clk = 1;
				sda_clk = 1;
			end 

		end
	end 



	always @(negedge i2c_clk, posedge rst) begin
		if(rst == 1) begin
			scl_enable = 0;
		end else begin
			if ((state == IDLE) || (state == START) || (state == STOP)) begin
				scl_enable = 0;
			end else begin
				scl_enable = 1;
			end
		end
	
	end


	always @(posedge i2c_clk, posedge rst) begin
		if(rst == 1) begin
			state = IDLE;
		end		
		else begin
			case(state)
			
				IDLE: begin
					if (init) begin
						state = START;
						saved_addr = data;
					end
					else state = IDLE;
				end

				START: begin
					counter = 7;
					state = ADDRESS;
				end
				
				ADDRESS: begin
					if (counter == 0) begin 
						state = READ_ACK;
					end else counter = counter - 1;
				end

				READ_ACK: begin
					if (sda == 0 && sda_enable==0) begin
						counter = 7;
						if(saved_addr[0] == 0) state = WRITE_DATA;
						else state = READ_DATA;
					end else state = STOP;
				end

				WRITE_DATA: begin
					if(counter == 0) begin
						state = READ_ACK2;
					end else counter = counter - 1;
				end
				
				READ_ACK2: begin
					if ((sda == 0) && (init == 1)) state = IDLE;
					else state = STOP;
				end
				

				READ_DATA: begin
					data_out[counter] = sda;
					if (counter == 0) state = WRITE_ACK;
					else counter = counter - 1;
				end
				
				WRITE_ACK: begin
					state = STOP;
				end

				STOP: begin
					state = IDLE;
				end
			endcase
		end
	end
	
	always @(negedge i2c_clk, posedge rst) begin
		if(rst == 1) begin
			sda_enable = 1;
			sda_out = 1;
		end else begin
			case(state)
				
				START: begin
					sda_enable = 1;
					sda_out = 0;
				end
				
				ADDRESS: begin
					sda_out = saved_addr[counter];
				end
				
				READ_ACK: begin
					sda_enable = 0;
				end
				
				WRITE_DATA: begin 
					sda_enable = 1;
					sda_out = saved_data[counter];
				end
				
				WRITE_ACK: begin
					sda_enable = 1;
					sda_out = 0;
				end
				
				READ_DATA: begin
					sda_enable = 0;				
				end
				
				STOP: begin
					sda_enable = 1;
					sda_out = 1;
				end
				
			endcase
		end
	end	

	//i2c_divisor  Duvisor(.clk(clk), .rst(rst), .i2c_clk(12c_clk));

endmodule
