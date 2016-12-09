// jump address concatenator

module transphaseregister (
  output reg [31:0] a_out, b_out, c_out, d_out, e_out, f_out,
  output reg 	    reg_write_out,
  output reg 	    mem_to_reg_out,
  output reg 	    mem_write_out,
  output reg 	    branch_out,
  output reg [2:0]  alu_control_out,
  output reg 	    alu_src_out,
  output reg 	    reg_dst_out,
  output reg 	    pc_reg_out,
  input             clk,
  input [31:0] 	    a, b, c, d, e, f,
  input 	    reg_write,
  input 	    mem_to_reg,
  input 	    mem_write,
  input 	    branch_t,
  input [2:0] 	    alu_control,
  input 	    alu_src,
  input 	    reg_dst,
  input 	    pc_reg
);

  always @ (posedge clk) begin
    a_out = a;
    b_out = b;
    c_out = c;
    d_out = d;
    e_out = e;
    f_out = f;
    reg_write_out = reg_write;
    mem_to_reg_out = mem_to_reg;
    mem_write_out = mem_write;
    branch_out = branch_t;
    alu_control_out = alu_control;
    alu_src_out = alu_src;
    reg_dst_out = reg_dst;
    pc_reg_out = pc_reg;
  end

endmodule
