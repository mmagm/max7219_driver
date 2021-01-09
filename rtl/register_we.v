module register_we
#(parameter SIZE = 32)
(
    input                     clk,
    input                     rst_n,
    input                     we,
    input      [SIZE - 1 : 0] d,
    output reg [SIZE - 1 : 0] q
);
    always @ (posedge clk or negedge rst_n)
        if (~rst_n)
            q <= { SIZE { 1'b0}};
        else
            if(we) q <= d;
endmodule
