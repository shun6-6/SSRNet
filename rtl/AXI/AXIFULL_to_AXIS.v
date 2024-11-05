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

    output                                      m_axis_tvalid       ,
    output [63 :0]                              m_axis_tdata        ,
    output                                      m_axis_tlast        ,
    output [7  :0]                              m_axis_tkeep        ,
    output                                      m_axis_tuser        ,
    input                                       m_axis_tready        
);
endmodule
