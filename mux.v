module mux2to1
(
    input input1,
    input input2,
    input select,
    output reg out
);

always @(input1, input2, select) begin
if (select) begin
    assign out = input2;
end
else begin
    assign out = input1;
end
end
endmodule

module mux2to15bits
(
    input [4:0] input1,
    input [4:0] input2,
    input select,
    output reg [4:0] out
);

always @(input1, input2, select) begin
if (select) begin
    assign out = input2;
end
else begin
    assign out = input1;
end
end
endmodule


module mux32to1by1small
(
    input [31:0] input1,
    input [31:0] input2,
    input select,
    output reg [31:0] out
);

  always @(input1, input2, select) begin
  if (select) begin
      assign out = input2;
  end
  else begin
      assign out = input1;
  end
  end
endmodule

// module mux32to1by1with3
// (
//     input [31:0] input1,
//     input [31:0] input2,
//     input [31:0] input3,
//     input [1:0] select,
//     output reg [31:0] out
// );
//
//   always @(input1, input2, select) begin
//   if (select == 10) begin
//       assign out = input3;
//   end
//   if (select = 01) begin
//     assign out = input2;
//   end
//   else begin
//       assign out = input1;
//   end
//   end
// endmodule
