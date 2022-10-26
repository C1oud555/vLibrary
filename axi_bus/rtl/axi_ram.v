`resetall
//
`timescale 1ns / 1ps
//
`default_nettype none

/*
 * AXI4 RAM
 */

module axi_ram #(
    // Width of data bus in bits
    parameter DATA_WIDTH = 32,
    // Width of address bus in bits
    parameter ADDR_WIDTH = 16,
    // Width of wstrb (width of data bus in words)
    parameter STRB_WIDTH = (DATA_WIDTH / 8),
    // Width of ID signal
    parameter ID_WIDTH = 8,
    // Extra pipeline register on output 
    parameter PIPELINE_OUTPUT = 0
) (
    input wire clk,
    input wire rst,

    /* -------------------------------------------------------------
     *                     Write Address
     * ------------------------------------------------------------- */
    input  wire [  ID_WIDTH-1:0] s_axi_awid,
    input  wire [ADDR_WIDTH-1:0] s_axi_awaddr,
    input  wire [           7:0] s_axi_awlen,
    input  wire [           2:0] s_axi_awsize,
    input  wire [           1:0] s_axi_awburst,
    input  wire                  s_axi_awlock,
    input  wire [           3:0] s_axi_awcache,
    input  wire [           2:0] s_axi_awprot,
    input  wire                  s_axi_awvalid,
    output wire                  s_axi_awready,

    /* -------------------------------------------------------------
     *                     Write Data
     * ------------------------------------------------------------- */
    input  wire [DATA_WIDTH-1:0] s_axi_wdata,
    input  wire [STRB_WIDTH-1:0] s_axi_wstrb,
    input  wire                  s_axi_wlast,
    input  wire                  s_axi_wvalid,
    output wire                  s_axi_wready,

    /* -------------------------------------------------------------
     *                     Write Response
     * ------------------------------------------------------------- */
    output wire [ID_WIDTH-1:0] s_axi_bid,
    output wire [         1:0] s_axi_bresp,
    output wire                s_axi_bvalid,
    input  wire                s_axi_bready,

    /* -------------------------------------------------------------
     *                     Read Address
     * ------------------------------------------------------------- */
    input  wire [  ID_WIDTH-1:0] s_axi_arid,
    input  wire [ADDR_WIDTH-1:0] s_axi_araddr,
    input  wire [           7:0] s_axi_arlen,
    input  wire [           2:0] s_axi_arsize,
    input  wire [           1:0] s_axi_arburst,
    input  wire                  s_axi_arlock,
    input  wire [           3:0] s_axi_arcache,
    input  wire [           2:0] s_axi_arprot,
    input  wire                  s_axi_arvalid,
    output wire                  s_axi_arready,

    /* -------------------------------------------------------------
     *                     Read Data
     * ------------------------------------------------------------- */
    output wire [  ID_WIDTH-1:0] s_axi_rid,
    output wire [DATA_WIDTH-1:0] s_axi_rdata,
    output wire [           1:0] s_axi_rresp,
    output wire                  s_axi_rlast,
    output wire                  s_axi_rvalid,
    input  wire                  s_axi_rready
);

  parameter VALID_ADDR_WIDTH = ADDR_WIDTH - $clog2(STRB_WIDTH);
  parameter WORD_WIDTH = STRB_WIDTH;
  parameter WORD_SIZE = DATA_WIDTH / WORD_WIDTH;

  initial begin
    if (WORD_SIZE * STRB_WIDTH != DATA_WIDTH) begin
      $error("Error: AXI data width not evenly divisble (instance %m)");
      $finish;
    end

    if (2**$clog2(WORD_WIDTH) != WORD_WIDTH) begin
      $error("Error: AXI word width must be even power of two (intance %m)");
      $finish;
    end
  end

  localparam [0:0] READ_STATE_IDLE = 1'd0, READ_STATE_BURST = 1'd1;
  reg [0:0] read_state_reg = READ_STATE_IDLE, read_state_next;

  localparam [1:0] WRITE_STATE_IDLE = 2'd0, WRITE_STATE_BURST=2'd1,WRITE_STATE_RESP = 2'd2;
  reg [1: 0] write_state_reg = WRITE_STATE_IDLE, write_state_next;

  reg mem_wr_en;
  reg mem_rd_en;

endmodule

`resetall
