module cpu
(
	input clk
);



// initiate the program counter
	wire[31:0] MuxtoPc;		// wire going from mux to pc
	wire[31:0] PctoIM;		// wire going from pc to Instruction memory

// pc + 4
	wire[31:0] PCplus4;		// adds four to the program counter
	wire unused1, unused2, unused3, unused4; // unused outputs of the plus 4 alu

// PC input mux here
	wire[31:0] branch_signal;
	wire[1:0] PcMuxCmd; // command signal to the pc input mux
	
// instruction memory
	wire[31:0] IMout;		// wire leaving Instruction memory
	wire[4:0] WriteRegAddress;	// the wire from the mux to the write data address
	wire[31:0] DataMuxtoReg;// output from data memory mux to regfile write data
	wire[1:0] WrAddressRegMux; // control signal for wr address reg mux 	control signal	

// regfile 
	wire WrEn_Reg;			// regfile write enable							control signal
	wire[31:0] ReadData1;	// data 1 from regfile
	wire[31:0] ReadData2;	// data 2 from regfile

// jump and jump register stuff
	wire[31:0] JumpData; // jump address
	wire[31:0] jump_signal; // signal from jump mux to pc mux;
	wire Jump_R; 			// command signal to choose jump or jump register
	wire[31:0] JalAluOut;
	wire unused8, unused9, unused10;

// sign extend immediate 16
	wire[31:0] extended;	// wire from the sign extend
	wire[31:0] muxtoalu;	// wire from mux that chooses input to alu
	wire[31:0] AluOutput; // the output from the big alu
	wire zero;			  // zero flag!
	wire unused5, unused6, unused7; // doesn't use a lot of signals
	wire[2:0] alu_com;		// command signal for big alu

// data memory
	wire[31:0] DataMemOut;	// output from data memory
	wire WrEn_DM;			// enables writing to data memory=

// mux after data memory
	wire[4:0] Reg_Wr_Addr_mux_out;	// address that we will write to after muxing in reg
	wire[1:0] RegDataSrcMux;	// control signal for mux after data memory
	
// need branching shifter and alu
	wire[31:0] shifted_imm;
	wire unused11, unused12, unused13;

	
	// DO THE AND GATE TOMORROW 
	wire nzero;
	wire branch_com;
	// do the lookup table for control signals
	register32 ProgramCounter(PctoIM, MuxtoPc, 1, clk); // the program counter

	ALU plus4(PCplus4, unused1, unused2, unused3, PctoIM, 4'b0100, 3'd0);

	mux_3_input_32 PC_input_mux(MuxtoPc, PcMuxCmd, jump_signal, branch_signal, PCplus4);

	instructionmemory InstructionMemory(IMout, PctoIM);

	mux_3_input_5 write_address_reg_mux(Reg_Wr_Addr_mux_out, WrAddressRegMux, IMout[20:16], IMout[15:11], 5'd31);

	regfile RegisterFile(ReadData1, ReadData2, DataMuxtoReg, IMout[25:21], IMout[20:16], WriteRegAddress, WrEn_Reg, clk);

	jump_shifter JumpShift(JumpData, IMout[25:0], PCplus4[31:28]);

	mux_2_input_32 jumpMux(jump_signal, Jump_R, ReadData1, JumpData);

	ALU JalAlu(JalAluOut, unused8, unused9, unused10, PCplus4, 4'b0100, 3'd0);

	signextend signXtend(extended, IMout[15:0]);

	mux_2_input_32 alu_mux(muxtoalu, alu_input, ReadData2, extended);

	ALU BigAlu(AluOutput, unused5, zero, unused7, ReadData1, muxtoalu, alu_com);

	datamemory Data_Memory(clk, WrEn_DM, AluOutput, ReadData2, DataMemOut); // address size probelms!

	mux_3_input_32 DM_mux(DataMuxtoReg, RegDataSrcMux, AluOutput, DataMemOut, JalAluOut);

	ALU branchAlu(branch_signal, unused11, unused12, unused13, shifted_imm, PCplus4, 3'd0);

	not invert_zero(nzero, zero);
	and branchand(PcMuxCmd[0], nzero, branch_com);

	LUTcaller LUT(WrEn_Reg, WrEn_DM, WrAddressRegMux, alu_input, alu_com, RegDataSrcMux, Jump_R, PcMuxCmd[1], branch_com, IMout[31:26], IMout[5:0]);
endmodule
	