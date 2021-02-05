// `include "lshift_reg.v"

module max7219_spi
#(parameter SIZE = 2)
(
    input clk,
    input rst_n,
    input [8*SIZE-1:0] address,
    input [8*SIZE-1:0] data,
    input start,
    output finished,
    output reg mosi, cs
);
    reg [16*SIZE-1:0] buffer;
    reg load_en;
    reg enable;
    wire out;

    lshift_reg #(.SIZE(16*SIZE)) lshift_reg_inst
    (
        .clk(clk),
        .rst_n(rst_n),
        .load_en(load_en),
        .enable(enable),
        .value(buffer),
        .so(out),
        .finished(finished)
    );

    // SIZE = 2
    // buffer[31:0]
    // address[15:0]
    // data[15:0]
    // buffer = {address[15:8], data[15:8], address[7:0], data[7:0]}
    integer i;
    always @* begin
        for (i = 0; i < SIZE; i = i + 1) begin
            // i = 0
            // buffer[31:24] = address[15:8]
            // buffer[23:16] = data[15:8]

            // i = 1
            // buffer[15:8] = address[7:0]
            // buffer[7:0] = data[7:0]

            // i = 0, ii = 2
            // buffer[2 * 16 - 1 -: 8] = buffer[31:24]
            // buffer[2 * 16 - 8 - 1 -: 8] = buffer[23:16]

            // i = 1, ii = 1
            // buffer[16 - 1 -: 8] = buffer[15:8]
            // buffer[16 - 8 - 1 -: 8] = buffer[7:0]

            // i = 0, ii = 1
            // address[8 + 8 - 1 -: 8] = address[15:8]
            // data[8 + 8 - 1 -: 8] = data[15:8]

            // i = 1, ii = 0
            // address[8 - 1 -: 8] = address[7:0]
            // data[8 - 1 -: 8] = data[7:0]

            buffer[(SIZE - i) * 16 - 1 -: 8] = address[(SIZE - i - 1) * 8 + 8 - 1 -: 8];
            buffer[(SIZE - i) * 16 - 8 - 1 -: 8] = data[(SIZE - i - 1) * 8 + 8 - 1 -: 8];
        end
    end

    // fsm
    localparam  IDLE   = 2'b00,
                START  = 2'b01,
                SEND   = 2'b10,
                FINISH = 2'b11;

    reg [1:0] state, nextState;

    always @(posedge clk or negedge rst_n)
        if (~rst_n)
            state <= IDLE;
        else
            state <= nextState;

    always @* begin
        nextState = state;
        cs = 1;
        load_en = 0;
        mosi = 0;
        enable = 0;

        case (state)
            IDLE: begin
                cs = 1;
                load_en = 0;
                mosi = 0;
                if (start)
                    nextState = START;
            end
            START: begin
                nextState = SEND;
                mosi = 0;
                cs = 1;
                load_en = 1;
                enable = 0;
            end
            SEND: begin
                cs = 0;
                load_en = 0;
                mosi = out;
                enable = 1;
                if (finished)
                    nextState = FINISH;
            end
            FINISH: begin
               cs = 1;
               mosi = 0;
               load_en = 0;
               enable = 0;
               nextState = START;
            end
            default: begin
                nextState = IDLE;
            end
        endcase
    end
endmodule
