`timescale 1ns/100ps

`define ICARUS 1

`ifdef ICARUS
    `include "spi_master_2.v"
`endif

module spi_master_2_tb;
    // simulation options
    parameter Tt     = 20;
    parameter Cycles = 82;

    // global signals
    reg         clk;
    reg         rst_n;

    reg [15:0] address, data;

    wire finish;
    wire mosi;
    wire cs;

    spi_master_2 spi_master_2
    (
        .sck(clk), 
        .rst_n(rst_n), 
        .address(address),
        .data(data),
        .finish(finish),
        .mosi(mosi),
        .cs(cs)
    );

    // simulation init - clock
    initial begin
        clk = 0;
        address = 16'hAAAA;
        data = 16'h0A0A;
        forever clk = #(Tt/2) ~clk;
    end

    initial begin
        $dumpfile("spi_master_2.vcd");
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
