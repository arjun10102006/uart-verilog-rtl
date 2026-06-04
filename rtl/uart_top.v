module uart_top #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 9600
)(
    input        clk,
    input        reset,
    input        start,
    input  [7:0] data_in,
    output [7:0] data_out,
    output       rx_done,
    output       tx_done
);

wire baud_tick;
wire baud_tick_16x;
wire tx;
wire rx;

assign rx = tx;

baud_gen #(
    .CLK_FREQ (CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) bg (
    .clk          (clk),
    .reset        (reset),
    .baud_tick    (baud_tick),
    .baud_tick_16x(baud_tick_16x)
);

uart_tx tx_inst (
    .clk      (clk),
    .reset    (reset),
    .start    (start),
    .baud_tick(baud_tick),
    .data_in  (data_in),
    .tx       (tx),
    .done     (tx_done)
);

uart_rx rx_inst (
    .clk          (clk),
    .reset        (reset),
    .rx           (rx),
    .baud_tick_16x(baud_tick_16x),
    .data_out     (data_out),
    .done         (rx_done)
);

endmodule
