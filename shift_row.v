module shift_row
(
   input clk,
   input rst_n,
   input en,
   input dir,
   input [7:0] d,
   output reg [127:0] out
);

    always @(posedge clk)
        if (!rst_n)
            out <= 0;
        else begin
            if (en)
                case (dir)
                    0:  out <= {out[119:0], d};
                    1:  out <= {d, out[127:8]};
                endcase
            else
                out <= out;
        end
endmodule
