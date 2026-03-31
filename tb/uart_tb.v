`timescale 1ns/1ns
module uart_tb;

reg clk = 0;
reg reset = 1;
reg start = 0;
reg [7:0] data_in = 8'b10110011;

wire [7:0] data_out;
wire done;

// clock
always #5 clk = ~clk;

uart_top uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .data_in(data_in),
    .data_out(data_out),
    .done(done)
);

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_tb);

    #10 reset = 0;

    #20 start = 1;
    #200 start = 0;

    #300000 $finish;
end

endmodule
