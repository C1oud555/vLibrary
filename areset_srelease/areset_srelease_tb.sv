module areset_srelease_tb;

  logic clk, i_rst, o_rst;
  areset_srelease u_dut(.*);

  initial begin
    clk = 0;
    i_rst = 0;
    @(posedge clk) i_rst = 1;

    repeat(5) @(posedge clk);
    #3 i_rst = 0;
    #4 i_rst = 1;

    repeat(3) @(posedge clk);
    #7 i_rst = 0;
    #3 i_rst = 1;

    repeat(10) @(posedge clk);

    $finish;
  end

  always #5 clk = ~clk;

  initial begin
      $dumpfile("areset_srelease_tb.vcd");
      $dumpvars;
  end
endmodule
