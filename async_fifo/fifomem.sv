module fifomem #(
    parameter DW = 8,
    parameter AW = 4
) (
    input [DW-1:0] wdata,
    input [AW-1:0] waddr,
    input [AW-1:0] raddr,
    input wclken,
    input wfull,
    input wclk,
    output [DW-1:0] rdata
);

`ifdef VENDORRAM
  vendor_ram mem (
      .dout(rdata),
      .din(wdata),
      .waddr(waddr),
      .raddr(raddr),
      .wclken(wclken),
      .wclken_n(wfull),
      .clk(wclk)
  );
`else

  localparam DP = 1 << AW;
  reg [DW-1: 0] mem[DP];
  assign rdata = mem[raddr];
  always @(posedge wclk)
    if (wclken && !wfull) mem[waddr] <= wdata;
`endif

endmodule
