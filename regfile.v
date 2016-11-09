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
input[31:0]	WriteData, // contents to write to register
input[4:0]	ReadRegister1,	// Address of first register to read
input[4:0]	ReadRegister2,	// Address of second register to read
input[4:0]	WriteRegister,	// Address of register to write
input		RegWrite,	// Enable writing of register when High
input		Clk		// Clock (Positive Edge Triggered)
);

    //decoder input
    wire [31:0] decout;

  //instantiate regfile32
  wire [31:0] reg0 ;
  wire [31:0] reg1 ;
  wire [31:0] reg2 ;
  wire [31:0] reg3;
  wire [31:0] reg4;
  wire [31:0] reg5;
  wire [31:0] reg6;
  wire [31:0] reg7;
  wire [31:0] reg8;
  wire [31:0] reg9;
  wire [31:0] reg10;
  wire [31:0] reg11;
  wire [31:0] reg12;
  wire [31:0] reg13;
  wire [31:0] reg14;
  wire [31:0] reg15;
  wire [31:0] reg16;
  wire [31:0] reg17;
  wire [31:0] reg18;
  wire [31:0] reg19;
  wire [31:0] reg20;
  wire [31:0] reg21;
  wire [31:0] reg22;
  wire [31:0] reg23;
  wire [31:0] reg24;
  wire [31:0] reg25;
  wire [31:0] reg26;
  wire [31:0] reg27;
  wire [31:0] reg28;
  wire [31:0] reg29;
  wire [31:0] reg30;
  wire [31:0] reg31;

  decoder1to32 decoder(decout, RegWrite, WriteRegister); //out, enable, address

  register32zero zeroreg(reg0, WriteData, decout[0], Clk); //zero register takes sets output to zero always.
  register32 onereg (reg1, WriteData, decout[1], Clk);
  register32 tworeg (reg2, WriteData, decout[2], Clk);
  register32 threereg (reg3, WriteData, decout[3], Clk);
  register32 fourreg (reg4, WriteData, decout[4], Clk);
  register32 fivereg (reg5, WriteData, decout[5], Clk);
  register32 sixreg (reg6, WriteData, decout[6], Clk);
  register32 sevenreg (reg7, WriteData, decout[7], Clk);
  register32 eightreg (reg8, WriteData, decout[8], Clk);
  register32 ninereg (reg9, WriteData, decout[9], Clk);
  register32 tenreg (reg10, WriteData, decout[10], Clk);
  register32 elevenreg (reg11, WriteData, decout[11], Clk);
  register32 twelvereg (reg12, WriteData, decout[12], Clk);
  register32 thirteenreg (reg13, WriteData, decout[13], Clk);
  register32 fourteenreg (reg14, WriteData, decout[14], Clk);
  register32 fifteenreg (reg15, WriteData, decout[15], Clk);
  register32 sixteenreg (reg16, WriteData, decout[16], Clk);
  register32 seventeenreg (reg17, WriteData, decout[17], Clk);
  register32 eighteenreg (reg18, WriteData, decout[18], Clk);
  register32 nineteenreg (reg19, WriteData, decout[19], Clk);
  register32 twentyreg (reg20, WriteData, decout[20], Clk);
  register32 twentyonereg (reg21, WriteData, decout[21], Clk);
  register32 twentytwoereg (reg22, WriteData, decout[22], Clk);
  register32 twentythreereg (reg23, WriteData, decout[23], Clk);
  register32 twentyfourreg (reg24, WriteData, decout[24], Clk);
  register32 twentyfivereg (reg25, WriteData, decout[25], Clk);
  register32 twentysixreg (reg26, WriteData, decout[26], Clk);
  register32 twentysevenreg (reg27, WriteData, decout[27], Clk);
  register32 twentyeightreg (reg28, WriteData, decout[28], Clk);
  register32 twentyninereg (reg29, WriteData, decout[29], Clk);
  register32 thirtyreg (reg30, WriteData, decout[30], Clk);
  register32 thirtyonereg (reg31, WriteData, decout[31], Clk);

  //to read from register on read data 1
  // calling Multiplexer, then setting output, address, and inputs
  mux32to1by32 mux1(ReadData1, ReadRegister1, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31);   //pick which register to read

  //to read from register on read data 2
  // calling Multiplexer, then setting output, address, and inputs
  mux32to1by32 mux2(ReadData2, ReadRegister2, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31); //pick which register to read
endmodule


module mux32to1by1
(
output      out,
input[4:0]  address,
input[31:0] inputs
);
  assign out = inputs[address];
endmodule

/*Create a multiplexer that is 32 bits wide and 32 inputs deep. There are many syntaxes available to do so, and each of them have their own little bit of excitement. The version below has more typing involved than other options, but it will allow better flexibility later. Match the following module port definition:*/

module mux32to1by32
(
output[31:0]    out,
input[4:0]      address,
input[31:0]     input0,
input[31:0]     input1,
input[31:0]     input2,
input[31:0]     input3,
input[31:0]     input4,
input[31:0]     input5,
input[31:0]     input6,
input[31:0]     input7,
input[31:0]     input8,
input[31:0]     input9,
input[31:0]     input10,
input[31:0]     input11,
input[31:0]     input12,
input[31:0]     input13,
input[31:0]     input14,
input[31:0]     input15,
input[31:0]     input16,
input[31:0]     input17,
input[31:0]     input18,
input[31:0]     input19,
input[31:0]     input20,
input[31:0]     input21,
input[31:0]     input22,
input[31:0]     input23,
input[31:0]     input24,
input[31:0]     input25,
input[31:0]     input26,
input[31:0]     input27,
input[31:0]     input28,
input[31:0]     input29,
input[31:0]     input30,
input[31:0]     input31
);

  wire[31:0] mux[31:0];         // Create a 2D array of wires
  assign mux[0] = input0;       // Connect the sources of the array
  assign mux[1] = input1;
  assign mux[2] = input2;
  assign mux[3] = input3;
  assign mux[4] = input4;
  assign mux[5] = input5;
  assign mux[6] = input6;
  assign mux[7] = input7;
  assign mux[8] = input8;
  assign mux[9] = input9;
  assign mux[10] = input10;
  assign mux[11] = input11;
  assign mux[12] = input12;
  assign mux[13] = input13;
  assign mux[14] = input14;
  assign mux[15] = input15;
  assign mux[16] = input16;
  assign mux[17] = input17;
  assign mux[18] = input18;
  assign mux[19] = input19;
 assign mux[20] = input20;
 assign mux[21] = input21;
 assign mux[22] = input22;
 assign mux[23] = input23;
 assign mux[24] = input24;
 assign mux[25] = input25;
 assign mux[26] = input26;
 assign mux[27] = input27;
 assign mux[28] = input28;
 assign mux[29] = input29;
 assign mux[30] = input30;
 assign mux[31] = input31;

  assign out = mux[address];    // Connect the output of the array
endmodule


// 32 bit decoder with enable signal
//   enable=0: all output bits are 0
//   enable=1: out[address] is 1, all other outputs are 0
module decoder1to32
(
output[31:0]	out,
input		enable,
input[4:0]	address
);

    assign out = enable<<address;

endmodule

/* This decoder (1 to 32, with a 5 bit address), has the output assigned
according to a bit shifter. The enable has the data to be shifted to the left,
and the address contains the number of single bit shift operations to be
performed. Therefore the output has the enable shifted by the amount specified
in the address. This allows the output only be in powers of two, like:
00000000000000000000000000000100 (address 3), 00000000000000000000000010000000
(address 8) etc. but it selects only one register file at a time.
*/

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

module register32
(
    output reg [31:0] q,
    input      [31:0] d,
    input       wrenable,
    input       clk
    );

    genvar i;

    generate
        for(i=0; i<32; i=i+1)
        begin: Allbits
            always @(posedge clk) begin
                if (wrenable) begin
                    q[i] = d[i];
                end
            end
        end
    endgenerate
endmodule

module register32zero
(
output reg	[31:0] q,
input		[31:0] d,
input		wrenable,
input		clk
);

    always @(posedge clk) begin
        if(wrenable) begin
             q = 32'd0;
        end
    end

endmodule
