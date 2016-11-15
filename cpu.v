module cpu
(
	input clk;
);

// wires to and from pc
wire[31:0] MuxtoPc;		// wire going from mux to pc
wire[31:0] PctoIM;		// wire going from pc to Instruction memory

wire unused1, unused2, unused3, unused4; // unused outputs of the plus 4 alu
wire[31:0] PCplus4		// adds four to the program counter

// things leaving the Instruction Memory
wire[31:0] IMout;		// wire leaving Instruction memory
wire[4:0] WriteRegAddress;	// the wire from the mux to the write data address
wire[31:0] DataMuxtoReg;// output from data memory mux to regfile write data

wire[31:0] extended;	// wire from the sign extend
wire[31:0] muxtoalu;	// wire from mux that chooses input to alu

// stuff leaving regfile and non IM inputs to regfile
wire WrEn_Reg;			// regfile write enable							control signal
wire[31:0] ReadData1;	// data 1 from regfile
wire[31:0] ReadData2;	// data 2 from regfile

// jump stuff
wire[31:0] JumpData; // jump address

// initiate the program counter
register32 ProgramCounter(PctoIM, MuxtoPc, 1, clk);

// pc + 4
alu plus4(PCplus4, unused1, unused2, unused3, PctoIM, 0'b0100, 3'd0);

// PC input mux here
mux_3bit PC_input_mux(MuxtoPc, , , ,PCplus4);

// create instruction memory
instructionmemory InstructionMemory(IMout, PctoIM);

wire[1:0] WrAddressRegMux; // control signal for wr address reg mux 	control signal
// create three input mux for inputs to write address register
mux_3bit write_address_reg_mux(DataMuxtoReg, WrAddressRegMux,
							 IMout[20:16], IMout[15:11], 5'd31);

// do the regfile now
regfile RegisterFile(ReadData1, ReadData2, DataMuxtoReg, IMout[25:21],
						 IMout[20:16], WriteRegAddress, WrEn_Reg, clk);

// sign extend immediate 16
signextend signXtend(extended, IMout[15:0]);

// jump and jump register stuff
// jump shifter for jump command
jump_shifter JumpShift(JumpData, IMout[25:0], PCplus4[31:28]);
// jump/ jump register mux (2 input)

// mux to big alu
mux_1bit alu_mux(muxtoalu, alu_input, ReadData2, extended);

// wires involving the big alu
wire[31:0] AluOutput; // the output from the big alu
wire zero;			  // zero flag!
wire unused5, unused6, unused7;
wire[2:0] alu_com;

// the alu
ALU BigAlu(AluOutput, unused5, unused6, unused7, ReadData1, muxtoalu, alu_com);

// data memory
// wires for data memory
wire[31:0] DataMemOut;	// output from data memory
wire WrEn_DM;			// enables writing to data memory