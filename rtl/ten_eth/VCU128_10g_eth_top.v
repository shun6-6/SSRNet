`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/19 11:04:53
// Design Name: 
// Module Name: VCU128_10g_eth_top
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


module VCU128_10g_eth_top#(
    parameter                   P_CHANNEL_NUM   = 4         ,
    parameter                   P_MIN_LENGTH    = 8'd64     ,
    parameter                   P_MAX_LENGTH    = 15'd9600 
)(
    input                       i_gt_refclk_p       ,
    input                       i_gt_refclk_n       ,
    input                       i_sys_clk_p         ,
    input                       i_sys_clk_n         ,
    output [P_CHANNEL_NUM-1:0]  o_gt_txp            ,
    output [P_CHANNEL_NUM-1:0]  o_gt_txn            ,
    input  [P_CHANNEL_NUM-1:0]  i_gt_rxp            ,
    input  [P_CHANNEL_NUM-1:0]  i_gt_rxn            ,
    output [P_CHANNEL_NUM-1:0]  o_sfp_dis           ,
    output                      o_dclk              ,
    output                      o_sys_reset         ,
    output                      o_0_tx_clk_out      ,
    output                      o_0_rx_clk_out      ,
    output                      o_0_user_tx_reset   ,
    output                      o_0_user_rx_reset   ,
    output                      o_0_stat_rx_status  ,
    output                      tx0_axis_tready     ,
    input                       tx0_axis_tvalid     ,
    input  [63 :0]              tx0_axis_tdata      ,
    input                       tx0_axis_tlast      ,
    input  [7  :0]              tx0_axis_tkeep      ,
    input                       tx0_axis_tuser      ,
    output                      m_rx0_axis_tvalid   ,
    output [63 :0]              m_rx0_axis_tdata    ,
    output                      m_rx0_axis_tlast    ,
    output [7  :0]              m_rx0_axis_tkeep    ,
    output                      m_rx0_axis_tuser    ,
    output [2 : 0]              m_rx0_axis_tdest    , 

    output                      o_1_tx_clk_out      ,
    output                      o_1_rx_clk_out      ,
    output                      o_1_user_tx_reset   ,
    output                      o_1_user_rx_reset   ,
    output                      o_1_stat_rx_status  ,
    output                      tx1_axis_tready     ,
    input                       tx1_axis_tvalid     ,
    input  [63 :0]              tx1_axis_tdata      ,
    input                       tx1_axis_tlast      ,
    input  [7  :0]              tx1_axis_tkeep      ,
    input                       tx1_axis_tuser      ,
    output                      m_rx1_axis_tvalid   ,
    output [63 :0]              m_rx1_axis_tdata    ,
    output                      m_rx1_axis_tlast    ,
    output [7  :0]              m_rx1_axis_tkeep    ,
    output                      m_rx1_axis_tuser    ,
    output [2 : 0]              m_rx1_axis_tdest    , 
  

    output                      o_2_tx_clk_out      ,
    output                      o_2_rx_clk_out      ,
    output                      o_2_user_tx_reset   ,
    output                      o_2_user_rx_reset   ,
    output                      o_2_stat_rx_status  ,
    output                      tx2_axis_tready     ,
    input                       tx2_axis_tvalid     ,
    input  [63 :0]              tx2_axis_tdata      ,
    input                       tx2_axis_tlast      ,
    input  [7  :0]              tx2_axis_tkeep      ,
    input                       tx2_axis_tuser      ,
    output                      m_rx2_axis_tvalid   ,
    output [63 :0]              m_rx2_axis_tdata    ,
    output                      m_rx2_axis_tlast    ,
    output [7  :0]              m_rx2_axis_tkeep    ,
    output                      m_rx2_axis_tuser    ,
    output [2 : 0]              m_rx2_axis_tdest    , 

    output                      o_3_tx_clk_out      ,
    output                      o_3_rx_clk_out      ,
    output                      o_3_user_tx_reset   ,
    output                      o_3_user_rx_reset   ,
    output                      o_3_stat_rx_status  ,
    output                      tx3_axis_tready     ,
    input                       tx3_axis_tvalid     ,
    input  [63 :0]              tx3_axis_tdata      ,
    input                       tx3_axis_tlast      ,
    input  [7  :0]              tx3_axis_tkeep      ,
    input                       tx3_axis_tuser      ,
    output                      m_rx3_axis_tvalid   ,
    output [63 :0]              m_rx3_axis_tdata    ,
    output                      m_rx3_axis_tlast    ,
    output [7  :0]              m_rx3_axis_tkeep    ,
    output                      m_rx3_axis_tuser    ,
    output [2 : 0]              m_rx3_axis_tdest    ,

    input  [2 : 0]              i_port0_connect_tor ,
    input  [2 : 0]              i_port1_connect_tor 
);

assign o_sfp_dis = 2'b00;

//wire            w_dclk              ;
wire            w_locked            ;
//wire            w_sys_reset         ;


wire                    rx0_axis_tvalid     ;
wire [63 :0]            rx0_axis_tdata      ;
wire                    rx0_axis_tlast      ;
wire [7  :0]            rx0_axis_tkeep      ;
wire                    rx0_axis_tuser      ; 
wire                    rx1_axis_tvalid     ;
wire [63 :0]            rx1_axis_tdata      ;
wire                    rx1_axis_tlast      ;
wire [7  :0]            rx1_axis_tkeep      ;
wire                    rx1_axis_tuser      ; 
wire                    rx2_axis_tvalid     ;
wire [63 :0]            rx2_axis_tdata      ;
wire                    rx2_axis_tlast      ;
wire [7  :0]            rx2_axis_tkeep      ;
wire                    rx2_axis_tuser      ; 
wire                    rx3_axis_tvalid     ;
wire [63 :0]            rx3_axis_tdata      ;
wire                    rx3_axis_tlast      ;
wire [7  :0]            rx3_axis_tkeep      ;
wire                    rx3_axis_tuser      ; 

wire [47:0]             w0_check_mac        ;
wire [3 :0]             w0_check_req_id     ;
wire                    w0_check_valid      ;
wire [3 :0]             w0_outport          ;
wire                    w0_result_valid     ;
wire [3 :0]             w0_check_resp_id    ;
wire                    w0_seek_flag        ;

wire                    server0_axis_tx_tvalid  ;
wire [63 :0]            server0_axis_tx_tdata   ;
wire                    server0_axis_tx_tlast   ;
wire [7  :0]            server0_axis_tx_tkeep   ;
wire                    server0_axis_tx_tuser   ;

clk_wiz_100Mhz clk_wiz_100Mhz_u0
(
    .clk_out1               (o_dclk         ),  
    .locked                 (w_locked       ),  
    .clk_in1_p              (i_sys_clk_p    ),  
    .clk_in1_n              (i_sys_clk_n    )   
);

rst_gen_module#(
    .P_RST_CYCLE            (20)   
)rst_gen_module_u0(
    .i_clk                  (w_dclk         ),
    .i_rst                  (~w_locked      ),
    .o_rst                  (o_sys_reset    ) 
);


ten_eth_rx#(
    .P_RX_PORT_ID           (0                     ),
    .P_MAC_HEAD             (32'h8D_BC_5C_4A       ),
    .P_MY_TOR_MAC           (48'h8D_BC_5C_4A_00_00 ),
    .P_MY_PORT_MAC          (48'h8D_BC_5C_4A_00_01 ),
    .P_UPLINK_TRUE           (0)
)ten_eth_rx_downlink_port0(
    .i_clk                  (o_0_tx_clk_out         ),
    .i_rst                  (o_0_user_rx_reset      ),
    .i_stat_rx_status       (o_0_stat_rx_status     ),
 
    .s_axis_rx_tvalid       (server0_axis_tx_tvalid ),
    .s_axis_rx_tdata        (server0_axis_tx_tdata  ),
    .s_axis_rx_tlast        (server0_axis_tx_tlast  ),
    .s_axis_rx_tkeep        (server0_axis_tx_tkeep  ),
    .s_axis_rx_tuser        (server0_axis_tx_tuser  ),
   
    .o_check_mac            (w0_check_mac           ),
    .o_check_id             (w0_check_req_id        ),
    .o_check_valid          (w0_check_valid         ),
    .i_outport              (w0_outport             ),
    .i_result_valid         (w0_result_valid        ),
    .i_check_id             (w0_check_resp_id       ),
    .i_seek_flag            (w0_seek_flag           ),
    .i_cur_connect_tor      ('d0      ),

    .m_axis_tvalid          (m_rx0_axis_tvalid      ),
    .m_axis_tdata           (m_rx0_axis_tdata       ),
    .m_axis_tlast           (m_rx0_axis_tlast       ),
    .m_axis_tkeep           (m_rx0_axis_tkeep       ),
    .m_axis_tuser           (m_rx0_axis_tuser       ),
    .m_axis_tdest           (m_rx0_axis_tdest       )
);

ten_eth_rx#(
    .P_RX_PORT_ID           (0                     ),
    .P_MAC_HEAD             (32'h8D_BC_5C_4A       ),
    .P_MY_TOR_MAC           (48'h8D_BC_5C_4A_00_00 ),
    .P_MY_PORT_MAC          (48'h8D_BC_5C_4A_00_01 ),
    .P_UPLINK_TRUE           (0)
)ten_eth_rx_downlink_port1(
    .i_clk                  (o_1_tx_clk_out         ),
    .i_rst                  (o_1_user_rx_reset      ),
    .i_stat_rx_status       (o_1_stat_rx_status     ),
 
    .s_axis_rx_tvalid       (server1_axis_tx_tvalid ),
    .s_axis_rx_tdata        (server1_axis_tx_tdata  ),
    .s_axis_rx_tlast        (server1_axis_tx_tlast  ),
    .s_axis_rx_tkeep        (server1_axis_tx_tkeep  ),
    .s_axis_rx_tuser        (server1_axis_tx_tuser  ),
   
    .o_check_mac            (w1_check_mac           ),
    .o_check_id             (w1_check_req_id        ),
    .o_check_valid          (w1_check_valid         ),
    .i_outport              (w1_outport             ),
    .i_result_valid         (w1_result_valid        ),
    .i_check_id             (w1_check_resp_id       ),
    .i_seek_flag            (w1_seek_flag           ),
    .i_cur_connect_tor      ('d0      ),

    .m_axis_tvalid          (m_rx1_axis_tvalid      ),
    .m_axis_tdata           (m_rx1_axis_tdata       ),
    .m_axis_tlast           (m_rx1_axis_tlast       ),
    .m_axis_tkeep           (m_rx1_axis_tkeep       ),
    .m_axis_tuser           (m_rx1_axis_tuser       ),
    .m_axis_tdest           (m_rx1_axis_tdest       )
);

ten_eth_rx#(
    .P_RX_PORT_ID           (0                     ),
    .P_MAC_HEAD             (32'h8D_BC_5C_4A       ),
    .P_MY_TOR_MAC           (48'h8D_BC_5C_4A_00_00 ),
    .P_MY_PORT_MAC          (48'h8D_BC_5C_4A_00_01 ),
    .P_UPLINK_TRUE           (1)
)ten_eth_rx_up_port0(
    .i_clk                  (o_1_tx_clk_out         ),
    .i_rst                  (o_1_user_rx_reset      ),
    .i_stat_rx_status       (o_1_stat_rx_status     ),
 
    .s_axis_rx_tvalid       (rx2_axis_tvalid        ),
    .s_axis_rx_tdata        (rx2_axis_tdata         ),
    .s_axis_rx_tlast        (rx2_axis_tlast         ),
    .s_axis_rx_tkeep        (rx2_axis_tkeep         ),
    .s_axis_rx_tuser        (rx2_axis_tuser         ),
   
    .o_check_mac            (w1_check_mac           ),
    .o_check_id             (w1_check_req_id        ),
    .o_check_valid          (w1_check_valid         ),
    .i_outport              (w1_outport             ),
    .i_result_valid         (w1_result_valid        ),
    .i_check_id             (w1_check_resp_id       ),
    .i_seek_flag            (w1_seek_flag           ),
    .i_cur_connect_tor      (i_port0_connect_tor    ),

    .m_axis_tvalid          (m_rx1_axis_tvalid      ),
    .m_axis_tdata           (m_rx1_axis_tdata       ),
    .m_axis_tlast           (m_rx1_axis_tlast       ),
    .m_axis_tkeep           (m_rx1_axis_tkeep       ),
    .m_axis_tuser           (m_rx1_axis_tuser       ),
    .m_axis_tdest           (m_rx1_axis_tdest       )
);

ten_eth_rx#(
    .P_RX_PORT_ID           (0                     ),
    .P_MAC_HEAD             (32'h8D_BC_5C_4A       ),
    .P_MY_TOR_MAC           (48'h8D_BC_5C_4A_00_00 ),
    .P_MY_PORT_MAC          (48'h8D_BC_5C_4A_00_01 ),
    .P_UPLINK_TRUE           (1)
)ten_eth_rx_uplink_port1(
    .i_clk                  (o_1_tx_clk_out         ),
    .i_rst                  (o_1_user_rx_reset      ),
    .i_stat_rx_status       (o_1_stat_rx_status     ),
 
    .s_axis_rx_tvalid       (rx3_axis_tvalid        ),
    .s_axis_rx_tdata        (rx3_axis_tdata         ),
    .s_axis_rx_tlast        (rx3_axis_tlast         ),
    .s_axis_rx_tkeep        (rx3_axis_tkeep         ),
    .s_axis_rx_tuser        (rx3_axis_tuser         ),
   
    .o_check_mac            (w1_check_mac           ),
    .o_check_id             (w1_check_req_id        ),
    .o_check_valid          (w1_check_valid         ),
    .i_outport              (w1_outport             ),
    .i_result_valid         (w1_result_valid        ),
    .i_check_id             (w1_check_resp_id       ),
    .i_seek_flag            (w1_seek_flag           ),
    .i_cur_connect_tor      (i_port1_connect_tor    ),

    .m_axis_tvalid          (m_rx1_axis_tvalid      ),
    .m_axis_tdata           (m_rx1_axis_tdata       ),
    .m_axis_tlast           (m_rx1_axis_tlast       ),
    .m_axis_tkeep           (m_rx1_axis_tkeep       ),
    .m_axis_tuser           (m_rx1_axis_tuser       ),
    .m_axis_tdest           (m_rx1_axis_tdest       )
);

uplus_ten_gig_module#(
    .P_CHANNEL_NUM          (P_CHANNEL_NUM      ),
    .P_MIN_LENGTH           (P_MIN_LENGTH       ),
    .P_MAX_LENGTH           (P_MAX_LENGTH       )
)uplus_ten_gig_module_u0(
    .i_gt_refclk_p          (i_gt_refclk_p      ),
    .i_gt_refclk_n          (i_gt_refclk_n      ),
    .i_dclk                 (o_dclk             ),
    .i_sys_reset            (o_sys_reset        ),

    .o_gt_txp               (o_gt_txp[P_CHANNEL_NUM-1:0]),
    .o_gt_txn               (o_gt_txn[P_CHANNEL_NUM-1:0]),
    .i_gt_rxp               (i_gt_rxp[P_CHANNEL_NUM-1:0]),
    .i_gt_rxn               (i_gt_rxn[P_CHANNEL_NUM-1:0]),

    .o_0_tx_clk_out         (o_0_tx_clk_out     ),
    .o_0_rx_clk_out         (o_0_rx_clk_out     ),
    .o_0_user_tx_reset      (o_0_user_tx_reset  ),
    .o_0_user_rx_reset      (o_0_user_rx_reset  ),
    .o_0_stat_rx_status     (o_0_stat_rx_status ),
    .tx0_axis_tready        (tx0_axis_tready    ),
    .tx0_axis_tvalid        (tx0_axis_tvalid    ),
    .tx0_axis_tdata         (tx0_axis_tdata     ),
    .tx0_axis_tlast         (tx0_axis_tlast     ),
    .tx0_axis_tkeep         (tx0_axis_tkeep     ),
    .tx0_axis_tuser         (tx0_axis_tuser     ),
    .rx0_axis_tvalid        (rx0_axis_tvalid    ),
    .rx0_axis_tdata         (rx0_axis_tdata     ),
    .rx0_axis_tlast         (rx0_axis_tlast     ),
    .rx0_axis_tkeep         (rx0_axis_tkeep     ),
    .rx0_axis_tuser         (rx0_axis_tuser     ),

    .o_1_tx_clk_out         (o_1_tx_clk_out     ),
    .o_1_rx_clk_out         (o_1_rx_clk_out     ),
    .o_1_user_tx_reset      (o_1_user_tx_reset  ),
    .o_1_user_rx_reset      (o_1_user_rx_reset  ),
    .o_1_stat_rx_status     (o_1_stat_rx_status ),
    .tx1_axis_tready        (tx1_axis_tready    ),
    .tx1_axis_tvalid        (tx1_axis_tvalid    ),
    .tx1_axis_tdata         (tx1_axis_tdata     ),
    .tx1_axis_tlast         (tx1_axis_tlast     ),
    .tx1_axis_tkeep         (tx1_axis_tkeep     ),
    .tx1_axis_tuser         (tx1_axis_tuser     ),
    .rx1_axis_tvalid        (rx1_axis_tvalid    ),
    .rx1_axis_tdata         (rx1_axis_tdata     ),
    .rx1_axis_tlast         (rx1_axis_tlast     ),
    .rx1_axis_tkeep         (rx1_axis_tkeep     ),
    .rx1_axis_tuser         (rx1_axis_tuser     ),

    .o_2_tx_clk_out         (o_2_tx_clk_out     ),
    .o_2_rx_clk_out         (o_2_rx_clk_out     ),
    .o_2_user_tx_reset      (o_2_user_tx_reset  ),
    .o_2_user_rx_reset      (o_2_user_rx_reset  ),
    .o_2_stat_rx_status     (o_2_stat_rx_status ),
    .tx2_axis_tready        (tx2_axis_tready    ),
    .tx2_axis_tvalid        (tx2_axis_tvalid    ),
    .tx2_axis_tdata         (tx2_axis_tdata     ),
    .tx2_axis_tlast         (tx2_axis_tlast     ),
    .tx2_axis_tkeep         (tx2_axis_tkeep     ),
    .tx2_axis_tuser         (tx2_axis_tuser     ),
    .rx2_axis_tvalid        (rx2_axis_tvalid    ),
    .rx2_axis_tdata         (rx2_axis_tdata     ),
    .rx2_axis_tlast         (rx2_axis_tlast     ),
    .rx2_axis_tkeep         (rx2_axis_tkeep     ),
    .rx2_axis_tuser         (rx2_axis_tuser     ),

    .o_3_tx_clk_out         (o_3_tx_clk_out     ),
    .o_3_rx_clk_out         (o_3_rx_clk_out     ),
    .o_3_user_tx_reset      (o_3_user_tx_reset  ),
    .o_3_user_rx_reset      (o_3_user_rx_reset  ),
    .o_3_stat_rx_status     (o_3_stat_rx_status ),
    .tx3_axis_tready        (tx3_axis_tready    ),
    .tx3_axis_tvalid        (tx3_axis_tvalid    ),
    .tx3_axis_tdata         (tx3_axis_tdata     ),
    .tx3_axis_tlast         (tx3_axis_tlast     ),
    .tx3_axis_tkeep         (tx3_axis_tkeep     ),
    .tx3_axis_tuser         (tx3_axis_tuser     ),
    .rx3_axis_tvalid        (rx3_axis_tvalid    ),
    .rx3_axis_tdata         (rx3_axis_tdata     ),
    .rx3_axis_tlast         (rx3_axis_tlast     ),
    .rx3_axis_tkeep         (rx3_axis_tkeep     ),
    .rx3_axis_tuser         (rx3_axis_tuser     )
);
endmodule
