// TODO: Move these tests into the main file after we consolidate.
// Resources:
// - MIPS instructions: http://www.mrc.uidaho.edu/mrc/people/jff/digital/MIPSir.html

`include "reg_addr.v"
`include "ram.v"
`include "cpu.v"

module testCPU ();

  // INIT ======================================================================

  reg clk       = 0;
  reg isTesting = 1;
  reg dutPassed = 1;

  wire [31:0] instruction_addr;
  wire [31:0] instructionMemOut;
  wire [31:0] dataMemOut;

  wire [31:0] cpuToMemAddress;
  wire [31:0] cpuToMemData;
  wire        cpuToMemWriteEnable;

  CPU dut (
    .instruction_addr(instruction_addr),
    .dataMemAddress(cpuToMemAddress),
    .dataOut(cpuToMemData),
    .toMemWriteEnable(cpuToMemWriteEnable),
    .clk(clk),
    .instruction(instructionMemOut),
    .dataIn(dataMemOut),
    .resetPC(isTesting)
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
    .address1(instruction_addr),
    .address2(toggleToMemAddress),
    .dataIn(toggleToMemData),
    .writeEnable(toggleToMemWriteEnable)
  );

  always #1 clk = !clk;
  initial begin

    $dumpfile("cpu.vcd");
    $dumpvars(3);
    $dumpoff;

    // Offset our test to be on the negedge. This way, our changes are picked up
    // by the next posedge of the clk.
    #1;

    // ASSEMBLY TEST ===========================================================

    $dumpon;

    executeProgram(99);

    testToMemAddress = 32'h1234;
    clkOnce();
    if (dataMemOut !== 32'h8) begin
      dutPassed = 0;
      $display("*** FAIL: Jay, Paul, and TJ's assembly.");
      $display("Actual data memory output: %h", dataMemOut);
    end

    $dumpoff;

    // LW & SW =================================================================
    // LW: Loads into a register a value from memory.
    // LW RTL:
    //   PC = PC + 4;
    //   $t = MEM[Reg[$s] + offset];
    // SW: Stores from a register a value to memory.
    // SW RTL:
    //   PC = PC + 4;
    //   DataMem[Reg[$s] + offset] = Reg[$t];

    // Load our test data.
    writeToMem(32'hAB, 32'h42);

    writeInstructions (6, {
      { `CMD_lw, `R_ZERO, `R_S1, 16'hAB },
      noop, noop, noop, noop,
      { `CMD_sw, `R_ZERO, `R_S1, 16'hAC }
    });

    executeProgram(6);

    testToMemAddress = 32'hAC;
    clkOnce();
    if (dataMemOut !== 32'h42) begin
      dutPassed = 0;
      $display("*** FAIL: Storing after a load.");
      $display("Actual data memory output: %h", dataMemOut);
    end

    // J =======================================================================
    // Jumps to the calculated address.
    // RTL:
    //   PC = (PC & 0xf0000000) | (target << 2);

    writeToMem(32'hAA, 32'h3);
    writeToMem(32'hAF, 32'h4); // If you get this value, you didn't jump.

    writeInstructions (12, {
      { `CMD_lw, `R_ZERO, `R_S0, 16'hAA },
      noop, noop, noop, noop,
      { `CMD_j, 26'hB },
      { `CMD_lw, `R_ZERO, `R_S0, 16'hAF },
      noop, noop, noop, noop,
      { `CMD_sw, `R_ZERO, `R_S0, 16'hAC }
    });

    executeProgram(7);

    testToMemAddress = 32'hAC;
    clkOnce();
    if (dataMemOut !== 32'h3) begin
      dutPassed = 0;
      $display("*** FAIL: Jump.");
      $display("Actual data memory output: %h", dataMemOut);
    end

    // JR ======================================================================
    // Jump to the address contained in register $s.
    // RTL:
    //   PC = $s;

    writeToMem(32'hAA, 32'h34); // Load this address.
    writeToMem(32'hAF, 32'h7); // This means you didn't jump.
    writeToMem(32'hB4, 32'h2); // This is the value that we want.

    writeInstructions (18, {
      { `CMD_lw, `R_ZERO, `R_S0, 16'hAA },
      noop, noop, noop, noop,
      { `CMD_lw, `R_ZERO, `R_S1, 16'hB4 },
      noop, noop, noop, noop,
      { `CMD_jr, `R_S0, 21'h0 },
      noop,
      { `CMD_lw, `R_ZERO, `R_S1, 16'hAF }, // This will be skipped.
      noop, noop, noop, noop,
      { `CMD_sw, `R_ZERO, `R_S1, 16'hB9 }
    });

    executeProgram(17);

    testToMemAddress = 32'hB9;
    clkOnce();
    if (dataMemOut !== 32'h2) begin
      dutPassed = 0;
      $display("*** FAIL: JR.");
      $display("Actual data memory output: %h", dataMemOut);
    end

    // JAL =====================================================================
    // Jumps to the calculated address and stores the return address in $31.
    // RTL:
    //   $31 = PC + 4;
    //   PC = (PC & 0xf0000000) | (target << 2);

    writeToMem(32'hAA, 32'hCC);

    writeInstructions (9, {
      noop,
      { `CMD_jal, 26'h8 },
      noop,
      { `CMD_lw, `R_ZERO, `R_RA, 16'hAA },
      noop, noop, noop, noop,
      { `CMD_sw, `R_ZERO, `R_RA, 16'hAB }
    });

    executeProgram(4);

    testToMemAddress = 32'hAB;
    clkOnce();
    if (dataMemOut !== 32'hC) begin
      dutPassed = 0;
      $display("*** FAIL: JAL.");
      $display("Actual data memory output: %h", dataMemOut);
    end

    // BNE =====================================================================
    // Branches to PC + (imm << 2) when address in register $s != address in register $t.
    // RTL:
    //   if ($s != $t)
    //     PC = PC + (imm << 2));
    //   else
    //     PC = PC + 4;

    writeToMem(32'hAA, 32'h1);
    writeToMem(32'hAF, 32'h2);

    writeInstructions (15, {
      { `CMD_lw, `R_ZERO, `R_S0, 16'hAA },
      noop, noop, noop, noop,
      { `CMD_bne, `R_ZERO, `R_S0, 16'h8 },
      noop, noop, noop,
      { `CMD_lw, `R_ZERO, `R_S0, 16'hAF },
      noop, noop, noop, noop,
      { `CMD_sw, `R_ZERO, `R_S0, 16'hBF }
    });

    executeProgram(10);

    testToMemAddress = 32'hBF;
    clkOnce();
    if (dataMemOut !== 32'h1) begin
      dutPassed = 0;
      $display("*** FAIL: BNE #1.");
      $display("Actual data memory output: %h", dataMemOut);
    end

    writeInstructions (15, {
      { `CMD_lw, `R_ZERO, `R_S0, 16'hAA },
      noop, noop, noop, noop,
      { `CMD_bne, `R_S0, `R_S0, 16'h8 },
      noop, noop, noop,
      { `CMD_lw, `R_ZERO, `R_S0, 16'hAF },
      noop, noop, noop, noop,
      { `CMD_sw, `R_ZERO, `R_S0, 16'hBF }
    });

    executeProgram(15);

    testToMemAddress = 32'hBF;
    clkOnce();
    if (dataMemOut !== 32'h2) begin
      dutPassed = 0;
      $display("*** FAIL: BNE #2.");
      $display("Actual data memory output: %h", dataMemOut);
    end

    // XORI ====================================================================
    // RTL:
    //  $d = $s ^ ZE(i)

    writeToMem(32'hC4, 32'b10101010101010101010101010101010);

    writeInstructions (11, {
      { `CMD_lw, `R_ZERO, `R_S0, 16'hC4 },
      noop, noop, noop, noop,
      { `CMD_xori, `R_S0, `R_S1, 16'b1111110101010101 },
      noop, noop, noop, noop,
      { `CMD_sw, `R_ZERO, `R_S1, 16'hF3 }
    });

    executeProgram(11);

    testToMemAddress = 32'hF3;
    clkOnce();
    if (dataMemOut !== 32'b10101010101010110101011111111111) begin
      dutPassed = 0;
      $display("*** FAIL: XORI");
      $display("Actual data memory output: %b", dataMemOut);
    end

    // ADD =====================================================================
    // Adds the values of the two registers and stores the result in a register.
    // RTL:
    //   PC = PC + 4;
    //   $d = $s + $t;

    // Load our test data.
    writeToMem(32'hF1, 32'h3);
    writeToMem(32'hF8, 32'h4);

    writeInstructions (16, {
      { `CMD_lw, `R_ZERO, `R_S0, 16'hF1 },
      noop, noop, noop, noop,
      { `CMD_lw, `R_ZERO, `R_S1, 16'hF8 },
      noop, noop, noop, noop,
      {  6'b0, `R_S0, `R_S1, `R_S2, 5'b0, `CMD_add },
      noop, noop, noop, noop,
      { `CMD_sw, `R_ZERO, `R_S2, 16'hC3 }
    });

    executeProgram(16);

    testToMemAddress = 32'hC3;
    clkOnce();
    if (dataMemOut !== 32'h7) begin
      dutPassed = 0;
      $display("*** FAIL: Addition.");
      $display("Actual data memory output: %h", dataMemOut);
    end

    // SUB =====================================================================
    // Subtracts two registers and stores the result in a register.
    // RTL:
    //   PC = PC + 4;
    //   $d = $s - $t;

    // Load our test data.
    writeToMem(32'hD1, 32'h4);
    writeToMem(32'hF2, 32'h9);

    writeInstructions (16, {
      { `CMD_lw, `R_ZERO, `R_S0, 16'hD1 },
      noop, noop, noop, noop,
      { `CMD_lw, `R_ZERO, `R_S1, 16'hF2 },
      noop, noop, noop, noop,
      { 6'b0, `R_S0, `R_S1, `R_S2, 5'b0, `CMD_sub },
      noop, noop, noop, noop,
      { `CMD_sw, `R_ZERO, `R_S2, 16'hE3 }
    });

    executeProgram(16);

    testToMemAddress = 32'hE3;
    clkOnce();
    if (dataMemOut !== 32'hfffffffb) begin // -5.
      dutPassed = 0;
      $display("*** FAIL: Subtraction.");
      $display("Actual data memory output: %h", dataMemOut);
    end

    // SLT =====================================================================
    // If the value at $s is less than the value at $t, then the value at $d should
    // be 1. Otherwise, it is 0.
    // RTL:
    //    PC = PC + 4;
    //    if ($s < $t)
    //      $d = 1;
    //    else
    //      $d = 0;

    // Load our test data.
    writeToMem(32'hA1, 32'h2);
    writeToMem(32'hC2, 32'h3);

    writeInstructions (16, {
      { `CMD_lw, `R_ZERO, `R_S2, 16'hA1 },
      noop, noop, noop, noop,
      { `CMD_lw, `R_ZERO, `R_S3, 16'hC2 },
      noop, noop, noop, noop,
      { 6'b0, `R_S2, `R_S3, `R_S4, 5'b0, `CMD_slt },
      noop, noop, noop, noop,
      { `CMD_sw, `R_ZERO, `R_S4, 16'hD3 }
    });

    executeProgram(16);

    testToMemAddress = 32'hD3;
    clkOnce();
    if (dataMemOut !== 32'b1) begin
      dutPassed = 0;
      $display("*** FAIL: Set on less than (signed) -> 2 < 3");
      $display("Actual data memory output: %h", dataMemOut);
    end

    writeToMem(32'hA1, 32'h4);
    writeToMem(32'hC2, 32'h3);

    executeProgram(16);

    testToMemAddress = 32'hD3;
    clkOnce();
    if (dataMemOut !== 32'b0) begin
      dutPassed = 0;
      $display("*** FAIL: Set on less than (signed) -> 4 > 3");
      $display("Actual data memory output: %h", dataMemOut);
    end

    writeToMem(32'hA1, 32'hfffffffe);
    writeToMem(32'hC2, 32'hffffffff);

    executeProgram(16);

    testToMemAddress = 32'hD3;
    clkOnce();
    if (dataMemOut !== 32'b1) begin
      dutPassed = 0;
      $display("*** FAIL: Set on less than (signed) -> -2 < -1");
      $display("Actual data memory output: %h", dataMemOut);
    end

    $display(">>> TEST cpu ....... ", dutPassed);
    $finish;
  end

  // HELPER METHODS ============================================================

  reg [31:0] noop = { 6'b0, `R_ZERO, `R_ZERO, `R_ZERO, 5'b0, `CMD_add };

  task clkOnce;          begin #2;  end endtask
  task executeProgram;
    input [31:0] count;
    integer i;
    begin
      isTesting <= 0;
      for (i = 0; i < count + 4; i = i + 1) begin #2; end
      isTesting <= 1;
    end
  endtask

  task writeToMem;
    input [31:0] address;
    input [31:0] data;
    begin
      testToMemData <= data;
      testToMemAddress <= address;
      testToMemWriteEnable <= 1'b1;
      clkOnce();
      testToMemWriteEnable <= 1'b0;
    end
  endtask

  task writeInstructions;
    input [31:0] count;
    input [(32**3)-1:0] data;
    integer i;
    begin
      for (i = 0; i < count + 4; i = i + 1) begin
        writeToMem(4 * i, i < count ? data[(32*(count-i))-1 -: 32] : noop);
      end
    end
  endtask
endmodule
