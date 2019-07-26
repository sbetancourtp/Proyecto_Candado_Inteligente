
module peripheral_i2c_TB ();

reg sys_clk_i, sys_rst_i;


wire sda;
wire scl;

reg [15:0]d_in;
reg cs;
reg [3:0]addr;
reg rd;
reg wr;
reg [7:0]d_out;


peripheral_i2c uut (sys_clk_i , sys_rst_i , d_in , cs , addr , rd , wr, d_out, sda, scl);


reg i;

initial begin
sys_clk_i = 0;
sys_rst_i=1;
# 100
sys_rst_i=0;


d_in=16'ha050;
addr =02;
wr=1;
rd=0;
cs=1;


#100

d_in=1;
addr =00;
wr=1;
rd=0;
cs=1;


# 100

d_in=0;
addr =00;
wr=1;
rd=0;
cs=1;




end

always sys_clk_i = #1 ~sys_clk_i;


initial begin: TEST_CASE
  $dumpfile("peripheral_i2c_TB.vcd");
  $dumpvars(-1, uut);
  #100000 $finish;
end

endmodule
