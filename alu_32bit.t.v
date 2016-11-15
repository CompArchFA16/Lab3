// 32-bit ALU testbench

`include "multiplexers.v"
// `include "adder.v"
// `include "gates.v"
`include "alu.v"

module test_alu_32bit ();
    reg[31:0] operandA, operandB;
    reg[2:0] command;
    wire[31:0] result;
    wire carryout, zero, overflow;

    reg             dutpassed;


    ALU test(result, carryout, zero, overflow, operandA, operandB, command);

    initial begin
    // $dumpfile("alu_32bit.vcd");
    // $dumpvars;

    // Basic Gates (NAND, AND, NOR, OR, XOR)
    operandA= 32'haaaaaaaa; operandB = 32'hcccccccc; command = `NAND; #1000
    if(result != 32'h77777777) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 1 Failed: NAND implementation failed");
    end
    else begin
        $display("Test Case 1 Passed");
    end

    operandA= 32'haaaaaaaa; operandB = 32'hcccccccc; command = `AND; #1000
    if(result != 32'h88888888) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 2 Failed: AND implementation failed");
    end
    else begin
        $display("Test Case 2 Passed");
    end

    operandA= 32'haaaaaaaa; operandB = 32'hcccccccc; command = `NOR; #1000
    if(result != 32'h11111111) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 3 Failed: NOR implementation failed");
    end
    else begin
        $display("Test Case 3 Passed");
    end

    operandA= 32'haaaaaaaa; operandB = 32'hcccccccc; command = `OR; #1000
    if(result != 32'heeeeeeee) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 4 Failed: OR implementation failed");
    end
    else begin
        $display("Test Case 4 Passed");
    end

    operandA= 32'haaaaaaaa; operandB = 32'hcccccccc; command = `XOR; #1000
    if(result != 32'h66666666) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 5 Failed: XOR implementation failed");
    end
    else begin
        $display("Test Case 5 Passed");
    end

    // Addition (ADD)
    operandA= 32'h10000000; operandB = 32'h20000000; command = `ADD; #5000
    if((result != 32'h30000000) || (carryout != 1'b0) || (overflow != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 6 Failed: ADD 1 implementation failed");
    end

    operandA= 32'he0000000; operandB = 32'hc0000000; command = `ADD; #5000
    if((result != 32'ha0000000) || (carryout != 1'b1) || (overflow != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 6 Failed: ADD 2 implementation failed");
    end

    operandA= 32'h70000000; operandB = 32'h20000000; command = `ADD; #5000
    if((result != 32'h90000000) || (carryout != 1'b0) || (overflow != 1'b1)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 6 Failed: ADD 3 implementation failed");
    end

    operandA= 32'hf0000000; operandB = 32'h80000000; command = `ADD; #5000
    if((result != 32'h70000000) || (carryout != 1'b1) || (overflow != 1'b1)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 6 Failed: ADD 4 implementation failed");
    end    

    operandA= 32'h10000000; operandB = 32'hf0000000; command = `ADD; #5000
    if((result != 32'h00000000) || (carryout != 1'b1) || (overflow != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 6 Failed: ADD 5 implementation failed");
    end  
    else begin
        $display("Last of Test Case 6 Passed");
    end


    // Subtraction (SUB)

    operandA= 32'h10000000; operandB = 32'he0000000; command = `SUB; #5000
    if((result != 32'h30000000) || (carryout != 1'b0) || (overflow != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 7 Failed: SUB 1 implementation failed");
    end    

    operandA= 32'he0000000; operandB = 32'h40000000; command = `SUB; #5000
    if((result != 32'ha0000000) || (carryout != 1'b1) || (overflow != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 7 Failed: SUB 2 implementation failed");
    end    

    operandA= 32'h70000000; operandB = 32'he0000000; command = `SUB; #5000
    if((result != 32'h90000000) || (carryout != 1'b0) || (overflow != 1'b1)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 7 Failed: SUB 3 implementation failed");
    end    

    operandA= 32'hf0000000; operandB = 32'h80000000; command = `SUB; #5000
    if((result != 32'h70000000) || (carryout != 1'b1) || (overflow != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 7 Failed: SUB 4 implementation failed");
    end    

    operandA= 32'h70000000; operandB = 32'h50000000; command = `SUB; #5000
    if((result != 32'h20000000) || (carryout != 1'b1) || (overflow != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 7 Failed: SUB 5 implementation failed");
    end    

    operandA= 32'hffffffff; operandB = 32'hffffffff; command = `SUB; #5000
    if((result != 32'h00000000) || (carryout != 1'b1) || (overflow != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 7 Failed: SUB 6 implementation failed");
    end    
    else begin
        $display("Last of Test Case 7 Passed");
    end

    // Set if less than (SLT)
    operandA= 32'h80000000; operandB = 32'hffffffff; command = `SLT; #5000
    if((result != 32'h00000001) || (carryout != 1'b0) || (overflow != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 8 Failed: SLT 1 implementation failed");
    end    

    operandA= 32'hffffffff; operandB = 32'h80000000; command = `SLT; #5000
    if((result != 32'h00000000) || (carryout != 1'b1) || (overflow != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 8 Failed: SLT 2 implementation failed");
    end    

    operandA= 32'h01111111; operandB = 32'h0fffffff; command = `SLT; #5000
    if((result != 32'h00000001) || (carryout != 1'b0) || (overflow != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 8 Failed: SLT 3 implementation failed");
    end    

    operandA= 32'h0fffffff; operandB = 32'h01111111; command = `SLT; #5000
    if((result != 32'h00000000) || (carryout != 1'b1) || (overflow != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 8 Failed: SLT 4 implementation failed");
    end    

    operandA= 32'hf0000000; operandB = 32'h0fffffff; command = `SLT; #5000
    if((result != 32'h00000001) || (carryout != 1'b1) || (overflow != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 8 Failed: SLT 5 implementation failed");
    end    

    operandA= 32'h0fffffff; operandB = 32'hf0000000; command = `SLT; #5000
    if((result != 32'h00000000) || (carryout != 1'b0) || (overflow != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 8 Failed: SLT 6 implementation failed");
    end
    else begin
        $display("Last of Test Case 8 Passed");
    end

    // Zero flag
    operandA= 32'h1234abcd; operandB = 32'h1234abcd; command = `SUB; #5000
    if((result != 32'h00000000) || (zero != 1'b1)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 9 Failed: Zero 1 implementation failed");
    end

    operandA= 32'h1234abcd; operandB = 32'habcd1234; command = `SUB; #5000
    if((result != 32'h66679999) || (zero != 1'b0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 9 Failed: Zero 2 implementation failed");
    end
    else begin
        $display("Last of Test Case 9 Passed");
    end

    end
endmodule
