`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/05 13:28:02
// Design Name: 
// Module Name: AXIFULL_to_AXIS
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AXIFULL_to_AXIS#
(
    parameter  C_M_TARGET_SLAVE_BASE_ADDR	= 32'h00000000,
    // Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
    parameter integer C_M_AXI_BURST_LEN	    = 16,
    // Thread ID Width
    parameter integer C_M_AXI_ID_WIDTH	    = 1,
    // Width of Address Bus
    parameter integer C_M_AXI_ADDR_WIDTH	= 32,
    // Width of Data Bus
    parameter integer C_M_AXI_DATA_WIDTH	= 64,
    // Width of User Write Address Bus
    parameter integer C_M_AXI_AWUSER_WIDTH	= 0,
    // Width of User Read Address Bus
    parameter integer C_M_AXI_ARUSER_WIDTH	= 0,
    // Width of User Write Data Bus
    parameter integer C_M_AXI_WUSER_WIDTH	= 0,
    // Width of User Read Data Bus
    parameter integer C_M_AXI_RUSER_WIDTH	= 0,
    // Width of User Response Bus
    parameter integer C_M_AXI_BUSER_WIDTH	= 0
)(
	input  wire                                 M_AXI_ACLK          ,
	input  wire                                 M_AXI_ARESETN       ,
    input                                       INIT_AXI_TXN        ,

	output wire [C_M_AXI_ID_WIDTH-1 : 0]        M_AXI_ARID          ,
	output wire [C_M_AXI_ADDR_WIDTH-1 : 0]      M_AXI_ARADDR        ,
	output wire [7 : 0]                         M_AXI_ARLEN         ,
	output wire [2 : 0]                         M_AXI_ARSIZE        ,
	output wire [1 : 0]                         M_AXI_ARBURST       ,
	output wire                                 M_AXI_ARLOCK        ,
	output wire [3 : 0]                         M_AXI_ARCACHE       ,
	output wire [2 : 0]                         M_AXI_ARPROT        ,
	output wire [3 : 0]                         M_AXI_ARQOS         ,
	output wire [C_M_AXI_ARUSER_WIDTH-1 : 0]    M_AXI_ARUSER        ,
	output wire                                 M_AXI_ARVALID       ,
	input  wire                                 M_AXI_ARREADY       ,

	input  wire [C_M_AXI_ID_WIDTH-1 : 0]        M_AXI_RID           ,
	input  wire [C_M_AXI_DATA_WIDTH-1 : 0]      M_AXI_RDATA         ,
	input  wire [1 : 0]                         M_AXI_RRESP         ,
	input  wire                                 M_AXI_RLAST         ,
	input  wire [C_M_AXI_RUSER_WIDTH-1 : 0]     M_AXI_RUSER         ,
	input  wire                                 M_AXI_RVALID        ,
	output wire                                 M_AXI_RREADY        ,

    input                                       i_axis_clk          ,
    input                                       i_axis_rst          ,
    output                                      m_axis_tvalid       ,
    output [63 :0]                              m_axis_tdata        ,
    output                                      m_axis_tlast        ,
    output [7  :0]                              m_axis_tkeep        ,
    output                                      m_axis_tuser        ,
    input                                       m_axis_tready       ,
    
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]           i_rd_ddr_addr       ,
    input                                       i_rd_ddr_req        ,
    input  [15 :0]                              i_rd_ddr_len        ,
    output                                      o_rd_ddr_cpl        ,
    input                                       i_rd_ddr_valid      
);
/******************************function*****************************/
function integer clogb2 (input integer bit_depth);
begin 
    for(clogb2 = 0; bit_depth > 0; clogb2 = clogb2 + 1)begin
        bit_depth = bit_depth >> 1;
    end
end
endfunction
/******************************parameter****************************/
localparam      P_AXI_SIZE      = clogb2((C_M_AXI_DATA_WIDTH/8) - 1);
localparam      P_AXI_DATA_BYTE = C_M_AXI_DATA_WIDTH/8              ;
/******************************machine******************************/

/******************************reg**********************************/
reg  [C_M_AXI_ID_WIDTH-1 : 0]       rM_AXI_ARID     ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]     rM_AXI_ARADDR   ;
reg  [7 : 0]                        rM_AXI_ARLEN    ;
reg  [2 : 0]                        rM_AXI_ARSIZE   ;
reg  [1 : 0]                        rM_AXI_ARBURST  ;
reg                                 rM_AXI_ARLOCK   ;
reg  [3 : 0]                        rM_AXI_ARCACHE  ;
reg  [2 : 0]                        rM_AXI_ARPROT   ;
reg  [3 : 0]                        rM_AXI_ARQOS    ;
reg  [C_M_AXI_ARUSER_WIDTH-1 : 0]   rM_AXI_ARUSER   ;
reg                                 rM_AXI_ARVALID  ;
reg                                 rM_AXI_RREADY   ;
reg                                 rm_axis_tvalid  ;
reg  [63 :0]                        rm_axis_tdata   ;
reg                                 rm_axis_tlast   ;
reg  [7  :0]                        rm_axis_tkeep   ;
reg                                 rm_axis_tuser   ;
/******************************wire*********************************/
wire                                w_axi_ar_active ;
wire                                w_axis_tx_active;
/******************************assign*******************************/
assign w_axi_ar_active = M_AXI_ARVALID & M_AXI_ARREADY;
assign w_axis_tx_active = m_axis_tready & m_axis_tvalid;
assign M_AXI_ARID    = rM_AXI_ARID      ;
assign M_AXI_ARADDR  = rM_AXI_ARADDR    ;
assign M_AXI_ARLEN   = rM_AXI_ARLEN     ;
assign M_AXI_ARSIZE  = rM_AXI_ARSIZE    ;
assign M_AXI_ARBURST = rM_AXI_ARBURST   ;
assign M_AXI_ARLOCK  = rM_AXI_ARLOCK    ;
assign M_AXI_ARCACHE = rM_AXI_ARCACHE   ;
assign M_AXI_ARPROT  = rM_AXI_ARPROT    ;
assign M_AXI_ARQOS   = rM_AXI_ARQOS     ;
assign M_AXI_ARUSER  = rM_AXI_ARUSER    ;
assign M_AXI_ARVALID = rM_AXI_ARVALID   ;
assign M_AXI_RREADY  = rM_AXI_RREADY    ;
assign m_axis_tvalid = rm_axis_tvalid   ;
assign m_axis_tdata  = rm_axis_tdata    ;
assign m_axis_tlast  = rm_axis_tlast    ;
assign m_axis_tkeep  = rm_axis_tkeep    ;
assign m_axis_tuser  = rm_axis_tuser    ;
/******************************component****************************/
FIFO_IND_64X256 FIFO_IND_64X256_data (
    .rst            (i_axis_rst         ), // input wire rst
    .wr_clk         (i_axis_clk         ), // input wire wr_clk
    .rd_clk         (M_AXI_ACLK         ), // input wire rd_clk
    .din            (rs_axis_tdata      ), // input wire [63 : 0] din
    .wr_en          (rs_axis_tvalid     ), // input wire wr_en
    .rd_en          (w_fifo_data_rden   ), // input wire rd_en
    .dout           (w_fifo_data_dout   ), // output wire [63 : 0] dout
    .full           (                   ), // output wire full
    .empty          (                   ), // output wire empty
    .wr_rst_busy    (                   ), // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);

FIFO_IND_16X32 FIFO_IND_16X32_len (
    .rst            (i_axis_rst         ),  // input wire rst
    .wr_clk         (i_axis_clk         ),  // input wire wr_clk
    .rd_clk         (M_AXI_ACLK         ),  // input wire rd_clk
    .din            (r_axis_data_len + 1'b1),  // input wire [15 : 0] din
    .wr_en          (rs_axis_tlast      ),  // input wire wr_en
    .rd_en          (r_fifo_len_rden    ),  // input wire rd_en
    .dout           (w_fifo_len_dout    ),  // output wire [15 : 0] dout
    .full           (w_fifo_len_full    ),  // output wire full
    .empty          (w_fifo_len_empty   ),  // output wire empty
    .wr_rst_busy    (                   ),  // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);

FIFO_IND_8X32 FIFO_IND_8X32_keep (
    .rst            (i_axis_rst         ),  // input wire rst
    .wr_clk         (i_axis_clk         ),  // input wire wr_clk
    .rd_clk         (M_AXI_ACLK         ),  // input wire rd_clk
    .din            (rs_axis_tkeep      ),  // input wire [7 : 0] din
    .wr_en          (rs_axis_tlast      ),  // input wire wr_en
    .rd_en          (r_fifo_len_rden    ),  // input wire rd_en
    .dout           (w_fifo_keep_dout   ),  // output wire [7 : 0] dout
    .full           (                   ),  // output wire full
    .empty          (                   ),  // output wire empty
    .wr_rst_busy    (                   ),  // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);
/******************************always*******************************/



endmodule
