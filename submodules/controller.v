`define OP_LW   6'b100011
`define OP_SW   6'b101011
`define OP_J    6'b000010
`define OP_JR   6'b001000
`define OP_JAL  6'b000011
`define OP_BNE  6'b000101
`define OP_XORI 6'b001110
`define OP_ADD  6'b100000
`define OP_SUB  6'b100010
`define OP_SLT  6'b101010

`define Q_PROC  1'b0
`define Q_STALL 1'b1

module controller
(
output reg reg_write,
output reg mem_to_reg,
output reg mem_write,
output reg branch,
output reg [2:0] alu_control,
output reg alu_src,
output reg reg_dst,
output reg pc_write,
output reg pc_jump,
output reg pc_reg,
output reg link,
output
input      clk,
input[5:0] op,
input[5:0] funct
);
  reg [1:0] counter = 0;
  reg       state = `Q_PROC
  reg       begin_stall = 0;

  always @(posedge clk) begin

    if (state == `Q_PROC)
      begin
        // SET CONTROL SIGNALS
        case (op)
          `OP_LW:   begin reg_write = 1; mem_to_reg = 1; mem_write = 0; branch = 0; alu_control = 3'b000; alu_src = 0; reg_dst = 0; pc_write = 1; pc_jump = 0; pc_reg = 0; link = 0; begin_stall = 1; end
          `OP_SW:   begin reg_write = 0; mem_to_reg = 0; mem_write = 1; branch = 0; alu_control = 3'b000; alu_src = 0; reg_dst = 0; pc_write = 1; pc_jump = 0; pc_reg = 0; link = 0; begin_stall = 0; end
          `OP_J:    begin reg_write = 0; mem_to_reg = 0; mem_write = 0; branch = 0; alu_control = 3'b000; alu_src = 0; reg_dst = 0; pc_write = 1; pc_jump = 1; pc_reg = 0; link = 0; begin_stall = 0; end
          `OP_JR:   begin reg_write = 0; mem_to_reg = 0; mem_write = 0; branch = 0; alu_control = 3'b000; alu_src = 0; reg_dst = 0; pc_write = 1; pc_jump = 0; pc_reg = 1; link = 0; begin_stall = 0; end
          `OP_JAL:  begin reg_write = 1; mem_to_reg = 0; mem_write = 0; branch = 0; alu_control = 3'b000; alu_src = 0; reg_dst = 0; pc_write = 1; pc_jump = 1; pc_reg = 0; link = 1; begin_stall = 1; end
          `OP_BNE:  begin reg_write = 0; mem_to_reg = 0; mem_write = 0; branch = 1; alu_control = 3'b001; alu_src = 1; reg_dst = 0; pc_write = 1; pc_jump = 0; pc_reg = 0; link = 0; begin_stall = 1; end
          `OP_XORI: begin reg_write = 1; mem_to_reg = 0; mem_write = 0; branch = 0; alu_control = 3'b010; alu_src = 1; reg_dst = 0; pc_write = 1; pc_jump = 0; pc_reg = 0; link = 0; begin_stall = 1; end
          `OP_ADD:  begin reg_write = 1; mem_to_reg = 0; mem_write = 0; branch = 0; alu_control = 3'b000; alu_src = 0; reg_dst = 1; pc_write = 1; pc_jump = 0; pc_reg = 0; link = 0; begin_stall = 1; end
          `OP_SUB:  begin reg_write = 1; mem_to_reg = 0; mem_write = 0; branch = 0; alu_control = 3'b001; alu_src = 0; reg_dst = 1; pc_write = 1; pc_jump = 0; pc_reg = 0; link = 0; begin_stall = 1; end
          `OP_SLT:  begin reg_write = 1; mem_to_reg = 0; mem_write = 0; branch = 0; alu_control = 3'b011; alu_src = 0; reg_dst = 1; pc_write = 1; pc_jump = 0; pc_reg = 0; link = 0; begin_stall = 1; end
        endcase
        // CHECK FOR STALLING
        if (begin_stall)
          begin
            begin_stall = 0;
            state = `Q_STALL;
          end
      end
    else
      begin
        // STALL FOR 3 CLOCK CYCLES
        reg_write = 0; mem_to_reg = 0; mem_write = 0; branch = 0; alu_control = 3'b000; alu_src = 0; reg_dst = 0; pc_write = 0; pc_jump = 0; pc_reg = 0; begin_stall = 0;
        counter = counter + 1;
        if (counter == 3)
          begin
            state = `Q_PROC;
            counter = 0;
          end
      end
    end
  end
endmodule