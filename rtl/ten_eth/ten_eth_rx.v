`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/15 11:16:07
// Design Name: 
// Module Name: ten_eth_rx
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


module ten_eth_rx#(
    parameter       P_RX_ID = 0
)(
    input           i_clk                   ,
    input           i_rst                   ,
    input           i_stat_rx_status        ,
    //receive 10g eth data      
    input           s_axis_rx_tvalid        ,
    input  [63 :0]  s_axis_rx_tdata         ,
    input           s_axis_rx_tlast         ,
    input  [7  :0]  s_axis_rx_tkeep         ,
    input           s_axis_rx_tuser         ,
    //seek outport      
    output [47:0]   o_check_mac             , 
    output [3 :0]   o_check_id              ,
    output          o_check_valid           ,
    //get outport       
    input  [3 :0]   i_outport               ,
    input           i_result_valid          ,
    input  [3 :0]   i_check_id              ,
    input           i_seek_flag             ,
    //output AXIS
    output          o_axis_tvalid           ,
    output [63 :0]  o_axis_tdata            ,
    output          o_axis_tlast            ,
    output [7  :0]  o_axis_tkeep            ,
    output          o_axis_tuser            ,
    output [2 : 0]  o_axis_tdest             
);
/******************************function*****************************/

/******************************parameter****************************/

/******************************machine******************************/

/******************************reg**********************************/
reg             ro_axis_tvalid    ;
reg  [63 :0]    ro_axis_tdata     ;
reg             ro_axis_tlast     ;
reg  [7  :0]    ro_axis_tkeep     ;
reg             ro_axis_tuser     ;
reg  [2 : 0]    ro_axis_tdest     ;

reg             rs_axis_rx_tvalid       ;
reg  [63 :0]    rs_axis_rx_tdata        ;
reg             rs_axis_rx_tlast        ;
reg  [7  :0]    rs_axis_rx_tkeep        ;
reg             rs_axis_rx_tuser        ;
reg             rs_axis_rx_tvalid_1d    ;
reg  [63 :0]    rs_axis_rx_tdata_1d     ;
reg  [3 :0]     ri_outport              ;
reg             ri_result_valid         ;
reg  [3 :0]     ri_check_id             ;
reg             ri_seek_flag            ;
reg             r_check_ready           ;
reg  [47 :0]	r_recv_dst_mac		    ;
reg  [47 :0]	r_recv_src_mac		    ;
reg  [5 :0]		r_recv_cnt			    ;

reg  [47:0]     ro_check_mac            ;
reg  [3 :0]     ro_check_id             ;
reg             ro_check_valid          ;


reg  [15:0]     r_rx_data_len           ;
reg             r_fifo_len_rden         ;
reg             r_fifo_data_rden        ;
reg             r_fifo_len_rden_1d      ;
reg             r_fifo_data_rden_1d     ;
reg  [15:0]     r_data_len              ;
reg  [15:0]     r_fifo_rd_cnt           ;
reg  [7 :0]     r_data_keep             ;
/******************************wire*********************************/
wire [63:0]     w_fifo_data_dout        ;
wire            w_fifo_data_full        ;
wire            w_fifo_data_empty       ;
wire [15:0]     w_fifo_len_dout         ;
wire            w_fifo_len_full         ;
wire            w_fifo_len_empty        ;
wire [7 :0]     w_fifo_keep_dout        ;
wire            w_fifo_keep_full        ;
wire            w_fifo_keep_empty       ;
wire            w_check_active          ;
/******************************assign*******************************/
assign o_check_mac   = ro_check_mac     ;
assign o_check_id    = ro_check_id      ;
assign o_check_valid = ro_check_valid   ;
assign w_check_active = r_check_ready && ri_result_valid;

assign o_axis_tvalid   = ro_axis_tvalid     ;
assign o_axis_tdata    = ro_axis_tdata      ;
assign o_axis_tlast    = ro_axis_tlast      ;
assign o_axis_tkeep    = ro_axis_tkeep      ;
assign o_axis_tuser    = ro_axis_tuser      ;
assign o_axis_tdest    = ro_axis_tdest      ;
/******************************component****************************/
ETH_RX_FIFO_64X128 ETH_RX_FIFO_64X128_data (
    .clk            (i_clk              ), // input wire clk
    .srst           (i_rst              ), // input wire srst
    .din            (rs_axis_rx_tdata   ), // input wire [63 : 0] din
    .wr_en          (rs_axis_rx_tvalid  ), // input wire wr_en
    .rd_en          (r_fifo_data_rden   ), // input wire rd_en
    .dout           (w_fifo_data_dout   ), // output wire [63 : 0] dout
    .full           (w_fifo_data_full   ), // output wire full
    .empty          (w_fifo_data_empty  ), // output wire empty
    .wr_rst_busy    (                   ), // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);

FIFO_16x64 FIFO_16x64_len (
    .clk            (i_clk              ), // input wire clk
    .srst           (i_rst              ), // input wire srst
    .din            (r_rx_data_len + 16'd1), // input wire [15 : 0] din
    .wr_en          (rs_axis_rx_tlast   ), // input wire wr_en
    .rd_en          (r_fifo_len_rden    ), // input wire rd_en
    .dout           (w_fifo_len_dout    ), // output wire [15 : 0] dout
    .full           (w_fifo_len_full    ), // output wire full
    .empty          (w_fifo_len_empty   ), // output wire empty
    .wr_rst_busy    (                   ), // output wire wr_rst_busy
    .rd_rst_busy    (                   )  // output wire rd_rst_busy
);

FIFO_8X64 FIFO_8X64_keep (
    .clk            (i_clk              ), // input wire clk
    .srst           (i_rst              ), // input wire srst
    .din            (rs_axis_rx_tkeep   ), // input wire [7 : 0] din
    .wr_en          (rs_axis_rx_tlast   ), // input wire wr_en
    .rd_en          (r_fifo_len_rden    ), // input wire rd_en
    .dout           (w_fifo_keep_dout   ), // output wire [7 : 0] dout
    .full           (w_fifo_keep_full   ), // output wire full
    .empty          (w_fifo_keep_empty  ), // output wire empty
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
        rs_axis_rx_tvalid_1d <= 'd0;
        rs_axis_rx_tdata_1d  <= 'd0;
    end
    else begin
        rs_axis_rx_tvalid <= s_axis_rx_tvalid   ;
        rs_axis_rx_tdata  <= s_axis_rx_tdata    ;
        rs_axis_rx_tlast  <= s_axis_rx_tlast    ;
        rs_axis_rx_tkeep  <= s_axis_rx_tkeep    ;
        rs_axis_rx_tuser  <= s_axis_rx_tuser    ;
        rs_axis_rx_tvalid_1d <= rs_axis_rx_tvalid;
        rs_axis_rx_tdata_1d  <= rs_axis_rx_tdata ;
    end
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        ri_outport      <= 'd0;
        ri_result_valid <= 'd0;
        ri_check_id     <= 'd0;
        ri_seek_flag    <= 'd0;
    end
    else if(!w_fifo_len_empty && w_check_active)begin
        ri_outport      <= ri_outport        ;
        ri_result_valid <= ri_result_valid   ;
        ri_check_id     <= ri_check_id       ;
        ri_seek_flag    <= ri_seek_flag      ;
    end
    else if(i_result_valid)begin
        ri_outport      <= i_outport        ;
        ri_result_valid <= i_result_valid   ;
        ri_check_id     <= i_check_id       ;
        ri_seek_flag    <= i_seek_flag      ;
    end
    else begin
        ri_outport      <= ri_outport       ;
        ri_result_valid <= 'd0              ;
        ri_check_id     <= ri_check_id      ;
        ri_seek_flag    <= ri_seek_flag     ;
    end
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
		r_recv_cnt <= 'd0;
    else if(rs_axis_rx_tvalid && !rs_axis_rx_tvalid_1d)
		r_recv_cnt <= r_recv_cnt + 1'b1;
    else if(rs_axis_rx_tlast)
        r_recv_cnt <= 'd0;
    else
        r_recv_cnt <= r_recv_cnt;
end

//记录数据包的目的地址
always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
		r_recv_dst_mac <= 'd0;
    else if(rs_axis_rx_tvalid && r_recv_cnt == 0)
        r_recv_dst_mac <= rs_axis_rx_tdata[63 : 16];
    else
        r_recv_dst_mac <= r_recv_dst_mac;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_recv_src_mac <= 'd0;
    else if(rs_axis_rx_tvalid && r_recv_cnt == 1)
        r_recv_src_mac <= {rs_axis_rx_tdata_1d[15:0],rs_axis_rx_tdata[63 : 32]};
    else
        r_recv_src_mac <= r_recv_src_mac;
end

//记录接收数据包的长度信息
always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_rx_data_len <= 'd0;
    else if(rs_axis_rx_tlast)
        r_rx_data_len <= 'd0;
    else if(rs_axis_rx_tvalid)
        r_rx_data_len <= r_rx_data_len + 1;
    else
        r_rx_data_len <= r_rx_data_len;
end

//进行端口查询
always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ro_check_valid <= 'd0;
    else if(rs_axis_rx_tvalid && r_recv_cnt == 1)
        ro_check_valid <= 1'b1;
    else
        ro_check_valid <= 'd0;
end
  
always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ro_check_mac <= 'd0;
    else if(rs_axis_rx_tvalid && r_recv_cnt == 1)
        ro_check_mac <= r_recv_dst_mac;
    else
        ro_check_mac <= ro_check_mac;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ro_check_mac <= 'd0;
    else if(rs_axis_rx_tvalid && r_recv_cnt == 1)
        ro_check_mac <= r_recv_dst_mac;
    else
        ro_check_mac <= ro_check_mac;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ro_check_id <= 'd0;
    else if(rs_axis_rx_tvalid && r_recv_cnt == 1)
        ro_check_id <= P_RX_ID;
    else
        ro_check_id <= ro_check_id;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_check_ready <= 'd0;
    else if(rs_axis_rx_tvalid && r_recv_cnt == 1)
		r_check_ready <= 1'b1;
    else if(!w_fifo_len_empty && w_check_active)
        r_check_ready <= 'd0;
    else
        r_check_ready <= r_check_ready;
end
   
//返回查询结果，匹配DDR缓存区或者进行corossbar转发

//read fifo

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_fifo_len_rden <= 'd0;
    else if(!w_fifo_len_empty && w_check_active)
        r_fifo_len_rden <= 'd1;
    else
        r_fifo_len_rden <= 'd0;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_fifo_len_rden_1d <= 'd0;
    else
        r_fifo_len_rden_1d <= r_fifo_len_rden;
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
        r_fifo_data_rden <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len)
        r_fifo_data_rden <= 'd0;
    else if(r_fifo_len_rden_1d)
        r_fifo_data_rden <= 'd1;
    else
        r_fifo_data_rden <= r_fifo_data_rden;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_fifo_rd_cnt <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len)
        r_fifo_rd_cnt <= 'd0;
    else if(r_fifo_data_rden_1d)
        r_fifo_rd_cnt <= r_fifo_rd_cnt + 'd1;
    else
        r_fifo_rd_cnt <= r_fifo_rd_cnt;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_fifo_data_rden_1d <= 'd0;
    else
        r_fifo_data_rden_1d <= r_fifo_data_rden;
end

//local transfer AXI 
always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ro_axis_tvalid <= 'd0;
    else if(ro_axis_tlast)
        ro_axis_tvalid <= 'd0;
    else if(r_fifo_data_rden_1d)
        ro_axis_tvalid <= 'd1;
    else
        ro_axis_tvalid <= ro_axis_tvalid;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ro_axis_tdata <= 'd0;
    else if(r_fifo_data_rden_1d)
        ro_axis_tdata <= w_fifo_data_dout;
    else
        ro_axis_tdata <= ro_axis_tdata;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ro_axis_tlast <= 'd0;
    else if(r_fifo_rd_cnt == r_data_len)
        ro_axis_tlast <= 'd1;
    else
        ro_axis_tlast <= 'd0;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ro_axis_tkeep <= 8'hFF;
    else if(r_fifo_rd_cnt == r_data_len)
        ro_axis_tkeep <= 8'h00;
    else
        ro_axis_tkeep <= 8'hFF;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ro_axis_tdest <= 'd0;
    else if(r_fifo_len_rden_1d)
        ro_axis_tdest <= ri_outport;
    else
        ro_axis_tdest <= ro_axis_tdest;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ro_axis_tuser <= 'd0;
    else if(!w_fifo_len_empty && w_check_active)
        ro_axis_tuser <= ri_seek_flag;
    else
        ro_axis_tuser <= ro_axis_tuser;
end

endmodule