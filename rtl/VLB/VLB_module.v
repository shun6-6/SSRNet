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
    parameter       P_MY_TOR_MAC        = 48'h8D_BC_5C_4A_10_00 ,
    parameter       P_MAC_HEAD          = 32'h8D_BC_5C_4A       ,
    parameter       P_SLOT_MAX_BYTE_NUM = 32'h00_04_00_00       ,
    parameter       P_ETH_MIN_LEN       = 8  
)(
    input                                           i_clk                       ,
    input                                           i_rst                       ,  
    input  [63: 0]                                  i_syn_time_stamp            ,
    input                                           i_slot_start                ,
    input  [2:0]                                    i_cur_slot_id               ,
    //带内控制协议接口
    input                                           s_uplink0_rx_axis_tvalid    ,
    input  [63 :0]                                  s_uplink0_rx_axis_tdata     ,
    input                                           s_uplink0_rx_axis_tlast     ,
    input  [7  :0]                                  s_uplink0_rx_axis_tkeep     ,
    input  [1 : 0]                                  s_uplink0_rx_axis_tuser     ,

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
    input  [1 : 0]                                  s_uplink1_rx_axis_tuser     ,

    output                                          m_uplink1_tx_axis_tvalid    ,
    output [63 :0]                                  m_uplink1_tx_axis_tdata     ,
    output                                          m_uplink1_tx_axis_tlast     ,
    output [7  :0]                                  m_uplink1_tx_axis_tkeep     ,
    output                                          m_uplink1_tx_axis_tuser     ,
    input                                           m_uplink1_tx_axis_tready    ,
    //queue size
    output                                          o_check_queue_req_valid     ,//握手跨时钟
    input                                           i_check_queue_resp_ready    ,
    input  [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   i_local_queue_size          ,
    input  [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   i_unlocal_queue_size        ,
    //port0 send data
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_port0_send_local2_pkt_size    ,
    output                                          o_port0_send_local2_valid       ,
    output [2 : 0]                                  o_port0_send_local2_queue       ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_port0_local_direct_pkt_size   ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_port0_local_direct_pkt_valid  ,
    output [2 : 0]                                  o_port0_cur_direct_tor          ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_port0_unlocal_direct_pkt_size ,
    output                                          o_port0_unlocal_direct_pkt_valid,
    output [2 : 0]                                  o_port0_unlocal_direct_pkt_queue,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_port0_recv_local2_pkt_size    ,
    output                                          o_port0_recv_local2_pkt_valid   ,
    output [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   o_port0_tx_relay                ,
    output                                          o_port0_tx_relay_valid          ,
    //port1 send data
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_port1_send_local2_pkt_size    ,
    output                                          o_port1_send_local2_valid       ,
    output [2 : 0]                                  o_port1_send_local2_queue       ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_port1_local_direct_pkt_size   ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_port1_local_direct_pkt_valid  ,
    output [2 : 0]                                  o_port1_cur_direct_tor          ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_port1_unlocal_direct_pkt_size ,
    output                                          o_port1_unlocal_direct_pkt_valid,
    output [2 : 0]                                  o_port1_unlocal_direct_pkt_queue,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_port1_recv_local2_pkt_size    ,
    output                                          o_port1_recv_local2_pkt_valid   ,
    output [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   o_port1_tx_relay                ,
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
localparam      P_MY_TOR_ID = P_MY_TOR_MAC[2:0];
localparam      P_SLOT_NUM_WIDTH    = clogb2(P_SLOT_NUM - 1);
localparam      P_TOR_NUM_WIDTH     = clogb2(P_TOR_NUM - 1);
/******************************machine******************************/

/******************************reg**********************************/
reg             rs_uplink0_rx_axis_tvalid;
reg  [63 :0]    rs_uplink0_rx_axis_tdata ;
reg             rs_uplink0_rx_axis_tlast ;
reg  [7  :0]    rs_uplink0_rx_axis_tkeep ;
reg             rs_uplink0_rx_axis_tuser ;

reg             rs_uplink1_rx_axis_tvalid;
reg  [63 :0]    rs_uplink1_rx_axis_tdata ;
reg             rs_uplink1_rx_axis_tlast ;
reg  [7  :0]    rs_uplink1_rx_axis_tkeep ;
reg             rs_uplink1_rx_axis_tuser ;
reg  [15:0]     r_recv0_cnt;
reg  [15:0]     r_recv1_cnt;

reg  ro_check_queue_req_valid;
reg  [2:0]ri_check_queue_resp_ready;
reg  r_slot_start_en = 0;
//控制器接口AXIS
reg                             r_slot_start        ;
reg  [2 : 0]                    r_cur_slot_id       ;

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
assign o_check_queue_req_valid = ro_check_queue_req_valid;
assign o_port0_tx_relay       = w_port1_rx_relay        ;
assign o_port0_tx_relay_valid = w_port1_rx_relay_valid  ;
assign o_port1_tx_relay       = w_port0_rx_relay        ;
assign o_port1_tx_relay_valid = w_port0_rx_relay_valid  ;

assign w_port0_tx_relay_valid = r_tx_relay_valid[0];
assign w_port1_tx_relay_valid = r_tx_relay_valid[1];
/******************************component****************************/
VLB_port_module#(
    .C_M_AXI_ADDR_WIDTH     (C_M_AXI_ADDR_WIDTH     ),
    .P_QUEUE_NUM            (P_QUEUE_NUM            ),//== P_TOR_NUM
    .P_CAPACITY_PKT_TYPE    (P_CAPACITY_PKT_TYPE    ),
    .P_OFFER_PKT_TYPE       (P_OFFER_PKT_TYPE       ),
    .P_RELAY_PKT_TYPE       (P_RELAY_PKT_TYPE       ),
    .P_SLOT_ID_TYPE         (P_SLOT_ID_TYPE         ),
    .P_SLOT_NUM_WIDTH       (P_SLOT_NUM_WIDTH       ),
    .P_SLOT_NUM             (P_SLOT_NUM             ),
    .P_TOR_NUM              (P_TOR_NUM              ),
    .P_OCS_NUM              (P_OCS_NUM              ),
    .P_MY_OCS_ID            ('d0                   ),
    .P_MY_TOR_MAC           (P_MY_TOR_MAC           ),
    .P_MAC_HEAD             (P_MAC_HEAD             ),
    .P_SLOT_MAX_BYTE_NUM     (P_SLOT_MAX_BYTE_NUM     ),
    .P_ETH_MIN_LEN          (P_ETH_MIN_LEN          )
)VLB_port_module_port0(
    .i_clk                          (i_clk                      ),
    .i_rst                          (i_rst                      ) ,

    .i_slot_start                   (w_slot_start_en            ),
    .i_slot_id                      (r_cur_slot_id              ),

    .i_syn_time_stamp               (i_syn_time_stamp           ),

    .s_rx_axis_tvalid               (rs_uplink0_rx_axis_tvalid   ),
    .s_rx_axis_tdata                (rs_uplink0_rx_axis_tdata    ),
    .s_rx_axis_tlast                (rs_uplink0_rx_axis_tlast    ),
    .s_rx_axis_tkeep                (rs_uplink0_rx_axis_tkeep    ),
    .s_rx_axis_tuser                (rs_uplink0_rx_axis_tuser    ),

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

    .o_send_my_local2_pkt_size      (o_port0_send_local2_pkt_size       ),
    .o_send_my_local2_valid         (o_port0_send_local2_valid          ),
    .o_send_my_local2_queue         (o_port0_send_local2_queue          ),
    .o_local_direct_pkt_size        (o_port0_local_direct_pkt_size      ),
    .o_local_direct_pkt_valid       (o_port0_local_direct_pkt_valid     ),
    .o_cur_direct_tor               (o_port0_cur_direct_tor             ),
    .o_unlocal_direct_pkt_size      (o_port0_unlocal_direct_pkt_size    ),
    .o_unlocal_direct_pkt_valid     (o_port0_unlocal_direct_pkt_valid   ),
    .o_unlocal_direct_pkt_queue     (o_port0_unlocal_direct_pkt_queue   ),
    .o_recv_local2_pkt_size         (o_port0_recv_local2_pkt_size       ),
    .o_recv_local2_pkt_valid        (o_port0_recv_local2_pkt_valid      ),

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
    .C_M_AXI_ADDR_WIDTH     (C_M_AXI_ADDR_WIDTH     ),
    .P_QUEUE_NUM            (P_QUEUE_NUM            ),//== P_TOR_NUM
    .P_CAPACITY_PKT_TYPE    (P_CAPACITY_PKT_TYPE    ),
    .P_OFFER_PKT_TYPE       (P_OFFER_PKT_TYPE       ),
    .P_RELAY_PKT_TYPE       (P_RELAY_PKT_TYPE       ),
    .P_SLOT_ID_TYPE         (P_SLOT_ID_TYPE         ),
    .P_SLOT_NUM_WIDTH       (P_SLOT_NUM_WIDTH       ),
    .P_SLOT_NUM             (P_SLOT_NUM             ),
    .P_TOR_NUM              (P_TOR_NUM              ),
    .P_OCS_NUM              (P_OCS_NUM              ),
    .P_MY_OCS_ID            ('d1                   ),
    .P_MY_TOR_MAC           (P_MY_TOR_MAC           ),
    .P_MAC_HEAD             (P_MAC_HEAD             ),
    .P_SLOT_MAX_BYTE_NUM     (P_SLOT_MAX_BYTE_NUM     ),
    .P_ETH_MIN_LEN          (P_ETH_MIN_LEN          )
)VLB_port_module_port1(
    .i_clk                          (i_clk                      ),
    .i_rst                          (i_rst                      ) ,

    .i_slot_start                   (w_slot_start_en            ),
    .i_slot_id                      (r_cur_slot_id              ),

    .i_syn_time_stamp               (i_syn_time_stamp           ),

    .s_rx_axis_tvalid               (rs_uplink1_rx_axis_tvalid   ),
    .s_rx_axis_tdata                (rs_uplink1_rx_axis_tdata    ),
    .s_rx_axis_tlast                (rs_uplink1_rx_axis_tlast    ),
    .s_rx_axis_tkeep                (rs_uplink1_rx_axis_tkeep    ),
    .s_rx_axis_tuser                (rs_uplink1_rx_axis_tuser    ),

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

    .o_send_my_local2_pkt_size      (o_port1_send_local2_pkt_size       ),
    .o_send_my_local2_valid         (o_port1_send_local2_valid          ),
    .o_send_my_local2_queue         (o_port1_send_local2_queue          ),
    .o_local_direct_pkt_size        (o_port1_local_direct_pkt_size      ),
    .o_local_direct_pkt_valid       (o_port1_local_direct_pkt_valid     ),
    .o_cur_direct_tor               (o_port1_cur_direct_tor             ),
    .o_unlocal_direct_pkt_size      (o_port1_unlocal_direct_pkt_size    ),
    .o_unlocal_direct_pkt_valid     (o_port1_unlocal_direct_pkt_valid   ),
    .o_unlocal_direct_pkt_queue     (o_port1_unlocal_direct_pkt_queue   ),
    .o_recv_local2_pkt_size         (o_port1_recv_local2_pkt_size       ),
    .o_recv_local2_pkt_valid        (o_port1_recv_local2_pkt_valid      ),

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
always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_recv0_cnt <= 'd0;
    else if(s_uplink0_rx_axis_tvalid && s_uplink0_rx_axis_tlast)
        r_recv0_cnt <= 'd0;
    else if(s_uplink0_rx_axis_tvalid)
		r_recv0_cnt <= r_recv0_cnt + 1'b1;
    else
        r_recv0_cnt <= r_recv0_cnt;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_recv1_cnt <= 'd0;
    else if(s_uplink1_rx_axis_tvalid && s_uplink1_rx_axis_tlast)
        r_recv1_cnt <= 'd0;
    else if(s_uplink1_rx_axis_tvalid)
		r_recv1_cnt <= r_recv1_cnt + 1'b1;
    else
        r_recv1_cnt <= r_recv1_cnt;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        rs_uplink0_rx_axis_tvalid <= 'd0;
        rs_uplink0_rx_axis_tdata  <= 'd0;
        rs_uplink0_rx_axis_tlast  <= 'd0;
        rs_uplink0_rx_axis_tkeep  <= 'd0;
        rs_uplink0_rx_axis_tuser  <= 'd0;
    end
    else if(s_uplink0_rx_axis_tvalid && s_uplink0_rx_axis_tuser == 'd3)begin
        rs_uplink0_rx_axis_tvalid <= s_uplink0_rx_axis_tvalid;
        rs_uplink0_rx_axis_tdata  <= s_uplink0_rx_axis_tdata ;
        rs_uplink0_rx_axis_tlast  <= s_uplink0_rx_axis_tlast ;
        rs_uplink0_rx_axis_tkeep  <= s_uplink0_rx_axis_tkeep ;
        rs_uplink0_rx_axis_tuser  <= s_uplink0_rx_axis_tuser ;
    end
    else begin
        rs_uplink0_rx_axis_tvalid <= 'd0;
        rs_uplink0_rx_axis_tdata  <= 'd0;
        rs_uplink0_rx_axis_tlast  <= 'd0;
        rs_uplink0_rx_axis_tkeep  <= 'd0;
        rs_uplink0_rx_axis_tuser  <= 'd0;
    end
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        rs_uplink1_rx_axis_tvalid <= 'd0;
        rs_uplink1_rx_axis_tdata  <= 'd0;
        rs_uplink1_rx_axis_tlast  <= 'd0;
        rs_uplink1_rx_axis_tkeep  <= 'd0;
        rs_uplink1_rx_axis_tuser  <= 'd0;
    end
    else if(s_uplink1_rx_axis_tvalid && s_uplink1_rx_axis_tuser == 'd3)begin
        rs_uplink1_rx_axis_tvalid <= s_uplink1_rx_axis_tvalid;
        rs_uplink1_rx_axis_tdata  <= s_uplink1_rx_axis_tdata ;
        rs_uplink1_rx_axis_tlast  <= s_uplink1_rx_axis_tlast ;
        rs_uplink1_rx_axis_tkeep  <= s_uplink1_rx_axis_tkeep ;
        rs_uplink1_rx_axis_tuser  <= s_uplink1_rx_axis_tuser ;
    end
    else begin
        rs_uplink1_rx_axis_tvalid <= 'd0;
        rs_uplink1_rx_axis_tdata  <= 'd0;
        rs_uplink1_rx_axis_tlast  <= 'd0;
        rs_uplink1_rx_axis_tkeep  <= 'd0;
        rs_uplink1_rx_axis_tuser  <= 'd0;
    end
end



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

        initial begin
            r_tx_relay[0][tor_i] = 'd0;
            r_tx_relay[1][tor_i] = 'd0;
        end

        assign w_local_queue_size  [tor_i * C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH] = r_local_queue_size  [tor_i];
        assign w_unlocal_queue_size[tor_i * C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH] = r_unlocal_queue_size[tor_i];

        assign w_port0_tx_relay[tor_i * C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH] = r_tx_relay_reg[0][tor_i];
        assign w_port1_tx_relay[tor_i * C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH] = r_tx_relay_reg[1][tor_i];

        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)begin
                r_even_route_table[tor_i][0] <= 'd0;
                r_even_route_table[tor_i][1] <= 'd0;
            end
            else begin
                //和偶数序号OCS0相连
                r_even_route_table[tor_i][0] <=  (tor_i + 1) > (P_TOR_NUM - 1) ? 
                                            ((tor_i + 1) - (P_TOR_NUM - 1) - 1) : 
                                            (tor_i + 1);
                r_even_route_table[tor_i][1] <=  (tor_i + 1 * 2 + 1) > (P_TOR_NUM - 1) ? 
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
                r_my_avail[tor_i] <= P_SLOT_MAX_BYTE_NUM - r_local_queue_size[tor_i] - r_unlocal_queue_size[tor_i];
            else if(r_tx_relay_valid[0])//updata avail after every compute relay pkt
                r_my_avail[tor_i] <= r_my_avail[tor_i] - r_tx_relay_reg[0][tor_i];
            else if(r_tx_relay_valid[1])
                r_my_avail[tor_i] <= r_my_avail[tor_i] - r_tx_relay_reg[1][tor_i];
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
/*  w_capacity_remain[0][0]表示对端ToR上行链路port0在OCS0当中的带宽余量，
    w_capacity_remain[0][1]表示本地根据自己在OCS0在下一跳的直连节点信息为对端分配一次中继流量后
    对端ToR上行链路port0在OCS0当中的带宽余量，这是因为对端的port0是与OCS0相连的，所以尽可能
    先分配可以通过OCS0跨时隙转发的数据，然后本地需要在w_capacity_remain[0][1]不为0的开启下
    继续为对端节点分配中继流量，此时的依据是OCS1的下一跳直连节点，因为这样子可以使得对端发送
    的中继流量在下一时隙就被发送，分别通过por0和port1。
    同理：w_capacity_remain[1][1]表示对端ToR上行链路port1在OCS1当中的带宽余量，w_capacity_remain[1][0]
    表示本地根据自己在OCS1在下一跳的直连节点信息为对端分配一次中继流量后对端ToR上行链路port1在OCS1当中的带宽余量*/
assign w_capacity_remain[0][0] = w_port0_rx_offer_capacity;
assign w_capacity_remain[0][1] = w_port0_rx_offer_capacity - r_tx_relay[0][r_my_next_slot[0][0]];
assign w_capacity_remain[1][1] = w_port1_rx_offer_capacity;
assign w_capacity_remain[1][0] = w_port1_rx_offer_capacity - r_tx_relay[1][r_my_next_slot[1][0]];


// always @(*)begin
//     if(r_compt_relay_en[0])begin//port0握手成功，先针对OCS0下一时隙直连节点开始分配relay
//         if(r_rx_offer[0][r_my_next_slot[0][0]] < w_capacity_remain[0][0])
//             if(r_rx_offer[0][r_my_next_slot[0][0]] < r_my_avail[r_my_next_slot[0][0]])
//                 r_tx_relay[0][r_my_next_slot[0][0]] = r_rx_offer[0][r_my_next_slot[0][0]];
//             else
//                 r_tx_relay[0][r_my_next_slot[0][0]] = r_my_avail[r_my_next_slot[0][0]];
//         else
//             if(w_capacity_remain[0][0] < r_my_avail[r_my_next_slot[0][0]])
//                 r_tx_relay[0][r_my_next_slot[0][0]] = w_capacity_remain[0][0];
//             else
//                 r_tx_relay[0][r_my_next_slot[0][0]] = r_my_avail[r_my_next_slot[0][0]];
//     end
//     else begin
//         r_tx_relay[0][r_my_next_slot[0][0]] = 'd0;
//     end   
// end

// always @(*)begin
//     if(r_compt_relay_en[0])begin//port0握手成功，后针对OCS1下一时隙直连节点开始分配relay
//         if(r_rx_offer[0][r_my_next_slot[1][0]] < w_capacity_remain[0][1])
//             if(r_rx_offer[0][r_my_next_slot[1][0]] < r_my_avail[r_my_next_slot[1][0]])
//                 r_tx_relay[0][r_my_next_slot[1][0]] = r_rx_offer[0][r_my_next_slot[1][0]];
//             else
//                 r_tx_relay[0][r_my_next_slot[1][0]] = r_my_avail[r_my_next_slot[1][0]];
//         else
//             if(w_capacity_remain[0][1] < r_my_avail[r_my_next_slot[1][0]])
//                 r_tx_relay[0][r_my_next_slot[1][0]] = w_capacity_remain[0][1];
//             else
//                 r_tx_relay[0][r_my_next_slot[1][0]] = r_my_avail[r_my_next_slot[1][0]];
//     end
//     else begin
//         r_tx_relay[0][r_my_next_slot[1][0]] = 'd0;
//     end   
// end


always @(*)begin
    if(r_compt_relay_en[0])begin
        
        //port0握手成功，先针对OCS0下一时隙直连节点开始分配relay
        if(r_rx_offer[0][r_my_next_slot[0][0]] < w_capacity_remain[0][0])
            if(r_rx_offer[0][r_my_next_slot[0][0]] < r_my_avail[r_my_next_slot[0][0]])
                r_tx_relay[0][r_my_next_slot[0][0]] = r_rx_offer[0][r_my_next_slot[0][0]];
            else
                r_tx_relay[0][r_my_next_slot[0][0]] = r_my_avail[r_my_next_slot[0][0]];
        else
            if(w_capacity_remain[0][0] < r_my_avail[r_my_next_slot[0][0]])
                r_tx_relay[0][r_my_next_slot[0][0]] = w_capacity_remain[0][0];
            else
                r_tx_relay[0][r_my_next_slot[0][0]] = r_my_avail[r_my_next_slot[0][0]];

        //port0握手成功，后针对OCS1下一时隙直连节点开始分配relay
        if(r_rx_offer[0][r_my_next_slot[1][0]] < w_capacity_remain[0][1])
            if(r_rx_offer[0][r_my_next_slot[1][0]] < r_my_avail[r_my_next_slot[1][0]])
                r_tx_relay[0][r_my_next_slot[1][0]] = r_rx_offer[0][r_my_next_slot[1][0]];
            else
                r_tx_relay[0][r_my_next_slot[1][0]] = r_my_avail[r_my_next_slot[1][0]];
        else
            if(w_capacity_remain[0][1] < r_my_avail[r_my_next_slot[1][0]])
                r_tx_relay[0][r_my_next_slot[1][0]] = w_capacity_remain[0][1];
            else
                r_tx_relay[0][r_my_next_slot[1][0]] = r_my_avail[r_my_next_slot[1][0]];

    end
    else begin
        r_tx_relay[0][r_my_next_slot[0][0]] = 'd0;
        r_tx_relay[0][r_my_next_slot[1][0]] = 'd0;
    end   
end

// always @(*)begin
//     if(r_compt_relay_en[1])begin//port1握手成功，先针对OCS1下一时隙直连节点开始分配relay
//         if(r_rx_offer[1][r_my_next_slot[1][0]] < w_capacity_remain[1][1])
//             if(r_rx_offer[1][r_my_next_slot[1][0]] < r_my_avail[r_my_next_slot[1][0]])
//                 r_tx_relay[1][r_my_next_slot[1][0]] = r_rx_offer[1][r_my_next_slot[1][0]];
//             else
//                 r_tx_relay[1][r_my_next_slot[1][0]] = r_my_avail[r_my_next_slot[1][0]];
//         else
//             if(w_capacity_remain[1][1] < r_my_avail[r_my_next_slot[1][0]])
//                 r_tx_relay[1][r_my_next_slot[1][0]] = w_capacity_remain[1][1];
//             else
//                 r_tx_relay[1][r_my_next_slot[1][0]] = r_my_avail[r_my_next_slot[1][0]];
//     end
//     else begin
//         r_tx_relay[1][r_my_next_slot[1][0]] = 'd0;
//     end   

//     if(r_compt_relay_en[1])begin//port1握手成功，后针对OCS0下一时隙直连节点开始分配relay
//         if(r_rx_offer[1][r_my_next_slot[0][0]] < w_capacity_remain[1][0])
//             if(r_rx_offer[1][r_my_next_slot[0][0]] < r_my_avail[r_my_next_slot[0][0]])
//                 r_tx_relay[1][r_my_next_slot[0][0]] = r_rx_offer[1][r_my_next_slot[0][0]];
//             else
//                 r_tx_relay[1][r_my_next_slot[0][0]] = r_my_avail[r_my_next_slot[0][0]];
//         else
//             if(w_capacity_remain[1][0] < r_my_avail[r_my_next_slot[0][0]])
//                 r_tx_relay[1][r_my_next_slot[0][0]] = w_capacity_remain[1][0];
//             else
//                 r_tx_relay[1][r_my_next_slot[0][0]] = r_my_avail[r_my_next_slot[0][0]];
//     end
//     else begin
//         r_tx_relay[1][r_my_next_slot[0][0]] = 'd0;
//     end  
// end

always @(*)begin
    if(r_compt_relay_en[1])begin

        //port1握手成功，先针对OCS1下一时隙直连节点开始分配relay
        if(r_rx_offer[1][r_my_next_slot[1][0]] < w_capacity_remain[1][1])
            if(r_rx_offer[1][r_my_next_slot[1][0]] < r_my_avail[r_my_next_slot[1][0]])
                r_tx_relay[1][r_my_next_slot[1][0]] = r_rx_offer[1][r_my_next_slot[1][0]];
            else
                r_tx_relay[1][r_my_next_slot[1][0]] = r_my_avail[r_my_next_slot[1][0]];
        else
            if(w_capacity_remain[1][1] < r_my_avail[r_my_next_slot[1][0]])
                r_tx_relay[1][r_my_next_slot[1][0]] = w_capacity_remain[1][1];
            else
                r_tx_relay[1][r_my_next_slot[1][0]] = r_my_avail[r_my_next_slot[1][0]];

        //port1握手成功，后针对OCS0下一时隙直连节点开始分配relay
        if(r_rx_offer[1][r_my_next_slot[0][0]] < w_capacity_remain[1][0])
            if(r_rx_offer[1][r_my_next_slot[0][0]] < r_my_avail[r_my_next_slot[0][0]])
                r_tx_relay[1][r_my_next_slot[0][0]] = r_rx_offer[1][r_my_next_slot[0][0]];
            else
                r_tx_relay[1][r_my_next_slot[0][0]] = r_my_avail[r_my_next_slot[0][0]];
        else
            if(w_capacity_remain[1][0] < r_my_avail[r_my_next_slot[0][0]])
                r_tx_relay[1][r_my_next_slot[0][0]] = w_capacity_remain[1][0];
            else
                r_tx_relay[1][r_my_next_slot[0][0]] = r_my_avail[r_my_next_slot[0][0]];

    end
    else begin
        r_tx_relay[1][r_my_next_slot[1][0]] = 'd0;
        r_tx_relay[1][r_my_next_slot[0][0]] = 'd0;
    end   
end


// genvar ocs_i;
// generate
//     for(ocs_i = 0; ocs_i < P_OCS_NUM; ocs_i = ocs_i + 1)begin

//         always @(*)begin
//             if(i_rst)begin
//                 r_tx_relay[0][0] = 'd0;
//                 r_tx_relay[0][1] = 'd0;
//                 r_tx_relay[0][2] = 'd0;
//                 r_tx_relay[0][3] = 'd0;
//                 r_tx_relay[0][4] = 'd0;
//                 r_tx_relay[0][5] = 'd0;
//                 r_tx_relay[0][6] = 'd0;
//                 r_tx_relay[0][7] = 'd0;
//             end
//             else if(r_compt_relay_en[0])begin//port0握手成功，开始分配relay
//                 if(r_rx_offer[0][r_my_next_slot[ocs_i][0]] < w_capacity_remain[0][ocs_i])
//                     if(r_rx_offer[0][r_my_next_slot[ocs_i][0]] < r_my_avail[r_my_next_slot[ocs_i][0]])
//                         r_tx_relay[0][r_my_next_slot[ocs_i][0]] = r_rx_offer[0][r_my_next_slot[ocs_i][0]];
//                     else
//                         r_tx_relay[0][r_my_next_slot[ocs_i][0]] = r_my_avail[r_my_next_slot[ocs_i][0]];
//                 else
//                     if(w_capacity_remain[0][ocs_i] < r_my_avail[r_my_next_slot[ocs_i][0]])
//                         r_tx_relay[0][r_my_next_slot[ocs_i][0]] = w_capacity_remain[0][ocs_i];
//                     else
//                         r_tx_relay[0][r_my_next_slot[ocs_i][0]] = r_my_avail[r_my_next_slot[ocs_i][0]];
//             end
//             else begin
//                 r_tx_relay[0][0] = r_tx_relay_reg[0][0];
//                 r_tx_relay[0][1] = r_tx_relay_reg[0][1];
//                 r_tx_relay[0][2] = r_tx_relay_reg[0][2];
//                 r_tx_relay[0][3] = r_tx_relay_reg[0][3];
//                 r_tx_relay[0][4] = r_tx_relay_reg[0][4];
//                 r_tx_relay[0][5] = r_tx_relay_reg[0][5];
//                 r_tx_relay[0][6] = r_tx_relay_reg[0][6];
//                 r_tx_relay[0][7] = r_tx_relay_reg[0][7];
//             end
                
//         end
        
//         always @(*)begin
//             if(i_rst)begin
//                 r_tx_relay[1][0] = 'd0;
//                 r_tx_relay[1][1] = 'd0;
//                 r_tx_relay[1][2] = 'd0;
//                 r_tx_relay[1][3] = 'd0;
//                 r_tx_relay[1][4] = 'd0;
//                 r_tx_relay[1][5] = 'd0;
//                 r_tx_relay[1][6] = 'd0;
//                 r_tx_relay[1][7] = 'd0;
//             end
//             else if(r_compt_relay_en[1])begin//port1握手成功，开始分配relay
//                 if(r_rx_offer[1][r_my_next_slot[ocs_i][0]] < w_capacity_remain[1][ocs_i])
//                     if(r_rx_offer[1][r_my_next_slot[ocs_i][0]] < r_my_avail[r_my_next_slot[ocs_i][0]])
//                         r_tx_relay[1][r_my_next_slot[ocs_i][0]] = r_rx_offer[1][r_my_next_slot[ocs_i][0]];
//                     else
//                         r_tx_relay[1][r_my_next_slot[ocs_i][0]] = r_my_avail[r_my_next_slot[ocs_i][0]];
//                 else
//                     if(w_capacity_remain[1][ocs_i] < r_my_avail[r_my_next_slot[ocs_i][0]])
//                         r_tx_relay[1][r_my_next_slot[ocs_i][0]] = w_capacity_remain[1][ocs_i];
//                     else
//                         r_tx_relay[1][r_my_next_slot[ocs_i][0]] = r_my_avail[r_my_next_slot[ocs_i][0]];
//             end
//             else begin
//                 r_tx_relay[1][0] = r_tx_relay_reg[1][0];
//                 r_tx_relay[1][1] = r_tx_relay_reg[1][1];
//                 r_tx_relay[1][2] = r_tx_relay_reg[1][2];
//                 r_tx_relay[1][3] = r_tx_relay_reg[1][3];
//                 r_tx_relay[1][4] = r_tx_relay_reg[1][4];
//                 r_tx_relay[1][5] = r_tx_relay_reg[1][5];
//                 r_tx_relay[1][6] = r_tx_relay_reg[1][6];
//                 r_tx_relay[1][7] = r_tx_relay_reg[1][7];
//         end
//         end


//     end

// endgenerate        



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
    else if(r_compt_relay_en[0])
        r_rx_offer_valid <= {r_rx_offer_valid[1],~r_rx_offer_valid[0]};
    else if(r_compt_relay_en[1])
        r_rx_offer_valid <= {~r_rx_offer_valid[1],r_rx_offer_valid[0]};
    else if(w_port0_rx_offer_valid && w_port1_rx_offer_valid)
        r_rx_offer_valid <= 2'b11;
    else if(w_port0_rx_offer_valid && !w_port1_rx_offer_valid)
        r_rx_offer_valid <= 2'b01;
    else if(!w_port0_rx_offer_valid && w_port1_rx_offer_valid)
        r_rx_offer_valid <= 2'b10;
    else
        r_rx_offer_valid <= r_rx_offer_valid;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_compt_relay_ready <= 'd1;
    else if(|r_tx_relay_valid)
        r_compt_relay_ready <= 'd1;
    else if(r_compt_relay_ready && |r_rx_offer_valid)
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

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_tx_relay_valid <= 2'b00;
    else
        r_tx_relay_valid <= r_compt_relay_en;
end


//控制器接口

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        r_slot_start  <= 'd0;
        r_cur_slot_id <= 'd0;
    end
    else if(i_slot_start)begin
        r_slot_start  <= i_slot_start;
        r_cur_slot_id <= i_cur_slot_id; 
    end
    else begin
        r_slot_start  <= 'd0 ;
        r_cur_slot_id <= r_cur_slot_id;
    end
end

endmodule
