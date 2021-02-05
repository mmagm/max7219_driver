module top(
    input clk,
    input sw_rst_n,
    output sck,
    output dout,
    output cs
);
    wire [127:0] rpixels;

    wire reset_n;
    sync sync_inst
    (
        .clk(clk),
        .sw(sw_rst_n),
        .synced(reset_n)
    );

    wire rreset_n;
    sync sync_r_inst
    (
        .clk(sck),
        .sw(sw_rst_n),
        .synced(rreset_n)
    );

    pll pll_inst
    (
      .inclk0(clk),
      .c0(sck)
    );

    wire afifo_full;
    wire afifo_empty;
    wire afifo_not_empty = ~afifo_empty;

    localparam DISPLAY_PAUSE = 6250000; // 78125; // 390625; // 781250; // 3125000; // 6250000;
    localparam DISPLAY_PAUSE_W = $clog2(DISPLAY_PAUSE);

    reg [DISPLAY_PAUSE_W-1:0] cnt_period;

    always @(posedge clk or negedge reset_n)
      if (!reset_n)
        cnt_period <= 0;
      else if (cnt_period == (DISPLAY_PAUSE - 1))
          cnt_period <= 0;
      else
          cnt_period <= cnt_period + 1'b1;

    reg enable;
    always @(posedge clk or negedge reset_n)
      begin
        if (!reset_n)
          enable <= 1'b0;
        else if (cnt_period == (DISPLAY_PAUSE - 1))
          enable <= 1'b1;
        else
          enable <= 1'b0;
      end

    wire [63:0] pixels1, pixels2;

    wire [7:0] col, shifted_col;

    wire [127:0] display = {pixels1, pixels2};

    provider provider_inst
    (
        .clk(clk),
        .rst_n(reset_n),
        .enable(enable),
        .col(col)
    );

    shift_col shift_col1_inst(
        .clk(clk),
        .rst_n(reset_n),
        .en(enable),
        .dir(1'b1),
        .d(col),
        .ex(shifted_col),
        .out(pixels1)
    );

    shift_col shift_col2_inst(
        .clk(clk),
        .rst_n(reset_n),
        .en(enable),
        .dir(1'b1),
        .d(shifted_col),
        .out(pixels2)
    );

    wire started;

    afifo #(.DSIZE(128),.ASIZE(8)) afifo_inst
    (
        .i_wclk(clk),
        .i_wrst_n(reset_n),
        .i_wr(1'b1),
        .i_wdata(display),
        .o_wfull(afifo_full),
        .i_rclk(sck),
        .i_rrst_n(rreset_n),
        .i_rd(started),
        .o_rdata(rpixels),
        .o_rempty(afifo_empty)
    );

    max7219_display #(.SIZE(2)) max7219_display_inst
    (
        .clk(sck),
        .rst_n(reset_n),
        .enable(afifo_not_empty),
        .started(started),
        .pixels(rpixels),
        .mosi(dout),
        .cs(cs)
    );
endmodule
