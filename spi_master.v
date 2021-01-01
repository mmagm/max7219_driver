module spi_master(
    input sck, 
    input rst_n, 
    input [7:0] address,
    input [7:0] data,
    output finish,
    output reg mosi, cs
);

    localparam  START = 5'd0,
                A1 = 5'd1,
                A2 = 5'd2,
                A3 = 5'd3,
                A4 = 5'd4,
                A5 = 5'd5,
                A6 = 5'd6,
                A7 = 5'd7,
                A8 = 5'd8,
                D1 = 5'd9,
                D2 = 5'd10,
                D3 = 5'd11,
                D4 = 5'd12,
                D5 = 5'd13,
                D6 = 5'd14,
                D7 = 5'd15,
                D8 = 5'd16,
                FINISH = 5'd17;

    reg [4:0] state, nextState;

    always @(posedge sck or negedge rst_n)
        if (~rst_n)
            state <= START;
        else
            state <= nextState;

    always @*
        case(state)
            START: nextState = A1;
            A1: nextState = A2;
            A2: nextState = A3;
            A3: nextState = A4;
            A4: nextState = A5;
            A5: nextState = A6;
            A6: nextState = A7;
            A7: nextState = A8;
            A8: nextState = D1;
            D1: nextState = D2;                
            D2: nextState = D3;
            D3: nextState = D4;
            D4: nextState = D5;
            D5: nextState = D6;
            D6: nextState = D7;
            D7: nextState = D8;
            D8: nextState = FINISH;
            FINISH: nextState = START;
        endcase

    wire [15:0] buffer = {address, data};

    always @* begin
        cs = 0;
        case(state)
            START: begin mosi = 0; cs = 0; end
            A1: begin mosi = buffer[15]; cs = 0; end
            A2: begin mosi = buffer[14]; cs = 0; end
            A3: begin mosi = buffer[13]; cs = 0; end
            A4: begin mosi = buffer[12]; cs = 0; end
            A5: begin mosi = buffer[11]; cs = 0; end
            A6: begin mosi = buffer[10]; cs = 0; end
            A7: begin mosi = buffer[9]; cs = 0; end
            A8: begin mosi = buffer[8]; cs = 0; end
            D1: begin mosi = buffer[7]; cs = 0; end
            D2: begin mosi = buffer[6]; cs = 0; end
            D3: begin mosi = buffer[5]; cs = 0; end
            D4: begin mosi = buffer[4]; cs = 0; end
            D5: begin mosi = buffer[3]; cs = 0; end
            D6: begin mosi = buffer[2]; cs = 0; end
            D7: begin mosi = buffer[1]; cs = 0; end
            D8: begin mosi = buffer[0]; cs = 0; end
            FINISH: begin mosi = 0; cs = 1; end
        endcase
    end

    assign finish = (state == FINISH);
endmodule
