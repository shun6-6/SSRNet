`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 11:17:53
// Design Name: 
// Module Name: forward_pkt_module
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


module forward_pkt_module(
    input           i_clk               ,
    input           i_rst               ,

    output          o_forward_req       ,
    input           i_forward_resp      ,
    output          o_forward_finish    ,

    input           s_axis_tvalid       ,
    input  [63 :0]  s_axis_tdata        ,
    input           s_axis_tlast        ,
    input  [7  :0]  s_axis_tkeep        ,
    input           s_axis_tuser        ,

    output          m_axis_tvalid       ,
    output [63 :0]  m_axis_tdata        ,
    output          m_axis_tlast        ,
    output [7  :0]  m_axis_tkeep        ,
    output          m_axis_tuser        ,
    input           m_axis_tready       
);
/******************************function*****************************/

/******************************parameter****************************/

/******************************machine******************************/

/******************************reg**********************************/
reg             rm_axis_tvalid       ;
reg  [63 :0]    rm_axis_tdata        ;
reg             rm_axis_tlast        ;
reg  [7  :0]    rm_axis_tkeep        ;
reg             rm_axis_tuser        ;
//FIFO
reg  [15:0]     r_rx_data_len           ;
reg             r_fifo_len_rden         ;
reg             r_fifo_data_rden        ;
reg             r_fifo_len_rden_1d      ;
reg             r_fifo_len_rden_2d      ;
reg             r_fifo_data_rden_1d     ;
reg  [15:0]     r_data_len              ;
reg  [15:0]     r_fifo_rd_cnt           ;
reg  [7 :0]     r_data_keep             ;
reg             r_fifo_lock             ;

reg             ro_forward_req          ;
reg             ro_forward_finish       ;
reg             r_continue_rd           ;
/******************************wire*********************************/
wire [63:0]     w_fifo_data_dout        ;
wire [15:0]     w_fifo_len_dout         ;
wire            w_fifo_len_full         ;
wire            w_fifo_len_empty        ;
wire [7 :0]     w_fifo_keep_dout        ;
wire            w_fifo_data_rden        ;
wire            w_forward_en            ;
wire            w_tx_en                 ;
/******************************assign*******************************/
assign m_axis_tvalid = rm_axis_tvalid;
assign m_axis_tdata  = rm_axis_tdata ;
assign m_axis_tlast  = rm_axis_tlast ;
assign m_axis_tkeep  = rm_axis_tkeep ;
assign m_axis_tuser  = 'd0 ;
assign o_forward_req    = ro_forward_req   ;
assign o_forward_finish = ro_forward_finish;
assign w_forward_en = ro_forward_req & i_forward_resp;
assign w_tx_en = rm_axis_tvalid & m_axis_tready;
assign w_fifo_data_rden = (r_fifo_data_rden && w_tx_en) || r_fifo_len_rden_2d;
/******************************component****************************/
FIFO_FORWARD_BUF FIFO_FORWARD_BUF_data (//64x16384
    .clk            (i_clk              ), // input wire clk
    .srst           (i_rst              ), // input wire srst
    .din            (s_axis_tdata       ), // input wire [63 : 0] din
    .wr_en          (s_axis_tvalid      ), // input wire wr_en
    .rd_en          (w_fifo_data_rden   ), // input wire rd_en
    .dout           (w_fifo_data_dout   ), // output wire [63 : 0] dout
    .full           (                   ), // output wire full
    .empty          (                   ), // output wire empty
    .wr_rst_busy    (                   ), // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);

FIFO_16X128 FIFO_16X128_len (
    .clk            (i_clk              ), // input wire clk
    .srst           (i_rst              ), // input wire srst
    .din            (r_rx_data_len + 16'd1), // input wire [15 : 0] din
    .wr_en          (s_axis_tlast       ), // input wire wr_en
    .rd_en          (r_fifo_len_rden    ), // input wire rd_en
    .dout           (w_fifo_len_dout    ), // output wire [15 : 0] dout
    .full           (w_fifo_len_full    ), // output wire full
    .empty          (w_fifo_len_empty   ), // output wire empty
    .wr_rst_busy    (                   ), // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);

FIFO_8X128 FIFO_8X128_keep (
    .clk            (i_clk              ), // input wire clk
    .srst           (i_rst              ), // input wire srst
    .din            (s_axis_tkeep       ), // input wire [7 : 0] din
    .wr_en          (s_axis_tlast       ), // input wire wr_en
    .rd_en          (r_fifo_len_rden    ), // input wire rd_en
    .dout           (w_fifo_keep_dout   ), // output wire [7 : 0] dout
    .full           (                   ), // output wire full
    .empty          (                   ), // output wire empty
    .wr_rst_busy    (                   ), // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);
/******************************always*******************************/
always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_rx_data_len <= 'd0;
    else if(s_axis_tlast & s_axis_tvalid)
        r_rx_data_len <= 'd0;
    else if(s_axis_tvalid)
        r_rx_data_len <= r_rx_data_len + 'd1;
    else
        r_rx_data_len <= r_rx_data_len;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ro_forward_req <= 'd0;
    else if(w_forward_en)
        ro_forward_req <= 'd0;
    else if(!w_fifo_len_empty)
        ro_forward_req <= 'd1;
    else
        ro_forward_req <= ro_forward_req;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ro_forward_finish <= 'd0;
    else if(w_fifo_len_empty)
        ro_forward_finish <= 'd1;
    else if(!w_fifo_len_empty)
        ro_forward_finish <= 'd0;
    else
        ro_forward_finish <= ro_forward_finish;
end
//begin read fifo
always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_fifo_len_rden <= 'd0;
    else if(r_fifo_len_rden)
        r_fifo_len_rden <= 'd0;
    else if((w_forward_en || r_continue_rd) && !r_fifo_lock)
        r_fifo_len_rden <= 'd1;
    else
        r_fifo_len_rden <= 'd0;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)begin
        r_fifo_len_rden_1d <= 'd0;
        r_fifo_len_rden_2d <= 'd0;
    end else begin
        r_fifo_len_rden_1d <= r_fifo_len_rden;
        r_fifo_len_rden_2d = r_fifo_len_rden_1d;
    end
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_fifo_lock <= 'd0;
    else if(rm_axis_tlast)
        r_fifo_lock <= 'd0;
    else if(r_fifo_len_rden)
        r_fifo_lock <= 'd1;
    else
        r_fifo_lock <= r_fifo_lock;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_continue_rd <= 'd0;
    else if(w_fifo_len_empty)
        r_continue_rd <= 'd0;
    else if(w_forward_en)
        r_continue_rd <= 'd1;
    else
        r_continue_rd <= r_continue_rd;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_data_len <= 'd0;
    else if(r_fifo_len_rden_1d)
        r_data_len <= w_fifo_len_dout;
    else
        r_data_len <= r_data_len;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_data_keep <= 'd0;
    else if(r_fifo_len_rden_1d)
        r_data_keep <= w_fifo_keep_dout;
    else
        r_data_keep <= r_data_keep;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_fifo_rd_cnt <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len - 1 && w_tx_en)
        r_fifo_rd_cnt <= 'd0;
    else if(w_tx_en)
        r_fifo_rd_cnt <= r_fifo_rd_cnt + 1'b1;
    else
        r_fifo_rd_cnt <= r_fifo_rd_cnt;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_fifo_data_rden <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len - 1 && w_tx_en)
        r_fifo_data_rden <= 'd0;
    else if(r_fifo_len_rden_1d)
        r_fifo_data_rden <= 'd1;
    else
        r_fifo_data_rden <= r_fifo_data_rden;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        rm_axis_tvalid <= 'd0;
    else if(rm_axis_tlast && w_tx_en)
        rm_axis_tvalid <= 'd0;
    else if(r_fifo_data_rden)
        rm_axis_tvalid <= 'd1;
    else
        rm_axis_tvalid <= rm_axis_tvalid;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        rm_axis_tlast <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len - 1 && w_tx_en)
        rm_axis_tlast <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len - 2 && w_tx_en)
        rm_axis_tlast <= 'd1;
    else
        rm_axis_tlast <= rm_axis_tlast;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        rm_axis_tkeep <= 8'hff;
    else if(r_fifo_rd_cnt == r_data_len - 1 && w_tx_en)
        rm_axis_tkeep <= 8'hff;
    else if(r_fifo_rd_cnt == r_data_len - 2 && w_tx_en)
        rm_axis_tkeep <= r_data_keep;
    else
        rm_axis_tkeep <= rm_axis_tkeep;
end


endmodule
