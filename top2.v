module top2(
    input clk,
    input rst_n,
    output sck,
    output dout,
    output cs
);
    wire clk_shift;

    wire [7:0] col, ex;
    wire [63:0] pixels1;
    wire [63:0] pixels2;

    sck_clk_divider #(5_000_000) sck_clk_divider_inst
    (
        .clk(clk),
        .rst_n(rst_n),
        .sck(clk_shift)
    );

    provider provider_1_inst
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
        .ex(ex),
        .out(pixels1)
    );

    shift_col1 shift_col2_inst(
        .clk(clk_shift),
        .rst_n(rst_n),
        .en(1'b1),
        .dir(1'b1),
        .d(ex),
        .out(pixels2)
    );

    wire [127:0] pixels = {pixels1, pixels2};

    max7219_display_2 max7219_display_2_inst
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
