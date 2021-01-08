module top2(
    input clk,
    input rst_n,
    output sck,
    output dout,
    output cs
);
    // reg [127:0] pixels = {8'h18, 8'h18, 8'h18, 8'hff, 8'hff, 8'h18, 8'h18, 8'h18,8'h18, 8'h18, 8'h18, 8'hff, 8'hff, 8'h18, 8'h18, 8'h18};
    // reg [127:0] pixels = {64'h3c66663e06663c00,64'h3c66663e06663c00};
    // reg [127:0] pixels = {64'h1c36363030307800, 64'h603c766666663c00};
    // reg [127:0] pixels = {64'h1c36363030307800, 64'h0};
	// reg [127:0] pixels = 128'h0;

    wire clk_shift;
    wire [7:0] data;
    wire [127:0] shifted;

    sck_clk_divider #(5_000_000) sck_clk_divider_inst
    (
        .clk(clk),
        .rst_n(rst_n),
        .sck(clk_shift),
        .sck_edge()
    );

	wire [63:0] symbol;
    reg [5:0] address;
	reg [3:0] cnt;

    rom rom_inst(
        .clock(clk_shift),
        .address(address),
        .q(symbol)
    );

    always @(posedge clk_shift or negedge rst_n)
	    if (~rst_n)
		    cnt <= 0;
		else
		    cnt <= cnt + 1'b1;

	always @(posedge clk_shift or negedge rst_n)
	    if (~rst_n)
	        address <= 0;
		else if (cnt == 4'hf)
		    address <= address + 1'b1;

	wire [127:0] pixels = {symbol, symbol};

    cycle_col cycle_col_inst
    (
        .clk(clk_shift),
        .rst_n(rst_n),
        .dir(1'b0),
        .pixels(pixels),
        .q(data)
    );

    shift_col shift_col_inst
    (
        .clk(clk_shift),
        .rst_n(rst_n),
        .en(1'b1),
        .dir(1'b0),
        .d(data),
        .out(shifted)
    );

    max7219_display_2 max7219_display_2_inst
    (
        .clk(clk),
        .rst_n(rst_n),
        .pixels(shifted),
        .sck(sck),
        .mosi(dout),
        .cs(cs),
        .finish()
    );
endmodule
