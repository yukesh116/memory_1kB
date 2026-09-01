`timescale 1ns/1ns
module mem_1kB_tb;
    reg clk;
    reg rst;
    reg  wr;
    reg [7:0]  data_in;
    reg [9:0]  address;
    wire [7:0] data_out;
    // DUT
    mem_1kB uut (
        .clk      (clk),
        .rst      (rst),
        .wr       (wr),
        .data_in  (data_in),
        .address  (address),
        .data_out (data_out)
    );

    // CLOCK GENERATION  Period = 10 ns

    initial begin
        clk = 0;

        forever #5 clk = ~clk;
    end

    initial begin
        // INITIAL VALUES

        rst     = 1;
        wr      = 0;
        data_in = 8'd0;
        address = 10'd0;

        // RESET
        @(negedge clk);
        rst = 1;
        @(posedge clk);
        // $strobe prints AFTER NBA update
        $strobe("%0t ns : RESET      : data_out = %0d", $time, data_out);

        // RELEASE RESET

        @(negedge clk);
        rst = 0;

        // WRITE 10 TO ADDRESS 103

        @(negedge clk);
        wr      = 1;
        address = 10'd103;
        data_in = 8'd10;
        @(posedge clk);
        $strobe("%0t ns : WRITE      : address = %0d, data = %0d",  $time, address, data_in);

        // WRITE 134 TO ADDRESS 104
        @(negedge clk);
        wr      = 1;
        address = 10'd104;
        data_in = 8'd134;
        @(posedge clk);
        $strobe("%0t ns : WRITE      : address = %0d, data = %0d",  $time, address, data_in);

        // READ ADDRESS 103
        // Expected: 10
    
        @(negedge clk);
        wr      = 0;
        address = 10'd103;
        @(posedge clk);
        $strobe("%0t ns : READ       : address = %0d, data_out = %0d", $time, address, data_out);

        // READ ADDRESS 3
        // Expected: X
        // Because address 3 was never written
        @(negedge clk);
        wr      = 0;
        address = 10'd3;
        @(posedge clk);
        $strobe("%0t ns : READ       : address = %0d, data_out = %0d", $time, address, data_out);

        // WRITE 102 TO ADDRESS 103
        @(negedge clk);
        wr      = 1;
        address = 10'd103;
        data_in = 8'd102;
        @(posedge clk);
        $strobe("%0t ns : WRITE      : address = %0d, data = %0d",  $time, address, data_in);

        // READ ADDRESS 103 AGAIN
        // Expected: 102

        @(negedge clk);
        wr      = 0;
        address = 10'd103;
        @(posedge clk);
        $strobe("%0t ns : READ       : address = %0d, data_out = %0d", $time, address, data_out);
         
        // FINISH
        #10;
        $finish;
        end
        initial begin
        $dumpfile("mem_1kB_tb.vcd");
        $dumpvars(0, mem_1kB_tb);
        end
endmodule