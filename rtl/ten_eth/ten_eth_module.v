`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/12 10:23:51
// Design Name: 
// Module Name: ten_eth_module
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


module ten_eth_module#(
    parameter                   P_CHANNEL_NUM   = 4         
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

    output                      o_0_tx_clk_out      ,
    output                      o_0_rx_clk_out      ,
    output                      o_0_user_tx_reset   ,
    output                      o_0_user_rx_reset   ,
    output                      o_0_stat_rx_status  ,

    output                      o_1_tx_clk_out      ,
    output                      o_1_rx_clk_out      ,
    output                      o_1_user_tx_reset   ,
    output                      o_1_user_rx_reset   ,
    output                      o_1_stat_rx_status  ,

    output                      o_2_tx_clk_out      ,
    output                      o_2_rx_clk_out      ,
    output                      o_2_user_tx_reset   ,
    output                      o_2_user_rx_reset   ,
    output                      o_2_stat_rx_status  ,

    output                      o_3_tx_clk_out      ,
    output                      o_3_rx_clk_out      ,
    output                      o_3_user_tx_reset   ,
    output                      o_3_user_rx_reset   ,
    output                      o_3_stat_rx_status  
);


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


wire            w_1_stat_rx_status  ;
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


VCU128_10g_eth_top#(
    .P_CHANNEL_NUM          (P_CHANNEL_NUM  )   ,
    .P_MIN_LENGTH           (8'd64          )   ,
    .P_MAX_LENGTH           (15'd9600       )   
)VCU128_10g_eth_top_u0( 
    .i_gt_refclk_p          (i_gt_refclk_p  )   ,
    .i_gt_refclk_n          (i_gt_refclk_n  )   ,
    .i_sys_clk_p            (i_sys_clk_p    )   ,
    .i_sys_clk_n            (i_sys_clk_n    )   ,
    .o_gt_txp               (o_gt_txp       )   ,
    .o_gt_txn               (o_gt_txn       )   ,
    .i_gt_rxp               (i_gt_rxp       )   ,
    .i_gt_rxn               (i_gt_rxn       )   ,
    .o_sfp_dis              (o_sfp_dis      )   ,

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
