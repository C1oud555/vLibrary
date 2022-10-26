module rptr_empty #(
    parameter AW = 4
) (
    output reg rempty,
    output reg [AW:0] rptr,
    output [AW-1:0] raddr,
    input [AW:0] rq2_wptr,
    input pop,
    input rclk,
    input rrst_n
);

  reg [AW:0] rbin;
  wire [AW:0] rgray_next, rbin_next;

  assign raddr = rbin[AW-1:0];
  assign rbin_next = rbin + (pop & !rempty);
  assign rgray_next = (rbin_next >> 1) ^ rbin_next;
  always_ff @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) begin
      rbin <= 0;
      rptr <= 0;
    end else begin
      rbin <= rbin_next;
      rptr <= rgray_next;
    end
  end

  wire empty_next = (rgray_next == rq2_wptr);
  always_ff @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) rempty <= 1'b1;
    else rempty <= empty_next;
  end


endmodule
