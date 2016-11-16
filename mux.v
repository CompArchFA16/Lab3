// http://www.alteraforum.com/forum/showthread.php?t=22519

`ifndef __MUX_V__
`define __MUX_V__

module mux 
#(   parameter WIDTH    = 8,
     parameter CHANNELS = 4) 
(
    input   [(CHANNELS*WIDTH)-1:0]      in_bus,
    input   [$clog2(CHANNELS-1)-1:0]    sel,   
    output  [WIDTH-1:0]                 out
);

genvar ig;
    
wire [WIDTH-1:0] input_array [0:CHANNELS-1];

assign out = input_array[sel];

generate
    for(ig=0; ig<CHANNELS; ig=ig+1) begin: array
        assign input_array[ig] = in_bus[(ig*WIDTH)+:WIDTH];
    end
endgenerate
endmodule

`endif
