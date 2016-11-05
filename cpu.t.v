// TODO: Move these tests into the main file after we consolidate.
// Resources:
// - MIPS instructions: http://www.mrc.uidaho.edu/mrc/people/jff/digital/MIPSir.html

`include "cpu.v"

module testDavidsStuff ();

  reg clk;

  // DUT.
  CPU dut ();

  // Start the clock.
  initial clk = 1;
  always #1 clk = !clk;

  reg dutPassed;

  initial begin

    $dumpfile("cpu.vcd");
    $dumpvars;
    dutPassed = 1;

    // LW ======================================================================

    // SW ======================================================================

    // J =======================================================================
    // Jumps to the calculated address.
    // RTL:
    //   PC = nPC;
    //   nPC = (PC & 0xf0000000) | (target << 2);

    // JR ======================================================================
    // Jump to the address contained in register $s.
    // RTL:
    //   PC = nPC;
    //   nPC = $s;

    // JAL =====================================================================
    // Jumps to the calculated address and stores the return address in $31.
    // RTL:
    //   $31 = PC + 8 (or nPC + 4);
    //   PC = nPC;
    //   nPC = (PC & 0xf0000000) | (target << 2);

    // BNE =====================================================================

    // XORI ====================================================================

    // ADD =====================================================================

    // SUB =====================================================================
    // Subtracts two registers and stores the result in a register.
    // RTL:
    //   $d = $s - $t;
    //   PC = nPC;
    //   nPC = nPC + 4;

    // SLT =====================================================================

    $finish;
  end
endmodule
