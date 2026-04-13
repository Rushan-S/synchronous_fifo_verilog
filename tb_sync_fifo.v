`timescale 1ns/1ps

module fifo_tb;

reg clk, rst;
reg w_en, r_en;
reg [7:0] in;

wire [7:0] out;
wire empty, full, almost_full, almost_empty;

fifo uut(.clk(clk), .rst(rst), .w_en(w_en), .r_en(r_en),
         .in(in), .out(out), .empty(empty), .full(full),
         .almost_full(almost_full), .almost_empty(almost_empty));

always #5 clk = ~clk;

integer i;

initial begin
    clk = 0; rst = 1; w_en = 0; r_en = 0; in = 0;
    #20; rst = 0;
    #10;

    // write 10 values
    $display("===== WRITE 10 VALUES =====");
    for(i = 1; i <= 10; i = i+1) begin
        @(negedge clk);
        w_en = 1; r_en = 0; in = i;
        @(posedge clk); #1;
        $display("T=%0t | in=%0d out=%0d | w_en=%b r_en=%b | count=%0d | empty=%b full=%b",
                  $time, in, out, w_en, r_en, uut.counter, empty, full);
        w_en = 0;
    end

    // read them back
    $display("\n===== READ 10 VALUES =====");
    for(i = 0; i < 10; i = i+1) begin
        @(negedge clk);
        r_en = 1; w_en = 0;
        @(posedge clk); #1;
        $display("T=%0t | in=%0d out=%0d | w_en=%b r_en=%b | count=%0d | empty=%b full=%b",
                  $time, in, out, w_en, r_en, uut.counter, empty, full);
        r_en = 0;
    end

    // simultaneous read and write
    $display("\n===== SIMULTANEOUS READ & WRITE =====");
    for(i = 11; i <= 20; i = i+1) begin
        @(negedge clk);
        w_en = 1; r_en = 1; in = i;
        @(posedge clk); #1;
        $display("T=%0t | in=%0d out=%0d | w_en=%b r_en=%b | count=%0d | empty=%b full=%b",
                  $time, in, out, w_en, r_en, uut.counter, empty, full);
    end
    w_en = 0; r_en = 0;

    //  checking for full and almost_full
    $display("\n==== FILL FIFO (CHECK FULL) =====");
    for(i = 21; i <= 60; i = i+1) begin
        @(negedge clk);
        w_en = 1; r_en = 0; in = i;
        @(posedge clk); #1;
        $display("T=%0t | in=%0d out=%0d | w_en=%b r_en=%b | count=%0d | empty=%b full=%b",
                  $time, in, out, w_en, r_en, uut.counter, empty, full);
        w_en = 0;
    end

    //  checking for  empty and almost_empty
    $display("\n==== EMPTY FIFO (CHECK EMPTY) =====");
    for(i = 0; i < 40; i = i+1) begin
        @(negedge clk);
        r_en = 1; w_en = 0;
        @(posedge clk); #1;
        $display("T=%0t | in=%0d out=%0d | w_en=%b r_en=%b | count=%0d | empty=%b full=%b",
                  $time, in, out, w_en, r_en, uut.counter, empty, full);
        r_en = 0;
    end

    $display("\n===== SIMULATION COMPLETE =====\n");
    #20; $stop;
end

initial begin
    $dumpfile("fifo_tb.vcd");
    $dumpvars(0, fifo_tb);
end

endmodule
