//------------------------------------------------------------------------
// Data Memory
//   Positive edge triggered
//   dataOut always has the value mem[address]
//   If writeEnable is true, writes dataIn to mem[address]
//------------------------------------------------------------------------

module instructionMemory
(
  input clk, regWE,
  input[9:0] Addr,
  input[31:0] DataIn,
  output[31:0]  DataOut
);

  reg [31:0] mem[1023:0];  

  always @(posedge clk) begin
    if (regWE) begin
      mem[Addr] <= DataIn;
    end
  end

  initial $readmemh("tests/test_program_2.dat", mem);

  assign DataOut = mem[Addr];
endmodule // instruction_memory

module dataMemory
(
  input clk, regWE,
  input[9:0] Addr,
  input[31:0] DataIn,
  output[31:0]  DataOut
);

  reg [31:0] mem[1023:0];  

  always @(posedge clk) begin
    if (regWE) begin
      mem[Addr] <= DataIn;
      $writememh("tests/data_out.dat", mem);
    end
  end

  initial $readmemh("tests/data_out.dat", mem);

  assign DataOut = mem[Addr];
endmodule

// module datamemory
// #(
//    parameter addresswidth  = 7,
//    parameter depth         = 2**addresswidth,
//    parameter width         = 8
//)
//(
//    input                     clk,
//    output reg [width-1:0]      dataOut,
//    input [addresswidth-1:0]    address,
//    input                       writeEnable,
//    input [width-1:0]           dataIn
//);
//
//
//    reg [width-1:0] memory [depth-1:0];
//
//    always @(posedge clk) begin
//        if(writeEnable)
//            memory[address] <= dataIn;
//        dataOut <= memory[address];
//    end
//
//endmodule
