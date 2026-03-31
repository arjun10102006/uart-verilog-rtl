module uart_rx(
    input clk,
    input reset,
    input rx,
    input baud_tick,
    output reg [7:0] data_out,
    output reg done
);

reg [2:0] state;
reg [7:0] shift_reg;
reg [3:0] bit_cnt;

parameter IDLE=0, START=1, DATA=2, STOP=3;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        bit_cnt <= 0;
        done <= 0;
    end else begin
        case(state)

        IDLE: begin
            done <= 0;
            if (rx == 0) state <= START;
        end

        START: if (baud_tick) begin
            state <= DATA;
            bit_cnt <= 0;
        end

        DATA: if (baud_tick) begin
            shift_reg[bit_cnt] <= rx;
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == 7) state <= STOP;
        end

        STOP: if (baud_tick) begin
            if (rx == 1) begin
                data_out <= shift_reg;
                done <= 1;
            end
            state <= IDLE;
        end

        endcase
    end
end

endmodule
