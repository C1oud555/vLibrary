module async_fifo #(
    parameter DP = 16,
    parameter DW = 8
) (
    input rclk,
    input rrst_n,
    input pop,
    output rempty,
    output [DW-1:0] rdata,

    input wclk,
    input wrst_n,
    input push,
    output wfull,
    input [DW-1:0] wdata
);

  parameter AW = $clog2(DP);

  wire [AW-1:0] waddr, raddr;
  wire [AW:0] wptr, rptr, wq2_rptr, rq2_wptr;

  sync_r2w #(.AW(AW)) u_r2w (.*);
  sync_w2r #(.AW(AW)) u_w2r (.*);

  fifomem #(
      .DW(DW),
      .AW(AW)
  ) u_mem (
      .wclken(push),
      .*
  );

  rptr_empty #(.AW(AW)) u_empty (.*);
  wptr_full #(.AW(AW)) u_full (.*);


endmodule
