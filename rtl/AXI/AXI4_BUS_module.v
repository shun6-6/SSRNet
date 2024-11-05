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
    parameter integer C_M_AXI_BUSER_WIDTH	= 0
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

    input                                       s_axis_tvalid       ,
    input  [63 :0]                              s_axis_tdata        ,
    input                                       s_axis_tlast        ,
    input  [7  :0]                              s_axis_tkeep        ,
    input                                       s_axis_tuser        ,
    input  [2 : 0]                              s_axis_tdest        ,

    output                                      m_axis_tvalid       ,
    output [63 :0]                              m_axis_tdata        ,
    output                                      m_axis_tlast        ,
    output [7  :0]                              m_axis_tkeep        ,
    output                                      m_axis_tuser        ,
    input                                       m_axis_tready                
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
localparam      P_AXI_DATA_BYTE = C_M_AXI_DATA_WIDTH/8          ;
/******************************machine******************************/

/******************************reg**********************************/

/******************************wire*********************************/

/******************************assign*******************************/

/******************************component****************************/

/******************************always*******************************/

endmodule
