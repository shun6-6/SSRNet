`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/05 13:28:02
// Design Name: 
// Module Name: AXIS_to_AXIFULL
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


module AXIS_to_AXIFULL#
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
    input                                       i_wr_ddr_ready      
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
reg  [C_M_AXI_ID_WIDTH-1 : 0]       rM_AXI_AWID         ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]     rM_AXI_AWADDR       ;
reg  [7 : 0]                        rM_AXI_AWLEN        ;
reg  [2 : 0]                        rM_AXI_AWSIZE       ;
reg  [1 : 0]                        rM_AXI_AWBURST      ;
reg                                 rM_AXI_AWLOCK       ;
reg  [3 : 0]                        rM_AXI_AWCACHE      ;
reg  [2 : 0]                        rM_AXI_AWPROT       ;
reg  [3 : 0]                        rM_AXI_AWQOS        ;
reg  [C_M_AXI_AWUSER_WIDTH-1 : 0]   rM_AXI_AWUSER       ;
reg                                 rM_AXI_AWVALID      ;

reg  [C_M_AXI_DATA_WIDTH/8-1 : 0]   rM_AXI_WSTRB        ;
reg                                 rM_AXI_WLAST        ;

reg                                 rM_AXI_WVALID       ;

reg                                 rs_axis_tvalid      ;
reg  [63 :0]                        rs_axis_tdata       ;
reg                                 rs_axis_tlast       ;
reg  [7  :0]                        rs_axis_tkeep       ;
reg                                 rs_axis_tuser       ;
reg  [2 : 0]                        rs_axis_tdest       ;
reg  [15 :0]                        r_axis_data_len     ;
 
reg                                 ro_wr_ddr_valid     ;
reg  [15 :0]                        ro_wr_ddr_len       ;
reg                                 ro_wr_ddr_cpl_valid ;
reg  [P_DDR_LOCAL_QUEUE - 1 : 0]    ro_wr_ddr_queue     ;
reg  [P_DDR_LOCAL_QUEUE - 1 : 0]    ro_wr_ddr_cpl_queue ;
reg  [15 :0]                        ro_wr_ddr_cpl_len   ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]     ro_wr_ddr_cpl_addr  ;
reg  [7 : 0]                        ro_wr_ddr_cpl_strb  ;
//FIFO 
reg                                 r_fifo_data_rden    ;
reg                                 r_fifo_len_rden     ;
reg                                 r_fifo_data_rden_1d = 1'b0 ;
reg                                 r_fifo_len_rden_1d  = 1'b0 ;
reg                                 r_fifo_lock         ;
reg  [7 :0]                         r_last_strb         ;
reg  [15:0]                         r_rd_cnt            ;
/******************************wire*********************************/
wire                                w_axi_rst           ;
wire [63:0]                         w_fifo_data_dout    ;
wire [15:0]                         w_fifo_len_dout     ;
wire [7 :0]                         w_fifo_keep_dout    ;
wire [7 :0]                         w_fifo_dest_dout    ;
wire                                w_fifo_len_full     ;
wire                                w_fifo_len_empty    ;
wire                                w_axi_wr_en         ;
wire                                w_axi_aw_en         ;
wire                                w_fifo_data_rden    ;
wire                                w_wr_ddr_en         ;
wire                                w_wr_cpl_en         ;
/******************************assign*******************************/
assign  w_axi_rst = !M_AXI_ARESETN  ;
assign  o_wr_ddr_valid = ro_wr_ddr_valid    ;
assign  o_wr_ddr_len = ro_wr_ddr_len    ;
assign  o_wr_ddr_cpl_valid = ro_wr_ddr_cpl_valid    ;
assign  w_wr_cpl_en = ro_wr_ddr_cpl_valid & i_wr_ddr_cpl_ready;
assign  o_wr_ddr_queue = ro_wr_ddr_queue  ;
assign  o_wr_ddr_cpl_queue = ro_wr_ddr_cpl_queue;
assign  o_wr_ddr_cpl_len  = ro_wr_ddr_cpl_len ;
assign  o_wr_ddr_cpl_addr = ro_wr_ddr_cpl_addr;
assign  o_wr_ddr_cpl_strb = ro_wr_ddr_cpl_strb;
assign  M_AXI_AWID    = rM_AXI_AWID     ;
assign  M_AXI_AWADDR  = rM_AXI_AWADDR   ;
assign  M_AXI_AWLEN   = rM_AXI_AWLEN    ;
assign  M_AXI_AWSIZE  = rM_AXI_AWSIZE   ;
assign  M_AXI_AWBURST = rM_AXI_AWBURST  ;
assign  M_AXI_AWLOCK  = rM_AXI_AWLOCK   ;
assign  M_AXI_AWCACHE = rM_AXI_AWCACHE  ;
assign  M_AXI_AWPROT  = rM_AXI_AWPROT   ;
assign  M_AXI_AWQOS   = rM_AXI_AWQOS    ;
assign  M_AXI_AWUSER  = rM_AXI_AWUSER   ;
assign  M_AXI_AWVALID = rM_AXI_AWVALID  ;
assign  M_AXI_WDATA   = w_fifo_data_dout    ;
assign  M_AXI_WSTRB   = rM_AXI_WSTRB    ;
assign  M_AXI_WLAST   = rM_AXI_WLAST    ;
assign  M_AXI_WUSER   = 'd0    ;
assign  M_AXI_WVALID  = rM_AXI_WVALID   ;
assign  M_AXI_BREADY  = 1'b1;
assign  w_axi_aw_en = M_AXI_AWVALID & M_AXI_AWREADY;
assign  w_axi_wr_en = M_AXI_WVALID & M_AXI_WREADY;
assign  w_fifo_data_rden = (r_fifo_data_rden && w_axi_wr_en) || w_axi_aw_en;
assign  w_wr_ddr_en = i_wr_ddr_ready & ro_wr_ddr_valid;
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

FIFO_IND_8X32 FIFO_IND_8X32_dest (
    .rst            (i_axis_rst         ),  // input wire rst
    .wr_clk         (i_axis_clk         ),  // input wire wr_clk
    .rd_clk         (M_AXI_ACLK         ),  // input wire rd_clk
    .din            ({5'd0,rs_axis_tdest}),  // input wire [7 : 0] din
    .wr_en          (rs_axis_tlast      ),  // input wire wr_en
    .rd_en          (r_fifo_len_rden    ),  // input wire rd_en
    .dout           (w_fifo_dest_dout   ),  // output wire [7 : 0] dout
    .full           (                   ),  // output wire full
    .empty          (                   ),  // output wire empty
    .wr_rst_busy    (                   ),  // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);
/******************************always*******************************/
//========== i_axis_clk region ===========//
always @(posedge i_axis_clk or posedge i_axis_rst)begin
    if(i_axis_rst)begin
        rs_axis_tvalid <= 'd0;
        rs_axis_tdata  <= 'd0;
        rs_axis_tlast  <= 'd0;
        rs_axis_tkeep  <= 'd0;
        rs_axis_tuser  <= 'd0;
        rs_axis_tdest  <= 'd0;
    end 
    else begin
        rs_axis_tvalid <= s_axis_tvalid && (s_axis_tuser == 'd0);
        rs_axis_tdata  <= s_axis_tdata ;
        rs_axis_tlast  <= s_axis_tlast ;
        rs_axis_tkeep  <= s_axis_tkeep ;
        rs_axis_tuser  <= s_axis_tuser ;
        rs_axis_tdest  <= s_axis_tdest ;
    end
end

always @(posedge i_axis_clk or posedge i_axis_rst)begin
    if(i_axis_rst)
        r_axis_data_len <= 'd0;
    else if(rs_axis_tlast)
        r_axis_data_len <= 'd0;
    else if(rs_axis_tvalid)
        r_axis_data_len <= r_axis_data_len + 1'b1;
    else
        r_axis_data_len <= r_axis_data_len;
end

//========== M_AXI_ACLK region ===========//
//发起写DDR请求
always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        ro_wr_ddr_valid <= 'd0;
    else if(w_wr_ddr_en)
        ro_wr_ddr_valid <= 'd0;
    else if(r_fifo_len_rden_1d)
        ro_wr_ddr_valid <= 'd1;
    else
        ro_wr_ddr_valid <= ro_wr_ddr_valid;
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        ro_wr_ddr_len <= 'd0;
    else if(r_fifo_len_rden_1d)
        ro_wr_ddr_len <= w_fifo_len_dout;
    else
        ro_wr_ddr_len <= ro_wr_ddr_len;
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        ro_wr_ddr_queue <= 'd0;
    else if(r_fifo_len_rden_1d)
        ro_wr_ddr_queue <= w_fifo_dest_dout[2:0];
    else
        ro_wr_ddr_queue <= ro_wr_ddr_queue;
end

//FIFO不空则读出一个长度信息，随后发起写DDR请求
always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        r_fifo_len_rden <= 'd0;
    else if(r_fifo_len_rden)
        r_fifo_len_rden <= 'd0;       
    else if(!w_fifo_len_empty && !r_fifo_lock)
        r_fifo_len_rden <= 'd1;
    else
        r_fifo_len_rden <= 'd0;
end

always @(posedge M_AXI_ACLK)begin
    r_fifo_len_rden_1d <= r_fifo_len_rden;
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        r_last_strb <= 'd0;
    else if(r_fifo_len_rden_1d)
        r_last_strb <= w_fifo_keep_dout;       
    else
        r_last_strb <= r_last_strb;
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        r_fifo_lock <= 'd0;
    else if(rM_AXI_WLAST && rM_AXI_WVALID)
        r_fifo_lock <= 'd0;
    else if(!w_fifo_len_empty && !r_fifo_lock && !ro_wr_ddr_cpl_valid)
        r_fifo_lock <= 'd1;
    else
        r_fifo_lock <= r_fifo_lock;
end

//得到DDR写响应以及首地址后开始产生AXI写地址
always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)begin
        rM_AXI_AWID    <= 'd0;
        rM_AXI_AWADDR  <= 'd0;
        rM_AXI_AWLEN   <= 'd0;
        rM_AXI_AWSIZE  <= 'd0;
        rM_AXI_AWBURST <= 'd0;
        rM_AXI_AWLOCK  <= 'd0;
        rM_AXI_AWCACHE <= 'd0;
        rM_AXI_AWPROT  <= 'd0;
        rM_AXI_AWQOS   <= 'd0;
        rM_AXI_AWUSER  <= 'd0;
        rM_AXI_AWVALID <= 'd0;
    end
    else if(w_axi_aw_en)begin
        rM_AXI_AWID    <= 'd0;
        rM_AXI_AWADDR  <= rM_AXI_AWADDR;
        rM_AXI_AWLEN   <= 'd0;
        rM_AXI_AWSIZE  <= 'd0;
        rM_AXI_AWBURST <= 'd0;
        rM_AXI_AWLOCK  <= 'd0;
        rM_AXI_AWCACHE <= 'd0;
        rM_AXI_AWPROT  <= 'd0;
        rM_AXI_AWQOS   <= 'd0;
        rM_AXI_AWUSER  <= 'd0;
        rM_AXI_AWVALID <= 'd0;
    end
    else if(w_wr_ddr_en)begin
        rM_AXI_AWID    <= 'd0;
        rM_AXI_AWADDR  <= i_wr_ddr_addr;
        rM_AXI_AWLEN   <= ro_wr_ddr_len - 1;
        rM_AXI_AWSIZE  <= P_AXI_SIZE;
        rM_AXI_AWBURST <= 2'b01;
        rM_AXI_AWLOCK  <= 'd0;
        rM_AXI_AWCACHE <= 4'b0010;
        rM_AXI_AWPROT  <= 'd0;
        rM_AXI_AWQOS   <= 'd0;
        rM_AXI_AWUSER  <= 'd0;
        rM_AXI_AWVALID <= 'd1;
    end
    else begin
        rM_AXI_AWID    <= rM_AXI_AWID   ;
        rM_AXI_AWADDR  <= rM_AXI_AWADDR ;
        rM_AXI_AWLEN   <= rM_AXI_AWLEN  ;
        rM_AXI_AWSIZE  <= rM_AXI_AWSIZE ;
        rM_AXI_AWBURST <= rM_AXI_AWBURST;
        rM_AXI_AWLOCK  <= rM_AXI_AWLOCK ;
        rM_AXI_AWCACHE <= rM_AXI_AWCACHE;
        rM_AXI_AWPROT  <= rM_AXI_AWPROT ;
        rM_AXI_AWQOS   <= rM_AXI_AWQOS  ;
        rM_AXI_AWUSER  <= rM_AXI_AWUSER ;
        rM_AXI_AWVALID <= rM_AXI_AWVALID;
    end
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        r_fifo_data_rden <= 'd0;
    else if(r_rd_cnt == ro_wr_ddr_len - 2 && w_axi_wr_en)
        r_fifo_data_rden <= 'd0;
    else if(w_axi_aw_en)
        r_fifo_data_rden <= 'd1;
    else
        r_fifo_data_rden <= r_fifo_data_rden;
end

always @(posedge M_AXI_ACLK)begin
    r_fifo_data_rden_1d <= r_fifo_data_rden;
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        r_rd_cnt <= 'd0;
    else if(r_rd_cnt == ro_wr_ddr_len - 1 && w_axi_wr_en)
        r_rd_cnt <= 'd0;
    else if(w_axi_wr_en)
        r_rd_cnt <= r_rd_cnt + 1'b1;
    else
        r_rd_cnt <= r_rd_cnt;
end
 
always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        rM_AXI_WVALID <= 'd0;
    else if(rM_AXI_WLAST && w_axi_wr_en)
        rM_AXI_WVALID <= 'd0;
    else if(w_axi_aw_en)
        rM_AXI_WVALID <= 'd1;
    else
        rM_AXI_WVALID <= rM_AXI_WVALID;
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        rM_AXI_WSTRB <= 8'hff;
    else if(r_rd_cnt == ro_wr_ddr_len - 1 && w_axi_wr_en)
        rM_AXI_WSTRB <= 8'hff;
    else if(r_rd_cnt == ro_wr_ddr_len - 2 && r_rd_cnt != 0 && w_axi_wr_en)
        rM_AXI_WSTRB <= r_last_strb;
    else
        rM_AXI_WSTRB <= rM_AXI_WSTRB;
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        rM_AXI_WLAST <= 'd0;
    else if(r_rd_cnt == ro_wr_ddr_len - 1 && w_axi_wr_en)
        rM_AXI_WLAST <= 'd0;
    else if(r_rd_cnt == ro_wr_ddr_len - 2 && w_axi_wr_en)
        rM_AXI_WLAST <= 'd1;
    else
        rM_AXI_WLAST <= rM_AXI_WLAST;
end

//return write complete single
always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        ro_wr_ddr_cpl_valid <= 'd0;
    else if(w_wr_cpl_en)
        ro_wr_ddr_cpl_valid <= 'd0;
    else if(rM_AXI_WLAST && rM_AXI_WVALID)
        ro_wr_ddr_cpl_valid <= 'd1;
    else
        ro_wr_ddr_cpl_valid <= ro_wr_ddr_cpl_valid;
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        ro_wr_ddr_cpl_len <= 'd0;
    else if(rM_AXI_WLAST && rM_AXI_WVALID)
        ro_wr_ddr_cpl_len <= ro_wr_ddr_len;
    else
        ro_wr_ddr_cpl_len <= ro_wr_ddr_cpl_len;
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        ro_wr_ddr_cpl_addr <= 'd0;
    else if(rM_AXI_WLAST && rM_AXI_WVALID)
        ro_wr_ddr_cpl_addr <= rM_AXI_AWADDR;
    else
        ro_wr_ddr_cpl_addr <= ro_wr_ddr_cpl_addr;
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        ro_wr_ddr_cpl_strb <= 'd0;
    else if(rM_AXI_WLAST && rM_AXI_WVALID)
        ro_wr_ddr_cpl_strb <= r_last_strb;
    else
        ro_wr_ddr_cpl_strb <= ro_wr_ddr_cpl_strb;
end
 
always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        ro_wr_ddr_cpl_queue <= 'd0;
    else if(rM_AXI_WLAST && rM_AXI_WVALID)
        ro_wr_ddr_cpl_queue <= ro_wr_ddr_queue;
    else
        ro_wr_ddr_cpl_queue <= ro_wr_ddr_cpl_queue;
end





endmodule
