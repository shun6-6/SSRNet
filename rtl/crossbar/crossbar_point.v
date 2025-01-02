`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 12:54:07
// Design Name: 
// Module Name: crossbar_point
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


module crossbar_point#(
    parameter       P_DEST = 3'd0
)(
    input           i_clk                   ,
    input           i_rst                   ,

    output          o_trans_req             ,
    input           i_trans_grant           ,

    input           s_axis_rx_tvalid        ,
    input  [63 :0]  s_axis_rx_tdata         ,
    input           s_axis_rx_tlast         ,
    input  [7  :0]  s_axis_rx_tkeep         ,
    input  [1 : 0]  s_axis_rx_tuser         ,
    input  [2 : 0]  s_axis_rx_tdest         ,

    output          m_axis_tx_tvalid        ,
    output [63 :0]  m_axis_tx_tdata         ,
    output          m_axis_tx_tlast         ,
    output [7  :0]  m_axis_tx_tkeep         ,
    output          m_axis_tx_tuser         ,
    input           m_axis_tx_tready        
);
/******************************function*****************************/

/******************************parameter****************************/

/******************************machine******************************/

/******************************reg**********************************/
reg             rs_axis_rx_tvalid       ;
reg  [63 :0]    rs_axis_rx_tdata        ;
reg             rs_axis_rx_tlast        ;
reg  [7  :0]    rs_axis_rx_tkeep        ;
reg  [1 : 0]    rs_axis_rx_tuser        ;
reg  [2 : 0]    rs_axis_rx_tdest        ;
reg             rm_axis_tx_tvalid       ;
reg  [63 :0]    rm_axis_tx_tdata        ;
reg             rm_axis_tx_tlast        ;
reg             rm_axis_tx_tlast_1d = 0 ;
reg  [7  :0]    rm_axis_tx_tkeep        ;
reg             rm_axis_tx_tuser        ;
reg             ri_trans_grant          ;
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
//transmit request
reg             r_trans_req             ;
/******************************wire*********************************/
wire [63:0]     w_fifo_data_dout        ;
wire [15:0]     w_fifo_len_dout         ;
wire            w_fifo_len_full         ;
wire            w_fifo_len_empty        ;
wire [7 :0]     w_fifo_keep_dout        ;
wire            w_wr_active             ;
wire            w_wr_en                 ;
wire            w_fifo_data_rden        ;
/******************************assign*******************************/
assign m_axis_tx_tvalid = rm_axis_tx_tvalid ;
assign m_axis_tx_tdata  = w_fifo_data_dout  ;
assign m_axis_tx_tlast  = rm_axis_tx_tlast  ;
assign m_axis_tx_tkeep  = rm_axis_tx_tkeep  ;
assign m_axis_tx_tuser  = 'd0  ;
assign o_trans_req      = r_trans_req       ;
assign w_wr_en          = rs_axis_rx_tdest == P_DEST && rs_axis_rx_tvalid && (rs_axis_rx_tuser == 'd1);
assign w_wr_active      = m_axis_tx_tvalid & m_axis_tx_tready;
assign w_fifo_data_rden = (r_fifo_data_rden && w_wr_active) || r_fifo_len_rden_2d;
/******************************component****************************/
FIFO_64X256 FIFO_64X256_data (
    .clk            (i_clk              ), // input wire clk
    .srst           (i_rst              ), // input wire srst
    .din            (rs_axis_rx_tdata   ), // input wire [63 : 0] din
    .wr_en          (w_wr_en            ), // input wire wr_en
    .rd_en          (w_fifo_data_rden   ), // input wire rd_en
    .dout           (w_fifo_data_dout   ), // output wire [63 : 0] dout
    .full           (                   ), // output wire full
    .empty          (                   ), // output wire empty
    .wr_rst_busy    (                   ), // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);

FIFO_16x32 FIFO_16x32_len (
    .clk            (i_clk              ), // input wire clk
    .srst           (i_rst              ), // input wire srst
    .din            (r_rx_data_len + 16'd1), // input wire [15 : 0] din
    .wr_en          (rs_axis_rx_tlast && w_wr_en), // input wire wr_en
    .rd_en          (r_fifo_len_rden    ), // input wire rd_en
    .dout           (w_fifo_len_dout    ), // output wire [15 : 0] dout
    .full           (w_fifo_len_full    ), // output wire full
    .empty          (w_fifo_len_empty   ), // output wire empty
    .wr_rst_busy    (                   ), // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);

FIFO_8x32 FIFO_8x32_keep (
    .clk            (i_clk              ), // input wire clk
    .srst           (i_rst              ), // input wire srst
    .din            (rs_axis_rx_tkeep   ), // input wire [7 : 0] din
    .wr_en          (rs_axis_rx_tlast && w_wr_en), // input wire wr_en
    .rd_en          (r_fifo_len_rden    ), // input wire rd_en
    .dout           (w_fifo_keep_dout   ), // output wire [7 : 0] dout
    .full           (                   ), // output wire full
    .empty          (                   ), // output wire empty
    .wr_rst_busy    (                   ), // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);
/******************************always*******************************/
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        rs_axis_rx_tvalid <= 'd0;
        rs_axis_rx_tdata  <= 'd0;
        rs_axis_rx_tlast  <= 'd0;
        rs_axis_rx_tkeep  <= 'd0;
        rs_axis_rx_tuser  <= 'd0;
        rs_axis_rx_tdest  <= 'd0;
        ri_trans_grant    <= 'd0;
    end
    else begin
        rs_axis_rx_tvalid <= s_axis_rx_tvalid   ;
        rs_axis_rx_tdata  <= s_axis_rx_tdata    ;
        rs_axis_rx_tlast  <= s_axis_rx_tlast    ;
        rs_axis_rx_tkeep  <= s_axis_rx_tkeep    ;
        rs_axis_rx_tuser  <= s_axis_rx_tuser    ;
        rs_axis_rx_tdest  <= s_axis_rx_tdest    ;
        ri_trans_grant    <= i_trans_grant      ;
    end
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_rx_data_len <= 'd0;
    else if(rs_axis_rx_tlast)
        r_rx_data_len <= 'd0;
    else if(rs_axis_rx_tvalid)
        r_rx_data_len <= r_rx_data_len + 'd1;
    else
        r_rx_data_len <= r_rx_data_len;
end

//generate transmit request
always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_trans_req <= 'd0;
    else if(i_trans_grant)
        r_trans_req <= 'd0;
    else if(!w_fifo_len_empty && !r_fifo_lock)
        r_trans_req <= 'd1;
    else
        r_trans_req <= r_trans_req;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_fifo_lock <= 'd0;
    else if(rm_axis_tx_tlast)
        r_fifo_lock <= 'd0;
    else if(r_fifo_len_rden)
        r_fifo_lock <= 'd1;
    else
        r_fifo_lock <= r_fifo_lock;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_fifo_len_rden <= 'd0;
    else if(r_fifo_len_rden)
        r_fifo_len_rden <= 'd0;
    else if(ri_trans_grant && !w_fifo_len_empty && !r_fifo_lock)
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
        r_fifo_len_rden_2d <= r_fifo_len_rden_1d;
    end
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
    else if(r_fifo_rd_cnt == r_data_len && w_wr_active && r_fifo_rd_cnt != 0)
        r_fifo_rd_cnt <= 'd0;
    else if(w_fifo_data_rden || (r_fifo_rd_cnt == r_data_len - 1 && w_wr_active))
        r_fifo_rd_cnt <= r_fifo_rd_cnt + 1'b1;
    else
        r_fifo_rd_cnt <= r_fifo_rd_cnt;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_fifo_data_rden <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len - 1 && w_wr_active)
        r_fifo_data_rden <= 'd0;
    else if(r_fifo_len_rden_1d)
        r_fifo_data_rden <= 'd1;
    else
        r_fifo_data_rden <= r_fifo_data_rden;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_fifo_data_rden_1d <= 'd0;
    else
        r_fifo_data_rden_1d <= r_fifo_data_rden;
end
 
always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        rm_axis_tx_tvalid <= 'd0;
    else if(rm_axis_tx_tlast && w_wr_active)
        rm_axis_tx_tvalid <= 'd0;
    else if(r_fifo_data_rden)
        rm_axis_tx_tvalid <= 'd1;
    else
        rm_axis_tx_tvalid <= rm_axis_tx_tvalid;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        rm_axis_tx_tlast <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len && w_wr_active)
        rm_axis_tx_tlast <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len - 1 && w_wr_active)
        rm_axis_tx_tlast <= 'd1;
    else
        rm_axis_tx_tlast <= rm_axis_tx_tlast;
end
always @(posedge i_clk) begin
    rm_axis_tx_tlast_1d <= rm_axis_tx_tlast;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        rm_axis_tx_tkeep <= 8'hff;
    else if(r_fifo_rd_cnt == r_data_len && w_wr_active)
        rm_axis_tx_tkeep <= 8'hff;
    else if(r_fifo_rd_cnt == r_data_len - 1 && w_wr_active)
        rm_axis_tx_tkeep <= r_data_keep;
    else
        rm_axis_tx_tkeep <= rm_axis_tx_tkeep;
end


endmodule
