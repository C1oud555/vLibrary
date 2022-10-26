module sync_fifo_tb;

  logic clk, rst_n;
  logic push, pop, full, empty;
  logic [7:0] i_data, o_data;

  sync_fifo #(
      .DW(8),
      .DP(7)
  ) u_fifo (
      .*
  );

  always #5 clk = ~clk;

  initial begin
    clk   = 0;
    rst_n = 0;
    push = 0;
    pop = 0;
    i_data = '0;

    repeat (2) @(posedge clk);
    rst_n = 1;

    t_push(1);
    t_push(2);
    t_push(3);
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
    @(posedge clk);
    push   = 1;
    i_data = data;
    if (!full) $display("push data %d", data);
    else $display("Full fifo");
    @(posedge clk);
    push = 0;
  endtask

  task t_pop;
    @(posedge clk);
    pop = 1;
    if (empty) $display("Empty fifo");
    else $display("Pop data %d", o_data);
    @(posedge clk);
    pop = 0;
  endtask

  initial begin
      $dumpfile("sync_fifo_tb.vcd");
      $dumpvars;
  end

endmodule
