module shift_col
(
   input clk,
   input rst_n,
   input en,
   input dir,
   input [7:0] d,
   output [127:0] out
);

    reg [127:0] pixels;
    reg [127:0] next_out;

    always @(posedge clk)
        if (!rst_n)
            pixels <= 0;
        else begin
            if (en)
                pixels <= next_out;
            else
                pixels <= pixels;
        end

    always @* begin
        case (dir)
            0: begin
                next_out = {{pixels[126:120],d[7]},
                            {pixels[118:112],d[6]},
                            {pixels[110:104],d[5]},
                            {pixels[102:96], d[4]},
                            {pixels[94:88],  d[3]},
                            {pixels[86:80],  d[2]},
                            {pixels[78:72],  d[1]},
                            {pixels[70:64],  d[0]},
                            {pixels[62:56], pixels[127]},
                            {pixels[54:48], pixels[119]},
                            {pixels[46:40], pixels[111]},
                            {pixels[38:32], pixels[103]},
                            {pixels[30:24], pixels[95]},
                            {pixels[22:16], pixels[87]},
                            {pixels[14:8],  pixels[79]},
                            {pixels[6:0],   pixels[71]}};
            end
            1: begin
                next_out = {{d[7], pixels[127:121]},
                            {d[6], pixels[119:113]},
                            {d[5], pixels[111:105]},
                            {d[4], pixels[103:97]},
                            {d[3], pixels[95:89]},
                            {d[2], pixels[87:81]},
                            {d[1], pixels[79:73]},
                            {d[0], pixels[71:65]},
                            {pixels[120], pixels[63:57]},
                            {pixels[112], pixels[55:49]},
                            {pixels[104], pixels[47:41]},
                            {pixels[96],  pixels[39:33]},
                            {pixels[88],  pixels[31:25]},
                            {pixels[80],  pixels[23:17]},
                            {pixels[72],  pixels[15:9]},
                            {pixels[64],  pixels[7:1]}};
            end
        endcase
    end

    assign out = pixels;
endmodule
