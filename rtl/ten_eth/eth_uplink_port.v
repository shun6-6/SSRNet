`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/13 16:24:19
// Design Name: 
// Module Name: eth_uplink_port
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


module eth_uplink_port(
    input           i_crtl_clk              ,
    input           i_crtl_rst              ,
    input           i_data_clk              ,
    input           i_data_rst              ,
    //receive 10g eth data
    input           s_ctrl_axis_tvalid      ,
    input  [63 :0]  s_ctrl_axis_tdata       ,
    input           s_ctrl_axis_tlast       ,
    input  [7  :0]  s_ctrl_axis_tkeep       ,
    input           s_ctrl_axis_tuser       ,
  
    input           s_data_axis_tvalid      ,
    input  [63 :0]  s_data_axis_tdata       ,
    input           s_data_axis_tlast       ,
    input  [7  :0]  s_data_axis_tkeep       ,
    input           s_data_axis_tuser       ,
    output          s_data_axis_tready      ,
    //output AXIS
    output          m_tx_axis_tvalid        ,
    output [63 :0]  m_tx_axis_tdata         ,
    output          m_tx_axis_tlast         ,
    output [7  :0]  m_tx_axis_tkeep         ,
    output          m_tx_axis_tuser         ,
    input           m_tx_axis_tready        
);
/******************************function*****************************/

/******************************parameter****************************/

/******************************machine******************************/

/******************************reg**********************************/
reg             rm_tx_axis_tvalid       ;
reg  [63 :0]    rm_tx_axis_tdata        ;
reg             rm_tx_axis_tlast        ;
reg  [7  :0]    rm_tx_axis_tkeep        ;
reg             r_fifo_len_rden         ;
reg             r_fifo_data_rden        ;
reg             r_fifo_len_rden_1d      ;
reg             r_fifo_len_rden_2d      ;
reg             r_fifo_data_rden_1d     ;
reg  [15:0]     r_wr_fifo_len           ;
reg  [15:0]     r_data_len              ;
reg  [15:0]     r_fifo_rd_cnt           ;
reg  [7 :0]     r_data_keep             ;
reg             r_fifo_lock             ;
reg  [1 :0]     r_fifo_arbiter          ;//1:read ctrl fifo 2:read data fifo
/******************************wire*********************************/
wire [63:0]     w_fifo_data_dout        ;
wire [15:0]     w_fifo_len_dout         ;
wire            w_fifo_len_full         ;
wire            w_fifo_len_empty        ;
wire [7 :0]     w_fifo_keep_dout        ;
wire            w_fifo_data_rden        ;
wire            w_wr_active             ;
/******************************assign*******************************/
assign m_tx_axis_tuser = 'd0;

assign s_data_axis_tready = r_fifo_arbiter == 2 ? m_tx_axis_tready   : 'd0  ;
assign m_tx_axis_tvalid   = r_fifo_arbiter == 2 ? s_data_axis_tvalid : rm_tx_axis_tvalid   ;
assign m_tx_axis_tdata    = r_fifo_arbiter == 2 ? s_data_axis_tdata  : rm_tx_axis_tdata    ;
assign m_tx_axis_tlast    = r_fifo_arbiter == 2 ? s_data_axis_tlast  : rm_tx_axis_tlast    ;
assign m_tx_axis_tkeep    = r_fifo_arbiter == 2 ? s_data_axis_tkeep  : rm_tx_axis_tkeep    ;
assign m_tx_axis_tuser    = r_fifo_arbiter == 2 ? s_data_axis_tuser  : 'd0   ;
assign w_wr_active      = m_tx_axis_tvalid & m_tx_axis_tready;
assign w_fifo_data_rden = (r_fifo_data_rden && w_wr_active) || r_fifo_len_rden_2d;
/******************************component****************************/
FIFO_IND_64X2048 FIFO_IND_64X2048_data (
  .rst          (i_crtl_rst         ), // input wire rst
  .wr_clk       (i_crtl_clk         ), // input wire wr_clk
  .rd_clk       (i_data_clk         ), // input wire rd_clk
  .din          (s_ctrl_axis_tdata  ), // input wire [63 : 0] din
  .wr_en        (s_ctrl_axis_tvalid ), // input wire wr_en
  .rd_en        (), // input wire rd_en
  .dout         (w_fifo_data_dout   ), // output wire [63 : 0] dout
  .full         (), // output wire full
  .empty        (), // output wire empty
  .wr_rst_busy  (), // output wire wr_rst_busy
  .rd_rst_busy  ()  // output wire rd_rst_busy
);

FIFO_IND_OOC_16X16 FIFO_IND_OOC_16X16_len (
  .rst          (i_crtl_rst         ), // input wire rst
  .wr_clk       (i_crtl_clk         ), // input wire wr_clk
  .rd_clk       (i_data_clk         ), // input wire rd_clk
  .din          (r_wr_fifo_len + 1'b1), // input wire [15 : 0] din
  .wr_en        (s_ctrl_axis_tvalid && s_ctrl_axis_tlast), // input wire wr_en
  .rd_en        (r_fifo_len_rden    ), // input wire rd_en
  .dout         (), // output wire [15 : 0] dout
  .full         (w_fifo_len_full    ), // output wire full
  .empty        (w_fifo_len_empty   ), // output wire empty
  .wr_rst_busy  (), // output wire wr_rst_busy
  .rd_rst_busy  ()  // output wire rd_rst_busy
);

FIFO_IND_OOC_8X16 FIFO_IND_OOC_8X16_keep (
  .rst          (i_crtl_rst         ), // input wire rst
  .wr_clk       (i_crtl_clk         ), // input wire wr_clk
  .rd_clk       (i_data_clk         ), // input wire rd_clk
  .din          (s_ctrl_axis_tkeep  ), // input wire [7 : 0] din
  .wr_en        (s_ctrl_axis_tvalid && s_ctrl_axis_tlast), // input wire wr_en
  .rd_en        (r_fifo_len_rden    ), // input wire rd_en
  .dout         (w_fifo_keep_dout   ), // output wire [7 : 0] dout
  .full         (), // output wire full
  .empty        (), // output wire empty
  .wr_rst_busy  (), // output wire wr_rst_busy
  .rd_rst_busy  ()  // output wire rd_rst_busy
);
/******************************always*******************************/
//==========ctrl clock region==========//
always @(posedge i_crtl_clk or posedge i_crtl_rst) begin
    if(i_crtl_rst)
        r_wr_fifo_len <= 'd0;
    else if(s_ctrl_axis_tvalid && s_ctrl_axis_tlast)
        r_wr_fifo_len <= 'd0;
    else if(s_ctrl_axis_tvalid)
        r_wr_fifo_len <= r_wr_fifo_len + 'd1;
    else
        r_wr_fifo_len <= r_wr_fifo_len;
end

/*控制数据需要通过异步FIFO处理跨时钟的问题，当控制数据FIFO不空，
  若此时输出端口没有数据在输出，则直接开始输出控制数据，如果有
  数据在输出，则等待结束后开始输出控制数据*/
//==========data clock region============//
//fifo arbiter
always @(posedge i_data_clk or posedge i_data_rst) begin
    if(i_data_rst)
        r_fifo_arbiter <= 'd0;
    else if(!w_fifo_len_empty && !m_tx_axis_tvalid)
        r_fifo_arbiter <= 'd1;
    else if(w_fifo_len_empty && !m_tx_axis_tvalid)
        r_fifo_arbiter <= 'd2;
    else
        r_fifo_arbiter <= r_fifo_arbiter;
end

always @(posedge i_data_clk or posedge i_data_rst) begin
    if(i_data_rst)
        r_fifo_len_rden <= 'd0;
    else if(r_fifo_lock)
        r_fifo_len_rden <= 'd0;
    else if(r_fifo_arbiter == 'd1 && !w_fifo_len_empty)
        r_fifo_len_rden <= 'd1;
    else
        r_fifo_len_rden <= r_fifo_len_rden;
end

always @(posedge i_data_clk or posedge i_data_rst) begin
    if(i_data_rst)
        r_fifo_lock <= 'd0;
    else if(r_fifo_arbiter == 'd1 && m_tx_axis_tvalid && m_tx_axis_tlast)
        r_fifo_lock <= 'd0;
    else if(r_fifo_arbiter == 'd1 && !w_fifo_len_empty)
        r_fifo_lock <= 'd1;
    else
        r_fifo_lock <= r_fifo_lock;
end

always @(posedge i_data_clk or posedge i_data_rst) begin
    if(i_data_rst)begin
        r_fifo_len_rden_1d <= 'd0;
        r_fifo_len_rden_2d <= 'd0;
    end else begin
        r_fifo_len_rden_1d <= r_fifo_len_rden;
        r_fifo_len_rden_2d = r_fifo_len_rden_1d;
    end
end

always @(posedge i_data_clk or posedge i_data_rst) begin
    if(i_data_rst)
        r_data_len <= 'd0;
    else if(r_fifo_len_rden_1d)
        r_data_len <= w_fifo_len_dout;
    else
        r_data_len <= r_data_len;
end

always @(posedge i_data_clk or posedge i_data_rst) begin
    if(i_data_rst)
        r_data_keep <= 'd0;
    else if(r_fifo_len_rden_1d)
        r_data_keep <= w_fifo_keep_dout;
    else
        r_data_keep <= r_data_keep;    
end

always @(posedge i_data_clk or posedge i_data_rst) begin
    if(i_data_rst)
        r_fifo_rd_cnt <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len - 1 && w_wr_active)
        r_fifo_rd_cnt <= 'd0;
    else if(w_wr_active)
        r_fifo_rd_cnt <= r_fifo_rd_cnt + 1'b1;
    else
        r_fifo_rd_cnt <= r_fifo_rd_cnt; 
end

always @(posedge i_data_clk or posedge i_data_rst) begin
    if(i_data_rst)
        r_fifo_data_rden <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len - 1 && w_wr_active)
        r_fifo_data_rden <= 'd0;
    else if(r_fifo_len_rden_1d)
        r_fifo_data_rden <= 'd1;
    else
        r_fifo_data_rden <= r_fifo_data_rden; 
end

always @(posedge i_data_clk or posedge i_data_rst) begin
    if(i_data_rst)
        rm_tx_axis_tvalid <= 'd0;
    else if(rm_tx_axis_tlast && w_wr_active)
        rm_tx_axis_tvalid <= 'd0;
    else if(r_fifo_data_rden)
        rm_tx_axis_tvalid <= 'd1;
    else
        rm_tx_axis_tvalid <= rm_tx_axis_tvalid;
end

always @(posedge i_data_clk or posedge i_data_rst) begin
    if(i_data_rst)
        rm_tx_axis_tlast <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len - 1 && w_wr_active)
        rm_tx_axis_tlast <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len - 2 && w_wr_active)
        rm_tx_axis_tlast <= 'd1;
    else
        rm_tx_axis_tlast <= rm_tx_axis_tlast;
end

always @(posedge i_data_clk or posedge i_data_rst) begin
    if(i_data_rst)
        rm_tx_axis_tkeep <= 8'hff;
    else if(r_fifo_rd_cnt == r_data_len - 1 && w_wr_active)
        rm_tx_axis_tkeep <= 8'hff;
    else if(r_fifo_rd_cnt == r_data_len - 2 && w_wr_active)
        rm_tx_axis_tkeep <= r_data_keep;
    else
        rm_tx_axis_tkeep <= rm_tx_axis_tkeep;
end

// always @(posedge i_data_clk or posedge i_data_rst) begin
//     if(i_data_rst)
        
//     else if()
        
//     else if()
        
//     else
        
// end

endmodule
