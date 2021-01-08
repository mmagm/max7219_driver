module top(
    input clk,
    input rst_n,

    output sck,
    output dout,
    output cs
);

    // reg [63:0] pixels = {8'h18, 8'h18, 8'h18, 8'hff, 8'hff, 8'h18, 8'h18, 8'h18};
	// reg [63:0] pixels = 64'he5a2e50000a207a2;

    wire [7:0] col;
    wire [63:0] pixels;
    wire clk_shift;

    sck_clk_divider #(5_000_000) sck_clk_divider_inst
    (
        .clk(clk),
        .rst_n(rst_n),
        .sck(clk_shift),
        .sck_edge()
    );

    provider provider_inst
    (
        .clk(clk_shift),
        .rst_n(rst_n),
        .col(col)
    );

    shift_col1 shift_col1_inst(
        .clk(clk_shift),
        .rst_n(rst_n),
        .en(1'b1),
        .dir(1'b1),
        .d(col),
        .out(pixels)
    );

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