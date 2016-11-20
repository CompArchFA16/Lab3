//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------

module regfile
(
output[31:0]	ReadData1,	// Contents of first register read
output[31:0]	ReadData2,	// Contents of second register read
input[31:0]	WriteData,	// Contents to write to register
input[4:0]	ReadRegister1,	// Address of first register to read
input[4:0]	ReadRegister2,	// Address of second register to read
input[4:0]	WriteRegister,	// Address of register to write
input		RegWrite,	// Enable writing of register when High
input		Clk		// Clock (Positive Edge Triggered)
);

    reg[31:0] RegOut[31:0];
    initial RegOut[0] = 32'b0;

    always @(posedge Clk) begin
        if(RegWrite) begin
            RegOut[WriteRegister] = WriteData;
        end
    end

    assign ReadData1 = RegOut[ReadRegister1];
    assign ReadData2 = RegOut[ReadRegister2];
endmodule

// Single-bit D Flip-Flop with enable
//   Positive edge triggered
module register
(
output reg	q,
input		d,
input		wrenable,
input		clk
);

    always @(posedge clk) begin
        if(wrenable) begin
            q = d;
        end
    end
endmodule

// 32-bit D Flip-Flop with enable
//   Positive edge triggered
module register32
(
output reg[31:0]	q,
input[31:0]   		d,
input wrenable,
input	clk
);

    always @(posedge clk) begin
        if(wrenable) begin
            q = d;
        end
    end

endmodule

// 32-bit D Flip-Flop that always outputs zero
module register32zero
(
output reg[31:0] q,
input[31:0]   		d,
input wrenable,
input	clk
);

    initial q = 0;
endmodule

// 32-bit D Flip-Flop with enable
//   Positive edge triggered
module register32_negedge
//negedge same thing for pc to go on offset clk edge
(
output reg[31:0]  q,
input[31:0]       d,
input wrenable,
input clk,
input start
);
  always @(negedge clk) begin
      if(wrenable) begin
          q = d;
      end
  end

  always @(posedge start) begin
    q = 0;
  end
endmodule
