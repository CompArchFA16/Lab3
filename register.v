module register

#(parameter n = 32, parameter nreg = 10)

(
	input clk,

	input [nreg-1:0] ra_addr,
	input [nreg-1:0] rb_addr,

	output [n-1:0] ra,
	output [n-1:0] rb,

	input wrEn, //RegWrite
	input [nreg-1:0] wd_addr, //WriteRegister
	input [n-1:0] wd //WriteData

);

// Register file storage
reg [n-1:0] registers [nreg-1:0];
reg [nreg-1:0] ra_reg, rb_reg;

always @(posedge clk) begin
    if (wrEn) begin
        registers[wd_addr] <= wd;
    end

    ra_reg <= ra_addr;
    rb_reg <= rb_addr;
end

assign ra = register[ra_reg];
assign rb = register[rb_reg];

endmodule