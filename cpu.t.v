// TODO: Move these tests into the main file after we consolidate.
// Resources:
// - MIPS instructions: http://www.mrc.uidaho.edu/mrc/people/jff/digital/MIPSir.html

`include "reg_addr.v"
`include "ram.v"
`include "cpu.v"

module testCPU ();

  // INIT ======================================================================

  reg clk;
  reg resetPC;
  reg isTesting;

  wire [31:0] instructionAddress;
  wire [31:0] instructionMemOut;
  wire [31:0] dataMemOut;

  wire [31:0] cpuToMemAddress;
  wire [31:0] cpuToMemData;
  wire        cpuToMemWriteEnable;

  CPU dut (
    .instructionAddress(instructionAddress),
    .dataMemAddress(cpuToMemAddress),
    .dataOut(cpuToMemData),
    .toMemWriteEnable(cpuToMemWriteEnable),
    .clk(clk),
    .instruction(instructionMemOut),
    .dataIn(dataMemOut),
    .resetPC(resetPC)
  );

  reg [31:0] testToMemAddress;
  reg [31:0] testToMemData;
  reg        testToMemWriteEnable;

  wire [31:0] toggleToMemAddress;
  wire [31:0] toggleToMemData;
  wire        toggleToMemWriteEnable;

  mux_2 #(32) toggleAddress (
    .out(toggleToMemAddress),
    .address(isTesting),
    .input0(cpuToMemAddress),
    .input1(testToMemAddress)
  );

  mux_2 #(32) toggleData (
    .out(toggleToMemData),
    .address(isTesting),
    .input0(cpuToMemData),
    .input1(testToMemData)
  );

  mux_2 #(1) toggleWriteEnable (
    .out(toggleToMemWriteEnable),
    .address(isTesting),
    .input0(cpuToMemWriteEnable),
    .input1(testToMemWriteEnable)
  );

  RAM ram (
    .readData1(instructionMemOut),
    .readData2(dataMemOut),
    .clk(clk),
    .address1(instructionAddress),
    .address2(toggleToMemAddress),
    .dataIn(toggleToMemData),
    .writeEnable(toggleToMemWriteEnable)
  );

  // HELPERS ===================================================================

  reg dutPassed;

  // Registers.
  reg [4:0] rS;
  reg [4:0] rT;
  reg [4:0] rD;
  reg [4:0] expected_rT;
  reg [4:0] expected_rD;

  reg [25:0] jumpTarget;
  reg [15:0] imm;
  reg [31:0] instruction;

  task clkOnce;          begin #2;  end endtask
  task waitAFullCPULoad; begin #10; end endtask

  task insertToMemory;
    input [31:0] address;
    input [31:0] data;
    begin
      isTesting <= 1'b1;
      testToMemData <= data;
      testToMemAddress <= address;
      testToMemWriteEnable <= 1'b1;
      clkOnce();
      testToMemWriteEnable <= 1'b0;
      isTesting <= 1'b0;
    end
  endtask

  // Start the clock.
  initial clk = 0;
  always #1 clk = !clk;

  initial begin

    $dumpfile("cpu.vcd");
    $dumpvars;
    dutPassed = 1;

    // Offset our test to be on the negedge. This way, our changes are picked up
    // by the next posedge of the clk.
    #1;

    // LW ======================================================================
    // RTL:
    //   PC = PC + 4;
    //   $t = MEM[$s + offset];

    // Load our test data.
    insertToMemory(32'hAB, 32'h42);

    resetPC = 1;
    insertToMemory(32'd0,  { `CMD_add, `R_ZERO, `R_ZERO, 16'b0  }); // To offset our resetPC.
    insertToMemory(32'd4,  { `CMD_lw,  `R_ZERO, `R_S1,   16'hAB });
    insertToMemory(32'd8,  { `CMD_add, `R_ZERO, `R_ZERO, 16'b0  });
    insertToMemory(32'd12, { `CMD_add, `R_ZERO, `R_ZERO, 16'b0  });
    insertToMemory(32'd16, { `CMD_add, `R_ZERO, `R_ZERO, 16'b0  });
    insertToMemory(32'd20, { `CMD_add, `R_ZERO, `R_ZERO, 16'b0  });
    insertToMemory(32'd24, { `CMD_sw,  `R_ZERO, `R_S1,   16'hAC });
    resetPC = 0;

    waitAFullCPULoad();
    waitAFullCPULoad();

    isTesting = 1;
    testToMemAddress = 32'hAC;
    clkOnce();
    if (dataMemOut !== 32'h42) begin
      dutPassed = 0;
      $display("Store after a load failed.");
      $display("Actual data memory output: %h", dataMemOut);
    end
    isTesting = 0;

    // SW ======================================================================
    // RTL:
    //   PC = PC + 4
    //   DataMem[Reg[rS] + imm] = Reg[rT]

    // instruction = { `CMD_sw, rS, rT, 16'b0 };
    // waitAFullCPULoad();

    // if (dataMemOut !== 32'd3) begin
      // dutPassed = 0;
    // end

    // J =======================================================================
    // Jumps to the calculated address.
    // RTL:
    //   PC = (PC & 0xf0000000) | (target << 2);

    // jumpTarget = 26'd203;
    // instruction = { `CMD_j, jumpTarget };
    // waitAFullCPULoad();

    // if (pc !== {4'b0, 26'd203, 2'b0}) begin
    //   dutPassed = 0;
    // end

    // JR ======================================================================
    // Jump to the address contained in register $s.
    // RTL:
    //   PC = $s;

    // instruction = { `CMD_jr, rS, 21'b0 };
    // waitAFullCPULoad();

    // TODO: Match to the actual register value.
    // if (pc !== {4'b0, 28'b0}) begin
    //   dutPassed = 0;
    // end

    // JAL =====================================================================
    // Jumps to the calculated address and stores the return address in $31.
    // RTL:
    //   $31 = PC + 4;
    //   PC = (PC & 0xf0000000) | (target << 2);

    // jumpTarget = 26'd214;
    // instruction = { `CMD_jal, jumpTarget };
    // waitAFullCPULoad();

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

    // rS = `R_S0;
    // rT = `R_S1;
    // imm = 16'b10;
    // insertToMemory({ `CMD_bne, rS, rT, imm });
    // waitAFullCPULoad();

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

    // imm =         16'b0000100000100001;
    // rS =          16'b1000000010000001;
    // expected_rT = 16'b1000100010100000;

    // instruction = {`CMD_xori, rS, rT, imm};
    // waitAFullCPULoad();

    // if (rT !== expected_rT) begin
      // dutPassed = 0;
    // end

    // ADD =====================================================================
    // Adds the values of the two registers and stores the result in a register.
    // RTL:
    //    PC = PC + 4;
    //    $d = $s + $t;

    // rS = 5'b0;
    // rT = 5'b1;
    // expected_rD = 5'b1;
    // instruction = { `CMD_add, rS, rT, rD };
    // waitAFullCPULoad();

    // if (rD !== expected_rD) begin
      // dutPassed = 0;
    // end

    // SUB =====================================================================
    // Subtracts two registers and stores the result in a register.
    // RTL:
    //   PC = PC + 4;
    //   $d = $s - $t;

    // TODO: Load values first into Reg[rS] and Reg[rD].

    // rS = 5'd0;
    // rT = 5'd1;
    // rD = 5'd2;
    // instruction = { `CMD_sub, rD, rS, rT };
    // waitAFullCPULoad();

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

    // rS = 5'b0;
    // rT = 5'b1;
    // expected_rD = 16'b1;
    // instruction = { `CMD_slt, rS, rT, rD };
    // waitAFullCPULoad();

    // if (rD !== expected_rD) begin
      // dutPassed = 0;
    // end

    $display("Has CPU tests passed? %b", dutPassed);
    $finish;
  end
endmodule
