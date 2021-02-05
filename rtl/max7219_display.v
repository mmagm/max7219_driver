// `include "sck_clk_divider.v"
// `include "max7219_spi.v"

module max7219_display
#(
    parameter SIZE = 2
)
(
    input clk,
    input rst_n,
    input enable,
    input [64 * SIZE - 1:0] pixels,
    output wire started,
    output wire mosi,
    output wire cs
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

    reg [8*SIZE-1:0] address;
    reg [8*SIZE-1:0] data;
    wire finished;

    max7219_spi #(.SIZE(SIZE)) max7219_spi_inst
    (
        .clk(clk),
        .rst_n(rst_n),
        .start(enable),
        .address(address),
        .data(data),
        .mosi(mosi),
        .cs(cs),
        .finished(finished)
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

    always @(posedge clk or negedge rst_n)
        if (~rst_n)
            state <= S_SCAN_LIMIT;
        else
            state <= nextState;

    integer i;
    always @* begin
        nextState = state;
        i = 0;

        case (state)
            S_SCAN_LIMIT: begin
                address = {SIZE{scanLimit}};
                data = {SIZE{8'h07}};
                if (finished)
                    nextState = S_DECODE_MODE;
            end
            S_DECODE_MODE: begin
                address = {SIZE{decodeMode}};
                data = {SIZE{8'h00}};
                if (finished)
                    nextState = S_SHUTDOWN;
            end
            S_SHUTDOWN: begin
                address = {SIZE{shutdown}};
                data = {SIZE{8'h01}};
                if (finished)
                    nextState = S_DISPLAY_TEST;
            end
            S_DISPLAY_TEST: begin
                address = {SIZE{displayTest}};
                data = {SIZE{8'h00}};
                if (finished)
                    nextState = S_INTENSITY;
            end
            S_INTENSITY: begin
                address = {SIZE{intensity}};
                data = {SIZE{8'h02}};
                if (finished)
                    nextState = S_RESET_DIGIT0;
            end

            S_RESET_DIGIT0: begin
                address = {SIZE{digit0}};
                data = {SIZE{8'h00}};
                if (finished)
                    nextState = S_RESET_DIGIT1;
            end
            S_RESET_DIGIT1: begin
                address = {SIZE{digit1}};
                data = {SIZE{8'h00}};
                if (finished)
                    nextState = S_RESET_DIGIT2;
            end
            S_RESET_DIGIT2: begin
                address = {SIZE{digit2}};
                data = {SIZE{8'h00}};
                if (finished)
                    nextState = S_RESET_DIGIT3;
            end
            S_RESET_DIGIT3: begin
                address = {SIZE{digit3}};
                data = {SIZE{8'h00}};
                if (finished)
                    nextState = S_RESET_DIGIT4;
            end
            S_RESET_DIGIT4: begin
                address = {SIZE{digit4}};
                data = {SIZE{8'h00}};
                if (finished)
                    nextState = S_RESET_DIGIT5;
            end
            S_RESET_DIGIT5: begin
                address = {SIZE{digit5}};
                data = {SIZE{8'h00}};
                if (finished)
                    nextState = S_RESET_DIGIT6;
            end
            S_RESET_DIGIT6: begin
                address = {SIZE{digit6}};
                data = {SIZE{8'h00}};
                if (finished)
                    nextState = S_RESET_DIGIT7;
            end
            S_RESET_DIGIT7: begin
                address = {SIZE{digit7}};
                data = {SIZE{8'h00}};
                if (finished)
                    nextState = S_NOOP_RESET;
            end

            S_NOOP_RESET: begin
                address = {SIZE{noop}};
                data = {SIZE{8'h00}};
                if (finished)
                    nextState = S_DISPLAY_DIGIT0;
            end

            S_DISPLAY_DIGIT0: begin
                address = {SIZE{digit0}};

                // SIZE = 2

                // i = 0
                // data[8 * 1 - 1 -: 8] = data[7:0]
                // pixels[64 * 0 + 64 - 1 -: 8] = pixels[63:56]

                // i = 1
                // data[8 * 2 - 1 -: 8] = data[15:8]
                // pixels[64*1 + 64 - 1 -: 8] = pixels[127:120]

                for (i = 0; i < SIZE; i = i + 1) begin
                    data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 64 - 1 -: 8];
                end

                if (finished)
                    nextState = S_DISPLAY_DIGIT1;
            end
            S_DISPLAY_DIGIT1: begin
                address = {SIZE{digit1}};

                for (i = 0; i < SIZE; i = i + 1) begin
                    data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 56 - 1 -: 8];
                end

                if (finished)
                    nextState = S_DISPLAY_DIGIT2;
            end
            S_DISPLAY_DIGIT2: begin
                address = {SIZE{digit2}};

                for (i = 0; i < SIZE; i = i + 1) begin
                    data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 48 - 1 -: 8];
                end

                if (finished)
                    nextState = S_DISPLAY_DIGIT3;
            end
            S_DISPLAY_DIGIT3: begin
                address = {SIZE{digit3}};

                for (i = 0; i < SIZE; i = i + 1) begin
                    data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 40 - 1 -: 8];
                end

                if (finished)
                    nextState = S_DISPLAY_DIGIT4;
            end
            S_DISPLAY_DIGIT4: begin
                address = {SIZE{digit4}};

                for (i = 0; i < SIZE; i = i + 1) begin
                    data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 32 - 1 -: 8];
                end

                if (finished)
                    nextState = S_DISPLAY_DIGIT5;
            end
            S_DISPLAY_DIGIT5: begin
                address = {SIZE{digit5}};

                for (i = 0; i < SIZE; i = i + 1) begin
                    data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 24 - 1 -: 8];
                end

                if (finished)
                    nextState = S_DISPLAY_DIGIT6;
            end
            S_DISPLAY_DIGIT6: begin
                address = {SIZE{digit6}};

                for (i = 0; i < SIZE; i = i + 1) begin
                    data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 16 - 1 -: 8];
                end

                if (finished)
                    nextState = S_DISPLAY_DIGIT7;
            end
            S_DISPLAY_DIGIT7: begin
                address = {SIZE{digit7}};

                for (i = 0; i < SIZE; i = i + 1) begin
                    data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 8 - 1 -: 8];
                end

                if (finished)
                    nextState = S_NOOP_DISPLAY;
            end

            S_NOOP_DISPLAY: begin
                address = {SIZE{noop}};
                data = {SIZE{8'h00}};
                if (finished)
                    nextState = S_NOOP_RESET;
            end

            default: nextState = S_SCAN_LIMIT;
        endcase
    end

    assign started = (state == S_DISPLAY_DIGIT7 |
                      state == S_DISPLAY_DIGIT6 | 
                      state == S_DISPLAY_DIGIT5 |
                      state == S_DISPLAY_DIGIT4 |
                      state == S_DISPLAY_DIGIT3 |
                      state == S_DISPLAY_DIGIT2 |
                      state == S_DISPLAY_DIGIT1 |
                      state == S_DISPLAY_DIGIT0);
endmodule
