`timescale 1ns/100ps

`define ICARUS 1

`ifdef ICARUS
`include "max7219_display_2.v"
`endif

module max7219_display_2_tb;
    // simulation options
    parameter Tt     = 20;
    parameter Cycles = 40000;

    // global signals
    reg         clk;
    reg         rst_n;

    reg [127:0] pixels;
    wire sck, mosi, cs, finish;

    max7219_display_2 max7219_display_2
    (
        .clk(clk),
        .rst_n(rst_n),
        .pixels(pixels),
        .sck(sck),
        .mosi(mosi),
        .cs(cs),
        .finish(finish)
    );

    // simulation init - clock
    initial begin
        clk = 0;
        pixels = {8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h08, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h08};
        forever clk = #(Tt/2) ~clk;
    end

    initial begin
        $dumpfile("max7219_display_2.vcd");
        $dumpvars;
    end

    // simulation init - reset
    initial begin
        rst_n   = 0;
        repeat (4)  @(posedge clk);
        rst_n   = 1;
    end

    // simulation duration
    initial begin
        repeat (Cycles)  @(posedge clk);
        $finish;
    end
endmodule
