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

  // Start the clock.
  initial clk = 0;
  always #1 clk = !clk;

  initial begin

    $dumpfile("cpu.vcd");
    $dumpvars(3);
    dutPassed = 1;

    // Offset our test to be on the negedge. This way, our changes are picked up
    // by the next posedge of the clk.
    #1;

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
      { `CMD_lw,  `R_ZERO, `R_S1,   16'hAB },
      { `CMD_add, `R_ZERO, `R_ZERO, 16'b0  },
      { `CMD_add, `R_ZERO, `R_ZERO, 16'b0  },
      { `CMD_add, `R_ZERO, `R_ZERO, 16'b0  },
      { `CMD_add, `R_ZERO, `R_ZERO, 16'b0  },
      { `CMD_sw,  `R_ZERO, `R_S1,   16'hAC }
    });

    waitTillComplete(6);

    isTesting = 1;
    testToMemAddress = 32'hAC;
    clkOnce();
    if (dataMemOut !== 32'h42) begin
      dutPassed = 0;
      $display("Store after a load failed.");
      $display("Actual data memory output: %h", dataMemOut);
    end
    isTesting = 0;

    // J =======================================================================
    // Jumps to the calculated address.
    // RTL:
    //   PC = (PC & 0xf0000000) | (target << 2);

    // jumpTarget = 26'd203;
    // instruction = { `CMD_j, jumpTarget };
    // waitTillComplete();

    // if (pc !== {4'b0, 26'd203, 2'b0}) begin
    //   dutPassed = 0;
    // end

    // JR ======================================================================
    // Jump to the address contained in register $s.
    // RTL:
    //   PC = $s;

    // instruction = { `CMD_jr, rS, 21'b0 };
    // waitTillComplete();

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
    // waitTillComplete();

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
    // writeToMem({ `CMD_bne, rS, rT, imm });
    // waitTillComplete();

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
    // waitTillComplete();

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
    // waitTillComplete();

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
    // waitTillComplete();

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
    // waitTillComplete();

    // if (rD !== expected_rD) begin
      // dutPassed = 0;
    // end

    $display(">>> TEST cpu ....... ", dutPassed);
    $finish;
  end

  // HELPER METHODS ============================================================

  task clkOnce;          begin #2;  end endtask
  task waitTillComplete;
    input [31:0] count;
    integer i;
    begin
      for (i = 0; i < count + 4; i = i + 1) begin #2; end
    end
  endtask

  task writeToMem;
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

  task writeInstructions;
    input [31:0] count;
    input [(32*32)-1:0] data;
    integer i;
    reg [31:0] instruction;
    begin
      resetPC = 1;
      writeToMem(0, { `CMD_add, `R_ZERO, `R_ZERO, 16'b0 }); // To offset our resetPC.
      for (i = 0; i < count + 4; i = i + 1) begin
        instruction = data[(32*(count-i))-1 -: 32];
        if (i < count) begin
          writeToMem(4 * (i + 1), instruction);
        end else begin
          writeToMem(4 * (i + 1), instruction); // To padd out with no-ops.
        end
      end
      resetPC = 0;
    end
  endtask
endmodule
