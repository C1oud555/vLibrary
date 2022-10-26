// use 
module sync_fifo #(
    parameter DW = 8,
    parameter DP = 8
) (
    input clk,
    input rst_n,

    input push,
    input [DW-1:0] i_data,
    output full,

    input pop,
    output [DW-1:0] o_data,
    output empty
);

  /*----------------------------*
   *---     Parameters       ---*
   *----------------------------*/
  parameter AW = $clog2(DP);

  /*-------------------------*
   *---     Outputs       ---*
   *-------------------------*/
  assign empty  = cnt == '0;
  assign full   = cnt == DP;
  assign o_data = mem[rd_ptr];

  /*---------------------------*
   *---     Registers       ---*
   *---------------------------*/
  reg [DW-1:0] mem[DP];
  reg [AW:0] cnt;
  reg [AW-1:0] wr_ptr;
  reg [AW-1:0] rd_ptr;

  /*----------------------------*
   *---     cnt handle       ---*
   *----------------------------*/
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) wr_ptr <= '0;
    else if (push & ~full) wr_ptr <= (wr_ptr == DP - 1) ? '0 : (wr_ptr + 1'b1);
  end
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) rd_ptr <= '0;
    else if (pop & ~empty) rd_ptr <= (rd_ptr == DP - 1) ? '0 : (rd_ptr + 1'b1);
  end
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) cnt <= '0;
    else begin
      if (push && !pop && !full) cnt <= cnt + 1'b1;
      else if (!push && pop && !empty) cnt <= cnt - 1'b1;
      // no pop or push
      // pop and push in the same cycle
      // else cnt <= cnt;
    end
  end

  /*----------------------------*
   *---     Write data       ---*
   *----------------------------*/
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) for (int i = 0; i < DP; i++) mem[i] <= '0;
    else begin
      if (push & ~full) mem[wr_ptr] <= i_data;
    end
  end

endmodule
