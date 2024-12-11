`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/29 10:40:33
// Design Name: 
// Module Name: VLB_port_module
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


module VLB_port_module#(
    parameter       C_M_AXI_ADDR_WIDTH  = 32                    ,
    parameter       P_QUEUE_NUM         = 8                     ,//== P_TOR_NUM
    parameter       P_CAPACITY_PKT_TYPE = 16'hff00              ,
    parameter       P_OFFER_PKT_TYPE    = 16'hff01              ,
    parameter       P_RELAY_PKT_TYPE    = 16'hff02              ,
    parameter       P_SLOT_ID_TYPE      = 16'hff03              ,
    parameter       P_SLOT_NUM_WIDTH    = 1                     ,
    parameter       P_SLOT_NUM          = 2                     ,
    parameter       P_TOR_NUM           = 8                     ,
    parameter       P_OCS_NUM           = 2                     ,
    parameter       P_MY_OCS            = 0                     ,
    parameter       P_MY_TOR_ID         = 0                     ,
    parameter       P_MY_TOR_MAC        = 48'h8D_BC_5C_4A_10_00 ,
    parameter       P_MAC_HEAD          = 32'h8D_BC_5C_4A       ,
    parameter       P_SLOT_MAX_PKT_NUM  = 32'h00_04_00_00       ,
    parameter       P_ETH_MIN_LEN       = 8                     
)(
    input                                           i_clk                       ,
    input                                           i_rst                       ,  
    //控制器接口                    
    input                                           i_slot_start                ,
    input  [P_SLOT_NUM_WIDTH - 1 : 0]               i_slot_id                   ,
    input  [47: 0]                                  i_dest_tor_mac              ,
    //同步时间戳                    
    input  [63 :0]                                  i_syn_time_stamp            ,
    //带内控制协议                  
    input                                           s_rx_axis_tvalid            ,
    input  [63 :0]                                  s_rx_axis_tdata             ,
    input                                           s_rx_axis_tlast             ,
    input  [7  :0]                                  s_rx_axis_tkeep             ,
    input                                           s_rx_axis_tuser             ,

    output                                          m_tx_axis_tvalid            ,
    output [63 :0]                                  m_tx_axis_tdata             ,
    output                                          m_tx_axis_tlast             ,
    output [7  :0]                                  m_tx_axis_tkeep             ,
    output                                          m_tx_axis_tuser             ,
    input                                           m_tx_axis_tready            ,
    //buffer size
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_my_capacity               ,
    output                                          o_my_capacity_valid         ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_twin_own_capacity         ,
    input                                           i_twin_own_capacity_valid   ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_my_rx_capacity            ,
    output                                          o_my_rx_capacity_valid      ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_twin_rx_capacity          ,
    input                                           i_twin_rx_capacity_valid    ,

    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_my_local2_pkt_size        ,
    output                                          o_send_local2_valid         ,
    output [2 : 0]                                  o_cur_direct_tor            ,

    input  [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   i_local_queue_size          ,
    input  [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   i_unlocal_queue_size        ,
    output                                          o_rx_offer_capacity         ,
    output [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   o_rx_offer                  ,
    output                                          o_rx_offer_valid            ,
    output [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   o_rx_relay                  ,
    output                                          o_rx_relay_valid            ,
    input  [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   i_tx_relay                  ,
    input                                           i_tx_relay_valid             
);
/******************************function*****************************/

/******************************parameter****************************/
localparam      P_TX_IDLE           = 'd0,
                P_COMPT_CAPACITY    = 'd1,
                P_TX_CAPACITY       = 'd2,
                P_COMPT_OFFER       = 'd3,
                P_TX_OFFER          = 'd4,
                P_COMPT_RELAY       = 'd5,
                P_TX_RELAY          = 'd6;

localparam      P_RX_IDLE           = 'd0,
                P_RX_CAPACITY       = 'd1,
                P_RX_OFFER          = 'd2,
                P_RX_RELAY          = 'd3;
/******************************machine******************************/
reg  [5 : 0]    r_rx_cur_state          ;
reg  [5 : 0]    r_rx_nxt_state          ;
reg  [5 : 0]    r_tx_cur_state          ;
reg  [5 : 0]    r_tx_nxt_state          ;
reg  [15: 0]    r_rx_state_cnt          ;
reg  [15: 0]    r_tx_state_cnt          ;
/******************************reg**********************************/
reg  [2 : 0]                                    r_direct_tor            ;
reg  [31 :0]                                    r_local_pkt_num1        ;
reg  [31 :0]                                    r_local_pkt_num2        ;
reg  [31 :0]                                    r_my_relay_pkt_num      ;
reg  [P_SLOT_NUM_WIDTH - 1 : 0]                 r_cur_slot_id           ;

reg  [47: 0]                                    r_dest_tor_mac          ;
reg                                             rm_tx_axis_tvalid       ;
reg  [63 :0]                                    rm_tx_axis_tdata        ;
reg                                             rm_tx_axis_tlast        ;
reg  [7  :0]                                    rm_tx_axis_tkeep        ;
reg                                             rm_tx_axis_tuser        ;
reg  [15 :0]                                    r_tx_cnt                ;
reg  [15 :0]                                    r_rx_cnt                ;
reg  [15: 0]                                    r_rx_type               ;

reg                             ro_send_local2_valid    ;
//控制器接口AXIS
reg  [2 : 0]    r_route_table [P_TOR_NUM - 1 : 0][P_SLOT_NUM - 1 : 0];


reg  [15 :0]    r_recv_ctrl_cnt         ;
reg  [63 :0]    rs_ctrl_rx_axis_tdata = 'd0;

reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_local_queue_size      [P_QUEUE_NUM - 1 : 0]   ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_unlocal_queue_size    [P_QUEUE_NUM - 1 : 0]   ;

reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_my_capacity  ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_my_offer     [P_QUEUE_NUM - 1 : 0]   ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_my_relay     [P_QUEUE_NUM - 1 : 0]   ;

reg                             r_updata_capacity = 0   ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_tx_relay     [P_QUEUE_NUM - 1 : 0]   ;

reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_my_rx_capacity   ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_rx_offer_capacity   ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_rx_local2     ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_rx_offer     [P_QUEUE_NUM - 1 : 0]   ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_rx_relay     [P_QUEUE_NUM - 1 : 0]   ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] ri_twin_rx_capacity = 'd0;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] ri_twin_own_capacity = 'd0;

reg     r_rx_offer_valid       ;
reg     r_rx_relay_valid       ;
reg     ro_compt_relay_finish   ;
reg     ro_compt_relay_valid    ;
reg     r_compt_relay_en = 1'b0;
/******************************wire*********************************/
wire            w_tx_en;
wire            w_recv_capacity_flag    ;
wire            w_recv_offer_flag    ;
wire            w_compt_relay_en    ;

/******************************assign*******************************/
assign w_tx_en = rm_tx_axis_tvalid & m_tx_axis_tready;
assign m_tx_axis_tvalid = rm_tx_axis_tvalid;
assign m_tx_axis_tdata  = rm_tx_axis_tdata ;
assign m_tx_axis_tlast  = rm_tx_axis_tlast ;
assign m_tx_axis_tkeep  = rm_tx_axis_tkeep ;
assign m_tx_axis_tuser  = 'd0 ;
assign o_compt_relay_finish = ro_compt_relay_finish;
assign o_compt_relay_valid  = ro_compt_relay_valid ;

assign w_recv_capacity_flag = r_rx_cur_state == P_RX_CAPACITY && s_rx_axis_tvalid && r_rx_cnt == 2;
assign w_recv_offer_flag = r_rx_cur_state == P_RX_OFFER && s_rx_axis_tvalid && r_rx_cnt == 6;
assign o_rx_offer_valid = r_rx_offer_valid;
assign o_rx_offer_capacity = r_rx_offer_capacity;
assign o_rx_relay_valid = r_rx_relay_valid;
assign o_my_rx_capacity = r_my_rx_capacity;
assign o_my_capacity = r_my_capacity;
assign o_my_rx_capacity_valid = r_tx_cur_state == P_COMPT_CAPACITY && r_tx_state_cnt == 'd2;
assign o_my_capacity_valid = r_tx_cur_state == P_COMPT_CAPACITY && r_tx_state_cnt == 'd1;
assign o_my_local2_pkt_size = r_local_pkt_num2 ;
assign o_send_local2_valid  = ro_send_local2_valid  ;
assign o_cur_direct_tor     = r_direct_tor     ;
/******************************component****************************/

/******************************always*******************************/
genvar tor_i;
generate
    for(tor_i = 0; tor_i < P_TOR_NUM; tor_i = tor_i + 1)begin

        assign o_rx_offer[tor_i * C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH] = r_rx_offer[tor_i];
        assign o_rx_relay[tor_i * C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH] = r_rx_relay[tor_i];

        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)begin
                r_route_table[tor_i][0] <= 'd0;
                r_route_table[tor_i][1] <= 'd0;
                // r_route_table[tor_i][2] <= 'd0;
                // r_route_table[tor_i][3] <= 'd0;
            end
            else if(P_MY_TOR_ID == 0)begin
                r_route_table[tor_i][0] <=  (tor_i + 1) > (P_TOR_NUM - 1) ? 
                                            ((tor_i + 1) - (P_TOR_NUM - 1) - 1) : 
                                            (tor_i + 1);
                r_route_table[tor_i][1] <=  (tor_i + 1 * 2 + 1) > (P_TOR_NUM - 1) ? 
                                            ((tor_i + 1 * 2 + 1) - (P_TOR_NUM - 1) - 1):
                                            (tor_i + 1 * 2 + 1);
                // r_route_table[tor_i][2] <=  (tor_i + 2 * 2 + 1) > (P_TOR_NUM - 1) ? 
                //                             ((tor_i + 2 * 2 + 1) - (P_TOR_NUM - 1) - 1): 
                //                             (tor_i + 2 * 2 + 1);
                // r_route_table[tor_i][3] <=  (tor_i + 3 * 2 + 1) > (P_TOR_NUM - 1) ? 
                //                             ((tor_i + 3 * 2 + 1) - (P_TOR_NUM - 1) - 1): 
                //                             (tor_i + 3 * 2 + 1);
            end
            else if(P_MY_TOR_ID == 1)begin
                r_route_table[tor_i][0] <=  (tor_i - 1) < 0 ? 
                                            ((P_TOR_NUM + tor_i - 1)) : 
                                            (tor_i - 1);
                r_route_table[tor_i][1] <=  (tor_i - 1 * 2 - 1) < 0 ? 
                                            (P_TOR_NUM + tor_i - 1 * 2 - 1):
                                            (tor_i - 1 * 2 - 1);
                // r_route_table[tor_i][2] <=  (tor_i - 2 * 2 - 1) < 0 ? 
                //                             (P_TOR_NUM + tor_i - 2 * 2 - 1): 
                //                             (tor_i - 2 * 2 - 1);
                // r_route_table[tor_i][3] <=  (tor_i - 3 * 2 - 1) < 0 ? 
                //                             (P_TOR_NUM + tor_i - 3 * 2 - 1): 
                //                             (tor_i - 3 * 2 - 1);
            end
            else begin
                    r_route_table[tor_i][0] <= r_route_table[tor_i][0];
                    r_route_table[tor_i][1] <= r_route_table[tor_i][1];
                    // r_route_table[tor_i][2] <= r_route_table[tor_i][2];
                    // r_route_table[tor_i][3] <= r_route_table[tor_i][3];
                end
        end
        
        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                r_local_queue_size[tor_i] <= 'd0;
            else
                r_local_queue_size[tor_i] <= i_local_queue_size[tor_i*C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH];
        end

        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                r_unlocal_queue_size[tor_i] <= 'd0;
            else
                r_unlocal_queue_size[tor_i] <= i_unlocal_queue_size[tor_i*C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH];
        end
        //计算本地offer
        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                r_my_offer[tor_i] <= 'd0;
            else if(r_tx_cur_state == P_TX_IDLE)
                r_my_offer[tor_i] <= 'd0;
            else if(w_recv_capacity_flag)
                r_my_offer[tor_i] <= r_local_queue_size[tor_i];
            else
                r_my_offer[tor_i] <= r_my_offer[tor_i];
        end

        //发送relay pkt
        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                r_tx_relay[tor_i] <= 'd0;
            else if(r_tx_cur_state == P_TX_IDLE)
                r_tx_relay[tor_i] <= 'd0;
            else if(i_tx_relay_valid)
                r_tx_relay[tor_i] <= i_tx_relay[tor_i*C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH];
            else
                r_tx_relay[tor_i] <= r_tx_relay[tor_i];
        end
        


    end
endgenerate

//从控制器当中获得当前时隙下的直连节点
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_direct_tor <= 'd0;
    else if(i_slot_start)
        r_direct_tor <= r_route_table[P_MY_TOR_ID][i_slot_id];
    else
        r_direct_tor <= r_direct_tor;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        r_cur_slot_id  <= 'd0;
        r_dest_tor_mac <= 'd0;
    end else if(i_slot_start)begin
        r_cur_slot_id  <= i_slot_id;
        r_dest_tor_mac <= i_dest_tor_mac;
    end else begin
        r_cur_slot_id  <= r_cur_slot_id;
        r_dest_tor_mac <= r_dest_tor_mac;
    end
end

//===================================发送状态机======================================//
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_tx_cur_state <= P_TX_IDLE;
    else
        r_tx_cur_state <= r_tx_nxt_state;
end

always @(*)begin
    case (r_tx_cur_state)
        P_TX_IDLE       : begin
            if(i_slot_start)
                r_tx_nxt_state = P_TX_CAPACITY;
            else
                r_tx_nxt_state = P_TX_IDLE;
        end 
        P_COMPT_CAPACITY : begin
            if(i_twin_rx_capacity_valid)
                r_tx_nxt_state = P_TX_CAPACITY;
            else
                r_tx_nxt_state = P_COMPT_CAPACITY;
        end 
        P_TX_CAPACITY   : begin
            if(w_tx_en && rm_tx_axis_tlast)
                r_tx_nxt_state = P_COMPT_OFFER;
            else
                r_tx_nxt_state = P_TX_CAPACITY;
        end
        P_COMPT_OFFER : begin
            if(r_updata_capacity)
                r_tx_nxt_state = P_TX_OFFER;
            else
                r_tx_nxt_state = P_COMPT_OFFER;
        end
        P_TX_OFFER      : begin
            if(w_tx_en && rm_tx_axis_tlast)
                r_tx_nxt_state = P_TX_RELAY;
            else
                r_tx_nxt_state = P_COMPT_RELAY;
        end 
        P_COMPT_RELAY   : begin
            if(i_tx_relay_valid)
                r_tx_nxt_state = P_TX_RELAY;
            else
                r_tx_nxt_state = P_COMPT_RELAY;
        end 
        P_TX_RELAY      : begin
            if(w_tx_en && rm_tx_axis_tlast)
                r_tx_nxt_state = P_TX_IDLE;
            else
                r_tx_nxt_state = P_TX_RELAY;
        end 
        default : r_tx_nxt_state = P_TX_IDLE;
    endcase
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_tx_state_cnt <= 'd0;
    else if(r_tx_cur_state != r_tx_nxt_state)
        r_tx_state_cnt <= 'd0;
    else
        r_tx_state_cnt <= r_tx_state_cnt + 1'b1;
end

//开始计算capacity packet
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_local_pkt_num1 <= 'd0;
    else if(r_tx_cur_state == P_COMPT_CAPACITY && r_tx_state_cnt == 'd0)
        r_local_pkt_num1 <= r_local_queue_size[r_direct_tor];
    else
        r_local_pkt_num1 <= r_local_pkt_num1;
end
//可直接发送的俩跳流量也需要更新一次
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_local_pkt_num2 <= 'd0;
    else if(r_tx_cur_state == P_COMPT_CAPACITY && r_tx_state_cnt == 'd0)
        r_local_pkt_num2 <= r_local_queue_size[r_route_table[r_direct_tor][r_cur_slot_id]];
    else if(w_recv_capacity_flag)
        if(ri_twin_rx_capacity <= r_local_pkt_num2)
            r_local_pkt_num2 <= ri_twin_rx_capacity;
        else
            r_local_pkt_num2 <= r_local_pkt_num2;
    else
        r_local_pkt_num2 <= r_local_pkt_num2;
end
   
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_send_local2_valid <= 'd0;
    else if(w_recv_capacity_flag)
        ro_send_local2_valid <= 'd1;
    else
        ro_send_local2_valid <= 'd0;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_my_relay_pkt_num <= 'd0;
    else if(r_tx_cur_state == P_COMPT_CAPACITY && r_tx_state_cnt == 'd0)
        r_my_relay_pkt_num <= r_unlocal_queue_size[r_direct_tor];
    else
        r_my_relay_pkt_num <= r_my_relay_pkt_num;
end
//本地带宽余量的计算以及矫正过程
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_my_capacity <= 'd0;
    else if(r_tx_cur_state == P_COMPT_CAPACITY && r_tx_state_cnt == 'd1)
        r_my_capacity <= (P_SLOT_MAX_PKT_NUM - r_local_pkt_num1 - r_local_pkt_num2 - r_my_relay_pkt_num) > 0
                            ? P_SLOT_MAX_PKT_NUM - r_local_pkt_num1 - r_local_pkt_num2 - r_my_relay_pkt_num
                            : 'd0;
    else if(i_twin_rx_capacity_valid)begin
        if(ri_twin_rx_capacity >= r_local_pkt_num2)begin
            if(r_rx_local2 < r_my_capacity)
                r_my_capacity <= r_my_capacity - r_rx_local2;
            else
                r_my_capacity <= 'd0;
        end
        else begin
            if(r_rx_local2 < (r_my_capacity + (r_local_pkt_num2 - ri_twin_rx_capacity)))
                r_my_capacity <= r_my_capacity + (r_local_pkt_num2 - ri_twin_rx_capacity) - r_rx_local2;
            else
                r_my_capacity <= 'd0;
        end
    end
    else
        r_my_capacity <= r_my_capacity;
end

always @(posedge i_clk)begin
    if(i_twin_rx_capacity_valid)
        ri_twin_rx_capacity <= i_twin_rx_capacity;
    else
        ri_twin_rx_capacity <= ri_twin_rx_capacity;
end

always @(posedge i_clk)begin
    if(i_twin_own_capacity_valid)
        ri_twin_own_capacity <= i_twin_own_capacity;
    else
        ri_twin_own_capacity <= ri_twin_own_capacity;
end

always @(posedge i_clk)begin
    r_updata_capacity <= w_recv_capacity_flag;
end

//接收到对端offer包后开始请求进行relay计算，因为俩个上行端口共用一个缓存区，所以需要申请对于缓存区的分配权
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_compt_relay_valid <= 'd0;
    else if(w_compt_relay_en)
        ro_compt_relay_valid <= 'd0;
    else if(r_rx_offer_valid)
        ro_compt_relay_valid <= 'd1;
    else
        ro_compt_relay_valid <= ro_compt_relay_valid;
end


always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        rm_tx_axis_tdata <= 'd0;
    else if(r_tx_cur_state == P_TX_CAPACITY)//capacity pkt include capacity and loca2
        case (r_tx_cnt)
            0         : rm_tx_axis_tdata <= {P_MY_TOR_MAC,r_dest_tor_mac[47:32]};
            1         : rm_tx_axis_tdata <= {r_dest_tor_mac[31:0],P_CAPACITY_PKT_TYPE,16'd0};
            2         : rm_tx_axis_tdata <= {ri_twin_own_capacity,r_local_pkt_num2};
            3,4,5,6,7 : rm_tx_axis_tdata <= i_syn_time_stamp;
            8         : rm_tx_axis_tdata <= 'd0;
            default   : rm_tx_axis_tdata <= rm_tx_axis_tdata;
        endcase       
    else if(r_tx_cur_state == P_TX_OFFER)
        case (r_tx_cnt)
            0         : rm_tx_axis_tdata <= {P_MY_TOR_MAC,r_dest_tor_mac[47:32]};
            1         : rm_tx_axis_tdata <= {r_dest_tor_mac[31:0],P_OFFER_PKT_TYPE,16'd0};
            2         : rm_tx_axis_tdata <= {r_my_capacity,32'd0};
            3         : rm_tx_axis_tdata <= {r_my_offer[7],r_my_offer[6]};
            4         : rm_tx_axis_tdata <= {r_my_offer[5],r_my_offer[4]};
            5         : rm_tx_axis_tdata <= {r_my_offer[3],r_my_offer[2]};
            6         : rm_tx_axis_tdata <= {r_my_offer[1],r_my_offer[0]};
            7         : rm_tx_axis_tdata <= i_syn_time_stamp;
            8         : rm_tx_axis_tdata <= 'd0;
            default   : rm_tx_axis_tdata <= rm_tx_axis_tdata;
        endcase  
    else if(r_tx_cur_state == P_TX_RELAY)
        case (r_tx_cnt)
            0         : rm_tx_axis_tdata <= {P_MY_TOR_MAC,r_dest_tor_mac[47:32]};
            1         : rm_tx_axis_tdata <= {r_dest_tor_mac[31:0],P_OFFER_PKT_TYPE,16'd0};
            2         : rm_tx_axis_tdata <= {r_tx_relay[7],r_tx_relay[6]};
            3         : rm_tx_axis_tdata <= {r_tx_relay[5],r_tx_relay[4]};
            4         : rm_tx_axis_tdata <= {r_tx_relay[3],r_tx_relay[2]};
            5         : rm_tx_axis_tdata <= {r_tx_relay[1],r_tx_relay[0]};
            6,7       : rm_tx_axis_tdata <= i_syn_time_stamp;
            8         : rm_tx_axis_tdata <= 'd0;
            default   : rm_tx_axis_tdata <= rm_tx_axis_tdata;
        endcase 
    else
        rm_tx_axis_tdata <= rm_tx_axis_tdata;
end

//发送capacity pkt
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_tx_cnt <= 'd0;
    else if(w_tx_en && r_tx_cnt == P_ETH_MIN_LEN)
        r_tx_cnt <= 'd0;
    else if(w_tx_en || (r_tx_cur_state == P_TX_CAPACITY && r_tx_state_cnt == 'd0))
        r_tx_cnt <= r_tx_cnt + 'd1;
    else if(w_tx_en || (r_tx_cur_state == P_TX_OFFER && r_tx_state_cnt == 'd0))
        r_tx_cnt <= r_tx_cnt + 'd1;
    else
        r_tx_cnt <= r_tx_cnt;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        rm_tx_axis_tvalid <= 'd0;
    else if(w_tx_en && rm_tx_axis_tlast)
        rm_tx_axis_tvalid <= 'd0;
    else if(r_tx_cur_state == P_TX_CAPACITY && r_tx_state_cnt == 'd0)
        rm_tx_axis_tvalid <= 'd1;
    else if(r_tx_cur_state == P_TX_OFFER && r_tx_state_cnt == 'd0)
        rm_tx_axis_tvalid <= 'd1;
    else 
        rm_tx_axis_tvalid <= rm_tx_axis_tvalid;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        rm_tx_axis_tlast <= 'd0;
    else if(w_tx_en && r_tx_cnt == P_ETH_MIN_LEN)
        rm_tx_axis_tlast <= 'd0;
    else if(w_tx_en && r_tx_cnt == P_ETH_MIN_LEN - 1)
        rm_tx_axis_tlast <= 'd1;
    else
        rm_tx_axis_tlast <= rm_tx_axis_tlast;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        rm_tx_axis_tkeep <= 8'h00;
    else if(w_tx_en && r_tx_cnt == P_ETH_MIN_LEN)
        rm_tx_axis_tkeep <= 8'h00;
    else if(r_tx_cur_state == P_TX_CAPACITY && r_tx_state_cnt == 'd0)
        rm_tx_axis_tkeep <= 8'hff;
    else if(r_tx_cur_state == P_TX_OFFER && r_tx_state_cnt == 'd0)
        rm_tx_axis_tkeep <= 8'hff;
    else
        rm_tx_axis_tkeep <= rm_tx_axis_tkeep;
end


//================================接收状态机====================================//
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_rx_cur_state <= P_RX_IDLE;
    else
        r_rx_cur_state <= r_rx_nxt_state;
end

always @(*) begin
    case (r_rx_cur_state)
        P_RX_IDLE       : begin
            if(i_slot_start)
                r_rx_nxt_state = P_RX_CAPACITY;
            else
                r_rx_nxt_state = P_RX_IDLE;
        end
        P_RX_CAPACITY   : begin
            if(s_rx_axis_tlast && s_rx_axis_tvalid && r_rx_type == P_CAPACITY_PKT_TYPE)
                r_rx_nxt_state = P_RX_OFFER;
            else
                r_rx_nxt_state = P_RX_CAPACITY;
        end
        P_RX_OFFER      : begin
            if(s_rx_axis_tlast && s_rx_axis_tvalid && r_rx_type == P_OFFER_PKT_TYPE)
                r_rx_nxt_state = P_RX_RELAY;
            else
                r_rx_nxt_state = P_RX_OFFER;
        end
        P_RX_RELAY      : begin
            if(s_rx_axis_tlast && s_rx_axis_tvalid && r_rx_type == P_RELAY_PKT_TYPE)
                r_rx_nxt_state = P_RX_IDLE;
            else
                r_rx_nxt_state = P_RX_RELAY;
        end
        default : r_rx_nxt_state = P_RX_IDLE;
    endcase
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_rx_cnt <= 'd0;
    else if(s_rx_axis_tvalid && s_rx_axis_tlast)
        r_rx_cnt <= 'd0;
    else if(s_rx_axis_tvalid)
        r_rx_cnt <= r_rx_cnt + 'd1;
    else
        r_rx_cnt <= r_rx_cnt;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_rx_type <= 'd0;
    else if(s_rx_axis_tvalid && r_rx_cnt == 1)
        r_rx_type <= s_rx_axis_tdata[31:16];
    else
        r_rx_type <= r_rx_type;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_my_rx_capacity <= 'd0;
    else if(r_rx_cur_state == P_RX_CAPACITY && s_rx_axis_tvalid && r_rx_cnt == 2)
        r_my_rx_capacity <= s_rx_axis_tdata[63:32];
    else
        r_my_rx_capacity <= r_my_rx_capacity;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_rx_offer_capacity <= 'd0;
    else if(r_rx_cur_state == P_RX_OFFER && s_rx_axis_tvalid && r_rx_cnt == 2)
        r_rx_offer_capacity <= s_rx_axis_tdata[63:32];
    else
        r_rx_offer_capacity <= r_rx_offer_capacity;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_rx_local2 <= 'd0;
    else if(r_rx_cur_state == P_RX_CAPACITY && s_rx_axis_tvalid && r_rx_cnt == 2)
        r_rx_local2 <= s_rx_axis_tdata[31:0];
    else
        r_rx_local2 <= r_rx_local2;
end


always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        r_rx_offer[0] <= 'd0;
        r_rx_offer[1] <= 'd0;
        r_rx_offer[2] <= 'd0;
        r_rx_offer[3] <= 'd0;
        r_rx_offer[4] <= 'd0;
        r_rx_offer[5] <= 'd0;
        r_rx_offer[6] <= 'd0;
        r_rx_offer[7] <= 'd0;
    end
    else if(r_rx_cur_state == P_RX_OFFER && s_rx_axis_tvalid && r_rx_cnt == 3)begin
        r_rx_offer[7] <= s_rx_axis_tdata[63:32];
        r_rx_offer[6] <= s_rx_axis_tdata[31: 0];
    end
    else if(r_rx_cur_state == P_RX_OFFER && s_rx_axis_tvalid && r_rx_cnt == 4)begin
        r_rx_offer[5] <= s_rx_axis_tdata[63:32];
        r_rx_offer[4] <= s_rx_axis_tdata[31: 0];
    end
    else if(r_rx_cur_state == P_RX_OFFER && s_rx_axis_tvalid && r_rx_cnt == 5)begin
        r_rx_offer[3] <= s_rx_axis_tdata[63:32];
        r_rx_offer[2] <= s_rx_axis_tdata[31: 0];
    end
    else if(r_rx_cur_state == P_RX_OFFER && s_rx_axis_tvalid && r_rx_cnt == 6)begin
        r_rx_offer[1] <= s_rx_axis_tdata[63:32];
        r_rx_offer[0] <= s_rx_axis_tdata[31: 0];
    end      
    else begin
        r_rx_offer[0] <= r_rx_offer[0];
        r_rx_offer[1] <= r_rx_offer[1];
        r_rx_offer[2] <= r_rx_offer[2];
        r_rx_offer[3] <= r_rx_offer[3];
        r_rx_offer[4] <= r_rx_offer[4];
        r_rx_offer[5] <= r_rx_offer[5];
        r_rx_offer[6] <= r_rx_offer[6];
        r_rx_offer[7] <= r_rx_offer[7];
    end   
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_rx_offer_valid <= 'd0;
    else if(r_rx_cur_state == P_RX_OFFER && s_rx_axis_tvalid && r_rx_cnt == 6)
        r_rx_offer_valid <= 'd1;
    else
        r_rx_offer_valid <= 'd0;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        r_rx_relay[0] <= 'd0;
        r_rx_relay[1] <= 'd0;
        r_rx_relay[2] <= 'd0;
        r_rx_relay[3] <= 'd0;
        r_rx_relay[4] <= 'd0;
        r_rx_relay[5] <= 'd0;
        r_rx_relay[6] <= 'd0;
        r_rx_relay[7] <= 'd0;
    end
    else if(r_rx_cur_state == P_RX_RELAY && s_rx_axis_tvalid && r_rx_cnt == 3)begin
        r_rx_relay[7] <= s_rx_axis_tdata[63:32];
        r_rx_relay[6] <= s_rx_axis_tdata[31: 0];
    end
    else if(r_rx_cur_state == P_RX_RELAY && s_rx_axis_tvalid && r_rx_cnt == 4)begin
        r_rx_relay[5] <= s_rx_axis_tdata[63:32];
        r_rx_relay[4] <= s_rx_axis_tdata[31: 0];
    end
    else if(r_rx_cur_state == P_RX_RELAY && s_rx_axis_tvalid && r_rx_cnt == 5)begin
        r_rx_relay[3] <= s_rx_axis_tdata[63:32];
        r_rx_relay[2] <= s_rx_axis_tdata[31: 0];
    end
    else if(r_rx_cur_state == P_RX_RELAY && s_rx_axis_tvalid && r_rx_cnt == 6)begin
        r_rx_relay[1] <= s_rx_axis_tdata[63:32];
        r_rx_relay[0] <= s_rx_axis_tdata[31: 0];
    end      
    else begin
        r_rx_relay[0] <= r_rx_relay[0];
        r_rx_relay[1] <= r_rx_relay[1];
        r_rx_relay[2] <= r_rx_relay[2];
        r_rx_relay[3] <= r_rx_relay[3];
        r_rx_relay[4] <= r_rx_relay[4];
        r_rx_relay[5] <= r_rx_relay[5];
        r_rx_relay[6] <= r_rx_relay[6];
        r_rx_relay[7] <= r_rx_relay[7];
    end   
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_rx_relay_valid <= 'd0;
    else if(r_rx_cur_state == P_RX_RELAY && s_rx_axis_tvalid && r_rx_cnt == 6)
        r_rx_relay_valid <= 'd1;
    else
        r_rx_relay_valid <= 'd0;
end



endmodule