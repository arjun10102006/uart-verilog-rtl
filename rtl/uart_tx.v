module uart_tx(
    input clk,
    input reset,
    input start,
    input baud_tick,
    input [7:0] data_in,
    output reg tx,
    output reg done
);

reg [3:0] bit_cnt;
reg [9:0] shift_full;  // includes start + data + stop
reg busy;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        tx <= 1;
        done <= 0;
        bit_cnt <= 0;
        busy <= 0;
    end else begin

        if (start && !busy) begin
            // load full frame: start + data + stop
            shift_full <= {1'b1, data_in, 1'b0}; 
            // {stop, data[7:0], start}
            busy <= 1;
            bit_cnt <= 0;
            done <= 0;
        end

        else if (busy && baud_tick) begin
            tx <= shift_full[0];
            shift_full <= shift_full >> 1;
            bit_cnt <= bit_cnt + 1;

            if (bit_cnt == 9) begin
                busy <= 0;
                done <= 1;
                tx <= 1;
            end
        end

    end
end

endmodule
