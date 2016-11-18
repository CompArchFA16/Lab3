module Instr_memory
(
  input[31:0] Addr,
  output [31:0] DataOut
);

  reg [31:0] mem[0:10];

  initial $readmemh("Imem.dat", mem);

  assign DataOut = mem[Addr];
endmodule

module Data_memory
(
  input clk, regWE,
  input[31:0] Addr,
  input[31:0] DataIn,
  output[31:0]  DataOut
);

  reg [31:0] mem[0:10];

  always @(posedge clk) begin
    if (regWE) begin
      mem[Addr] <= DataIn;
      $writememh("Dmem.dat", mem);
    end
  end

  initial begin
      $readmemh("Dmem.dat", mem);
  end
 
      assign DataOut = mem[Addr];
endmodule

