module gate_ID_EX (

  output reg        regWrite_EX,
  output reg        memToReg_EX,
  output reg        memWrite_EX,
  output reg        branch_EX,
  output reg [2:0]  aluControl_EX,
  output reg        aluSrc_EX,
  output reg        regDst_EX,
  output reg [31:0] readData1Out_EX,
  output reg [31:0] readData2Out_EX,
  output reg [4:0]  instruction_Rt_EX,
  output reg [4:0]  instruction_Rd_EX,
  output reg [31:0] signExtendOut_EX,
  output reg [31:0] pcPlus4_EX,
  input             clk,
  input             regWrite_ID,
  input             memToReg_ID,
  input             memWrite_ID,
  input             branch_ID,
  input      [2:0]  aluControl_ID,
  input             aluSrc_ID,
  input             regDst_ID,
  input      [31:0] readData1Out_ID,
  input      [31:0] readData2Out_ID,
  input      [4:0]  instruction_Rt_ID,
  input      [4:0]  instruction_Rd_ID,
  input      [31:0] signExtendOut_ID,
  input      [31:0] pcPlus4_ID
);
  always @ ( posedge clk ) begin
    regWrite_EX      <= regWrite_ID;
    memToReg_EX      <= memToReg_ID;
    memWrite_EX      <= memWrite_ID;
    branch_EX        <= branch_ID;
    aluControl_EX    <= aluControl_ID;
    aluSrc_EX        <= aluSrc_ID;
    regDst_EX        <= regDst_ID;
    readData1Out_EX  <= readData1Out_ID;
    readData2Out_EX  <= readData2Out_ID;
    instruction_Rt_EX <= instruction_Rt_ID;
    instruction_Rd_EX <= instruction_Rd_ID;
    signExtendOut_EX  <= signExtendOut_ID;
    pcPlus4_EX     <= pcPlus4_ID;
  end
endmodule
