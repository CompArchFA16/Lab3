`timescale 1 ns / 1 ps
`include "alu.v"

`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7

module testALU();
    
    reg signed [31:0] operandA;
    reg signed [31:0] operandB;
    reg[2:0] command;

    wire signed [31:0] result;
    wire carryout, zero, overflow;

    ALU alu0(result, carryout, zero, overflow, operandA, operandB, command);

    initial begin
        // $dumpfile("alu_all.vcd");
        // $dumpvars();  
        $display("operandA     operandB     cmd | result       co ov z ");
        operandA=-32'd2147483000;operandB=32'd483001;command=`ADD; #100000;
        $display("%-11d  %-11d  ADD | %-11d  %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);
        operandA=32'd2147483000;operandB=32'd483001;command=`ADD; #100000;
        $display("%-11d  %-11d  ADD | %-11d  %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);
        operandA=32'd214748300;operandB=32'd48301;command=`ADD; #100000;
        $display("%-11d  %-11d  ADD | %-11d  %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);
        operandA=32'd2147483000;operandB=32'd483001;command=`SUB; #100000;
        $display("%-11d  %-11d  SUB | %-11d  %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);
        operandA=-32'd2147483000;operandB=32'd483001;command=`SUB; #100000;
        $display("%-11d  %-11d  SUB | %-11d  %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);
        operandA=-32'd214748300;operandB=32'd48301;command=`SUB; #100000;
        $display("%-11d  %-11d  SUB | %-11d  %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);

        $display();
        $display("operandA                          operandB                          cmd  | result                            co ov z");
        operandA=32'b10101010101010101111000011110000;operandB=32'b01010101010101010000111111110000;command=`AND; #100000;
        $display("%b  %b  AND  | %b  %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);
        command=`NAND; #100000;
        $display("%b  %b  NAND | %b  %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);
        command=`OR; #100000;
        $display("%b  %b  OR   | %b  %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);
        command=`NOR; #100000;
        $display("%b  %b  NOR  | %b  %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);
        command=`XOR; #100000;
        $display("%b  %b  XOR  | %b  %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);

        $display();
        $display("operandA     operandB     cmd | result co ov z ");
        operandA=-32'd2147483000;operandB=32'd483001;command=`SLT; #100000;
        $display("%-11d  %-11d  SLT | %0d      %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);
        operandA=32'd2147483000; operandB=-32'd483001;#100000;
        $display("%-11d  %-11d  SLT | %0d      %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);
        operandA=32'd2147483000;operandB=32'd483001;command=`SLT; #100000;
        $display("%-11d  %-11d  SLT | %0d      %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);
        operandA=-32'd2147483000;operandB=-32'd483001;command=`SLT; #100000;
        $display("%-11d  %-11d  SLT | %0d      %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);
        operandA=-32'd2147483000;operandB=32'd422283001;command=`SLT; #100000;
        $display("%-11d  %-11d  SLT | %0d      %b  %b  %b", operandA, operandB, result, carryout, overflow, zero);

        // $dumpflush;
    end

endmodule

