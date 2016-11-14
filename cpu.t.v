// TODO: Move these tests into the main file after we consolidate.
// Resources:
// - MIPS instructions: http://www.mrc.uidaho.edu/mrc/people/jff/digital/MIPSir.html

`include "reg_addr.v"
`include "cpu.v"

module testCPU ();

  // INIT ======================================================================

  reg clk;

  wire [31:0] cpuToMemAddress;
  wire [31:0] cpuToMemData;
  wire        cpuToMemWriteEnable;

  wire [31:0] dataMemOut;

  mockDataMemory dataMem (
    .out(dataMemOut),
    .clk(clk),
    .address(cpuToMemAddress),
    .in(cpuToMemData),
    .writeEnable(cpuToMemWriteEnable)
  );

  // DUT.
  CPU dut (
    .toMemAddress(cpuToMemAddress),
    .toMemData(cpuToMemData),
    .toMemWriteEnable(cpuToMemWriteEnable),
    .clk(clk),
    .fromMemData(dataMemOut)
  );

  // HELPERS ===================================================================

  // Registers.
  reg [4:0] rS;
  reg [4:0] rT;
  reg [4:0] rD;
  reg [4:0] expected_rD;

  reg        dutPassed;
  reg [25:0] jumpTarget;
  reg [15:0] imm;

  reg [5:0] expected_rT;

  task completeInstructionCycle;
    begin
      // TODO: Update this time to the correct length of our instruction cycle.
      #200;
    end
  endtask

  // Start the clock.
  initial clk = 1;
  always #1 clk = !clk;

  initial begin

    $dumpfile("cpu.vcd");
    $dumpvars;
    dutPassed = 1;

    // LW ======================================================================
    // RTL:
    //   $t = MEM [$s + i]:4

    rS = `R_S0; // datamem address to load from
    rT = `R_S1; // register to load into <- value lives here
    // instruction = { `CMD_lw, rS, rT, 16'b0 };
    completeInstructionCycle();

    // dataMemAddr =  32'd7;
    // dataMemWE = 1'b1;

    // TODO: Complete.
    // if dataMemAddr is wrong
      // fail

    // SW ======================================================================
    // RTL:
    //   PC = PC + 4
    //   DataMem[Reg[rS] + imm] = Reg[rT]

    // instruction = { `CMD_sw, rS, rT, 16'b0 };
    completeInstructionCycle();

    if (dataMemOut !== 32'd3) begin
      dutPassed = 0;
    end

    // J =======================================================================
    // Jumps to the calculated address.
    // RTL:
    //   PC = (PC & 0xf0000000) | (target << 2);

    jumpTarget = 26'd203;
    // instruction = { `CMD_j, jumpTarget };
    completeInstructionCycle();

    // if (pc !== {4'b0, 26'd203, 2'b0}) begin
    //   dutPassed = 0;
    // end

    // JR ======================================================================
    // Jump to the address contained in register $s.
    // RTL:
    //   PC = $s;

    // instruction = { `CMD_jr, rS, 21'b0 };
    completeInstructionCycle();

    // TODO: Match to the actual register value.
    // if (pc !== {4'b0, 28'b0}) begin
    //   dutPassed = 0;
    // end

    // JAL =====================================================================
    // Jumps to the calculated address and stores the return address in $31.
    // RTL:
    //   $31 = PC + 4;
    //   PC = (PC & 0xf0000000) | (target << 2);

    jumpTarget = 26'd214;
    // instruction = { `CMD_jal, jumpTarget };
    completeInstructionCycle();

    // if (pc !== {4'b0, 26'd214, 2'b0}) begin
    //   dutPassed = 0;
    // end

    // TODO: Determine how to test the return address $31.

    // BNE =====================================================================
    // Branches to PC + (imm << 2) when address in register $s != address in register $t.
    // RTL:
    //   if ($s != $t)
    //     PC = PC + (imm << 2));
    //   else
    //     PC = PC + 4;

    imm = 16'b10;
    // instruction = { `CMD_bne, rS, rT, imm };
    completeInstructionCycle();

    //pc = 0 --> 4
    //pc = 0 --> 14
    // if (pc !== 32'd14) begin
    //   dutPassed = 0;
    //   // $display("pc: %d", pc);
    //   // $display("imm: %d", imm);
    // end

    // XORI ====================================================================
    // RTL:
    //  $d = $s ^ ZE(i)

    imm =         16'b0000100000100001;
    rS =          16'b1000000010000001;
    expected_rT = 16'b1000100010100000;

    // instruction = {`CMD_xori, rS, rT, imm};
    completeInstructionCycle();

    if (rT !== expected_rT) begin
      dutPassed = 0;
    end

    // ADD =====================================================================
    // Adds the values of the two registers and stores the result in a register.
    // RTL:
    //    PC = PC + 4;
    //    $d = $s + $t;

    rS = 5'b0;
    rT = 5'b1;
    expected_rD = 5'b1;
    // instruction = { `CMD_add, rS, rT, rD };
    completeInstructionCycle();

    if (rD !== expected_rD) begin
      dutPassed = 0;
    end

    // SUB =====================================================================
    // Subtracts two registers and stores the result in a register.
    // RTL:
    //   PC = PC + 4;
    //   $d = $s - $t;

    // TODO: Load values first into Reg[rS] and Reg[rD].

    rS = 5'd0;
    rT = 5'd1;
    rD = 5'd2;
    // instruction = { `CMD_sub, rD, rS, rT };
    completeInstructionCycle();

    // TODO: Read from rD and check value.

    // SLT =====================================================================
    // If the value at $s is less than the value at $t, then the value at $d should
    // be 1. Otherwise, it is 0.
    // RTL:
    //    PC = PC + 4;
    //    if ($s < $t)
    //      $d = 1;
    //    else
    //      $d = 0;

    rS = 5'b0;
    rT = 5'b1;
    expected_rD = 16'b1;
    // instruction = { `CMD_slt, rS, rT, rD };
    completeInstructionCycle();

    if (rD !== expected_rD) begin
      dutPassed = 0;
    end

    $display("Has CPU tests passed? %b", dutPassed);
    $finish;
  end
endmodule

// MOCKS =======================================================================

module mockDataMemory (
  output reg [31:0] out,

  input        clk,
 	input [31:0] address,
  input [31:0] in,
 	input        writeEnable
);
	initial begin
		if (address === 32'd7) begin
			out <= 32'd3;
		end
	end
endmodule
