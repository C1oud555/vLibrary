module areset_srelease (
    input  clk,
    input  i_rst,
    output o_rst
);

  reg r1, r2;

  always_ff @(posedge clk or negedge i_rst) begin
    if (!i_rst) begin
      r1 <= 0;
      r2 <= 0;
    end else begin
      r1 <= 1;
      r2 <= r1;
    end
  end

  assign o_rst = r2;


endmodule
