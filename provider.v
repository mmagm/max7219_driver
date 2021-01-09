module provider(
    input clk,
    input rst_n,
    output reg [7:0] col
);
    // FPGA-Systems.ru (15 symbols)
    // (0..9) - 1..9,0
    // (A..z) - 10..62
    // (A..Z) - 10..35
    // (a..z) - 37..62
    // . - 80
    // - - 65

    // A B C D E F G H I J K L M
    // N O P Q R S T U V W X Y Z

    // a b c d e f g h i j k l m
    // n o p q r s t u v w x y z

    // 15
    // 25
    // 16
    // 10
    // 65
    // 28
    // 61
    // 55
    // 56
    // 41
    // 49
    // 55
    // 80
    // 54
    // 57

    reg [7:0] address, next_address;
    reg [2:0] row_cnt;

    localparam  S0 = 4'd0,
                S1 = 4'd1,
                S2 = 4'd2,
                S3 = 4'd3,
                S4 = 4'd4,
                S5 = 4'd5,
                S6 = 4'd6,
                S7 = 4'd7,
                S8 = 4'd8,
                S9 = 4'd9,
                S10 = 4'd10,
                S11 = 4'd11,
                S12 = 4'd12,
                S13 = 4'd13,
                S14 = 4'd14,
                S15 = 4'd15;

    reg [3:0] state, next_state;

    wire [63:0] pixels;

    always @(posedge clk or negedge rst_n)
        if (~rst_n) begin
            address <= 127;
            row_cnt <= 0;
            state <= S0;
        end
        else begin
            row_cnt <= row_cnt + 1'b1;
            if (row_cnt == 3'b111) begin
                address <= next_address; // address + 1'b1;
                state <= next_state;
            end
        end

    always @* begin
        next_state = state;
        case(state)
            S0: begin next_state = S1; next_address = 127; end
            S1: begin next_state = S2; next_address = 15; end
            S2: begin next_state = S3; next_address = 25; end
            S3: begin next_state = S4; next_address = 16; end
            S4: begin next_state = S5; next_address = 10; end
            S5: begin next_state = S6; next_address = 65; end
            S6: begin next_state = S7; next_address = 28; end
            S7: begin next_state = S8; next_address = 61; end
            S8: begin next_state = S9; next_address = 55; end
            S9: begin next_state = S10; next_address = 56; end
            S10: begin next_state = S11; next_address = 41; end
            S11: begin next_state = S12; next_address = 49; end
            S12: begin next_state = S13; next_address = 55; end
            S13: begin next_state = S14; next_address = 80; end
            S14: begin next_state = S15; next_address = 54; end
            S15: begin next_state = S0; next_address = 57; end
        endcase
    end

    rom #(.LENGTH(128), .WIDTH(64)) rom_inst
    (
        .clk(clk),
        .addr(address),
        .q(pixels)
    );

    always @* begin
        case (row_cnt)
            3'd0: begin
                col = {pixels[56], pixels[48],  pixels[40], pixels[32], pixels[24], pixels[16], pixels[8], pixels[0]};
            end
            3'd1: begin
                col = {pixels[57], pixels[49],  pixels[41], pixels[33], pixels[25], pixels[17], pixels[9], pixels[1]};
            end
            3'd2: begin
                col = {pixels[58], pixels[50], pixels[42], pixels[34], pixels[26], pixels[18], pixels[10], pixels[2]};
            end
            3'd3: begin
                col = {pixels[59], pixels[51], pixels[43], pixels[35], pixels[27], pixels[19], pixels[11], pixels[3]};
            end
            3'd4: begin
                col = {pixels[60], pixels[52], pixels[44], pixels[36], pixels[28], pixels[20], pixels[12], pixels[4]};
            end
            3'd5: begin
                col = {pixels[61], pixels[53], pixels[45], pixels[37], pixels[29], pixels[21], pixels[13], pixels[5]};
            end
            3'd6: begin
                col = {pixels[62], pixels[54], pixels[46], pixels[38], pixels[30], pixels[22], pixels[14], pixels[6]};
            end
            3'd7: begin
                col = {pixels[63], pixels[55], pixels[47], pixels[39], pixels[31], pixels[23], pixels[15], pixels[7]};
            end
        endcase
    end
endmodule
