module cycle(
    input clk,
    input rst_n,
    input [127:0] pixels,
    output reg [7:0] q
);
    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n)
        if (~rst_n)
            cnt <= 0;
        else
            cnt <= cnt + 1'b1;

    always @*
        case (cnt)
            4'h0: q = pixels[127:120];
            4'h1: q = pixels[119:112];
            4'h2: q = pixels[111:104];
            4'h3: q = pixels[103:96];
            4'h4: q = pixels[95:88];
            4'h5: q = pixels[87:80];
            4'h6: q = pixels[79:72];
            4'h7: q = pixels[71:64];
            4'h8: q = pixels[63:56];
            4'h9: q = pixels[55:48];
            4'hA: q = pixels[47:40];
            4'hB: q = pixels[39:32];
            4'hC: q = pixels[31:24];
            4'hD: q = pixels[23:16];
            4'hE: q = pixels[15:8];
            4'hF: q = pixels[7:0];
        endcase
endmodule
