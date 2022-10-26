module wptr_full #(
    parameter AW = 4
) (
    output reg wfull,
    output reg [AW:0] wptr,
    output [AW-1:0] waddr,
    input [AW:0] wq2_rptr,
    input push,
    input wclk,
    input wrst_n
);
  reg [AW:0] wbin;
  wire [AW:0] wbin_next, wgray_next;

  assign waddr = wbin[AW-1:0];
  assign wbin_next = wbin + (push & !wfull);
  assign wgray_next = (wbin_next >> 1) ^ wbin_next;
  always_ff @(posedge wclk or negedge wrst_n) begin
    if (!wrst_n) begin
      wbin <= '0;
      wptr <= '0;
    end else begin
      wbin <= wbin_next;
      wptr <= wgray_next;
    end
  end

  wire full_next = wgray_next == {~wq2_rptr[AW:AW-1], wq2_rptr[AW-2:0]};
  always_ff @(posedge wclk or negedge wrst_n) begin
    if (!wrst_n) wfull <= 1'b0;
    else wfull <= full_next;
  end



endmodule
