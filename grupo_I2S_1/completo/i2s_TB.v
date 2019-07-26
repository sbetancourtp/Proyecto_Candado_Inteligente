
module i2s_TB ();

reg sys_clk_i, sys_rst_i;

reg [15:0] data;
reg init;
wire busy;
wire dout;


i2s uut(sys_clk_i, sys_rst_i,init, busy, data, dout, bclk);




initial begin
  sys_clk_i   = 1;
  sys_rst_i = 0;
  init =0;
  #10 sys_rst_i = 1;
  #100 sys_rst_i = 0;

 // envio de 1 dato
//  data =16'ha050;
  init = 1;
  #200 init = 0;

  #13000

// envío 2do dato

  data =16'hAAAA;
 //init =1;
 //#600 init =0;
 //#10 sys_rst_i = 1; 
 //#100 sys_rst_i = 0;

  #13000

// envío 3er dato
//  data =16'h7777;
 init = 1;
 #600 init = 0;

//  #10 sys_rst_i = 1; 
//  #100 sys_rst_i = 0;

#22000

// envío 4to dato
data =16'h7777;
init = 1;
#600 init = 0;

//#13000
//data =16'haaaa;

end

always sys_clk_i = #1 ~sys_clk_i;


initial begin: TEST_CASE
  $dumpfile("i2s_TB.vcd");
  $dumpvars(-1, uut);
  #1000000 $finish;
end

endmodule
