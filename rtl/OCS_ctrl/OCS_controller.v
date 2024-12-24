`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/19 20:27:06
// Design Name: 
// Module Name: OCS_controller
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
/*控制器有8个channel，连接8个ToR，当对应连接的所有的ToR的链路
状态稳定后，第一个时隙开始，下发一个仿真开始指令给所有ToR，
所有ToR下行连接的server开始产生数据，等待一个完整的时隙后，开始切换
ocs状态，等待切换时延结束后，下发一次时间同步，标志一次全新的时隙开始
时隙一次最多传输16KByte数据，所需时间2048 x 6.4 = 13us
仿真暂定配置时延1.5微妙（234 clk），时隙持续15（2343 clk）微妙，具体修改需要控制VLB模块的
P_SLOT_MAX_BYTE_NUM参数
*/

module OCS_controller#(
    parameter                   P_CHANNEL_NUM   = 8             ,
    parameter                   P_MIN_LENGTH    = 8'd64         ,
    parameter                   P_MAX_LENGTH    = 15'd9600      ,
    parameter                   P_CONFIG_DELAY  = 32'h0000_00EA ,
    parameter                   P_SLOT_LEN      = 32'h0000_0927  
)(
    input                       i_gt_0_refclk_p     ,
    input                       i_gt_0_refclk_n     ,
    input                       i_gt_1_refclk_p     ,
    input                       i_gt_1_refclk_n     ,
    input                       i_sys_clk_p         ,
    input                       i_sys_clk_n         ,
    output [P_CHANNEL_NUM-1:0]  o_gt_txp            ,
    output [P_CHANNEL_NUM-1:0]  o_gt_txn            ,
    input  [P_CHANNEL_NUM-1:0]  i_gt_rxp            ,
    input  [P_CHANNEL_NUM-1:0]  i_gt_rxn            ,
    output [P_CHANNEL_NUM-1:0]  o_sfp_dis           ,
    output                      o_slot_id           
);

assign o_sfp_dis = 8'b0000_0000;

wire            w_dclk              ;
wire            w_locked            ;
wire            w_sys_reset         ;

wire            o_0_tx_clk_out      ;
wire            o_0_rx_clk_out      ;
wire            o_0_user_tx_reset   ;
wire            o_0_user_rx_reset   ;
wire            o_0_stat_rx_status  ;
wire            tx0_axis_tready     ;
wire            tx0_axis_tvalid     ;
wire [63 :0]    tx0_axis_tdata      ;
wire            tx0_axis_tlast      ;
wire [7  :0]    tx0_axis_tkeep      ;
wire            tx0_axis_tuser      ;
wire            rx0_axis_tvalid     ;
wire [63 :0]    rx0_axis_tdata      ;
wire            rx0_axis_tlast      ;
wire [7  :0]    rx0_axis_tkeep      ;
wire            rx0_axis_tuser      ;

wire            o_1_tx_clk_out      ;
wire            o_1_rx_clk_out      ;
wire            o_1_user_tx_reset   ;
wire            o_1_user_rx_reset   ;
wire            o_1_stat_rx_status  ;
wire            tx1_axis_tready     ;
wire            tx1_axis_tvalid     ;
wire [63 :0]    tx1_axis_tdata      ;
wire            tx1_axis_tlast      ;
wire [7  :0]    tx1_axis_tkeep      ;
wire            tx1_axis_tuser      ;
wire            rx1_axis_tvalid     ;
wire [63 :0]    rx1_axis_tdata      ;
wire            rx1_axis_tlast      ;
wire [7  :0]    rx1_axis_tkeep      ;
wire            rx1_axis_tuser      ;

wire            o_2_tx_clk_out      ;
wire            o_2_rx_clk_out      ;
wire            o_2_user_tx_reset   ;
wire            o_2_user_rx_reset   ;
wire            o_2_stat_rx_status  ;
wire            tx2_axis_tready     ;
wire            tx2_axis_tvalid     ;
wire [63 :0]    tx2_axis_tdata      ;
wire            tx2_axis_tlast      ;
wire [7  :0]    tx2_axis_tkeep      ;
wire            tx2_axis_tuser      ;
wire            rx2_axis_tvalid     ;
wire [63 :0]    rx2_axis_tdata      ;
wire            rx2_axis_tlast      ;
wire [7  :0]    rx2_axis_tkeep      ;
wire            rx2_axis_tuser      ;

wire            o_3_tx_clk_out      ;
wire            o_3_rx_clk_out      ;
wire            o_3_user_tx_reset   ;
wire            o_3_user_rx_reset   ;
wire            o_3_stat_rx_status  ;
wire            tx3_axis_tready     ;
wire            tx3_axis_tvalid     ;
wire [63 :0]    tx3_axis_tdata      ;
wire            tx3_axis_tlast      ;
wire [7  :0]    tx3_axis_tkeep      ;
wire            tx3_axis_tuser      ;
wire            rx3_axis_tvalid     ;
wire [63 :0]    rx3_axis_tdata      ;
wire            rx3_axis_tlast      ;
wire [7  :0]    rx3_axis_tkeep      ;
wire            rx3_axis_tuser      ;

wire            o_4_tx_clk_out      ;
wire            o_4_rx_clk_out      ;
wire            o_4_user_tx_reset   ;
wire            o_4_user_rx_reset   ;
wire            o_4_stat_rx_status  ;
wire            tx4_axis_tready     ;
wire            tx4_axis_tvalid     ;
wire [63 :0]    tx4_axis_tdata      ;
wire            tx4_axis_tlast      ;
wire [7  :0]    tx4_axis_tkeep      ;
wire            tx4_axis_tuser      ;
wire            rx4_axis_tvalid     ;
wire [63 :0]    rx4_axis_tdata      ;
wire            rx4_axis_tlast      ;
wire [7  :0]    rx4_axis_tkeep      ;
wire            rx4_axis_tuser      ;

wire            o_5_tx_clk_out      ;
wire            o_5_rx_clk_out      ;
wire            o_5_user_tx_reset   ;
wire            o_5_user_rx_reset   ;
wire            o_5_stat_rx_status  ;
wire            tx5_axis_tready     ;
wire            tx5_axis_tvalid     ;
wire [63 :0]    tx5_axis_tdata      ;
wire            tx5_axis_tlast      ;
wire [7  :0]    tx5_axis_tkeep      ;
wire            tx5_axis_tuser      ;
wire            rx5_axis_tvalid     ;
wire [63 :0]    rx5_axis_tdata      ;
wire            rx5_axis_tlast      ;
wire [7  :0]    rx5_axis_tkeep      ;
wire            rx5_axis_tuser      ;

wire            o_6_tx_clk_out      ;
wire            o_6_rx_clk_out      ;
wire            o_6_user_tx_reset   ;
wire            o_6_user_rx_reset   ;
wire            o_6_stat_rx_status  ;
wire            tx6_axis_tready     ;
wire            tx6_axis_tvalid     ;
wire [63 :0]    tx6_axis_tdata      ;
wire            tx6_axis_tlast      ;
wire [7  :0]    tx6_axis_tkeep      ;
wire            tx6_axis_tuser      ;
wire            rx6_axis_tvalid     ;
wire [63 :0]    rx6_axis_tdata      ;
wire            rx6_axis_tlast      ;
wire [7  :0]    rx6_axis_tkeep      ;
wire            rx6_axis_tuser      ;

wire            o_7_tx_clk_out      ;
wire            o_7_rx_clk_out      ;
wire            o_7_user_tx_reset   ;
wire            o_7_user_rx_reset   ;
wire            o_7_stat_rx_status  ;
wire            tx7_axis_tready     ;
wire            tx7_axis_tvalid     ;
wire [63 :0]    tx7_axis_tdata      ;
wire            tx7_axis_tlast      ;
wire [7  :0]    tx7_axis_tkeep      ;
wire            tx7_axis_tuser      ;
wire            rx7_axis_tvalid     ;
wire [63 :0]    rx7_axis_tdata      ;
wire            rx7_axis_tlast      ;
wire [7  :0]    rx7_axis_tkeep      ;
wire            rx7_axis_tuser      ;

wire [7  :0]    w_chnl_ready        ;
wire            w_new_slot_start    ;
wire            w_slot_id           ;

assign w_chnl_ready = { o_7_stat_rx_status,o_6_stat_rx_status,
                        o_5_stat_rx_status,o_4_stat_rx_status,
                        o_3_stat_rx_status,o_2_stat_rx_status,
                        o_1_stat_rx_status,o_0_stat_rx_status};

assign o_slot_id = w_slot_id;


clk_wiz_100Mhz clk_wiz_100Mhz_u0
(
    .clk_out1               (w_dclk         ),  
    .locked                 (w_locked       ),  
    .clk_in1_p              (i_sys_clk_p    ),  
    .clk_in1_n              (i_sys_clk_n    )   
);

rst_gen_module#(
    .P_RST_CYCLE            (20)   
)rst_gen_module_u0(
    .i_clk                  (w_dclk         ),
    .i_rst                  (~w_locked      ),
    .o_rst                  (w_sys_reset    ) 
);


ocs_slot_ctrl#(
    .P_CONFIG_DELAY     (P_CONFIG_DELAY     ),
    .P_SLOT_LEN         (P_SLOT_LEN         ) 
)ocs_slot_ctrl_u0(
    .i_clk              (o_0_tx_clk_out     ),
    .i_rst              (o_0_user_tx_reset  ),

    .i_chnl_ready       (w_chnl_ready       ),
    .o_slot_id          (w_slot_id          ),
    .o_slot_start       (w_new_slot_start   ) 
);

ocs_ctrl_trx#(
    .P_MASTER_TIME_PORT (1                    ) ,
    .P_SLAVER_TIME_PORT (0                    ) ,
    .P_SLOT_ID_TYPE     (16'hff03             ) ,
    .P_MY_MAC           (48'h8D_BC_5C_4A_1A_1F) ,
    .P_DEST_TOR_MAC     (48'h8D_BC_5C_4A_00_00)
)ocs_ctrl_trx_port_0(
    .i_clk              (o_0_tx_clk_out     ),
    .i_rst              (o_0_user_tx_reset  ),

    .i_chnl_ready       (w_chnl_ready       ),
    .i_stat_rx_status   (o_0_stat_rx_status ),
    .i_select_std_port  ('d1),
    .i_new_slot_start   (w_new_slot_start   ),
    .i_slot_id          (w_slot_id          ),

    .i_rx_axis_tvalid   (rx0_axis_tvalid    ),
    .i_rx_axis_tdata    (rx0_axis_tdata     ),
    .i_rx_axis_tlast    (rx0_axis_tlast     ),
    .i_rx_axis_tkeep    (rx0_axis_tkeep     ),
    .i_rx_axis_tuser    (rx0_axis_tuser     ),
  
    .o_tx_axis_tvalid   (tx0_axis_tvalid    ),
    .o_tx_axis_tdata    (tx0_axis_tdata     ),
    .o_tx_axis_tlast    (tx0_axis_tlast     ),
    .o_tx_axis_tkeep    (tx0_axis_tkeep     ),
    .o_tx_axis_tuser    (tx0_axis_tuser     ),
    .i_tx_axis_tready   (tx0_axis_tready    ) 
);

ocs_ctrl_trx#(
    .P_MASTER_TIME_PORT (1                    ) ,
    .P_SLAVER_TIME_PORT (0                    ) ,
    .P_SLOT_ID_TYPE     (16'hff03             ) ,
    .P_MY_MAC           (48'h8D_BC_5C_4A_1A_1F) ,
    .P_DEST_TOR_MAC     (48'h8D_BC_5C_4A_01_00)
)ocs_ctrl_trx_port_1(
    .i_clk              (o_1_tx_clk_out     ),
    .i_rst              (o_1_user_tx_reset  ),

    .i_chnl_ready       (w_chnl_ready       ),
    .i_stat_rx_status   (o_1_stat_rx_status ),
    .i_select_std_port  ('d0),
    .i_new_slot_start   (w_new_slot_start   ),
    .i_slot_id          (w_slot_id          ),

    .i_rx_axis_tvalid   (rx1_axis_tvalid    ),
    .i_rx_axis_tdata    (rx1_axis_tdata     ),
    .i_rx_axis_tlast    (rx1_axis_tlast     ),
    .i_rx_axis_tkeep    (rx1_axis_tkeep     ),
    .i_rx_axis_tuser    (rx1_axis_tuser     ),
  
    .o_tx_axis_tvalid   (tx1_axis_tvalid    ),
    .o_tx_axis_tdata    (tx1_axis_tdata     ),
    .o_tx_axis_tlast    (tx1_axis_tlast     ),
    .o_tx_axis_tkeep    (tx1_axis_tkeep     ),
    .o_tx_axis_tuser    (tx1_axis_tuser     ),
    .i_tx_axis_tready   (tx1_axis_tready    ) 
);

ocs_ctrl_trx#(
    .P_MASTER_TIME_PORT (1                    ) ,
    .P_SLAVER_TIME_PORT (0                    ) ,
    .P_SLOT_ID_TYPE     (16'hff03             ) ,
    .P_MY_MAC           (48'h8D_BC_5C_4A_1A_1F) ,
    .P_DEST_TOR_MAC     (48'h8D_BC_5C_4A_02_00)
)ocs_ctrl_trx_port_2(
    .i_clk              (o_2_tx_clk_out     ),
    .i_rst              (o_2_user_tx_reset  ),

    .i_chnl_ready       (w_chnl_ready       ),
    .i_stat_rx_status   (o_2_stat_rx_status ),
    .i_select_std_port  ('d0),
    .i_new_slot_start   (w_new_slot_start   ),
    .i_slot_id          (w_slot_id          ),

    .i_rx_axis_tvalid   (rx2_axis_tvalid    ),
    .i_rx_axis_tdata    (rx2_axis_tdata     ),
    .i_rx_axis_tlast    (rx2_axis_tlast     ),
    .i_rx_axis_tkeep    (rx2_axis_tkeep     ),
    .i_rx_axis_tuser    (rx2_axis_tuser     ),
  
    .o_tx_axis_tvalid   (tx2_axis_tvalid    ),
    .o_tx_axis_tdata    (tx2_axis_tdata     ),
    .o_tx_axis_tlast    (tx2_axis_tlast     ),
    .o_tx_axis_tkeep    (tx2_axis_tkeep     ),
    .o_tx_axis_tuser    (tx2_axis_tuser     ),
    .i_tx_axis_tready   (tx2_axis_tready    ) 
);

ocs_ctrl_trx#(
    .P_MASTER_TIME_PORT (1                    ) ,
    .P_SLAVER_TIME_PORT (0                    ) ,
    .P_SLOT_ID_TYPE     (16'hff03             ) ,
    .P_MY_MAC           (48'h8D_BC_5C_4A_1A_1F) ,
    .P_DEST_TOR_MAC     (48'h8D_BC_5C_4A_03_00)
)ocs_ctrl_trx_port_3(
    .i_clk              (o_3_tx_clk_out     ),
    .i_rst              (o_3_user_tx_reset  ),

    .i_chnl_ready       (w_chnl_ready       ),
    .i_stat_rx_status   (o_3_stat_rx_status ),
    .i_select_std_port  ('d0),
    .i_new_slot_start   (w_new_slot_start   ),
    .i_slot_id          (w_slot_id          ),

    .i_rx_axis_tvalid   (rx3_axis_tvalid    ),
    .i_rx_axis_tdata    (rx3_axis_tdata     ),
    .i_rx_axis_tlast    (rx3_axis_tlast     ),
    .i_rx_axis_tkeep    (rx3_axis_tkeep     ),
    .i_rx_axis_tuser    (rx3_axis_tuser     ),
  
    .o_tx_axis_tvalid   (tx3_axis_tvalid    ),
    .o_tx_axis_tdata    (tx3_axis_tdata     ),
    .o_tx_axis_tlast    (tx3_axis_tlast     ),
    .o_tx_axis_tkeep    (tx3_axis_tkeep     ),
    .o_tx_axis_tuser    (tx3_axis_tuser     ),
    .i_tx_axis_tready   (tx3_axis_tready    ) 
);

ocs_ctrl_trx#(
    .P_MASTER_TIME_PORT (1                    ) ,
    .P_SLAVER_TIME_PORT (0                    ) ,
    .P_SLOT_ID_TYPE     (16'hff03             ) ,
    .P_MY_MAC           (48'h8D_BC_5C_4A_1A_1F) ,
    .P_DEST_TOR_MAC     (48'h8D_BC_5C_4A_04_00)
)ocs_ctrl_trx_port_4(
    .i_clk              (o_4_tx_clk_out     ),
    .i_rst              (o_4_user_tx_reset  ),

    .i_chnl_ready       (w_chnl_ready       ),
    .i_stat_rx_status   (o_4_stat_rx_status ),
    .i_select_std_port  ('d0),
    .i_new_slot_start   (w_new_slot_start   ),
    .i_slot_id          (w_slot_id          ),

    .i_rx_axis_tvalid   (rx4_axis_tvalid    ),
    .i_rx_axis_tdata    (rx4_axis_tdata     ),
    .i_rx_axis_tlast    (rx4_axis_tlast     ),
    .i_rx_axis_tkeep    (rx4_axis_tkeep     ),
    .i_rx_axis_tuser    (rx4_axis_tuser     ),
  
    .o_tx_axis_tvalid   (tx4_axis_tvalid    ),
    .o_tx_axis_tdata    (tx4_axis_tdata     ),
    .o_tx_axis_tlast    (tx4_axis_tlast     ),
    .o_tx_axis_tkeep    (tx4_axis_tkeep     ),
    .o_tx_axis_tuser    (tx4_axis_tuser     ),
    .i_tx_axis_tready   (tx4_axis_tready    ) 
);

ocs_ctrl_trx#(
    .P_MASTER_TIME_PORT (1                    ) ,
    .P_SLAVER_TIME_PORT (0                    ) ,
    .P_SLOT_ID_TYPE     (16'hff03             ) ,
    .P_MY_MAC           (48'h8D_BC_5C_4A_1A_1F) ,
    .P_DEST_TOR_MAC     (48'h8D_BC_5C_4A_05_00)
)ocs_ctrl_trx_port_5(
    .i_clk              (o_5_tx_clk_out     ),
    .i_rst              (o_5_user_tx_reset  ),

    .i_chnl_ready       (w_chnl_ready       ),
    .i_stat_rx_status   (o_5_stat_rx_status ),
    .i_select_std_port  ('d0),
    .i_new_slot_start   (w_new_slot_start   ),
    .i_slot_id          (w_slot_id          ),

    .i_rx_axis_tvalid   (rx5_axis_tvalid    ),
    .i_rx_axis_tdata    (rx5_axis_tdata     ),
    .i_rx_axis_tlast    (rx5_axis_tlast     ),
    .i_rx_axis_tkeep    (rx5_axis_tkeep     ),
    .i_rx_axis_tuser    (rx5_axis_tuser     ),
  
    .o_tx_axis_tvalid   (tx5_axis_tvalid    ),
    .o_tx_axis_tdata    (tx5_axis_tdata     ),
    .o_tx_axis_tlast    (tx5_axis_tlast     ),
    .o_tx_axis_tkeep    (tx5_axis_tkeep     ),
    .o_tx_axis_tuser    (tx5_axis_tuser     ),
    .i_tx_axis_tready   (tx5_axis_tready    ) 
);

ocs_ctrl_trx#(
    .P_MASTER_TIME_PORT (1                    ) ,
    .P_SLAVER_TIME_PORT (0                    ) ,
    .P_SLOT_ID_TYPE     (16'hff03             ) ,
    .P_MY_MAC           (48'h8D_BC_5C_4A_1A_1F) ,
    .P_DEST_TOR_MAC     (48'h8D_BC_5C_4A_06_00)
)ocs_ctrl_trx_port_6(
    .i_clk              (o_6_tx_clk_out     ),
    .i_rst              (o_6_user_tx_reset  ),

    .i_chnl_ready       (w_chnl_ready       ),
    .i_stat_rx_status   (o_6_stat_rx_status ),
    .i_select_std_port  ('d0),
    .i_new_slot_start   (w_new_slot_start   ),
    .i_slot_id          (w_slot_id          ),

    .i_rx_axis_tvalid   (rx6_axis_tvalid    ),
    .i_rx_axis_tdata    (rx6_axis_tdata     ),
    .i_rx_axis_tlast    (rx6_axis_tlast     ),
    .i_rx_axis_tkeep    (rx6_axis_tkeep     ),
    .i_rx_axis_tuser    (rx6_axis_tuser     ),
  
    .o_tx_axis_tvalid   (tx6_axis_tvalid    ),
    .o_tx_axis_tdata    (tx6_axis_tdata     ),
    .o_tx_axis_tlast    (tx6_axis_tlast     ),
    .o_tx_axis_tkeep    (tx6_axis_tkeep     ),
    .o_tx_axis_tuser    (tx6_axis_tuser     ),
    .i_tx_axis_tready   (tx6_axis_tready    ) 
);

ocs_ctrl_trx#(
    .P_MASTER_TIME_PORT (1                    ) ,
    .P_SLAVER_TIME_PORT (0                    ) ,
    .P_SLOT_ID_TYPE     (16'hff03             ) ,
    .P_MY_MAC           (48'h8D_BC_5C_4A_1A_1F) ,
    .P_DEST_TOR_MAC     (48'h8D_BC_5C_4A_07_00)
)ocs_ctrl_trx_port_7(
    .i_clk              (o_7_tx_clk_out     ),
    .i_rst              (o_7_user_tx_reset  ),

    .i_chnl_ready       (w_chnl_ready       ),
    .i_stat_rx_status   (o_7_stat_rx_status ),
    .i_select_std_port  ('d0),
    .i_new_slot_start   (w_new_slot_start   ),
    .i_slot_id          (w_slot_id          ),

    .i_rx_axis_tvalid   (rx7_axis_tvalid    ),
    .i_rx_axis_tdata    (rx7_axis_tdata     ),
    .i_rx_axis_tlast    (rx7_axis_tlast     ),
    .i_rx_axis_tkeep    (rx7_axis_tkeep     ),
    .i_rx_axis_tuser    (rx7_axis_tuser     ),
  
    .o_tx_axis_tvalid   (tx7_axis_tvalid    ),
    .o_tx_axis_tdata    (tx7_axis_tdata     ),
    .o_tx_axis_tlast    (tx7_axis_tlast     ),
    .o_tx_axis_tkeep    (tx7_axis_tkeep     ),
    .o_tx_axis_tuser    (tx7_axis_tuser     ),
    .i_tx_axis_tready   (tx7_axis_tready    ) 
);

ten_gig_ctrl_module#(
    .P_CHANNEL_NUM          (P_CHANNEL_NUM >> 1 ),
    .P_MIN_LENGTH           (P_MIN_LENGTH       ),
    .P_MAX_LENGTH           (P_MAX_LENGTH       )
)ten_gig_ctrl_module_u0(
    .i_gt_refclk_p          (i_gt_0_refclk_p    ),
    .i_gt_refclk_n          (i_gt_0_refclk_n    ),
    .i_dclk                 (w_dclk             ),
    .i_sys_reset            (w_sys_reset        ),

    .o_gt_txp               (o_gt_txp[3:0]),
    .o_gt_txn               (o_gt_txn[3:0]),
    .i_gt_rxp               (i_gt_rxp[3:0]),
    .i_gt_rxn               (i_gt_rxn[3:0]),

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


ten_gig_ctrl_module#(
    .P_CHANNEL_NUM          (P_CHANNEL_NUM >> 1 ),
    .P_MIN_LENGTH           (P_MIN_LENGTH       ),
    .P_MAX_LENGTH           (P_MAX_LENGTH       )
)ten_gig_ctrl_module_u1(
    .i_gt_refclk_p          (i_gt_1_refclk_p    ),
    .i_gt_refclk_n          (i_gt_1_refclk_n    ),
    .i_dclk                 (w_dclk             ),
    .i_sys_reset            (w_sys_reset        ),

    .o_gt_txp               (o_gt_txp[P_CHANNEL_NUM-1:4]),
    .o_gt_txn               (o_gt_txn[P_CHANNEL_NUM-1:4]),
    .i_gt_rxp               (i_gt_rxp[P_CHANNEL_NUM-1:4]),
    .i_gt_rxn               (i_gt_rxn[P_CHANNEL_NUM-1:4]),

    .o_0_tx_clk_out         (o_4_tx_clk_out     ),
    .o_0_rx_clk_out         (o_4_rx_clk_out     ),
    .o_0_user_tx_reset      (o_4_user_tx_reset  ),
    .o_0_user_rx_reset      (o_4_user_rx_reset  ),
    .o_0_stat_rx_status     (o_4_stat_rx_status ),
    .tx0_axis_tready        (tx4_axis_tready    ),
    .tx0_axis_tvalid        (tx4_axis_tvalid    ),
    .tx0_axis_tdata         (tx4_axis_tdata     ),
    .tx0_axis_tlast         (tx4_axis_tlast     ),
    .tx0_axis_tkeep         (tx4_axis_tkeep     ),
    .tx0_axis_tuser         (tx4_axis_tuser     ),
    .rx0_axis_tvalid        (rx4_axis_tvalid    ),
    .rx0_axis_tdata         (rx4_axis_tdata     ),
    .rx0_axis_tlast         (rx4_axis_tlast     ),
    .rx0_axis_tkeep         (rx4_axis_tkeep     ),
    .rx0_axis_tuser         (rx4_axis_tuser     ),

    .o_1_tx_clk_out         (o_5_tx_clk_out     ),
    .o_1_rx_clk_out         (o_5_rx_clk_out     ),
    .o_1_user_tx_reset      (o_5_user_tx_reset  ),
    .o_1_user_rx_reset      (o_5_user_rx_reset  ),
    .o_1_stat_rx_status     (o_5_stat_rx_status ),
    .tx1_axis_tready        (tx5_axis_tready    ),
    .tx1_axis_tvalid        (tx5_axis_tvalid    ),
    .tx1_axis_tdata         (tx5_axis_tdata     ),
    .tx1_axis_tlast         (tx5_axis_tlast     ),
    .tx1_axis_tkeep         (tx5_axis_tkeep     ),
    .tx1_axis_tuser         (tx5_axis_tuser     ),
    .rx1_axis_tvalid        (rx5_axis_tvalid    ),
    .rx1_axis_tdata         (rx5_axis_tdata     ),
    .rx1_axis_tlast         (rx5_axis_tlast     ),
    .rx1_axis_tkeep         (rx5_axis_tkeep     ),
    .rx1_axis_tuser         (rx5_axis_tuser     ),

    .o_2_tx_clk_out         (o_6_tx_clk_out     ),
    .o_2_rx_clk_out         (o_6_rx_clk_out     ),
    .o_2_user_tx_reset      (o_6_user_tx_reset  ),
    .o_2_user_rx_reset      (o_6_user_rx_reset  ),
    .o_2_stat_rx_status     (o_6_stat_rx_status ),
    .tx2_axis_tready        (tx6_axis_tready    ),
    .tx2_axis_tvalid        (tx6_axis_tvalid    ),
    .tx2_axis_tdata         (tx6_axis_tdata     ),
    .tx2_axis_tlast         (tx6_axis_tlast     ),
    .tx2_axis_tkeep         (tx6_axis_tkeep     ),
    .tx2_axis_tuser         (tx6_axis_tuser     ),
    .rx2_axis_tvalid        (rx6_axis_tvalid    ),
    .rx2_axis_tdata         (rx6_axis_tdata     ),
    .rx2_axis_tlast         (rx6_axis_tlast     ),
    .rx2_axis_tkeep         (rx6_axis_tkeep     ),
    .rx2_axis_tuser         (rx6_axis_tuser     ),

    .o_3_tx_clk_out         (o_7_tx_clk_out     ),
    .o_3_rx_clk_out         (o_7_rx_clk_out     ),
    .o_3_user_tx_reset      (o_7_user_tx_reset  ),
    .o_3_user_rx_reset      (o_7_user_rx_reset  ),
    .o_3_stat_rx_status     (o_7_stat_rx_status ),
    .tx3_axis_tready        (tx7_axis_tready    ),
    .tx3_axis_tvalid        (tx7_axis_tvalid    ),
    .tx3_axis_tdata         (tx7_axis_tdata     ),
    .tx3_axis_tlast         (tx7_axis_tlast     ),
    .tx3_axis_tkeep         (tx7_axis_tkeep     ),
    .tx3_axis_tuser         (tx7_axis_tuser     ),
    .rx3_axis_tvalid        (rx7_axis_tvalid    ),
    .rx3_axis_tdata         (rx7_axis_tdata     ),
    .rx3_axis_tlast         (rx7_axis_tlast     ),
    .rx3_axis_tkeep         (rx7_axis_tkeep     ),
    .rx3_axis_tuser         (rx7_axis_tuser     )
);



endmodule
