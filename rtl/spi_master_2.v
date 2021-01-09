module spi_master_2(
    input sck, 
    input rst_n, 
    input [15:0] address,
    input [15:0] data,
    output finish,
    output reg mosi, cs
);

    localparam  START = 6'd0,
                A01 = 6'd1,
                A02 = 6'd2,
                A03 = 6'd3,
                A04 = 6'd4,
                A05 = 6'd5,
                A06 = 6'd6,
                A07 = 6'd7,
                A08 = 6'd8,
                D01 = 6'd9,
                D02 = 6'd10,
                D03 = 6'd11,
                D04 = 6'd12,
                D05 = 6'd13,
                D06 = 6'd14,
                D07 = 6'd15,
                D08 = 6'd16,
                A11 = 6'd17,
                A12 = 6'd18,
                A13 = 6'd19,
                A14 = 6'd20,
                A15 = 6'd21,
                A16 = 6'd22,
                A17 = 6'd23,
                A18 = 6'd24,
                D11 = 6'd25,
                D12 = 6'd26,
                D13 = 6'd27,
                D14 = 6'd28,
                D15 = 6'd29,
                D16 = 6'd30,
                D17 = 6'd31,
                D18 = 6'd32,                
                FINISH = 6'd33;

    reg [5:0] state, nextState;

    always @(posedge sck or negedge rst_n)
        if (~rst_n)
            state <= START;
        else
            state <= nextState;

    always @*
        case(state)
            START: nextState = A01;
            A01: nextState = A02;
            A02: nextState = A03;
            A03: nextState = A04;
            A04: nextState = A05;
            A05: nextState = A06;
            A06: nextState = A07;
            A07: nextState = A08;
            A08: nextState = D01;
            D01: nextState = D02;
            D02: nextState = D03;
            D03: nextState = D04;
            D04: nextState = D05;
            D05: nextState = D06;
            D06: nextState = D07;
            D07: nextState = D08;
            D08: nextState = A11;
            A11: nextState = A12;
            A12: nextState = A13;
            A13: nextState = A14;
            A14: nextState = A15;
            A15: nextState = A16;
            A16: nextState = A17;
            A17: nextState = A18;
            A18: nextState = D11;
            D11: nextState = D12;
            D12: nextState = D13;
            D13: nextState = D14;
            D14: nextState = D15;
            D15: nextState = D16;
            D16: nextState = D17;
            D17: nextState = D18;
            D18: nextState = FINISH;
            FINISH: nextState = START;
        endcase

    wire [31:0] buffer = {address[15:8], data[15:8], address[7:0], data[7:0]};

    always @* begin
        cs = 0;
        case(state)
            START: begin mosi = 0; cs = 0; end
            A01: begin mosi = buffer[31]; cs = 0; end
            A02: begin mosi = buffer[30]; cs = 0; end
            A03: begin mosi = buffer[29]; cs = 0; end
            A04: begin mosi = buffer[28]; cs = 0; end
            A05: begin mosi = buffer[27]; cs = 0; end
            A06: begin mosi = buffer[26]; cs = 0; end
            A07: begin mosi = buffer[25]; cs = 0; end
            A08: begin mosi = buffer[24]; cs = 0; end
            D01: begin mosi = buffer[23]; cs = 0; end
            D02: begin mosi = buffer[22]; cs = 0; end
            D03: begin mosi = buffer[21]; cs = 0; end
            D04: begin mosi = buffer[20]; cs = 0; end
            D05: begin mosi = buffer[19]; cs = 0; end
            D06: begin mosi = buffer[18]; cs = 0; end
            D07: begin mosi = buffer[17]; cs = 0; end
            D08: begin mosi = buffer[16]; cs = 0; end
            A11: begin mosi = buffer[15]; cs = 0; end
            A12: begin mosi = buffer[14]; cs = 0; end
            A13: begin mosi = buffer[13]; cs = 0; end
            A14: begin mosi = buffer[12]; cs = 0; end
            A15: begin mosi = buffer[11]; cs = 0; end
            A16: begin mosi = buffer[10]; cs = 0; end
            A17: begin mosi = buffer[9]; cs = 0; end
            A18: begin mosi = buffer[8]; cs = 0; end
            D11: begin mosi = buffer[7]; cs = 0; end
            D12: begin mosi = buffer[6]; cs = 0; end
            D13: begin mosi = buffer[5]; cs = 0; end
            D14: begin mosi = buffer[4]; cs = 0; end
            D15: begin mosi = buffer[3]; cs = 0; end
            D16: begin mosi = buffer[2]; cs = 0; end
            D17: begin mosi = buffer[1]; cs = 0; end
            D18: begin mosi = buffer[0]; cs = 0; end
            FINISH: begin mosi = 0; cs = 1; end
        endcase
    end

    assign finish = (state == FINISH);
endmodule
