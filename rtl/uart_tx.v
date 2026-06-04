module uart_tx (
    input        clk,
    input        reset,
    input        start,
    input        baud_tick,
    input  [7:0] data_in,
    output reg   tx,
    output reg   done
);

reg [3:0] bit_cnt;
reg [9:0] shift_full;
reg       busy;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        tx         <= 1'b1;
        done       <= 1'b0;
        bit_cnt    <= 4'd0;
        busy       <= 1'b0;
        shift_full <= 10'h3FF;
    end else begin

        done <= 1'b0;

        if (start && !busy) begin
            shift_full <= {1'b1, data_in, 1'b0};
            busy       <= 1'b1;
            bit_cnt    <= 4'd0;
        end

        else if (busy && baud_tick) begin
            if (bit_cnt == 4'd9) begin
                tx   <= 1'b1;
                busy <= 1'b0;
                done <= 1'b1;
            end else begin
                tx         <= shift_full[0];
                shift_full <= {1'b1, shift_full[9:1]};
                bit_cnt    <= bit_cnt + 1;
            end
        end

    end
end

endmodule
