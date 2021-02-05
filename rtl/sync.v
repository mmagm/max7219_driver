module sync(
    input clk,
    input sw,
    output wire synced
);
    reg [1:0] sync_reg;

    always @(posedge clk)
    begin
        sync_reg[0] <= sw;
        sync_reg[1] <= sync_reg[0];
    end

    assign synced = sync_reg[1];
endmodule
