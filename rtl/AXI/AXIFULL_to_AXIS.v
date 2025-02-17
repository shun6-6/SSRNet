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
    parameter integer C_M_AXI_BUSER_WIDTH	= 0,
    parameter integer P_DDR_LOCAL_QUEUE     = 4,
    parameter integer P_WRITE_DDR_PORT_NUM  = 1,
    parameter integer P_P_WRITE_DDR_PORT    = 0
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
    
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]           i_rd_ddr_byte       ,
    input                                       i_rd_ddr_byte_valid ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]           i_rd_ddr_addr       ,
    input  [15 :0]                              i_rd_ddr_len        ,
    input  [7 : 0]                              i_rd_ddr_strb       ,
    input                                       i_rd_ddr_valid      ,
    output                                      o_rd_ddr_cpl        ,
    output                                      o_rd_ddr_ready      ,
    output                                      o_rd_queue_finish   
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
reg  [C_M_AXI_ID_WIDTH-1 : 0]       rM_AXI_ARID         ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]     rM_AXI_ARADDR       ;
reg  [7 : 0]                        rM_AXI_ARLEN        ;
reg  [2 : 0]                        rM_AXI_ARSIZE       ;
reg  [1 : 0]                        rM_AXI_ARBURST      ;
reg                                 rM_AXI_ARLOCK       ;
reg  [3 : 0]                        rM_AXI_ARCACHE      ;
reg  [2 : 0]                        rM_AXI_ARPROT       ;
reg  [3 : 0]                        rM_AXI_ARQOS        ;
reg  [C_M_AXI_ARUSER_WIDTH-1 : 0]   rM_AXI_ARUSER       ;
reg                                 rM_AXI_ARVALID      ;
reg                                 rM_AXI_RREADY       ;
reg                                 rm_axis_tvalid      ;

reg                                 rm_axis_tlast       ;
reg  [7  :0]                        rm_axis_tkeep       ;
reg                                 rm_axis_tuser       ;
reg                                 ro_rd_ddr_ready     ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]     ri_rd_ddr_addr      ;
reg  [15 :0]                        ri_rd_ddr_len       ;
reg  [7 : 0]                        ri_rd_ddr_strb      ;
reg                                 ri_rd_ddr_valid     ;
reg                                 ro_rd_ddr_cpl       ;
reg                                 r_fifo_data_rden    ;
reg                                 r_fifo_len_rden     ;
reg                                 r_fifo_len_rden_1d = 0 ;
reg                                 r_fifo_len_rden_2d = 0 ;
reg  [15:0]                         r_fifo_rd_cnt       ;
reg                                 r_fifo_lock         ;
reg  [15:0]                         r_data_len          ;
reg  [7 :0]                         r_data_strb         ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]     ri_rd_ddr_byte      ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]     r_rd_complete_byte  ;
reg                                 ro_rd_queue_finish  ;

reg  [1:0]                           ri_rd_ddr_byte_valid;
reg         r_desc_rden;
reg         r_desc_rden_1d;
reg         r_desc_rden_lock;
/******************************wire*********************************/
wire                                w_axi_ar_active     ;
wire                                w_axi_rd_active     ;
wire                                w_axis_tx_active    ;
wire                                w_axi_rst           ;
wire [63:0]                         w_fifo_data_dout    ;
wire [15:0]                         w_fifo_len_dout     ;
wire [7 :0]                         w_fifo_strb_dout    ;
wire                                w_fifo_len_full     ;
wire                                w_fifo_len_empty    ;
wire                                w_fifo_data_rden    ;
wire                                w_rd_last_byte      ;
wire [31:0]                         w_max_next_pkt      ;

wire [47:0] w_desc_dout;
wire        w_desc_empty;
/******************************assign*******************************/
assign w_axi_rst = !M_AXI_ARESETN  ;
assign w_axi_ar_active = M_AXI_ARVALID & M_AXI_ARREADY;
assign w_axi_rd_active = M_AXI_RVALID & M_AXI_RREADY;
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
assign M_AXI_RREADY  = 1'b1    ;
assign m_axis_tvalid = rm_axis_tvalid   ;
assign m_axis_tdata  = w_fifo_data_dout    ;
assign m_axis_tlast  = rm_axis_tlast    ;
assign m_axis_tkeep  = rm_axis_tkeep    ;
assign m_axis_tuser  = 'd0    ;
assign o_rd_ddr_cpl  = ro_rd_ddr_cpl    ;
assign o_rd_ddr_ready = ro_rd_ddr_ready ;
assign w_fifo_data_rden = (r_fifo_data_rden && w_axis_tx_active) || r_fifo_len_rden_2d;
assign w_rd_last_byte = w_axis_tx_active && rm_axis_tlast;
assign w_max_next_pkt = ri_rd_ddr_byte - r_rd_complete_byte;
// assign o_rd_queue_finish = ro_rd_queue_finish;
assign o_rd_queue_finish = ri_rd_ddr_byte == r_rd_complete_byte;
/******************************component****************************/
FIFO_IND_64X4096 FIFO_IND_64X4096_data (
    .rst            (i_axis_rst          ), // input wire rst
    .wr_clk         (M_AXI_ACLK         ), // input wire wr_clk
    .rd_clk         (i_axis_clk         ), // input wire rd_clk
    .din            (M_AXI_RDATA        ), // input wire [63 : 0] din
    .wr_en          (w_axi_rd_active    ), // input wire wr_en
    .rd_en          (w_fifo_data_rden   ), // input wire rd_en
    .dout           (w_fifo_data_dout   ), // output wire [63 : 0] dout
    .full           (                   ), // output wire full
    .empty          (                   ), // output wire empty
    .wr_rst_busy    (                   ), // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);

FIFO_IND_16X16 FIFO_IND_16X16_len (
    .rst            (i_axis_rst          ),  // input wire rst
    .wr_clk         (M_AXI_ACLK         ),  // input wire wr_clk
    .rd_clk         (i_axis_clk         ),  // input wire rd_clk
    .din            (ri_rd_ddr_len      ),  // input wire [15 : 0] din
    .wr_en          (w_axi_rd_active && M_AXI_RLAST),  // input wire wr_en
    .rd_en          (r_fifo_len_rden    ),  // input wire rd_en
    .dout           (w_fifo_len_dout    ),  // output wire [15 : 0] dout
    .full           (w_fifo_len_full    ),  // output wire full
    .empty          (w_fifo_len_empty   ),  // output wire empty
    .wr_rst_busy    (),  // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);

FIFO_IND_8X32 FIFO_IND_8X32_keep (
    .rst            (i_axis_rst          ),  // input wire rst
    .wr_clk         (M_AXI_ACLK         ),  // input wire wr_clk
    .rd_clk         (i_axis_clk         ),  // input wire rd_clk
    .din            (ri_rd_ddr_strb     ),  // input wire [7 : 0] din
    .wr_en          (w_axi_rd_active && M_AXI_RLAST),  // input wire wr_en
    .rd_en          (r_fifo_len_rden    ),  // input wire rd_en
    .dout           (w_fifo_strb_dout   ),  // output wire [7 : 0] dout
    .full           (                   ),  // output wire full
    .empty          (                   ),  // output wire empty
    .wr_rst_busy    (                   ),  // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);


FIFO_DESC_48X256 FIFO_DESC_48X256 (
  .clk          (M_AXI_ACLK ),                  // input wire clk
  .srst         (w_axi_rst  ),               // input wire srst
  .din          ({i_rd_ddr_len,i_rd_ddr_addr}),                // input wire [47 : 0] din
  .wr_en        (i_rd_ddr_valid),              // input wire wr_en
  .rd_en        (r_desc_rden),              // input wire rd_en
  .dout         (w_desc_dout    ),               // output wire [47 : 0] dout
  .full         (),               // output wire full
  .empty        (w_desc_empty),              // output wire empty
  .wr_rst_busy  (wr_rst_busy),  // output wire wr_rst_busy
  .rd_rst_busy  (rd_rst_busy)  // output wire rd_rst_busy
);
/******************************always*******************************/
//================ AXI CLOCK REGION ==================//
always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        ro_rd_ddr_ready <= 'd0;
    else if(w_fifo_len_full)
        ro_rd_ddr_ready <= 'd0;
    else
        ro_rd_ddr_ready <= 'd1;
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        ro_rd_ddr_cpl <= 'd0;
    else if(w_axi_rd_active && M_AXI_RLAST)
        ro_rd_ddr_cpl <= 'd1;
    else
        ro_rd_ddr_cpl <= 'd0;
end

// always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
//     if(w_axi_rst)begin
//         ri_rd_ddr_addr  <= 'd0;
//         ri_rd_ddr_len   <= 'd0;
//         ri_rd_ddr_strb  <= 'd0;
//         ri_rd_ddr_valid <= 'd0;
//     end
//     else if(i_rd_ddr_valid)begin
//         ri_rd_ddr_addr  <= i_rd_ddr_addr ;
//         ri_rd_ddr_len   <= i_rd_ddr_len  ;
//         ri_rd_ddr_strb  <= i_rd_ddr_strb ;
//         ri_rd_ddr_valid <= i_rd_ddr_valid;
//     end
//     else begin
//         ri_rd_ddr_addr  <= ri_rd_ddr_addr ;
//         ri_rd_ddr_len   <= ri_rd_ddr_len  ;
//         ri_rd_ddr_strb  <= ri_rd_ddr_strb ;
//         ri_rd_ddr_valid <= 'd0;
//     end
// end


always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        r_desc_rden <= 'd0;
    else if(!w_desc_empty && !r_desc_rden_lock)
        r_desc_rden <= 'd1;
    else
        r_desc_rden <= 'd0;
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        r_desc_rden_1d <= 'd0;
    else
        r_desc_rden_1d <= r_desc_rden;
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        r_desc_rden_lock <= 'd0;
    else if(ro_rd_ddr_cpl)
        r_desc_rden_lock <= 'd0;
    else if(!w_desc_empty && !r_desc_rden_lock)
        r_desc_rden_lock <= 'd1;
    else
        r_desc_rden_lock <= r_desc_rden_lock;
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)begin
        ri_rd_ddr_addr  <= 'd0;
        ri_rd_ddr_len   <= 'd0;
        ri_rd_ddr_strb  <= 'd0;
        ri_rd_ddr_valid <= 'd0;
    end
    else if(r_desc_rden_1d)begin
        ri_rd_ddr_addr  <=  w_desc_dout[31:0];
        ri_rd_ddr_len   <=  w_desc_dout[47:32];
        ri_rd_ddr_strb  <= 8'hff ;
        ri_rd_ddr_valid <= 'd1;
    end
    else begin
        ri_rd_ddr_addr  <= ri_rd_ddr_addr ;
        ri_rd_ddr_len   <= ri_rd_ddr_len  ;
        ri_rd_ddr_strb  <= ri_rd_ddr_strb ;
        ri_rd_ddr_valid <= 'd0;
    end
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)begin
        rM_AXI_ARID    <= 'd0;
        rM_AXI_ARADDR  <= 'd0;
        rM_AXI_ARLEN   <= 'd0;
        rM_AXI_ARSIZE  <= 'd0;
        rM_AXI_ARBURST <= 'd0;
        rM_AXI_ARLOCK  <= 'd0;
        rM_AXI_ARCACHE <= 'd0;
        rM_AXI_ARPROT  <= 'd0;
        rM_AXI_ARQOS   <= 'd0;
        rM_AXI_ARUSER  <= 'd0;
        rM_AXI_ARVALID <= 'd0;
    end
    else if(w_axi_ar_active)begin
        rM_AXI_ARID    <= 'd0;
        rM_AXI_ARADDR  <= 'd0;
        rM_AXI_ARLEN   <= 'd0;
        rM_AXI_ARSIZE  <= 'd0;
        rM_AXI_ARBURST <= 'd0;
        rM_AXI_ARLOCK  <= 'd0;
        rM_AXI_ARCACHE <= 'd0;
        rM_AXI_ARPROT  <= 'd0;
        rM_AXI_ARQOS   <= 'd0;
        rM_AXI_ARUSER  <= 'd0;
        rM_AXI_ARVALID <= 'd0;
    end
    else if(ri_rd_ddr_valid)begin
        rM_AXI_ARID    <= 'd0;
        rM_AXI_ARADDR  <= ri_rd_ddr_addr;
        rM_AXI_ARLEN   <= ri_rd_ddr_len - 1;
        rM_AXI_ARSIZE  <= P_AXI_SIZE;
        rM_AXI_ARBURST <= 2'b01;
        rM_AXI_ARLOCK  <= 'd0;
        rM_AXI_ARCACHE <= 4'b0010;
        rM_AXI_ARPROT  <= 'd0;
        rM_AXI_ARQOS   <= 'd0;
        rM_AXI_ARUSER  <= 'd0;
        rM_AXI_ARVALID <= 'd1;
    end
    else begin
        rM_AXI_ARID    <= rM_AXI_ARID   ;
        rM_AXI_ARADDR  <= rM_AXI_ARADDR ;
        rM_AXI_ARLEN   <= rM_AXI_ARLEN  ;
        rM_AXI_ARSIZE  <= rM_AXI_ARSIZE ;
        rM_AXI_ARBURST <= rM_AXI_ARBURST;
        rM_AXI_ARLOCK  <= rM_AXI_ARLOCK ;
        rM_AXI_ARCACHE <= rM_AXI_ARCACHE;
        rM_AXI_ARPROT  <= rM_AXI_ARPROT ;
        rM_AXI_ARQOS   <= rM_AXI_ARQOS  ;
        rM_AXI_ARUSER  <= rM_AXI_ARUSER ;
        rM_AXI_ARVALID <= rM_AXI_ARVALID;
    end
end

always @(posedge M_AXI_ACLK or posedge w_axi_rst)begin
    if(w_axi_rst)
        rM_AXI_RREADY <= 'd0;
    else if(M_AXI_RLAST && w_axi_rd_active)
        rM_AXI_RREADY <= 'd0;
    else if(ri_rd_ddr_valid)
        rM_AXI_RREADY <= 'd1;
    else
        rM_AXI_RREADY <= rM_AXI_RREADY;
end

//================ AXIS CLOCK REGION ==================//
always @(posedge i_axis_clk or posedge i_axis_rst)begin
    if(i_axis_rst)
        r_fifo_len_rden <= 'd0;
    else if(r_fifo_len_rden)
        r_fifo_len_rden <= 'd0;
    else if(!r_fifo_lock && !w_fifo_len_empty)
        r_fifo_len_rden <= 'd1;
    else
        r_fifo_len_rden <= r_fifo_len_rden;
end

always @(posedge i_axis_clk)begin
    r_fifo_len_rden_1d <= r_fifo_len_rden;
    r_fifo_len_rden_2d <= r_fifo_len_rden_1d;
end

always @(posedge i_axis_clk or posedge i_axis_rst)begin
    if(i_axis_rst)
        r_fifo_lock <= 'd0;
    else if(m_axis_tlast && w_axis_tx_active)
        r_fifo_lock <= 'd0;
    else if(!r_fifo_lock && !w_fifo_len_empty)
        r_fifo_lock <= 'd1;
    else
        r_fifo_lock <= r_fifo_lock;
end

always @(posedge i_axis_clk or posedge i_axis_rst)begin
    if(i_axis_rst)begin
        r_data_len  <= 'd0;
        r_data_strb <= 'd0;
    end
    else if(r_fifo_len_rden_1d)begin
        r_data_len  <= w_fifo_len_dout;
        r_data_strb <= w_fifo_strb_dout;
    end
    else begin
        r_data_len  <= r_data_len ;
        r_data_strb <= r_data_strb;
    end
end
//read data fifo
always @(posedge i_axis_clk or posedge i_axis_rst)begin
    if(i_axis_rst)
        r_fifo_data_rden <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len - 1 && w_axis_tx_active)
        r_fifo_data_rden <= 'd0;
    else if(r_fifo_len_rden_1d)
        r_fifo_data_rden <= 'd1;
    else
        r_fifo_data_rden <= r_fifo_data_rden;
end

always @(posedge i_axis_clk or posedge i_axis_rst)begin
    if(i_axis_rst)
        r_fifo_rd_cnt <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len && w_axis_tx_active && r_fifo_rd_cnt != 0)
        r_fifo_rd_cnt <= 'd0;
    else if(w_fifo_data_rden || (r_fifo_rd_cnt == r_data_len - 1 && w_axis_tx_active))
        r_fifo_rd_cnt <= r_fifo_rd_cnt + 1'b1;
    else
        r_fifo_rd_cnt <= r_fifo_rd_cnt;
end

always @(posedge i_axis_clk or posedge i_axis_rst)begin
    if(i_axis_rst)
        rm_axis_tvalid <= 'd0;
    else if(rm_axis_tlast && w_axis_tx_active)
        rm_axis_tvalid <= 'd0;
    else if(r_fifo_data_rden)
        rm_axis_tvalid <= 'd1;
    else
        rm_axis_tvalid <= rm_axis_tvalid;
end

always @(posedge i_axis_clk or posedge i_axis_rst)begin
    if(i_axis_rst)
        rm_axis_tlast <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len && w_axis_tx_active)
        rm_axis_tlast <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len - 1 && w_axis_tx_active)
        rm_axis_tlast <= 'd1;
    else
        rm_axis_tlast <= rm_axis_tlast;
end
 
always @(posedge i_axis_clk or posedge i_axis_rst)begin
    if(i_axis_rst)
        rm_axis_tkeep <= 8'hff;
    else if(r_fifo_rd_cnt == r_data_len && w_axis_tx_active)
        rm_axis_tkeep <= 8'hff;
    else if(r_fifo_rd_cnt == r_data_len - 1 && w_axis_tx_active)
        rm_axis_tkeep <= r_data_strb;
    else
        rm_axis_tkeep <= rm_axis_tkeep;
end

//读DDR结束指示信号

always @(posedge i_axis_clk or posedge i_axis_rst)begin
    if(i_axis_rst)
        ri_rd_ddr_byte_valid <= 'd0;
    else
        ri_rd_ddr_byte_valid <= {ri_rd_ddr_byte_valid[0],i_rd_ddr_byte_valid};
end


always @(posedge i_axis_clk or posedge i_axis_rst)begin
    if(i_axis_rst)
        ri_rd_ddr_byte <= 'd0;
    else if(ri_rd_ddr_byte_valid[1])
        ri_rd_ddr_byte <= i_rd_ddr_byte;
    else
        ri_rd_ddr_byte <= ri_rd_ddr_byte;
end

always @(posedge i_axis_clk or posedge i_axis_rst)begin
    if(i_axis_rst)
        r_rd_complete_byte <= 'd0;
    else if(ri_rd_ddr_byte_valid[1])
        r_rd_complete_byte <= 'd0;
    else if(w_axis_tx_active && rm_axis_tlast)
        r_rd_complete_byte <= r_rd_complete_byte + (r_data_len << 3);
    else
        r_rd_complete_byte <= r_rd_complete_byte;
end

always @(posedge i_axis_clk or posedge i_axis_rst)begin
    if(i_axis_rst)
        ro_rd_queue_finish <= 'd0;
    else if(ri_rd_ddr_byte_valid[1])
        ro_rd_queue_finish <= 'd0;
    else if(w_max_next_pkt < 1518)
        ro_rd_queue_finish <= 'd1;
    else
        ro_rd_queue_finish <= ro_rd_queue_finish;
end

// always @(posedge i_axis_clk or posedge i_axis_rst)begin
//     if(i_axis_rst)
//          <= 'd0;
//     else if()
        
//     else
        
// end


endmodule
