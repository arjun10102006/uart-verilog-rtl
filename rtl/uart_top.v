module uart_top(
    input clk,
    input reset,
    input start,
    input [7:0] data_in,
    output [7:0] data_out,
    output done
);

wire baud_tick;
wire tx;
wire rx;

assign rx = tx;

baud_gen bg (
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick)
);

uart_tx tx_inst (
    .clk(clk),
    .reset(reset),
    .start(start),
    .baud_tick(baud_tick),
    .data_in(data_in),
    .tx(tx),
    .done()
);

uart_rx rx_inst (
    .clk(clk),
    .reset(reset),
    .rx(rx),
    .baud_tick(baud_tick),
    .data_out(data_out),
    .done(done)
);

endmodule
