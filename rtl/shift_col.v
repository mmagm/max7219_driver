module shift_col
(
   input clk,
   input rst_n,
   input en,
   input dir,
   input [7:0] d,
   output reg [7:0] ex,
   output [63:0] out
);

    reg [63:0] pixels;
    reg [63:0] next_out;

    always @(posedge clk)
        if (!rst_n)
            pixels <= 0;
        else if (en)
            pixels <= next_out;

    always @* begin
        case (dir)
            0: begin
                next_out = {{pixels[62:56], d[7]},
                            {pixels[54:48], d[6]},
                            {pixels[46:40], d[5]},
                            {pixels[38:32], d[4]},
                            {pixels[30:24], d[3]},
                            {pixels[22:16], d[2]},
                            {pixels[14:8],  d[1]},
                            {pixels[6:0],   d[0]}};
                ex = {pixels[63], pixels[55], pixels[47], pixels[39], pixels[31], pixels[23], pixels[15], pixels[7]};
            end
            1: begin
                next_out = {{d[7], pixels[63:57]},
                            {d[6], pixels[55:49]},
                            {d[5], pixels[47:41]},
                            {d[4], pixels[39:33]},
                            {d[3], pixels[31:25]},
                            {d[2], pixels[23:17]},
                            {d[1], pixels[15:9]},
                            {d[0], pixels[7:1]}};
                ex = {pixels[56], pixels[48], pixels[40], pixels[32], pixels[24], pixels[16], pixels[8], pixels[0]};
            end
        endcase
    end

    assign out = pixels;
endmodule
