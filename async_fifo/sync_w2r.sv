module sync_w2r #(
    parameter AW = 4
) (
    output reg [AW:0] rq2_wptr,
    input [AW:0] wptr,
    input rclk,
    input rrst_n
);

  reg [AW:0] rq1_wptr;

  always_ff @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) begin
      rq1_wptr <= '0;
      rq2_wptr <= '0;
    end else begin
      rq1_wptr <= wptr;
      rq2_wptr <= rq1_wptr;
    end
  end

endmodule
