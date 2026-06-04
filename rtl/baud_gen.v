module baud_gen #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 9600
)(
    input  clk,
    input  reset,
    output reg baud_tick,
    output reg baud_tick_16x
);

localparam integer DIVIDER     = CLK_FREQ / BAUD_RATE;
localparam integer DIVIDER_16X = CLK_FREQ / (BAUD_RATE * 16);

reg [15:0] counter;
reg [8:0] counter_16x;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter   <= 0;
        baud_tick <= 0;
    end else begin
        if (counter == DIVIDER - 1) begin
            counter   <= 0;
            baud_tick <= 1;
        end else begin
            counter   <= counter + 1;
            baud_tick <= 0;
        end
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter_16x   <= 0;
        baud_tick_16x <= 0;
    end else begin
        if (counter_16x == DIVIDER_16X - 1) begin
            counter_16x   <= 0;
            baud_tick_16x <= 1;
        end else begin
            counter_16x   <= counter_16x + 1;
            baud_tick_16x <= 0;
        end
    end
end

endmodule
