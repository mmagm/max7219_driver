module top(
    input clk,
    input rst_n,

    output sck,
    output dout,
    output cs
);

    reg [63:0] pixels = {8'h18, 8'h18, 8'h18, 8'hff, 8'hff, 8'h18, 8'h18, 8'h18};

    max7219_display max7219_display_inst
    (
        .clk(clk),
        .rst_n(rst_n),
        .pixels(pixels),
        .sck(sck),
        .mosi(dout),
        .cs(cs),
        .finish()
    );

endmodule