module uart_rx (
    input            clk,
    input            reset,
    input            rx,
    input            baud_tick_16x,
    output reg [7:0] data_out,
    output reg       done
);

localparam IDLE  = 2'd0,
           START = 2'd1,
           DATA  = 2'd2,
           STOP  = 2'd3;

reg [1:0] state;
reg [7:0] shift_reg;
reg [3:0] bit_cnt;
reg [3:0] sample_cnt;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state      <= IDLE;
        bit_cnt    <= 0;
        sample_cnt <= 0;
        shift_reg  <= 8'h00;
        data_out   <= 8'h00;
        done       <= 0;
    end else begin

        done <= 0;

        case (state)

        IDLE: begin
            sample_cnt <= 0;
            bit_cnt    <= 0;
            if (rx == 0)
                state <= START;
        end

        START: begin
            if (baud_tick_16x) begin
                if (sample_cnt == 4'd7) begin
                    sample_cnt <= 0;
                    if (rx == 0)
                        state <= DATA;
                    else
                        state <= IDLE;
                end else
                    sample_cnt <= sample_cnt + 1;
            end
        end

        DATA: begin
            if (baud_tick_16x) begin
                if (sample_cnt == 4'd15) begin
                    sample_cnt         <= 0;
                    shift_reg[bit_cnt] <= rx;
                    bit_cnt            <= bit_cnt + 1;
                    if (bit_cnt == 4'd7)
                        state <= STOP;
                end else
                    sample_cnt <= sample_cnt + 1;
            end
        end

        STOP: begin
            if (baud_tick_16x) begin
                if (sample_cnt == 4'd15) begin
                    sample_cnt <= 0;
                    if (rx == 1) begin
                        data_out <= shift_reg;
                        done     <= 1;
                    end
                    state <= IDLE;
                end else
                    sample_cnt <= sample_cnt + 1;
            end
        end

        endcase
    end
end

endmodule
