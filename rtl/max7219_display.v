`ifdef ICARUS
    `include "spi_master.v"
    `include "sck_clk_divider.v"
`endif

module max7219_display(
    input clk,
    input rst_n,
    input [63:0] pixels,
    output sck,
    output mosi,
    output cs,
    output finish
);

    localparam  noop        = 8'h00,
                digit0      = 8'h01,
                digit1      = 8'h02,
                digit2      = 8'h03,
                digit3      = 8'h04,
                digit4      = 8'h05,
                digit5      = 8'h06,
                digit6      = 8'h07,
                digit7      = 8'h08,
                decodeMode  = 8'h09,
                intensity   = 8'h0A,
                scanLimit   = 8'h0B,
                shutdown    = 8'h0C,
                displayTest = 8'h0F;

    reg [7:0] address;
    reg [7:0] data;
    wire finished;

    sck_clk_divider sck_clk_divider_inst
    (
        .clk(clk),
        .rst_n(rst_n),
        .sck(sck),
        .sck_edge()
    );


    spi_master spi_master_inst
    (
        .sck(sck),
        .rst_n(rst_n),
        .address(address),
        .data(data),
        .mosi(mosi),
        .cs(cs),
        .finish(finished)
    );

    reg [5:0] state, nextState;

    localparam  S_SCAN_LIMIT = 6'd0,
                S_DECODE_MODE = 6'd1,
                S_SHUTDOWN = 6'd2,
                S_DISPLAY_TEST = 6'd3,
                S_INTENSITY = 6'd4,

                S_RESET_DIGIT0 = 6'd5,
                S_RESET_DIGIT1 = 6'd6,
                S_RESET_DIGIT2 = 6'd7,
                S_RESET_DIGIT3 = 6'd8,
                S_RESET_DIGIT4 = 6'd9,
                S_RESET_DIGIT5 = 6'd10,
                S_RESET_DIGIT6 = 6'd11,
                S_RESET_DIGIT7 = 6'd12,

                S_NOOP_RESET = 6'd13,

                S_DISPLAY_DIGIT0 = 6'd14,
                S_DISPLAY_DIGIT1 = 6'd15,
                S_DISPLAY_DIGIT2 = 6'd16,
                S_DISPLAY_DIGIT3 = 6'd17,
                S_DISPLAY_DIGIT4 = 6'd18,
                S_DISPLAY_DIGIT5 = 6'd19,
                S_DISPLAY_DIGIT6 = 6'd20,
                S_DISPLAY_DIGIT7 = 6'd21,

                S_NOOP_DISPLAY = 6'd22;

    always @(posedge sck or negedge rst_n)
        if (~rst_n)
            state <= S_SCAN_LIMIT;
        else
            state <= nextState;

    always @* begin
        nextState = state;

        case (state)
            S_SCAN_LIMIT: begin
                address = scanLimit;
                data = 8'h07;
                if (finished)
                    nextState = S_DECODE_MODE;
            end
            S_DECODE_MODE: begin
                address = decodeMode;
                data = 8'h00;
                if (finished)
                    nextState = S_SHUTDOWN;
            end
            S_SHUTDOWN: begin
                address = shutdown;
                data = 8'h01;
                if (finished)
                    nextState = S_DISPLAY_TEST;
            end
            S_DISPLAY_TEST: begin
                address = displayTest;
                data = 8'h00;
                if (finished)
                    nextState = S_INTENSITY;
            end
            S_INTENSITY: begin
                address = intensity;
                data = 8'h0f;
                if (finished)
                    nextState = S_RESET_DIGIT0;
            end

            S_RESET_DIGIT0: begin
                address = digit0;
                data = 8'h00;
                if (finished)
                    nextState = S_RESET_DIGIT1;
            end
            S_RESET_DIGIT1: begin
                address = digit1;
                data = 8'h00;
                if (finished)
                    nextState = S_RESET_DIGIT2;
            end
            S_RESET_DIGIT2: begin
                address = digit2;
                data = 8'h00;
                if (finished)
                    nextState = S_RESET_DIGIT3;
            end
            S_RESET_DIGIT3: begin
                address = digit3;
                data = 8'h00;
                if (finished)
                    nextState = S_RESET_DIGIT4;
            end
            S_RESET_DIGIT4: begin
                address = digit4;
                data = 8'h00;
                if (finished)
                    nextState = S_RESET_DIGIT5;
            end
            S_RESET_DIGIT5: begin
                address = digit5;
                data = 8'h00;
                if (finished)
                    nextState = S_RESET_DIGIT6;
            end
            S_RESET_DIGIT6: begin
                address = digit6;
                data = 8'h00;
                if (finished)
                    nextState = S_RESET_DIGIT7;
            end
            S_RESET_DIGIT7: begin
                address = digit7;
                data = 8'h00;
                if (finished)
                    nextState = S_NOOP_RESET;
            end

            S_NOOP_RESET: begin
                address = noop;
                data = 8'h00;
                if (finished)
                    nextState = S_DISPLAY_DIGIT0;
            end

            S_DISPLAY_DIGIT0: begin
                address = digit0;
                data = pixels[63:56];
                if (finished)
                    nextState = S_DISPLAY_DIGIT1;
            end
            S_DISPLAY_DIGIT1: begin
                address = digit1;
                data = pixels[55:48];
                if (finished)
                    nextState = S_DISPLAY_DIGIT2;
            end
            S_DISPLAY_DIGIT2: begin
                address = digit2;
                data = pixels[47:40];
                if (finished)
                    nextState = S_DISPLAY_DIGIT3;
            end
            S_DISPLAY_DIGIT3: begin
                address = digit3;
                data = pixels[39:32];
                if (finished)
                    nextState = S_DISPLAY_DIGIT4;
            end
            S_DISPLAY_DIGIT4: begin
                address = digit4;
                data = pixels[31:24];
                if (finished)
                    nextState = S_DISPLAY_DIGIT5;
            end
            S_DISPLAY_DIGIT5: begin
                address = digit5;
                data = pixels[23:16];
                if (finished)
                    nextState = S_DISPLAY_DIGIT6;
            end
            S_DISPLAY_DIGIT6: begin
                address = digit6;
                data = pixels[15:8];
                if (finished)
                    nextState = S_DISPLAY_DIGIT7;
            end
            S_DISPLAY_DIGIT7: begin
                address = digit7;
                data = pixels[7:0];
                if (finished)
                    nextState = S_NOOP_DISPLAY;
            end

            S_NOOP_DISPLAY: begin
                address = noop;
                data = 8'h00;
                if (finished)
                    nextState = S_NOOP_RESET;
            end
        endcase
    end

    assign finish = (state == S_NOOP_DISPLAY);
endmodule
