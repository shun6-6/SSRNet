`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/05 13:31:15
// Design Name: 
// Module Name: AXI4_BUS_module
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


module AXI4_BUS_module#
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
    parameter integer C_M_AXI_BUSER_WIDTH	= 0,
    parameter integer P_DDR_LOCAL_QUEUE     = 4,
    parameter integer P_WRITE_DDR_PORT_NUM  = 1,
    parameter integer P_P_WRITE_DDR_PORT    = 0
)(
	input  wire                                 M_AXI_ACLK          ,
	input  wire                                 M_AXI_ARESETN       ,
    input                                       INIT_AXI_TXN        ,

	output wire [C_M_AXI_ID_WIDTH-1 : 0]        M_AXI_AWID          ,
	output wire [C_M_AXI_ADDR_WIDTH-1 : 0]      M_AXI_AWADDR        ,
	output wire [7 : 0]                         M_AXI_AWLEN         ,
	output wire [2 : 0]                         M_AXI_AWSIZE        ,
	output wire [1 : 0]                         M_AXI_AWBURST       ,
	output wire                                 M_AXI_AWLOCK        ,
	output wire [3 : 0]                         M_AXI_AWCACHE       ,
	output wire [2 : 0]                         M_AXI_AWPROT        ,
	output wire [3 : 0]                         M_AXI_AWQOS         ,
	output wire [C_M_AXI_AWUSER_WIDTH-1 : 0]    M_AXI_AWUSER        ,
	output wire                                 M_AXI_AWVALID       ,
	input  wire                                 M_AXI_AWREADY       ,

	output wire [C_M_AXI_DATA_WIDTH-1 : 0]      M_AXI_WDATA         ,
	output wire [C_M_AXI_DATA_WIDTH/8-1 : 0]    M_AXI_WSTRB         ,
	output wire                                 M_AXI_WLAST         ,
	output wire [C_M_AXI_WUSER_WIDTH-1 : 0]     M_AXI_WUSER         ,
	output wire                                 M_AXI_WVALID        ,
	input  wire                                 M_AXI_WREADY        ,

	input  wire [C_M_AXI_ID_WIDTH-1 : 0]        M_AXI_BID           ,
	input  wire [1 : 0]                         M_AXI_BRESP         ,
	input  wire [C_M_AXI_BUSER_WIDTH-1 : 0]     M_AXI_BUSER         ,
	input  wire                                 M_AXI_BVALID        ,
	output wire                                 M_AXI_BREADY        ,

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
    input                                       s_axis_tvalid       ,
    input  [63 :0]                              s_axis_tdata        ,
    input                                       s_axis_tlast        ,
    input  [7  :0]                              s_axis_tkeep        ,
    input                                       s_axis_tuser        ,
    input  [2 : 0]                              s_axis_tdest        ,
    output                                      o_wr_ddr_valid      ,
    output [15 :0]                              o_wr_ddr_len        ,
    output [P_DDR_LOCAL_QUEUE - 1 : 0]          o_wr_ddr_queue      ,
    output                                      o_wr_ddr_cpl_valid  ,
    input                                       i_wr_ddr_cpl_ready  ,
    output [P_DDR_LOCAL_QUEUE - 1 : 0]          o_wr_ddr_cpl_queue  ,
    output [15 :0]                              o_wr_ddr_cpl_len    ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]           o_wr_ddr_cpl_addr   ,
    output [7 : 0]                              o_wr_ddr_cpl_strb   ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]           i_wr_ddr_addr       ,
    input                                       i_wr_ddr_ready      ,

    output                                      m_axis_tvalid       ,
    output [63 :0]                              m_axis_tdata        ,
    output                                      m_axis_tlast        ,
    output [7  :0]                              m_axis_tkeep        ,
    output                                      m_axis_tuser        ,
    input                                       m_axis_tready       ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]           i_rd_ddr_addr       ,
    input  [15 :0]                              i_rd_ddr_len        ,
    input  [7 : 0]                              i_rd_ddr_strb       ,
    input                                       i_rd_ddr_valid      ,
    output                                      o_rd_ddr_cpl        ,
    output                                      o_rd_ddr_ready      
);



AXIS_to_AXIFULL#
(
    .C_M_TARGET_SLAVE_BASE_ADDR	(C_M_TARGET_SLAVE_BASE_ADDR ),
    .C_M_AXI_BURST_LEN	        (C_M_AXI_BURST_LEN	        ),
    .C_M_AXI_ID_WIDTH	        (C_M_AXI_ID_WIDTH	        ),
    .C_M_AXI_ADDR_WIDTH	        (C_M_AXI_ADDR_WIDTH	        ),
    .C_M_AXI_DATA_WIDTH	        (C_M_AXI_DATA_WIDTH	        ),
    .C_M_AXI_AWUSER_WIDTH	    (C_M_AXI_AWUSER_WIDTH	    ),
    .C_M_AXI_ARUSER_WIDTH	    (C_M_AXI_ARUSER_WIDTH	    ),
    .C_M_AXI_WUSER_WIDTH	    (C_M_AXI_WUSER_WIDTH	    ),
    .C_M_AXI_RUSER_WIDTH	    (C_M_AXI_RUSER_WIDTH	    ),
    .C_M_AXI_BUSER_WIDTH	    (C_M_AXI_BUSER_WIDTH	    ),
    .P_DDR_LOCAL_QUEUE          (P_DDR_LOCAL_QUEUE          ),
    .P_WRITE_DDR_PORT_NUM       (P_WRITE_DDR_PORT_NUM       ),
    .P_P_WRITE_DDR_PORT         (P_P_WRITE_DDR_PORT         )
)AXIS_to_AXIFULL_u0(
	.M_AXI_ACLK                 (M_AXI_ACLK     ),
	.M_AXI_ARESETN              (M_AXI_ARESETN  ),
    .INIT_AXI_TXN               (INIT_AXI_TXN   ),

	.M_AXI_AWID                 (M_AXI_AWID     ),
	.M_AXI_AWADDR               (M_AXI_AWADDR   ),
	.M_AXI_AWLEN                (M_AXI_AWLEN    ),
	.M_AXI_AWSIZE               (M_AXI_AWSIZE   ),
	.M_AXI_AWBURST              (M_AXI_AWBURST  ),
	.M_AXI_AWLOCK               (M_AXI_AWLOCK   ),
	.M_AXI_AWCACHE              (M_AXI_AWCACHE  ),
	.M_AXI_AWPROT               (M_AXI_AWPROT   ),
	.M_AXI_AWQOS                (M_AXI_AWQOS    ),
	.M_AXI_AWUSER               (M_AXI_AWUSER   ),
	.M_AXI_AWVALID              (M_AXI_AWVALID  ),
	.M_AXI_AWREADY              (M_AXI_AWREADY  ),
	.M_AXI_WDATA                (M_AXI_WDATA    ),
	.M_AXI_WSTRB                (M_AXI_WSTRB    ),
	.M_AXI_WLAST                (M_AXI_WLAST    ),
	.M_AXI_WUSER                (M_AXI_WUSER    ),
	.M_AXI_WVALID               (M_AXI_WVALID   ),
	.M_AXI_WREADY               (M_AXI_WREADY   ),
	.M_AXI_BID                  (M_AXI_BID      ),
	.M_AXI_BRESP                (M_AXI_BRESP    ),
	.M_AXI_BUSER                (M_AXI_BUSER    ),
	.M_AXI_BVALID               (M_AXI_BVALID   ),
	.M_AXI_BREADY               (M_AXI_BREADY   ),
    .i_axis_clk                 (i_axis_clk     ),
    .i_axis_rst                 (i_axis_rst     ),
    .s_axis_tvalid              (s_axis_tvalid  ),
    .s_axis_tdata               (s_axis_tdata   ),
    .s_axis_tlast               (s_axis_tlast   ),
    .s_axis_tkeep               (s_axis_tkeep   ),
    .s_axis_tuser               (s_axis_tuser   ),
    .s_axis_tdest               (s_axis_tdest   ),

    .o_wr_ddr_valid             (o_wr_ddr_valid     ),
    .o_wr_ddr_len               (o_wr_ddr_len       ),
    .o_wr_ddr_queue             (o_wr_ddr_queue     ),
    .o_wr_ddr_cpl_valid         (o_wr_ddr_cpl_valid ),
    .i_wr_ddr_cpl_ready         (i_wr_ddr_cpl_ready ),
    .o_wr_ddr_cpl_queue         (o_wr_ddr_cpl_queue ),
    .o_wr_ddr_cpl_len           (o_wr_ddr_cpl_len   ),
    .o_wr_ddr_cpl_addr          (o_wr_ddr_cpl_addr  ),
    .o_wr_ddr_cpl_strb          (o_wr_ddr_cpl_strb  ),
    .i_wr_ddr_addr              (i_wr_ddr_addr      ),
    .i_wr_ddr_ready             (i_wr_ddr_ready     )
);

AXIFULL_to_AXIS#
(
    .C_M_TARGET_SLAVE_BASE_ADDR	(C_M_TARGET_SLAVE_BASE_ADDR ),
    .C_M_AXI_BURST_LEN	        (C_M_AXI_BURST_LEN	        ),
    .C_M_AXI_ID_WIDTH	        (C_M_AXI_ID_WIDTH	        ),
    .C_M_AXI_ADDR_WIDTH	        (C_M_AXI_ADDR_WIDTH	        ),
    .C_M_AXI_DATA_WIDTH	        (C_M_AXI_DATA_WIDTH	        ),
    .C_M_AXI_AWUSER_WIDTH	    (C_M_AXI_AWUSER_WIDTH	    ),
    .C_M_AXI_ARUSER_WIDTH	    (C_M_AXI_ARUSER_WIDTH	    ),
    .C_M_AXI_WUSER_WIDTH	    (C_M_AXI_WUSER_WIDTH	    ),
    .C_M_AXI_RUSER_WIDTH	    (C_M_AXI_RUSER_WIDTH	    ),
    .C_M_AXI_BUSER_WIDTH	    (C_M_AXI_BUSER_WIDTH	    ),
    .P_DDR_LOCAL_QUEUE          (P_DDR_LOCAL_QUEUE          ),
    .P_WRITE_DDR_PORT_NUM       (P_WRITE_DDR_PORT_NUM       ),
    .P_P_WRITE_DDR_PORT         (P_P_WRITE_DDR_PORT         )
)AXIFULL_to_AXIS_u0(
	.M_AXI_ACLK                 (M_AXI_ACLK     ),
	.M_AXI_ARESETN              (M_AXI_ARESETN  ),
    .INIT_AXI_TXN               (INIT_AXI_TXN   ),
	.M_AXI_ARID                 (M_AXI_ARID     ),
	.M_AXI_ARADDR               (M_AXI_ARADDR   ),
	.M_AXI_ARLEN                (M_AXI_ARLEN    ),
	.M_AXI_ARSIZE               (M_AXI_ARSIZE   ),
	.M_AXI_ARBURST              (M_AXI_ARBURST  ),
	.M_AXI_ARLOCK               (M_AXI_ARLOCK   ),
	.M_AXI_ARCACHE              (M_AXI_ARCACHE  ),
	.M_AXI_ARPROT               (M_AXI_ARPROT   ),
	.M_AXI_ARQOS                (M_AXI_ARQOS    ),
	.M_AXI_ARUSER               (M_AXI_ARUSER   ),
	.M_AXI_ARVALID              (M_AXI_ARVALID  ),
	.M_AXI_ARREADY              (M_AXI_ARREADY  ),
	.M_AXI_RID                  (M_AXI_RID      ),
	.M_AXI_RDATA                (M_AXI_RDATA    ),
	.M_AXI_RRESP                (M_AXI_RRESP    ),
	.M_AXI_RLAST                (M_AXI_RLAST    ),
	.M_AXI_RUSER                (M_AXI_RUSER    ),
	.M_AXI_RVALID               (M_AXI_RVALID   ),
	.M_AXI_RREADY               (M_AXI_RREADY   ),
    .i_axis_clk                 (i_axis_clk     ),
    .i_axis_rst                 (i_axis_rst     ),
    .m_axis_tvalid              (m_axis_tvalid  ),
    .m_axis_tdata               (m_axis_tdata   ),
    .m_axis_tlast               (m_axis_tlast   ),
    .m_axis_tkeep               (m_axis_tkeep   ),
    .m_axis_tuser               (m_axis_tuser   ),
    .m_axis_tready              (m_axis_tready  ),

    .i_rd_ddr_addr              (i_rd_ddr_addr  ),
    .i_rd_ddr_len               (i_rd_ddr_len   ),
    .i_rd_ddr_strb              (i_rd_ddr_strb  ),
    .i_rd_ddr_valid             (i_rd_ddr_valid ),
    .o_rd_ddr_cpl               (o_rd_ddr_cpl   ),
    .o_rd_ddr_ready             (o_rd_ddr_ready ) 
);

endmodule
