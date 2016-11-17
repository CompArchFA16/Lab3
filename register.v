module register

#(parameter n = 32, parameter naddr = 5)

(
	input clk,

	input [naddr-1:0] ra_addr,
	input [naddr-1:0] rb_addr,

	output [n-1:0] ra,
	output [n-1:0] rb,

	input wrEn, //RegWrite
	input [naddr-1:0] wd_addr, //WriteRegister
	input [n-1:0] wd //WriteData

);

// Register file storage
reg [n-1:0] registers [1000:0];

initial begin
	registers[0] = 32'b0;
end

always @(posedge clk) begin
    if (wrEn) begin
    	$display("%b", wd);
    	$display("%b", wd_addr);
        registers[wd_addr] = wd;
        $display("%b", registers[wd_addr]);
    end
end

assign ra = registers[ra_addr];
assign rb = registers[rb_addr];

endmodule

module test();
	reg [31:0] wrData;
	reg [4:0] a,b,wrReg;
	reg clk, wrEn;
	wire [31:0] aout, bout;

	register register(clk,a,b,aout,bout,wrEn,wrReg,wrData);

	initial begin
		$dumpfile("register.vcd");
	    $dumpvars();

		clk = 0; 
		a = 5'd0;
		wrReg = 5'd8; 
		wrData = 32'd50; 
		wrEn = 1; 
		#5
		clk = 1;
		#5
		a = 5'd8;
		#50

		$display("%b", aout);
	end
endmodule