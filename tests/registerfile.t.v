// Register File testbench
`include "submodules/registerfile.v"

module testRegisterFile();

  reg[31:0]  ReadData1;  // Data from first register read
  reg[31:0]  ReadData2;  // Data from second register read
  reg[31:0]  WriteData;  // Data to write to register
  reg[4:0] ReadRegister1;  // Address of first register to read
  reg[4:0] ReadRegister2;  // Address of second register to read
  reg[4:0] WriteRegister;  // Address of register to write
  reg    RegWrite; // Enable writing of register when High
  reg    Clk;    // Clock (Positive Edge Triggered)
  reg    dutpassed;  // Indicates whether register file passed tests

  // Initialize register driver signals
  reg write_broken, decoder_broken, register_not_zero, always_reads_reg_17;
  initial begin
    WriteData=32'd0;
    ReadRegister1=5'd0;
    ReadRegister2=5'd0;
    WriteRegister=5'd0;
    RegWrite=0;
    Clk=0;

    write_broken=0;
    decoder_broken=0;
    register_not_zero=0;
    always_reads_reg_17=0;
    dutpassed = 1;


    // Once 'begintest' is asserted, start running test cases

    // Test Case 1:
    //   Write '42' to register 2, verify with Read Ports 1 and 2
    //   (Passes because example register file is hardwired to return 42)
    WriteRegister = 5'd2;
    WriteData = 32'd42;
    RegWrite = 1;
    ReadRegister1 = 5'd2;
    ReadRegister2 = 5'd2;
    #5 Clk=1; #5 Clk=0; // Generate single clock pulse

    // Verify expectations and report test result
    if((ReadData1 != 42) || (ReadData2 != 42)) begin
      dutpassed = 0;  // Set to 'false' on failure
    end

    // Test Case 2:
    //   Write '15' to register 2, verify with Read Ports 1 and 2
    //   (Fails with example register file, but should pass with yours)
    WriteRegister = 5'd2;
    WriteData = 32'd15;
    RegWrite = 1;
    ReadRegister1 = 5'd2;
    ReadRegister2 = 5'd2;
    #5 Clk=1; #5 Clk=0;

    if((ReadData1 != 15) || (ReadData2 != 15)) begin
      dutpassed = 0;
    end


    // Test Case 3:
    //   Write '15' to register 2, switch write enabled false,
    //   write '30' to register 2, verify that '30' was NOT written.
    //   DELIVERABLE 8 CASE 2: Tests if write enable is ignored.
    WriteRegister = 5'd2;
    WriteData = 32'd15;
    RegWrite = 1;
    ReadRegister1 = 5'd2;
    ReadRegister2 = 5'd2;
    #5 Clk=1; #5 Clk=0;
    RegWrite = 0;
    WriteRegister = 5'd2;
    WriteData = 32'd30;
    #5 Clk=1; #5 Clk=0;

    if((ReadData1 != 15) || (ReadData2 != 15)) begin
      dutpassed = 0;
      write_broken = 1;
    end

    // Test Case 4:
    //   Write '15' to register 16, write '15' to register 31,
    //   write '31' to register 16,
    //   verify that reg 16 was written to and reg 31 has not changed
    //   DELIVERABLE 8 CASE 3: Decoder broken. Multiple registers written to.
    RegWrite = 1;
    ReadRegister1 = 5'd16;
    ReadRegister2 = 5'd28;
    WriteRegister = 5'd16; WriteData = 32'd15;
    #5 Clk=1; #5 Clk=0;
    WriteRegister = 5'd31; WriteData = 32'd15;
    #5 Clk=1; #5 Clk=0;
    WriteRegister = 5'd16; WriteData = 32'd31;
    #5 Clk=1; #5 Clk=0;

    if((ReadData1 != 31) || (ReadData2 != 15)) begin
      dutpassed = 0;
      decoder_broken = 1;
    end

    // Test Case 5:
    //   Attempt to write '15' to register 0
    //   DELIVERABLE 8 CASE 4: Register 0 does not hold constant of zero.
    RegWrite = 1;
    ReadRegister1 = 5'd0;
    ReadRegister2 = 5'd0;
    WriteRegister = 5'd0; WriteData = 32'd15;
    #5 Clk=1; #5 Clk=0;

    if((ReadData1 != 0) || (ReadData2 != 0)) begin
      dutpassed = 0;
      register_not_zero = 1;
    end

    // Test Case 6:
    //
    //   DELIVERABLE 8 CASE 5: Port 2 always reads register 17.
    RegWrite = 1;
    ReadRegister1 = 5'd5;
    ReadRegister2 = 5'd5;
    WriteRegister = 5'd5; WriteData = 32'd15;
    #5 Clk=1; #5 Clk=0;
    WriteRegister = 5'd17; WriteData = 32'd31;
    #5 Clk=1; #5 Clk=0;

    if((ReadData2 == 31)) begin
      dutpassed = 0;
      always_reads_reg_17 = 1;
    end

    // Report classifications
    if(!(write_broken || decoder_broken || register_not_zero || always_reads_reg_17)) begin
      $display("RGF: PASSED");
    end
    if(write_broken) begin
      $display("RGF: FAILED WRITE ENABLE BROKEN");
    end
    if(decoder_broken) begin
      $display("RGF: FAILED DECODER BROKEN");
    end
    if(register_not_zero) begin
      $display("RGF: FAILED ZERO REG WRITES");
    end
    if(always_reads_reg_17) begin
      $display("RGF: FAILED PORT 2 BROKEN");
    end
  end
endmodule