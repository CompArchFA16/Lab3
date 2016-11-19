`timescale 1 ns / 1 ps
`include "alu.v"

`define ADD  3'd0
`define SUB  3'd1
`define NAND 3'd2
`define AND  3'd3
`define NOR  3'd4
`define OR   3'd5
`define XOR  3'd6
`define SLT  3'd7

module testALU();
    
    reg signed [31:0] A;
    reg signed [31:0] B;
    reg[2:0] command;

    wire signed [31:0] result;
    wire zero, overflow;

    ALU alu(result, zero, overflow, A, B, command);

    initial begin
        // $dumpfile("alu_all.vcd");
        // $dumpvars();  
        $display("A            B            cmd | result       ov z ");
        A=-32'd2147483000;B=32'd483001;command=`ADD; #100000;
        $display("%-11d  %-11d  ADD | %-11d  %b  %b", A, B, result, overflow, zero);
        A=32'd2147483000;B=32'd483001;command=`ADD; #100000;
        $display("%-11d  %-11d  ADD | %-11d  %b  %b", A, B, result, overflow, zero);
        A=32'd214748300;B=32'd48301;command=`ADD; #100000;
        $display("%-11d  %-11d  ADD | %-11d  %b  %b", A, B, result, overflow, zero);
        A=32'd2147483000;B=32'd483001;command=`SUB; #100000;
        $display("%-11d  %-11d  SUB | %-11d  %b  %b", A, B, result, overflow, zero);
        A=-32'd2147483000;B=32'd483001;command=`SUB; #100000;
        $display("%-11d  %-11d  SUB | %-11d  %b  %b", A, B, result, overflow, zero);
        A=-32'd214748300;B=32'd48301;command=`SUB; #100000;
        $display("%-11d  %-11d  SUB | %-11d  %b  %b", A, B, result, overflow, zero);

        $display();
        $display("A                                 B                                 cmd  | result                            ov z");
        A=32'b10101010101010101111000011110000;B=32'b01010101010101010000111111110000;command=`AND; #100000;
        $display("%b  %b  AND  | %b  %b  %b", A, B, result, overflow, zero);
        command=`NAND; #100000;
        $display("%b  %b  NAND | %b  %b  %b", A, B, result, overflow, zero);
        command=`OR; #100000;
        $display("%b  %b  OR   | %b  %b  %b", A, B, result, overflow, zero);
        command=`NOR; #100000;
        $display("%b  %b  NOR  | %b  %b  %b", A, B, result, overflow, zero);
        command=`XOR; #100000;
        $display("%b  %b  XOR  | %b  %b  %b", A, B, result, overflow, zero);

        $display();
        $display("A            B            cmd | result ov z ");
        A=-32'd2147483000;B=32'd483001;command=`SLT; #100000;
        $display("%-11d  %-11d  SLT | %0d      %b  %b", A, B, result, overflow, zero);
        A=32'd2147483000; B=-32'd483001;#100000;
        $display("%-11d  %-11d  SLT | %0d      %b  %b", A, B, result, overflow, zero);
        A=32'd2147483000;B=32'd483001;command=`SLT; #100000;
        $display("%-11d  %-11d  SLT | %0d      %b  %b", A, B, result, overflow, zero);
        A=-32'd2147483000;B=-32'd483001;command=`SLT; #100000;
        $display("%-11d  %-11d  SLT | %0d      %b  %b", A, B, result, overflow, zero);
        A=-32'd2147483000;B=32'd422283001;command=`SLT; #100000;
        $display("%-11d  %-11d  SLT | %0d      %b  %b", A, B, result, overflow, zero);

        // $dumpflush;
    end

endmodule

