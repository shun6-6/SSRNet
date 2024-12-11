`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/25 18:56:20
// Design Name: 
// Module Name: VLB_module
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


module VLB_module#(
    parameter       C_M_AXI_ADDR_WIDTH  = 32                    ,
    parameter       P_QUEUE_NUM         = 8                     ,//== P_TOR_NUM
    parameter       P_CAPACITY_PKT_TYPE = 16'hff00              ,
    parameter       P_OFFER_PKT_TYPE    = 16'hff01              ,
    parameter       P_RELAY_PKT_TYPE    = 16'hff02              ,
    parameter       P_SLOT_ID_TYPE      = 16'hff03              ,
    parameter       P_TIME_STAMP_TYPE   = 16'hffff              ,
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
    input  [63: 0]                                  i_syn_time_stamp            ,
    //控制器接口
    input                                           s_ctrl_rx_axis_tvalid       ,
    input  [63 :0]                                  s_ctrl_rx_axis_tdata        ,
    input                                           s_ctrl_rx_axis_tlast        ,
    input  [7  :0]                                  s_ctrl_rx_axis_tkeep        ,
    input                                           s_ctrl_rx_axis_tuser        ,
    //带内控制协议接口
    input                                           s_uplink0_rx_axis_tvalid    ,
    input  [63 :0]                                  s_uplink0_rx_axis_tdata     ,
    input                                           s_uplink0_rx_axis_tlast     ,
    input  [7  :0]                                  s_uplink0_rx_axis_tkeep     ,
    input                                           s_uplink0_rx_axis_tuser     ,

    output                                          m_uplink0_tx_axis_tvalid    ,
    output [63 :0]                                  m_uplink0_tx_axis_tdata     ,
    output                                          m_uplink0_tx_axis_tlast     ,
    output [7  :0]                                  m_uplink0_tx_axis_tkeep     ,
    output                                          m_uplink0_tx_axis_tuser     ,
    input                                           m_uplink0_tx_axis_tready    ,

    input                                           s_uplink1_rx_axis_tvalid    ,
    input  [63 :0]                                  s_uplink1_rx_axis_tdata     ,
    input                                           s_uplink1_rx_axis_tlast     ,
    input  [7  :0]                                  s_uplink1_rx_axis_tkeep     ,
    input                                           s_uplink1_rx_axis_tuser     ,

    output                                          s_uplink1_tx_axis_tvalid    ,
    output [63 :0]                                  s_uplink1_tx_axis_tdata     ,
    output                                          s_uplink1_tx_axis_tlast     ,
    output [7  :0]                                  s_uplink1_tx_axis_tkeep     ,
    output                                          s_uplink1_tx_axis_tuser     ,
    input                                           s_uplink1_tx_axis_tready    ,
    //queue size
    output                                          o_check_queue_req_valid     ,//握手跨时钟
    input                                           i_check_queue_resp_ready    ,
    input  [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   i_local_queue_size          ,
    input  [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   i_unlocal_queue_size        ,
    //port0 send data
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_port0_my_local2_pkt_size  ,
    output                                          o_port0_send_local2_valid   ,
    output [2 : 0]                                  o_port0_cur_direct_tor      ,
    output [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   o_port0_tx_relay            ,
    output                                          o_port0_tx_relay_valid      ,
    //port1 send data
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_port1_my_local2_pkt_size  ,
    output                                          o_port1_send_local2_valid   ,
    output [2 : 0]                                  o_port1_cur_direct_tor      ,
    output [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   o_port1_tx_relay            ,
    output                                          o_port1_tx_relay_valid      

);
/******************************function*****************************/
function integer clogb2 (input integer bit_depth);              
	begin                                                           
	  for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
	    bit_depth = bit_depth >> 1;                                 
	end                                                           
endfunction 
/******************************parameter****************************/
localparam      P_SLOT_NUM_WIDTH    = clogb2(P_SLOT_NUM - 1);
localparam      P_TOR_NUM_WIDTH     = clogb2(P_TOR_NUM - 1);
/******************************machine******************************/

/******************************reg**********************************/
reg  ro_check_queue_req_valid;
reg  [2:0]ri_check_queue_resp_ready;
reg  r_slot_start_en = 0;
//控制器接口AXIS
reg  [15 :0]                    r_recv_ctrl_cnt     ;
reg                             r_slot_start        ;

reg  [P_SLOT_NUM_WIDTH - 1 : 0] r_cur_slot_id       ;
reg  [47: 0]                    r_dest_tor_mac      ;
reg  [63: 0]                    rs_ctrl_rx_axis_tdata = 'd0;

reg  [P_TOR_NUM_WIDTH - 1 : 0]  r_even_route_table [P_TOR_NUM - 1 : 0][P_SLOT_NUM - 1 : 0];
reg  [P_TOR_NUM_WIDTH - 1 : 0]  r_odd_route_table [P_TOR_NUM - 1 : 0][P_SLOT_NUM - 1 : 0];
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_local_queue_size [P_QUEUE_NUM - 1 : 0]    ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_unlocal_queue_size [P_QUEUE_NUM - 1 : 0]  ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_tx_relay [1:0][P_QUEUE_NUM - 1 : 0]    ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_tx_relay_reg [1:0][P_QUEUE_NUM - 1 : 0]    ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_my_avail     [P_QUEUE_NUM - 1 : 0]   ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_rx_offer [1:0][P_QUEUE_NUM - 1 : 0]    ;
reg  [P_TOR_NUM_WIDTH - 1 : 0]  r_my_next_slot [P_OCS_NUM - 1 : 0][P_SLOT_NUM - 2 : 0];

reg             r_compt_relay_ready     ;
reg  [1 : 0]    r_compt_relay_en        ;
reg  [1 : 0]    r_rx_offer_valid        ;
reg  [1 : 0]    r_tx_relay_valid        ;
/******************************wire*********************************/
wire  w_slot_start_en;
wire [C_M_AXI_ADDR_WIDTH-1 : 0]               w_port0_my_capacity               ;
wire                                          w_port0_my_capacity_valid         ;
wire [C_M_AXI_ADDR_WIDTH-1 : 0]               w_port0_rx_capacity               ;
wire                                          w_port0_rx_capacity_valid         ;
wire [C_M_AXI_ADDR_WIDTH-1 : 0]               w_port0_rx_offer_capacity         ;
wire [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   w_port0_rx_offer                  ;
wire                                          w_port0_rx_offer_valid            ;
wire [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   w_port0_rx_relay                  ;
wire                                          w_port0_rx_relay_valid            ;
wire [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   w_port0_tx_relay                  ;
wire                                          w_port0_tx_relay_valid            ;

wire [C_M_AXI_ADDR_WIDTH-1 : 0]               w_port1_my_capacity               ;
wire                                          w_port1_my_capacity_valid         ;
wire [C_M_AXI_ADDR_WIDTH-1 : 0]               w_port1_rx_capacity               ;
wire                                          w_port1_rx_capacity_valid         ;
wire [C_M_AXI_ADDR_WIDTH-1 : 0]               w_port1_rx_offer_capacity         ;
wire [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   w_port1_rx_offer                  ;
wire                                          w_port1_rx_offer_valid            ;
wire [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   w_port1_rx_relay                  ;
wire                                          w_port1_rx_relay_valid            ;
wire [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   w_port1_tx_relay                  ;
wire                                          w_port1_tx_relay_valid            ;

// wire [C_M_AXI_ADDR_WIDTH-1 : 0] w_capacity_remain [1 : 0][P_OCS_NUM - 1 : 0][P_SLOT_NUM - 2 : 0]  ;
//从空间角度上分析，tor上行链路链接俩个tor，讨论这两tor的后续时隙直连节点，这里由于只有俩个tor并且每个OCS只有俩个时隙，
//所以省略了后面的[P_SLOT_NUM - 2 : 0]，相当于只需要讨论后面一个时隙的情况
wire [C_M_AXI_ADDR_WIDTH-1 : 0] w_capacity_remain [1 : 0][P_OCS_NUM - 1 : 0]  ;
wire [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0] w_local_queue_size  ;
wire [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0] w_unlocal_queue_size;
/******************************assign*******************************/
assign w_slot_start_en = ri_check_queue_resp_ready[1] && !ri_check_queue_resp_ready[2];

assign o_port0_tx_relay       = w_port1_rx_relay        ;
assign o_port0_tx_relay_valid = w_port1_rx_relay_valid  ;
assign o_port1_tx_relay       = w_port0_rx_relay        ;
assign o_port1_tx_relay_valid = w_port0_rx_relay_valid  ;

/******************************component****************************/
VLB_port_module#(
    .C_M_AXI_ADDR_WIDTH     (32                    ),
    .P_QUEUE_NUM            (8                     ),//== P_TOR_NUM
    .P_CAPACITY_PKT_TYPE    (16'hff00              ),
    .P_OFFER_PKT_TYPE       (16'hff01              ),
    .P_RELAY_PKT_TYPE       (16'hff02              ),
    .P_SLOT_ID_TYPE         (16'hff03              ),
    .P_SLOT_NUM_WIDTH       (1                     ),
    .P_SLOT_NUM             (2                     ),
    .P_TOR_NUM              (8                     ),
    .P_OCS_NUM              (2                     ),
    .P_MY_OCS               (0                     ),
    .P_MY_TOR_ID            (0                     ),
    .P_MY_TOR_MAC           (48'h8D_BC_5C_4A_10_00 ),
    .P_MAC_HEAD             (32'h8D_BC_5C_4A       ),
    .P_SLOT_MAX_PKT_NUM     (32'h00_04_00_00       ),
    .P_ETH_MIN_LEN          (8                     )
)VLB_port_module_port0(
    .i_clk                          (i_clk                      ),
    .i_rst                          (i_rst                      ) ,

    .i_slot_start                   (w_slot_start_en            ),
    .i_slot_id                      (r_cur_slot_id              ),
    .i_dest_tor_mac                 (r_dest_tor_mac             ),

    .i_syn_time_stamp               (i_syn_time_stamp           ),

    .s_rx_axis_tvalid               (s_uplink0_rx_axis_tvalid   ),
    .s_rx_axis_tdata                (s_uplink0_rx_axis_tdata    ),
    .s_rx_axis_tlast                (s_uplink0_rx_axis_tlast    ),
    .s_rx_axis_tkeep                (s_uplink0_rx_axis_tkeep    ),
    .s_rx_axis_tuser                (s_uplink0_rx_axis_tuser    ),

    .m_tx_axis_tvalid               (m_uplink0_tx_axis_tvalid   ),
    .m_tx_axis_tdata                (m_uplink0_tx_axis_tdata    ),
    .m_tx_axis_tlast                (m_uplink0_tx_axis_tlast    ),
    .m_tx_axis_tkeep                (m_uplink0_tx_axis_tkeep    ),
    .m_tx_axis_tuser                (m_uplink0_tx_axis_tuser    ),
    .m_tx_axis_tready               (m_uplink0_tx_axis_tready   ),

    .o_my_capacity                  (w_port0_my_capacity        ),
    .o_my_capacity_valid            (w_port0_my_capacity_valid  ),
    .i_twin_own_capacity            (w_port1_my_capacity        ),
    .i_twin_own_capacity_valid      (w_port1_my_capacity_valid  ),
    .o_my_rx_capacity               (w_port0_rx_capacity        ),
    .o_my_rx_capacity_valid         (w_port0_rx_capacity_valid  ),
    .i_twin_rx_capacity             (w_port1_rx_capacity        ),
    .i_twin_rx_capacity_valid       (w_port1_rx_capacity_valid  ),

    .o_my_local2_pkt_size           (o_port0_my_local2_pkt_size ),
    .o_send_local2_valid            (o_port0_send_local2_valid  ),
    .o_cur_direct_tor               (o_port0_cur_direct_tor     ),

    .i_local_queue_size             (w_local_queue_size         ),
    .i_unlocal_queue_size           (w_unlocal_queue_size       ),
    .o_rx_offer_capacity            (w_port0_rx_offer_capacity  ),
    .o_rx_offer                     (w_port0_rx_offer           ),
    .o_rx_offer_valid               (w_port0_rx_offer_valid     ),
    .o_rx_relay                     (w_port0_rx_relay           ),
    .o_rx_relay_valid               (w_port0_rx_relay_valid     ),
    .i_tx_relay                     (w_port1_tx_relay           ),
    .i_tx_relay_valid               (w_port1_tx_relay_valid     )
);

VLB_port_module#(
    .C_M_AXI_ADDR_WIDTH     (32                    ),
    .P_QUEUE_NUM            (8                     ),//== P_TOR_NUM
    .P_CAPACITY_PKT_TYPE    (16'hff00              ),
    .P_OFFER_PKT_TYPE       (16'hff01              ),
    .P_RELAY_PKT_TYPE       (16'hff02              ),
    .P_SLOT_ID_TYPE         (16'hff03              ),
    .P_SLOT_NUM_WIDTH       (1                     ),
    .P_SLOT_NUM             (2                     ),
    .P_TOR_NUM              (8                     ),
    .P_OCS_NUM              (2                     ),
    .P_MY_OCS               (0                     ),
    .P_MY_TOR_ID            (0                     ),
    .P_MY_TOR_MAC           (48'h8D_BC_5C_4A_10_00 ),
    .P_MAC_HEAD             (32'h8D_BC_5C_4A       ),
    .P_SLOT_MAX_PKT_NUM     (32'h00_04_00_00       ),
    .P_ETH_MIN_LEN          (8                     )
)VLB_port_module_port1(
    .i_clk                          (i_clk                      ),
    .i_rst                          (i_rst                      ) ,

    .i_slot_start                   (w_slot_start_en            ),
    .i_slot_id                      (r_cur_slot_id              ),
    .i_dest_tor_mac                 (r_dest_tor_mac             ),

    .i_syn_time_stamp               (i_syn_time_stamp           ),

    .s_rx_axis_tvalid               (s_uplink1_rx_axis_tvalid   ),
    .s_rx_axis_tdata                (s_uplink1_rx_axis_tdata    ),
    .s_rx_axis_tlast                (s_uplink1_rx_axis_tlast    ),
    .s_rx_axis_tkeep                (s_uplink1_rx_axis_tkeep    ),
    .s_rx_axis_tuser                (s_uplink1_rx_axis_tuser    ),

    .m_tx_axis_tvalid               (m_uplink1_tx_axis_tvalid   ),
    .m_tx_axis_tdata                (m_uplink1_tx_axis_tdata    ),
    .m_tx_axis_tlast                (m_uplink1_tx_axis_tlast    ),
    .m_tx_axis_tkeep                (m_uplink1_tx_axis_tkeep    ),
    .m_tx_axis_tuser                (m_uplink1_tx_axis_tuser    ),
    .m_tx_axis_tready               (m_uplink1_tx_axis_tready   ),

    .o_my_capacity                  (w_port1_my_capacity        ),
    .o_my_capacity_valid            (w_port1_my_capacity_valid  ),
    .i_twin_own_capacity            (w_port0_my_capacity        ),
    .i_twin_own_capacity_valid      (w_port0_my_capacity_valid  ),
    .o_my_rx_capacity               (w_port1_rx_capacity        ),
    .o_my_rx_capacity_valid         (w_port1_rx_capacity_valid  ),
    .i_twin_rx_capacity             (w_port0_rx_capacity        ),
    .i_twin_rx_capacity_valid       (w_port0_rx_capacity_valid  ),

    .o_my_local2_pkt_size           (o_port1_my_local2_pkt_size ),
    .o_send_local2_valid            (o_port1_send_local2_valid  ),
    .o_cur_direct_tor               (o_port1_cur_direct_tor     ),

    .i_local_queue_size             (w_local_queue_size         ),
    .i_unlocal_queue_size           (w_unlocal_queue_size       ),
    .o_rx_offer_capacity            (w_port1_rx_offer_capacity  ),
    .o_rx_offer                     (w_port1_rx_offer           ),
    .o_rx_offer_valid               (w_port1_rx_offer_valid     ),
    .o_rx_relay                     (w_port1_rx_relay           ),
    .o_rx_relay_valid               (w_port1_rx_relay_valid     ),
    .i_tx_relay                     (w_port0_tx_relay           ),
    .i_tx_relay_valid               (w_port0_tx_relay_valid     )
);
/******************************always*******************************/

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_check_queue_req_valid <= 'd0;
    else if(ri_check_queue_resp_ready[2])
        ro_check_queue_req_valid <= 'd0;
    else if(r_slot_start)
        ro_check_queue_req_valid <= 'd1;
    else
        ro_check_queue_req_valid <= ro_check_queue_req_valid;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ri_check_queue_resp_ready <= 3'b000;
    else
        ri_check_queue_resp_ready <= {ri_check_queue_resp_ready[1],ri_check_queue_resp_ready[0],i_check_queue_resp_ready};
end

always @(posedge i_clk)begin
    r_slot_start_en <= w_slot_start_en  ;
end

genvar tor_i;
generate
    for(tor_i = 0; tor_i < P_TOR_NUM; tor_i = tor_i + 1)begin

        assign w_local_queue_size  [tor_i * C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH] = r_local_queue_size  [tor_i];
        assign w_unlocal_queue_size[tor_i * C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH] = r_unlocal_queue_size[tor_i];

        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)begin
                r_even_route_table[tor_i][0] <= 'd0;
                r_even_route_table[tor_i][1] <= 'd0;
            end
            else begin
                //和偶数序号OCS0相连
                r_even_route_table[0][tor_i][0] <=  (tor_i + 1) > (P_TOR_NUM - 1) ? 
                                            ((tor_i + 1) - (P_TOR_NUM - 1) - 1) : 
                                            (tor_i + 1);
                r_even_route_table[0][tor_i][1] <=  (tor_i + 1 * 2 + 1) > (P_TOR_NUM - 1) ? 
                                            ((tor_i + 1 * 2 + 1) - (P_TOR_NUM - 1) - 1):
                                            (tor_i + 1 * 2 + 1);
            end
        end

        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)begin
                r_odd_route_table[tor_i][0] <= 'd0;
                r_odd_route_table[tor_i][1] <= 'd0;
            end
            else begin
                //和奇数序号OCS1相连
                r_odd_route_table[tor_i][0] <=  (tor_i - 1) < 0 ? 
                                            ((P_TOR_NUM + tor_i - 1)) : 
                                            (tor_i - 1);
                r_odd_route_table[tor_i][1] <=  (tor_i - 1 * 2 - 1) < 0 ? 
                                            (P_TOR_NUM + tor_i - 1 * 2 - 1):
                                            (tor_i - 1 * 2 - 1);
            end
        end

        //计算缓存区可用空间，即available
        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                r_my_avail[tor_i] <= 'd0;
            else if(r_slot_start_en)
                r_my_avail[tor_i] <= P_SLOT_MAX_PKT_NUM - r_local_queue_size[tor_i] - r_unlocal_queue_size[tor_i];
            else if(r_compt_relay_en[0])//updata avail after every compute relay pkt
                r_my_avail[tor_i] <= r_my_avail[tor_i] - r_tx_relay[0][tor_i];
            else if(r_compt_relay_en[1])
                r_my_avail[tor_i] <= r_my_avail[tor_i] - r_tx_relay[1][tor_i];
            else
                r_my_avail[tor_i] <= r_my_avail[tor_i];
        end

        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                r_tx_relay_reg[0][tor_i] <= 'd0;
            else
                r_tx_relay_reg[0][tor_i] <= r_tx_relay[0][tor_i];
        end
        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                r_tx_relay_reg[1][tor_i] <= 'd0;
            else
                r_tx_relay_reg[1][tor_i] <= r_tx_relay[1][tor_i];
        end

        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                r_rx_offer[0][tor_i] <= 'd0;
            else
                r_rx_offer[0][tor_i] <= w_port0_rx_offer[tor_i * C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH];
        end

        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                r_rx_offer[1][tor_i] <= 'd0;
            else
                r_rx_offer[1][tor_i] <= w_port1_rx_offer[tor_i * C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH];
        end
        
    end

endgenerate
/*  上行端口0的直连ToR在下一个时隙会通过OCS0、OCS1有俩个直连节点，要空间角度上考虑中继优先级
    这里的r_tx_relay[0][0]指的是上行port0的直连节点通过OCS0在下一时隙的直连节点,实际应该是
    r_tx_relay[0][0][0]，最后的表示[0]表示后续时隙编号，但是由于这里的OCS度那口规模是8，
    所以每一个OCS只有俩个时隙，因此暂时只需要考虑后续的一个时隙即可*/

//同步更新带宽余量信息
assign w_capacity_remain[0][0] = w_port0_rx_offer_capacity;
assign w_capacity_remain[0][1] = w_port0_rx_offer_capacity - r_tx_relay[0][r_my_next_slot[0][0]];
assign w_capacity_remain[1][0] = w_port1_rx_offer_capacity;
assign w_capacity_remain[1][1] = w_port1_rx_offer_capacity - r_tx_relay[1][r_my_next_slot[1][0]];

genvar ocs_i;
generate
    for(ocs_i = 0; ocs_i < P_OCS_NUM; ocs_i = ocs_i + 1)begin

        always @(*)begin
            if(i_rst)begin
                r_tx_relay[0][r_my_next_slot[ocs_i][0]] <= 'd0;
            end
            else if(r_compt_relay_en[0])begin//port0握手成功，开始分配relay
                if(r_rx_offer[0][r_my_next_slot[ocs_i][0]] < w_capacity_remain[0][ocs_i])
                    if(r_rx_offer[0][r_my_next_slot[ocs_i][0]] < r_my_avail[r_my_next_slot[ocs_i][0]])
                        r_tx_relay[0][r_my_next_slot[ocs_i][0]] = r_rx_offer[0][r_my_next_slot[ocs_i][0]];
                    else
                        r_tx_relay[0][r_my_next_slot[ocs_i][0]] = r_my_avail[r_my_next_slot[ocs_i][0]];
                else
                    if(w_capacity_remain[ocs_i][0] < r_my_avail[r_my_next_slot[ocs_i][0]])
                        r_tx_relay[0][r_my_next_slot[ocs_i][0]] = w_capacity_remain[ocs_i][0];
                    else
                        r_tx_relay[0][r_my_next_slot[ocs_i][0]] = r_my_avail[r_my_next_slot[ocs_i][0]];
            end
            else
                r_tx_relay[0][r_my_next_slot[ocs_i][0]] <= r_tx_relay[0][r_my_next_slot[ocs_i][0]];
        end
        
        always @(*)begin
            if(i_rst)begin
                r_tx_relay[1][r_my_next_slot[ocs_i][0]] <= 'd0;
            end
            else if(r_compt_relay_en[1])begin//port0握手成功，开始分配relay
                if(r_rx_offer[1][r_my_next_slot[ocs_i][0]] < w_capacity_remain[1][ocs_i])
                    if(r_rx_offer[1][r_my_next_slot[ocs_i][0]] < r_my_avail[r_my_next_slot[ocs_i][0]])
                        r_tx_relay[1][r_my_next_slot[ocs_i][0]] = r_rx_offer[1][r_my_next_slot[ocs_i][0]];
                    else
                        r_tx_relay[1][r_my_next_slot[ocs_i][0]] = r_my_avail[r_my_next_slot[ocs_i][0]];
                else
                    if(w_capacity_remain[ocs_i][0] < r_my_avail[r_my_next_slot[ocs_i][0]])
                        r_tx_relay[1][r_my_next_slot[ocs_i][0]] = w_capacity_remain[ocs_i][0];
                    else
                        r_tx_relay[1][r_my_next_slot[ocs_i][0]] = r_my_avail[r_my_next_slot[ocs_i][0]];
            end
            else
                r_tx_relay[1][r_my_next_slot[ocs_i][0]] <= r_tx_relay[1][r_my_next_slot[ocs_i][0]];
        end


    end

endgenerate        



genvar queue_i;
generate
    for(queue_i = 0; queue_i < P_QUEUE_NUM; queue_i = queue_i + 1)begin
        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                r_local_queue_size  [queue_i] <= 'd0;
            else if(w_slot_start_en)//跨时钟
                r_local_queue_size  [queue_i] <= i_local_queue_size[queue_i*C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH];
            else 
                r_local_queue_size  [queue_i] <= r_local_queue_size  [queue_i];
        end

        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                r_unlocal_queue_size[queue_i] <= 'd0;
            else if(w_slot_start_en)//跨时钟
                r_unlocal_queue_size[queue_i] <= i_unlocal_queue_size[queue_i*C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH];
            else if(r_tx_relay_valid[0])
                r_unlocal_queue_size[queue_i] <= r_unlocal_queue_size[queue_i] - r_tx_relay[0][queue_i];
            else if(r_tx_relay_valid[1])
                r_unlocal_queue_size[queue_i] <= r_unlocal_queue_size[queue_i] - r_tx_relay[1][queue_i];
            else 
                r_unlocal_queue_size[queue_i] <= r_unlocal_queue_size[queue_i];
        end

    end
endgenerate

genvar slot_i;
generate
    for(slot_i = 0; slot_i < P_SLOT_NUM - 1; slot_i = slot_i + 1)begin

        //记录不同的当前时隙下的后续时隙的直连节点信息
        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                r_my_next_slot[0][slot_i] <= 'd0;
            else if(r_slot_start_en)begin
                if(r_cur_slot_id + slot_i + 1 < P_SLOT_NUM)
                    r_my_next_slot[0][slot_i] <= r_even_route_table[P_MY_TOR_ID][r_cur_slot_id + 1];
                else
                    r_my_next_slot[0][slot_i] <= r_even_route_table[P_MY_TOR_ID][P_SLOT_NUM - r_cur_slot_id - 1];
            end  
            else
                r_my_next_slot[0][slot_i] <= r_my_next_slot[0][slot_i];
        end

        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                r_my_next_slot[1][slot_i] <= 'd0;
            else if(r_slot_start_en)begin
                if(r_cur_slot_id + slot_i + 1 < P_SLOT_NUM)
                    r_my_next_slot[1][slot_i] <= r_odd_route_table[P_MY_TOR_ID][r_cur_slot_id + 1];
                else
                    r_my_next_slot[1][slot_i] <= r_odd_route_table[P_MY_TOR_ID][P_SLOT_NUM - r_cur_slot_id - 1];
            end  
            else
                r_my_next_slot[1][slot_i] <= r_my_next_slot[1][slot_i];
        end

    end

endgenerate

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_rx_offer_valid <= 2'b00;
    else if(|r_compt_relay_en)
        r_rx_offer_valid <= 2'b00;
    else if(w_port0_rx_offer_valid)
        r_rx_offer_valid <= 2'b01;
    else if(w_port1_rx_offer_valid)
        r_rx_offer_valid <= 2'b10;
    else
        r_rx_offer_valid <= r_rx_offer_valid;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_compt_relay_ready <= 'd1;
    else if(|r_tx_relay_valid)
        r_compt_relay_ready <= 'd1;
    else if(r_compt_relay_ready && w_port0_rx_offer_valid)
        r_compt_relay_ready <= 'd0;
    else if(r_compt_relay_ready && w_port1_rx_offer_valid)
        r_compt_relay_ready <= 'd0;
    else
        r_compt_relay_ready <= r_compt_relay_ready;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_compt_relay_en <= 2'b00;
    else if(r_compt_relay_ready && r_rx_offer_valid[0])
        r_compt_relay_en <= 2'b01;
    else if(r_compt_relay_ready && r_rx_offer_valid[1])
        r_compt_relay_en <= 2'b10;
    else
        r_compt_relay_en <= 2'b00;
end

//控制器接口，记录时间戳、时隙开始标识以及时隙ID
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_recv_ctrl_cnt <= 'd0;
    else if(s_ctrl_rx_axis_tvalid && s_ctrl_rx_axis_tlast)
        r_recv_ctrl_cnt <= 'd0;
    else if(s_ctrl_rx_axis_tvalid)
        r_recv_ctrl_cnt <= r_recv_ctrl_cnt + 'd1;
    else
        r_recv_ctrl_cnt <= r_recv_ctrl_cnt;
end

always @(posedge i_clk)begin
    rs_ctrl_rx_axis_tdata <= s_ctrl_rx_axis_tdata;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_dest_tor_mac <= 'd0;
    else if(s_ctrl_rx_axis_tvalid && r_recv_ctrl_cnt == 1 && s_ctrl_rx_axis_tdata[31:16] == P_SLOT_ID_TYPE)
        r_dest_tor_mac <= {rs_ctrl_rx_axis_tdata[15:0],s_ctrl_rx_axis_tdata[63:32]};
    else
        r_dest_tor_mac <= r_dest_tor_mac;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_cur_slot_id <= 'd0;
    else if(s_ctrl_rx_axis_tvalid && r_recv_ctrl_cnt == 1 && s_ctrl_rx_axis_tdata[31:16] == P_SLOT_ID_TYPE)
        r_cur_slot_id <= s_ctrl_rx_axis_tdata[P_SLOT_NUM_WIDTH - 1 : 0];
    else
        r_cur_slot_id <= r_cur_slot_id;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_slot_start <= 'd0;
    else if(s_ctrl_rx_axis_tvalid && r_recv_ctrl_cnt == 1 && s_ctrl_rx_axis_tdata[31:16] == P_SLOT_ID_TYPE)
        r_slot_start <= 'd1;
    else
        r_slot_start <= 'd0;
end


// always @(posedge i_clk or posedge i_rst)begin
//     if(i_rst)

//     else if()

//     else

// end

endmodule
