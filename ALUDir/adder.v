// Adder circuit

// define gates with delays
`define AND and #30
`define OR or #30
`define XOR xor #50

module fullAdder
(
    output sum, 
    output carryout,
    input a, 
    input b, 
    input carryin
);
    wire a, b, carryin;
    wire bandc, aandc, aandb, bcorac;
    wire axorb; 

    // Carryout
    `AND andgate0 (bandc, b, carryin);
    `AND andgate1 (aandc, a, carryin);
    `AND andgate2 (aandb, a, b);
    `OR  orgate0  (bcorac, aandc, bandc);
    `OR  orgate1  (carryout, bcorac, aandb);

    // Sum
    `XOR xorgate0 (axorb, a, b);
    `XOR xorgate1 (sum, axorb, carryin);

endmodule
