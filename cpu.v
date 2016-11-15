module cpu
(
	input clk;
);



// initiate the program counter
	wire[31:0] MuxtoPc;		// wire going from mux to pc
	wire[31:0] PctoIM;		// wire going from pc to Instruction memory

	register32 ProgramCounter(PctoIM, MuxtoPc, 1, clk); // the program counter

// pc + 4
	wire[31:0] PCplus4		// adds four to the program counter
	wire unused1, unused2, unused3, unused4; // unused outputs of the plus 4 alu
	alu plus4(PCplus4, unused1, unused2, unused3, PctoIM, 0'b0100, 3'd0);

// PC input mux here
	wire[1:0] PcMuxCmd; // command signal to the pc input mux
	mux_3bit PC_input_mux(MuxtoPc, PcMuxCmd, jump_signal, branch_signal, PCplus4);

// instruction memory
	// things leaving the Instruction Memory
	wire[31:0] IMout;		// wire leaving Instruction memory
	wire[4:0] WriteRegAddress;	// the wire from the mux to the write data address
	wire[31:0] DataMuxtoReg;// output from data memory mux to regfile write data

	instructionmemory InstructionMemory(IMout, PctoIM);

	wire[1:0] WrAddressRegMux; // control signal for wr address reg mux 	control signal

// create three input mux for inputs to write address register
	mux_3bit write_address_reg_mux(DataMuxtoReg, WrAddressRegMux,
							 IMout[20:16], IMout[15:11], 5'd31);

// regfile 
	// stuff leaving regfile and non IM inputs to regfile
	wire WrEn_Reg;			// regfile write enable							control signal
	wire[31:0] ReadData1;	// data 1 from regfile
	wire[31:0] ReadData2;	// data 2 from regfile
	regfile RegisterFile(ReadData1, ReadData2, DataMuxtoReg, IMout[25:21],
							 IMout[20:16], WriteRegAddress, WrEn_Reg, clk);

// jump and jump register stuff
	// jump shifter for jump command
	wire[31:0] JumpData; // jump address
	jump_shifter JumpShift(JumpData, IMout[25:0], PCplus4[31:28]);

	// jump/ jump register mux (2 input)
	wire[31:0] jump_signal; // signal from jump mux to pc mux;
	wire Jump_R; 			// command signal to choose jump or jump register
	mux_1bit jumpMux(jump_signal, Jump_R, ReadData1, JumpData)

	// need jump and link alu
	wire[31:0] JalAluOut;
	wire unused8, unused9, unused10;
	alu JalAlu(JalAluOut, unused8, unused9, unused10, PCplus4, 0'b0100, 3'd0);


// sign extend immediate 16
	wire[31:0] extended;	// wire from the sign extend
	signextend signXtend(extended, IMout[15:0]);
// the alu

	// mux to big alu
	wire[31:0] muxtoalu;	// wire from mux that chooses input to alu
	mux_1bit alu_mux(muxtoalu, alu_input, ReadData2, extended);

	// wires involving the big alu
	wire[31:0] AluOutput; // the output from the big alu
	wire zero;			  // zero flag!
	wire unused5, unused6, unused7; // doesn't use a lot of signals
	wire[2:0] alu_com;		// command signal for big alu

	// ALU INSTANTIATED
	ALU BigAlu(AluOutput, unused5, zero, unused7, ReadData1, muxtoalu, alu_com);

// data memory
	// wires for data memory
	wire[31:0] DataMemOut;	// output from data memory
	wire WrEn_DM;			// enables writing to data memory

	// doing the data memory
	datamemory Data_Memory(clk, WrEn_DM, AluOutput, ReadData2, DataMemOut); // address size probelms!

//mux after data memory
	wire[31:0] DataMuxtoReg;
	wire[31:0] RegDataSrcMux;	// control signal for mux after data memory
	mux_3bit DM_mux(DataMuxtoReg, RegDataSrcMux, AluOutput, DataMemOut, JalAluOut);

// need branching shifter and alu
	wire[31:0] shifted_imm;
	wire[31:0] branch_signal;
	wire unused11, unused12, unused13;

	alu JalAlu(branch_signal, unused11, unused12, unused13, shifted_imm, PCplus4, 3'd0);
	// DO THE AND GATE TOMORROW
endmodule