module clock_mux (
    input clk_a,
    input clk_b,
    input clk_sel,
    input rst_n,

    output clk_o
);

  /* -------------------------------------------------------------
   *                     Wrong MUX
   * ------------------------------------------------------------- */
  // assign clk_o = clk_sel ? clk_a : clk_b;

  /* -------------------------------------------------------------
   *                     Right Mux
   * ------------------------------------------------------------- */
  wire sel_a, sel_b;
  reg sel_a_r1, sel_a_r2, sel_a_r2n;
  reg sel_b_r1, sel_b_r2, sel_b_r2n;

  assign sel_a = clk_sel & sel_b_r2n;
  assign sel_b = ~clk_sel & sel_a_r2n;

  // 2 ff for asynchorous
  always @(posedge clk_b or negedge rst_n) begin
    if (!rst_n) sel_a_r1 <= 0;
    else sel_a_r1 <= sel_a;
  end

  always @(negedge clk_b or negedge rst_n) begin
    if (!rst_n) begin
      sel_a_r2  <= 0;
      sel_a_r2n <= 1;
    end else begin
      sel_a_r2  <= sel_a_r1;
      sel_a_r2n <= ~sel_a_r1;
    end
  end

  // 2 ff for asynchorous
  always @(posedge clk_a or negedge rst_n) begin
    if (!rst_n) sel_b_r1 <= 0;
    else sel_b_r1 <= sel_b;
  end

  always @(negedge clk_a or negedge rst_n) begin
    if (!rst_n) begin
      sel_b_r2  <= 0;
      sel_b_r2n <= 1;
    end else begin
      sel_b_r2  <= sel_b_r1;
      sel_b_r2n <= ~sel_b_r1;
    end
  end

  wire clk_a_o, clk_b_o;
  assign clk_a_o = clk_a & sel_a_r2;
  assign clk_b_o = clk_b & sel_b_r2;

  assign clk_o   = clk_a_o | clk_b_o;

  /* -------------------------------------------------------------
   *                     Or use ICG
   * ------------------------------------------------------------- */
  // always @* begin
  // if (clk_en)
  //   clk_o = clk_a;
  // end

endmodule

module clock_mux_p #(
    parameter NUM_CLK = 4
) (
    input [NUM_CLK-1:0] clk,
    input [NUM_CLK-1:0] clk_sel,  // one hot
    output clk_out
);

  genvar i;

  reg  [NUM_CLK-1:0] ena_r0;
  reg  [NUM_CLK-1:0] ena_r1;
  reg  [NUM_CLK-1:0] ena_r2;
  wire [NUM_CLK-1:0] qualified_sel;

  wire [NUM_CLK-1:0] gated_clks;

  initial begin
    ena_r0 = 0;
    ena_r1 = 0;
    ena_r2 = 0;
  end

  generate
    for (i = 0; i < NUM_CLK; i = i + 1) begin : lp0
      wire [NUM_CLK-1:0] tmp_mask;
      assign tmp_mask = {NUM_CLK{1'b1}} ^ (1 << i);

      assign qualified_sel[i] = clk_sel[i] & (~|(ena_r2 & tmp_mask));

      always @(posedge clk[i]) begin
        ena_r0[i] <= qualified_sel[i];
        ena_r1[i] <= ena_r0[i];
      end

      always @(negedge clk[i]) begin
        ena_r2[i] <= ena_r1[i];
      end

      assign gated_clks[i] = clk[i] & ena_r2[i];
    end
  endgenerate

  // These will not exhibit simultaneous toggle by construction
  assign clk_out = |gated_clks;

endmodule
