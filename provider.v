module provider(
    input clk,
    input rst_n,
    output reg [7:0] col
);
    reg [5:0] address;
    reg [2:0] row_cnt;

    wire [63:0] pixels;
 
    always @(posedge clk or negedge rst_n)
        if (~rst_n) begin
            address <= 0;
            row_cnt <= 0;
        end
        else begin
            row_cnt <= row_cnt + 1'b1;
            if (row_cnt == 3'b111)
                address <= address + 1'b1; 
        end

    font_rom #(.LENGTH(64), .WIDTH(64)) font_rom_inst
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
