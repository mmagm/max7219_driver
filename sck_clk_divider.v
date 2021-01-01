`ifdef ICARUS
    `include "register.v"
`endif

module sck_clk_divider
(
    input clk,
    input rst_n,
    output sck,
    output sck_edge
);
    localparam tick_count = 4;

    localparam DOWN_SIZE = tick_count;
    localparam UP_SIZE = tick_count - 1;

    localparam  S_DOWN = 2'd0,
                S_EDGE = 2'd1,
                S_UP = 2'd2;

    wire [1:0] state;
    reg [1:0] nextState;

    register #(.SIZE(2)) state_reg_inst
    (
        .clk(clk),
        .rst_n(rst_n),
        .d(nextState),
        .q(state)
    );

    wire [31:0] cnt;
    reg [31:0] nextCnt;

    register #(.SIZE(32)) cnt_reg_inst
    (
        .clk(clk),
        .rst_n(rst_n),
        .d(nextCnt),
        .q(cnt)
    );

    always @* begin
        nextState = state;
        case (state)
            S_DOWN: if (cnt == DOWN_SIZE) nextState = S_EDGE;
            S_EDGE: nextState = S_UP;
            S_UP: if (cnt == UP_SIZE) nextState = S_DOWN;
				default: nextState = state;
        endcase
    end

    always @* begin
        nextCnt = cnt + 1'b1;
        case (state)
            S_DOWN: if (cnt == DOWN_SIZE) nextCnt = 0;
            S_EDGE: nextCnt = 0;
            S_UP: if (cnt == UP_SIZE) nextCnt = 0;
				default: nextCnt = cnt + 1'b1;
        endcase
    end

    assign sck = (state != S_DOWN);
    assign sck_edge = (state == S_EDGE);
endmodule