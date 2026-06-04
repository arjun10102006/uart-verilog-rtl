`timescale 1ns/1ps

module uart_tb;

localparam CLK_FREQ  = 50_000_000;
localparam BAUD_RATE = 9600;

reg        clk     = 0;
reg        reset   = 1;
reg        start   = 0;
reg  [7:0] data_in = 8'h00;

wire [7:0] data_out;
wire       rx_done;
wire       tx_done;

always #10 clk = ~clk;

uart_top #(
    .CLK_FREQ (CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) uut (
    .clk     (clk),
    .reset   (reset),
    .start   (start),
    .data_in (data_in),
    .data_out(data_out),
    .rx_done (rx_done),
    .tx_done (tx_done)
);

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_tb);
end

reg [7:0] expected;
integer   test_num = 0;

always @(posedge clk) begin
    if (rx_done) begin
        test_num = test_num + 1;
        if (data_out === expected)
            $display("[%0t ns] TEST %0d PASS: sent 0x%02X, received 0x%02X",
                     $time, test_num, expected, data_out);
        else
            $display("[%0t ns] TEST %0d FAIL: sent 0x%02X, received 0x%02X",
                     $time, test_num, expected, data_out);
    end
end

always @(posedge clk) begin
    if (tx_done)
        $display("[%0t ns] TX DONE", $time);
end

initial begin
    reset = 1;
    repeat(2) @(posedge clk);
    #20 reset = 0;
    @(posedge clk);

    // Test 1: send 0xB3
    $display("[%0t ns] Sending byte 1: 0xB3", $time);
    expected = 8'hB3;
    data_in  = 8'hB3;
    @(posedge clk); #1 start = 1;
    @(posedge clk); #1 start = 0;

    // Wait for tx_done using polling loop (Verilog-compatible)
    wait(tx_done == 1);
    @(posedge clk);

    // Test 2: send 0xA5
    $display("[%0t ns] Sending byte 2: 0xA5", $time);
    expected = 8'hA5;
    data_in  = 8'hA5;
    @(posedge clk); #1 start = 1;
    @(posedge clk); #1 start = 0;

    // Wait for rx_done using polling loop (Verilog-compatible)
    wait(rx_done == 1);
    @(posedge clk);

    #500_000;
    $display("[%0t ns] Simulation complete.", $time);
    $finish;
end

// Safety timeout
initial begin
    #3_500_000;
    $display("[%0t ns] TIMEOUT", $time);
    $finish;
end

endmodule
