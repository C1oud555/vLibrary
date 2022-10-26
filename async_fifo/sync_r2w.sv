module sync_r2w #(
    parameter AW = 4
) (
    output reg [AW:0] wq2_rptr,
    input [AW:0] rptr,
    input wclk,
    input wrst_n
);

  reg [AW:0] wq1_rptr;

  always_ff @(posedge wclk or negedge wrst_n) begin
    if (!wrst_n) begin
      wq1_rptr <= '0;
      wq2_rptr <= '0;
    end else begin
      wq1_rptr <= rptr;
      wq2_rptr <= wq1_rptr;
    end
  end

endmodule
