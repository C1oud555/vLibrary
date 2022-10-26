module async_fifo_tb;

  logic wclk, rrst_n;
  logic rclk, wrst_n;
  logic push, pop, wfull, rempty;
  logic [7:0] wdata, rdata;

  async_fifo #(
      .DW(8),
      .DP(64)
  ) u_fifo (
      .*
  );

  always #7 wclk = ~wclk;
  always #13 rclk = ~rclk;

  initial begin
    wclk = 0;
    rclk = 0;
    wrst_n = 0;
    rrst_n = 0;
    push = 0;
    pop = 0;
    wdata = '0;

    repeat (2) @(posedge rclk);
    wrst_n = 1;
    rrst_n = 1;

    for (int i = 0; i < 100; i++)
    fork
      begin
        t_push(i);
        t_push(i + 2);
      end
      #20;
      t_pop();
    join

    t_push(1);
    t_push(2);
    t_push(3);
    t_push(4);
    t_push(5);
    t_push(6);
    t_push(7);
    t_push(8);
    t_push(4);
    t_pop();
    t_pop();
    t_push(5);
    t_push(6);
    t_pop();
    t_push(7);
    t_push(8);
    t_pop();
    t_pop();
    t_pop();
    t_push(9);
    t_push(10);
    t_push(11);

    t_pop();
    t_pop();
    t_pop();
    t_pop();
    t_pop();
    t_pop();
    t_pop();
    t_pop();
    t_pop();
    t_pop();
    t_pop();
    t_pop();

    $finish();
  end

  task t_push(logic [7:0] data);
    @(posedge wclk);
    push  = 1;
    wdata = data;
    if (!wfull) $display("push data %d", data);
    else $display("Full fifo");
    @(posedge wclk);
    push = 0;
  endtask

  task t_pop;
    @(posedge rclk);
    #1 pop = 1;
    @(posedge rclk);
    if (rempty) $display("Empty fifo");
    else $display("Pop data %d", rdata);
    pop = 0;
  endtask

  initial begin
    $dumpfile("sync_fifo_tb.vcd");
    $dumpvars;
  end

endmodule
