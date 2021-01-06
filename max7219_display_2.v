`ifdef ICARUS
    `include "spi_master_2.v"
    `include "sck_clk_divider.v"
`endif

module max7219_display_2(
    input clk,
    input rst_n,
    input [127:0] pixels,
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

    reg [15:0] address;
    reg [15:0] data;
    wire finished;

    sck_clk_divider sck_clk_divider_inst
    (
        .clk(clk),
        .rst_n(rst_n),
        .sck(sck),
        .sck_edge()
    );

    spi_master_2 spi_master_2_inst
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
                address = {scanLimit, scanLimit};
                data = {8'h07, 8'h07};
                if (finished)
                    nextState = S_DECODE_MODE;
            end
            S_DECODE_MODE: begin
                address = {decodeMode, decodeMode};
                data = {8'h00, 8'h00};
                if (finished)
                    nextState = S_SHUTDOWN;
            end
            S_SHUTDOWN: begin
                address = {shutdown, shutdown};
                data = {8'h01, 8'h01};
                if (finished)
                    nextState = S_DISPLAY_TEST;
            end
            S_DISPLAY_TEST: begin
                address = {displayTest, displayTest};
                data = {8'h00, 8'h00};
                if (finished)
                    nextState = S_INTENSITY;
            end
            S_INTENSITY: begin
                address = {intensity, intensity};
                data = {8'h02, 8'h02};
                if (finished)
                    nextState = S_RESET_DIGIT0;
            end

            S_RESET_DIGIT0: begin
                address = {digit0, digit0};
                data = {8'h00, 8'h00};
                if (finished)
                    nextState = S_RESET_DIGIT1;
            end
            S_RESET_DIGIT1: begin
                address = {digit1, digit1};
                data = {8'h00, 8'h00};
                if (finished)
                    nextState = S_RESET_DIGIT2;
            end
            S_RESET_DIGIT2: begin
                address = {digit2,digit2};
                data = {8'h00, 8'h00};
                if (finished)
                    nextState = S_RESET_DIGIT3;
            end
            S_RESET_DIGIT3: begin
                address = {digit3, digit3};
                data = {8'h00, 8'h00};
                if (finished)
                    nextState = S_RESET_DIGIT4;
            end
            S_RESET_DIGIT4: begin
                address = {digit4, digit4};
                data = {8'h00, 8'h00};
                if (finished)
                    nextState = S_RESET_DIGIT5;
            end
            S_RESET_DIGIT5: begin
                address = {digit5, digit5};
                data = {8'h00, 8'h00};
                if (finished)
                    nextState = S_RESET_DIGIT6;
            end
            S_RESET_DIGIT6: begin
                address = {digit6, digit6};
                data = {8'h00, 8'h00};
                if (finished)
                    nextState = S_RESET_DIGIT7;
            end
            S_RESET_DIGIT7: begin
                address = {digit7, digit7};
                data = {8'h00, 8'h00};
                if (finished)
                    nextState = S_NOOP_RESET;
            end

            S_NOOP_RESET: begin
                address = {noop, noop};
                data = {8'h00, 8'h00};
                if (finished)
                    nextState = S_DISPLAY_DIGIT0;
            end

            S_DISPLAY_DIGIT0: begin
                address = {digit0, digit0};
                data = {pixels[127:120], pixels[63:56]};
                // data = {{pixels[127], pixels[119], pixels[111], pixels[103], pixels[95], pixels[87], pixels[79], pixels[71]},
                //         {pixels[63], pixels[55], pixels[47], pixels[39], pixels[31], pixels[23], pixels[15], pixels[7]}};
                // data = {{pixels[71], pixels[79], pixels[87], pixels[95], pixels[103], pixels[111], pixels[119], pixels[127]},
                //         {pixels[15], pixels[7], pixels[23], pixels[31], pixels[39], pixels[47], pixels[55], pixels[63]}};
                if (finished)
                    nextState = S_DISPLAY_DIGIT1;
            end
            S_DISPLAY_DIGIT1: begin
                address = {digit1, digit1};
                data = {pixels[119:112], pixels[55:48]};
                // data = {{pixels[126], pixels[118], pixels[110], pixels[102], pixels[94], pixels[86], pixels[78], pixels[70]},
                //         {pixels[62], pixels[54], pixels[46], pixels[38], pixels[30], pixels[22], pixels[14], pixels[6]}};
                // data = {{pixels[70], pixels[78], pixels[86], pixels[94], pixels[102], pixels[110], pixels[118], pixels[126]},
                //         {pixels[6], pixels[14], pixels[22], pixels[30], pixels[38], pixels[46], pixels[54], pixels[62]}};
                if (finished)
                    nextState = S_DISPLAY_DIGIT2;
            end
            S_DISPLAY_DIGIT2: begin
                address = {digit2, digit2};
                data = {pixels[111:104], pixels[47:40]};
                // data = {{pixels[125], pixels[117], pixels[109], pixels[101], pixels[93], pixels[85], pixels[77], pixels[69]}, 
                //         {pixels[61], pixels[53], pixels[45], pixels[37], pixels[29], pixels[21], pixels[13], pixels[5]}};
                // data = {{pixels[69], pixels[77], pixels[85], pixels[93], pixels[101], pixels[109], pixels[117], pixels[125]}, 
                //         {pixels[5], pixels[13], pixels[21], pixels[29], pixels[37], pixels[45], pixels[53], pixels[61]}};
                if (finished)
                    nextState = S_DISPLAY_DIGIT3;
            end
            S_DISPLAY_DIGIT3: begin
                address = {digit3, digit3};
                data = {pixels[103:96], pixels[39:32]};
                // data = {{pixels[124], pixels[116], pixels[108], pixels[100], pixels[92], pixels[84], pixels[76], pixels[68]},
                //         {pixels[60], pixels[52], pixels[44], pixels[36], pixels[28], pixels[20], pixels[12], pixels[4]}};
                // data = {{pixels[68], pixels[76], pixels[84], pixels[92], pixels[100], pixels[108], pixels[116], pixels[124]},
                //         {pixels[4], pixels[12], pixels[20], pixels[28], pixels[36], pixels[42], pixels[50], pixels[60]}};
                if (finished)
                    nextState = S_DISPLAY_DIGIT4;
            end
            S_DISPLAY_DIGIT4: begin
                address = {digit4, digit4};
                data = {pixels[95:88], pixels[31:24]};
                // data = {{pixels[123], pixels[115], pixels[107], pixels[99], pixels[91], pixels[83], pixels[75], pixels[67]},
                //         {pixels[59], pixels[51], pixels[43], pixels[35], pixels[27], pixels[19], pixels[11], pixels[3]}};
                // data = {{pixels[67], pixels[75], pixels[83], pixels[91], pixels[99], pixels[107], pixels[115], pixels[123]},
                //         {pixels[3], pixels[11], pixels[19], pixels[27], pixels[35], pixels[43], pixels[51], pixels[59]}};
                if (finished)
                    nextState = S_DISPLAY_DIGIT5;
            end
            S_DISPLAY_DIGIT5: begin
                address = {digit5, digit5};
                data = {pixels[87:80], pixels[23:16]};
                // data = {{pixels[122], pixels[114], pixels[106], pixels[98], pixels[90], pixels[82], pixels[74], pixels[66]},
                //         {pixels[58], pixels[50], pixels[42], pixels[34], pixels[26], pixels[18], pixels[10], pixels[2]}};
                // data = {{pixels[66], pixels[75], pixels[82], pixels[90], pixels[98], pixels[106], pixels[114], pixels[122]},
                //         {pixels[2], pixels[10], pixels[18], pixels[26], pixels[34], pixels[42], pixels[50], pixels[58]}};
                if (finished)
                    nextState = S_DISPLAY_DIGIT6;
            end
            S_DISPLAY_DIGIT6: begin
                address = {digit6, digit6};
                data = {pixels[79:72], pixels[15:8]};
                // data = {{pixels[121], pixels[113], pixels[105], pixels[97], pixels[89], pixels[81], pixels[73], pixels[65]},
                //         {pixels[57], pixels[49], pixels[41], pixels[33], pixels[25], pixels[17], pixels[9], pixels[1]}};
                // data = {{pixels[65], pixels[73], pixels[81], pixels[89], pixels[97], pixels[105], pixels[113], pixels[121]},
                //         {pixels[1], pixels[9], pixels[17], pixels[25], pixels[33], pixels[41], pixels[49], pixels[57]}};
                if (finished)
                    nextState = S_DISPLAY_DIGIT7;
            end
            S_DISPLAY_DIGIT7: begin
                address = {digit7, digit7};
                data = {pixels[71:64], pixels[7:0]};
                // data = {{pixels[120], pixels[112], pixels[104], pixels[96], pixels[88], pixels[80], pixels[72], pixels[64]},
                //         {pixels[56], pixels[48], pixels[40], pixels[32], pixels[24], pixels[16], pixels[8], pixels[0]}};
                // data = {{pixels[64], pixels[72], pixels[80], pixels[88], pixels[96], pixels[104], pixels[112], pixels[120]},
                //         {pixels[0], pixels[8], pixels[16], pixels[24], pixels[32], pixels[40], pixels[48], pixels[56]}};
                if (finished)
                    nextState = S_NOOP_DISPLAY;
            end

            S_NOOP_DISPLAY: begin
                address = {noop, noop};
                data = {8'h00, 8'h00};
                if (finished)
                    nextState = S_NOOP_RESET;
            end
        endcase
    end

    assign finish = (state == S_NOOP_DISPLAY);
endmodule
