`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/12 19:19:54
// Design Name: 
// Module Name: server_module
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


module server_module#(
    parameter       P_UPLINK_TRUE   = 0                     ,
    parameter       P_SEED          = 8'hA5                 ,
    parameter       P_MAC_HEAD      = 32'h8D_BC_5C_4A       ,
    parameter       P_MY_TOR_MAC    = 48'h8D_BC_5C_4A_00_00 ,
    parameter       P_MY_PORT_MAC   = 48'h8D_BC_5C_4A_00_01 
)(
    input           i_clk               ,
    input           i_rst               ,
    input           i_stat_rx_status    ,
    input  [63:0]   i_time_stamp        ,
    input  [2 : 0]  i_cur_connect_tor   ,
    input           i_sim_start         ,

    input  [47:0]   i_check_mac         , 
    input  [3 :0]   i_check_id          ,
    input           i_check_valid       ,
    //get outport       
    output [2 :0]   o_outport           ,
    output          o_result_valid      ,
    output [3 :0]   o_check_id          ,
    output [1 :0]   o_seek_flag         ,

    output          tx_axis_tvalid      ,
    output [63:0]   tx_axis_tdata       ,
    output          tx_axis_tlast       ,
    output [7 :0]   tx_axis_tkeep       ,
    output          tx_axis_tuser       ,

    input           rx_axis_tvalid      ,
    input  [63:0]   rx_axis_tdata       ,
    input           rx_axis_tlast       ,
    input  [7 :0]   rx_axis_tkeep       ,
    input           rx_axis_tuser       ,
    output          rx_axis_tready      

);
/******************************function*****************************/

/******************************parameter****************************/
localparam      P_PKT_LEN   = 64;
localparam      P_GAP_CYCLE = 16;
localparam      P_TX_IDLE   = 'd0,
                P_TX_RANDOM = 'd1,
                P_TX_DATA   = 'd2,
                P_TX_GAP    = 'd3;
/******************************machine******************************/
reg  [5 : 0]    r_cur_state ;
reg  [5 : 0]    r_nxt_state ;
reg  [15: 0]    r_st_cnt    ;
/******************************reg**********************************/
reg             ri_sim_start        ;
reg             r_tx_axis_tvalid    ;
reg  [63:0]     r_tx_axis_tdata     ;
reg             r_tx_axis_tlast     ;
reg  [15:0]     r_tx_cnt            ;

reg  [7 : 0]    r_random_dest       ;
reg  [2 : 0]    r_dest_tor          ;
reg  [2 : 0]    r_dest_server       ;
reg  [47: 0]    r_dest_mac          ;

reg  [2 :0]     ro_outport          ;
reg             ro_result_valid     ;
reg  [3 :0]     ro_check_id         ;
reg  [1 :0]     ro_seek_flag        ;

reg  [47:0]     ri_check_mac        ;
reg  [3 :0]     ri_check_id         ;
reg             ri_check_valid      ;
/******************************wire*********************************/
wire feedback;

/******************************assign*******************************/
assign rx_axis_tready = 1'b1;
assign o_outport      = ro_outport     ;
assign o_result_valid = ro_result_valid;
assign o_check_id     = ro_check_id    ;
assign o_seek_flag    = ro_seek_flag   ;
assign tx_axis_tvalid = r_tx_axis_tvalid;
assign tx_axis_tdata  = r_tx_axis_tdata ;
assign tx_axis_tlast  = r_tx_axis_tlast ;
assign tx_axis_tkeep  = 8'hff ;
assign tx_axis_tuser  = 'd0 ;
assign feedback = r_random_dest[7] ^ r_random_dest[5] ^ r_random_dest[4] ^ r_random_dest[3];
/******************************component****************************/

/******************************always*******************************/
always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ri_sim_start <= 'd0;
    else if(i_sim_start)
        ri_sim_start <= i_sim_start;
    else
        ri_sim_start <= ri_sim_start;
end

//generate randon dest tor and server
always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) 
        r_random_dest <= P_SEED; 
    else if(r_cur_state == P_TX_RANDOM && r_st_cnt == 'd0)
        r_random_dest <= {r_random_dest[6:0], feedback};
    else
        r_random_dest <= r_random_dest;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_dest_tor <= 'd0;
    else if(r_cur_state == P_TX_RANDOM && r_st_cnt == 'd1)
        r_dest_tor <= r_dest_tor + 1'b1;
    else
        r_dest_tor <= r_dest_tor;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_dest_server <= 'd0;
    else if(r_cur_state == P_TX_RANDOM && r_st_cnt == 'd2 && (r_dest_tor) == P_MY_TOR_MAC[10:8])
        r_dest_server <= P_MY_PORT_MAC[2:0] == 'd1 ? 3'd2 : 3'd1;
    else if(r_cur_state == P_TX_RANDOM && r_st_cnt == 'd2 && (r_dest_tor) != P_MY_TOR_MAC[10:8])
        r_dest_server <= r_random_dest[0] == 'd1 ? 3'd1 : 3'd2;
    else
        r_dest_server <= r_dest_server;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_dest_mac <= 'd0;
    else if(r_cur_state == P_TX_RANDOM && r_st_cnt == 'd3)
        r_dest_mac <= {P_MAC_HEAD,{5'd0,r_dest_tor},{5'd0,r_dest_server}};
    else
        r_dest_mac <= r_dest_mac;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_cur_state <= P_TX_IDLE;
    else
        r_cur_state <= r_nxt_state;
end

always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) 
        r_st_cnt <= P_SEED; 
    else if(r_cur_state != r_nxt_state)
        r_st_cnt <= 'd0;
    else
        r_st_cnt <= r_st_cnt + 'd1;
end

always @(*)begin
    case (r_cur_state)
        P_TX_IDLE   : r_nxt_state = !P_UPLINK_TRUE && ri_sim_start ? P_TX_RANDOM : P_TX_IDLE;
        P_TX_RANDOM : r_nxt_state = r_st_cnt == 3 ? P_TX_DATA : P_TX_RANDOM;
        P_TX_DATA   : r_nxt_state = r_tx_cnt == P_PKT_LEN - 2 ? P_TX_GAP : P_TX_DATA;
        P_TX_GAP    : r_nxt_state = r_st_cnt == P_GAP_CYCLE ? P_TX_IDLE : P_TX_GAP;
        default     : r_nxt_state = P_TX_IDLE;
    endcase
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_tx_cnt <= 'd0;
    else if(r_tx_cnt == P_PKT_LEN - 1)
        r_tx_cnt <= 'd0;
    else if(r_tx_axis_tvalid)
        r_tx_cnt <= r_tx_cnt + 'd1;
    else
        r_tx_cnt <= r_tx_cnt;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_tx_axis_tvalid <= 'd0;
    else if(r_tx_cnt == P_PKT_LEN - 1)
        r_tx_axis_tvalid <= 'd0;
    else if(r_cur_state == P_TX_DATA)
        r_tx_axis_tvalid <= 'd1;
    else
        r_tx_axis_tvalid <= r_tx_axis_tvalid;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_tx_axis_tdata <= 'd0;
    else if(r_cur_state == P_TX_DATA)
        case (r_st_cnt)
            0       : r_tx_axis_tdata <= {r_dest_mac,P_MY_PORT_MAC[47:32]};
            1       : r_tx_axis_tdata <= {P_MY_PORT_MAC[31:0],16'h0800,16'd0};
            default : r_tx_axis_tdata <= i_time_stamp;
        endcase
    else
        r_tx_axis_tdata <= 'd0;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_tx_axis_tlast <= 'd0;
    else if(r_tx_cnt == P_PKT_LEN - 2)
        r_tx_axis_tlast <= 'd1;
    else
        r_tx_axis_tlast <= 'd0;
end

//完成查表功能
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        ri_check_mac   <= 'd0;
        ri_check_id    <= 'd0;
        ri_check_valid <= 'd0;
    end
    else if(i_check_valid)begin
        ri_check_mac   <= i_check_mac  ;
        ri_check_id    <= i_check_id   ;
        ri_check_valid <= i_check_valid;
    end
    else begin
        ri_check_mac   <= ri_check_mac  ;
        ri_check_id    <= ri_check_id   ;
        ri_check_valid <= 'd0;
    end
end


always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_check_id <= 'd0;
    else if(ri_check_valid)
        ro_check_id <= ri_check_id;
    else
        ro_check_id <= ro_check_id;
end

/*  下行链路情况：
    1、目的地是本地服务器，直接crossbar转发，ro_seek_flag = 1
    2、跨机架数据，全部暂存DDR的本地队列，ro_seek_flag = 0
    上行链路情况：
    1、目的地是本地服务器，直接crossbar转发，ro_seek_flag = 1
    2、中继数据，需要进行跨时隙转发，全部暂存DDR的非本地队列，ro_seek_flag = 0
    3、本时隙进行俩跳转发的数据，存入FIFO等待发送，ro_seek_flag = 2 
    4、VLB负载均衡控制协议包，ro_seek_flag = 3*/
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_seek_flag <= 'd0;
    else if(ri_check_valid && ri_check_mac[47:8] == P_MY_TOR_MAC[47:8] && ri_check_mac[7:0] != 0)
        ro_seek_flag <= 'd1;//crossbar转发
    else if(ri_check_valid && ri_check_mac[47:8] != P_MY_TOR_MAC[47:8] && !P_UPLINK_TRUE)
        ro_seek_flag <= 'd0;//下行链路接收的非本地数据
    else if(ri_check_valid && ri_check_mac[47:8] == P_MY_TOR_MAC[47:8] && ri_check_mac[7:0] == 0 && P_UPLINK_TRUE)
        ro_seek_flag <= 'd3;//VLB PKT
    else if(ri_check_valid && ri_check_mac[47:8] != P_MY_TOR_MAC[47:8] && ri_check_mac[15:8] != {5'd0,i_cur_connect_tor} && P_UPLINK_TRUE)
        ro_seek_flag <= 'd0;//上行链路接收的非本地数据
    else if(ri_check_valid && ri_check_mac[47:8] != P_MY_TOR_MAC[47:8] && ri_check_mac[15:8] == {5'd0,i_cur_connect_tor} && P_UPLINK_TRUE)
        ro_seek_flag <= 'd2;//待转发的俩跳流量
    else
        ro_seek_flag <= ro_seek_flag;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_outport <= 'd0;
    else if(ri_check_valid && ri_check_mac[47:8] == P_MY_TOR_MAC[47:8])
        ro_outport <= ri_check_mac[2:0] - 1;//在crossbar里本地port编号是对应port0和1
    else if(ri_check_valid && ri_check_mac[47:8] != P_MY_TOR_MAC[47:8])
        ro_outport <= ri_check_mac[10:8];
    else
        ro_outport <= ro_outport;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_result_valid <= 'd0;
    else if(ri_check_valid)
        ro_result_valid <= 'd1;
    else
        ro_result_valid <= 'd0;
end


endmodule
