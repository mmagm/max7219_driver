module lshift_reg
#(parameter SIZE = 8)
(
    input clk,
    input rst_n,
    input load_en,
    input enable,
    input [SIZE-1:0] value,
    output wire so,
    output wire finished
);
    localparam COUNTER_SIZE = $clog2(SIZE);

    integer i;
    reg [SIZE-1:0] buffer;

    reg [COUNTER_SIZE-1:0] counter;

    always @(posedge clk or negedge rst_n)
        if (~rst_n)
            counter <= {COUNTER_SIZE{1'b0}};
        else if (load_en | (counter == SIZE - 1))
            counter <= {COUNTER_SIZE{1'b0}};
        else if (enable)
            counter <= counter + 1'b1;

    always @(posedge clk or negedge rst_n)
        if (~rst_n)
            buffer <= {SIZE{1'b0}};
        else if (load_en)
            buffer <= value;
        else if (enable) begin
            for (i = 0; i < SIZE - 1; i = i + 1) begin
                buffer[i+1] <= buffer[i];
            end
            buffer[0] <= 1'b0;
        end

    assign so = buffer[SIZE-1];
    assign finished = (counter == SIZE - 1);
endmodule