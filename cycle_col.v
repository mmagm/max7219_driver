module cycle_col(
    input clk,
    input rst_n,
    input dir,
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
        if (dir)
            case (cnt)
                4'h0: q = {pixels[71], pixels[79], pixels[87], pixels[95], pixels[103], pixels[111], pixels[119], pixels[127]};
                4'h1: q = {pixels[70], pixels[78], pixels[86], pixels[94], pixels[102], pixels[110], pixels[118], pixels[126]};
                4'h2: q = {pixels[69], pixels[77], pixels[85], pixels[93], pixels[101], pixels[109], pixels[117], pixels[125]};
                4'h3: q = {pixels[68], pixels[76], pixels[84], pixels[92], pixels[100], pixels[108], pixels[116], pixels[124]};
                4'h4: q = {pixels[67], pixels[75], pixels[83], pixels[91], pixels[99],  pixels[107], pixels[115], pixels[123]};
                4'h5: q = {pixels[66], pixels[74], pixels[82], pixels[90], pixels[98],  pixels[106], pixels[114], pixels[122]};
                4'h6: q = {pixels[65], pixels[73], pixels[81], pixels[89], pixels[97],  pixels[105], pixels[113], pixels[121]};
                4'h7: q = {pixels[64], pixels[72], pixels[80], pixels[88], pixels[96],  pixels[104], pixels[112], pixels[120]};

                4'h8: q = {pixels[7], pixels[15], pixels[23], pixels[31], pixels[39], pixels[47], pixels[55], pixels[63]};
                4'h9: q = {pixels[6], pixels[14], pixels[22], pixels[30], pixels[38], pixels[46], pixels[54], pixels[62]};
                4'hA: q = {pixels[5], pixels[13], pixels[21], pixels[29], pixels[37], pixels[45], pixels[53], pixels[61]};
                4'hB: q = {pixels[4], pixels[12], pixels[20], pixels[28], pixels[36], pixels[44], pixels[52], pixels[60]};
                4'hC: q = {pixels[3], pixels[11], pixels[19], pixels[27], pixels[35], pixels[43], pixels[51], pixels[59]};
                4'hD: q = {pixels[2], pixels[10], pixels[18], pixels[26], pixels[34], pixels[42], pixels[50], pixels[58]};
                4'hE: q = {pixels[1], pixels[9],  pixels[17], pixels[25], pixels[33], pixels[41], pixels[49], pixels[57]};
                4'hF: q = {pixels[0], pixels[8],  pixels[16], pixels[24], pixels[32], pixels[40], pixels[48], pixels[56]};
            endcase
        else
		    case (cnt)
                4'h7: q = {pixels[71], pixels[79], pixels[87], pixels[95], pixels[103], pixels[111], pixels[119], pixels[127]};
                4'h6: q = {pixels[70], pixels[78], pixels[86], pixels[94], pixels[102], pixels[110], pixels[118], pixels[126]};
                4'h5: q = {pixels[69], pixels[77], pixels[85], pixels[93], pixels[101], pixels[109], pixels[117], pixels[125]};
                4'h4: q = {pixels[68], pixels[76], pixels[84], pixels[92], pixels[100], pixels[108], pixels[116], pixels[124]};
                4'h3: q = {pixels[67], pixels[75], pixels[83], pixels[91], pixels[99],  pixels[107], pixels[115], pixels[123]};
                4'h2: q = {pixels[66], pixels[74], pixels[82], pixels[90], pixels[98],  pixels[106], pixels[114], pixels[122]};
                4'h1: q = {pixels[65], pixels[73], pixels[81], pixels[89], pixels[97],  pixels[105], pixels[113], pixels[121]};
                4'h0: q = {pixels[64], pixels[72], pixels[80], pixels[88], pixels[96],  pixels[104], pixels[112], pixels[120]};

                4'hF: q = {pixels[7], pixels[15], pixels[23], pixels[31], pixels[39], pixels[47], pixels[55], pixels[63]};
                4'hE: q = {pixels[6], pixels[14], pixels[22], pixels[30], pixels[38], pixels[46], pixels[54], pixels[62]};
                4'hD: q = {pixels[5], pixels[13], pixels[21], pixels[29], pixels[37], pixels[45], pixels[53], pixels[61]};
                4'hC: q = {pixels[4], pixels[12], pixels[20], pixels[28], pixels[36], pixels[44], pixels[52], pixels[60]};
                4'hB: q = {pixels[3], pixels[11], pixels[19], pixels[27], pixels[35], pixels[43], pixels[51], pixels[59]};
                4'hA: q = {pixels[2], pixels[10], pixels[18], pixels[26], pixels[34], pixels[42], pixels[50], pixels[58]};
                4'h9: q = {pixels[1], pixels[9],  pixels[17], pixels[25], pixels[33], pixels[41], pixels[49], pixels[57]};
                4'h8: q = {pixels[0], pixels[8],  pixels[16], pixels[24], pixels[32], pixels[40], pixels[48], pixels[56]};
            endcase
endmodule
