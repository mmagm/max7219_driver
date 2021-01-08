module tb;
    reg [0:7] addr;

    initial begin
        // addr[0] = 1;
        // addr[1] = 0;
        // addr[2] = 1;
        // addr[3] = 0;
        // addr[4] = 1;
        // addr[5] = 0;
        // addr[6] = 1;
        // addr[7] = 0;

        addr = 8'ha2;

        $display("%b", addr);
    end
endmodule
