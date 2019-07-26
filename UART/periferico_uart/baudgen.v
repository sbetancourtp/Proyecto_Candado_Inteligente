//-- Fichero baudgen.v
`include "baudgen.vh"

//-- ENTRADAS:
//--     -clk: Senal de reloj del sistema (100 MHZ en la FPGA Nexys 4)
//--     -clk_ena: Habilitacion. 
//--            1. funcionamiento normal. Emitiendo pulsos
//--            0: Inicializado y parado. No se emiten pulsos
//
//-- SALIDAS:
//--     - clk_out. Señal de salida que marca el tiempo entre bits
//--                Anchura de 1 periodo de clk. SALIDA NO REGISTRADA
module baudgen(input wire clk,
               input wire clk_ena, 
               output wire clk_out);

//-- Valor por defecto de la velocidad en baudios
parameter M = `B115200;

//-- Numero de bits para almacenar el divisor de baudios
localparam N = clog2(M);

//-- Registro para implementar el contador modulo M
reg [N-1:0] divcounter = 0;

//-- Contador módulo M
always @(posedge clk)

  if (clk_ena)
    //-- Funcionamiento normal
    divcounter <= (divcounter == M - 1) ? 0 : divcounter + 1;
  else
    //-- Contador "congelado" al valor maximo
    divcounter <= M - 1;

//-- Sacar un pulso de anchura 1 ciclo de reloj si el generador
//-- esta habilitado (clk_ena == 1)
//-- en caso contrario se saca 0
assign clk_out = (divcounter == 0) ? clk_ena : 0;

function integer clog2;
	input integer value;
begin
	value = value-1;
	for (clog2=0; value>0; clog2=clog2+1)
	value = value>>1;
end
endfunction
endmodule
