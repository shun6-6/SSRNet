`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/13 15:42:21
// Design Name: 
// Module Name: ten_gig_ctrl_module
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


module ten_gig_ctrl_module#(
    parameter       P_CHANNEL_NUM   = 2         ,
    parameter       P_MIN_LENGTH    = 8'd64     ,
    parameter       P_MAX_LENGTH    = 15'd9600 
)(
    input                       i_gt_refclk_p       ,
    input                       i_gt_refclk_n       ,
    input                       i_dclk              ,
    input                       i_sys_reset         ,
    output [P_CHANNEL_NUM-1:0]  o_gt_txp            ,
    output [P_CHANNEL_NUM-1:0]  o_gt_txn            ,
    input  [P_CHANNEL_NUM-1:0]  i_gt_rxp            ,
    input  [P_CHANNEL_NUM-1:0]  i_gt_rxn            ,

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
    output                      rx0_axis_tvalid     ,
    output [63 :0]              rx0_axis_tdata      ,
    output                      rx0_axis_tlast      ,
    output [7  :0]              rx0_axis_tkeep      ,
    output                      rx0_axis_tuser      ,

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
    output                      rx1_axis_tvalid     ,
    output [63 :0]              rx1_axis_tdata      ,
    output                      rx1_axis_tlast      ,
    output [7  :0]              rx1_axis_tkeep      ,
    output                      rx1_axis_tuser      ,

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
    output                      rx2_axis_tvalid     ,
    output [63 :0]              rx2_axis_tdata      ,
    output                      rx2_axis_tlast      ,
    output [7  :0]              rx2_axis_tkeep      ,
    output                      rx2_axis_tuser      ,

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
    output                      rx3_axis_tvalid     ,
    output [63 :0]              rx3_axis_tdata      ,
    output                      rx3_axis_tlast      ,
    output [7  :0]              rx3_axis_tkeep      ,
    output                      rx3_axis_tuser      
);

wire w_gt_refclk_out    ;
wire w_gt_refclk        ;
wire w_qpll0reset       ;
wire w_qpll0lock        ;
wire w_qpll0outclk      ;
wire w_qpll0outrefclk   ;
wire w_qpll1reset       ;
wire w_qpll1lock        ;
wire w_qpll1outclk      ;
wire w_qpll1outrefclk   ;

xxv_ethernet_0_clocking_wrapper i_xxv_ethernet_0_clocking_wrapper(
    .gt_refclk_p        (i_gt_refclk_p  ),
    .gt_refclk_n        (i_gt_refclk_n  ),
    .gt_refclk_out      (w_gt_refclk_out),
    .gt_refclk          (w_gt_refclk    )
);

xxv_ethernet_0_common_wrapper i_xxv_ethernet_0_common_wrapper
(
    .refclk             (w_gt_refclk        ),
    .qpll0reset         (w_qpll0reset       ),
    .qpll0lock          (w_qpll0lock        ),
    .qpll0outclk        (w_qpll0outclk      ),
    .qpll0outrefclk     (w_qpll0outrefclk   ),
    .qpll1reset         (w_qpll1reset       ),
    .qpll1lock          (w_qpll1lock        ),
    .qpll1outclk        (w_qpll1outclk      ),
    .qpll1outrefclk     (w_qpll1outrefclk   )
);

uplus_ten_gig_channel#(
    .P_MIN_LENGTH       (P_MIN_LENGTH       ),
    .P_MAX_LENGTH       (P_MAX_LENGTH       )
)uplus_ten_gig_channel_u0(
    .i_sys_reset        (i_sys_reset        ),
    .i_dclk             (i_dclk             ),
    .o_gt_txp           (o_gt_txp[0]        ),
    .o_gt_txn           (o_gt_txn[0]        ),
    .i_gt_rxp           (i_gt_rxp[0]        ),
    .i_gt_rxn           (i_gt_rxn[0]        ),
    .o_tx_clk_out       (o_0_tx_clk_out     ),
    .o_rx_clk_out       (o_0_rx_clk_out     ),
    .o_user_tx_reset    (o_0_user_tx_reset  ),
    .o_user_rx_reset    (o_0_user_rx_reset  ),
    .o_stat_rx_status   (o_0_stat_rx_status ),
    .o_qpll0reset       (w_qpll0reset       ),
    .i_qpll0lock        (w_qpll0lock        ),
    .i_qpll0outclk      (w_qpll0outclk      ),
    .i_qpll0outrefclk   (w_qpll0outrefclk   ),
    .o_qpll1reset       (w_qpll1reset       ),
    .i_qpll1lock        (w_qpll1lock        ),
    .i_qpll1outclk      (w_qpll1outclk      ),
    .i_qpll1outrefclk   (w_qpll1outrefclk   ),
    .tx_axis_tready     (tx0_axis_tready    ),
    .tx_axis_tvalid     (tx0_axis_tvalid    ),
    .tx_axis_tdata      (tx0_axis_tdata     ),
    .tx_axis_tlast      (tx0_axis_tlast     ),
    .tx_axis_tkeep      (tx0_axis_tkeep     ),
    .tx_axis_tuser      (tx0_axis_tuser     ),
    .rx_axis_tvalid     (rx0_axis_tvalid    ),
    .rx_axis_tdata      (rx0_axis_tdata     ),
    .rx_axis_tlast      (rx0_axis_tlast     ),
    .rx_axis_tkeep      (rx0_axis_tkeep     ),
    .rx_axis_tuser      (rx0_axis_tuser     ) 
);

uplus_ten_gig_channel#(
    .P_MIN_LENGTH       (P_MIN_LENGTH       ),
    .P_MAX_LENGTH       (P_MAX_LENGTH       )
)uplus_ten_gig_channel_u1(
    .i_sys_reset        (i_sys_reset        ),
    .i_dclk             (i_dclk             ),
    .o_gt_txp           (o_gt_txp[1]        ),
    .o_gt_txn           (o_gt_txn[1]        ),
    .i_gt_rxp           (i_gt_rxp[1]        ),
    .i_gt_rxn           (i_gt_rxn[1]        ),
    .o_tx_clk_out       (o_1_tx_clk_out     ),
    .o_rx_clk_out       (o_1_rx_clk_out     ),
    .o_user_tx_reset    (o_1_user_tx_reset  ),
    .o_user_rx_reset    (o_1_user_rx_reset  ),
    .o_stat_rx_status   (o_1_stat_rx_status ),
    .o_qpll0reset       (       ),//只需要一个通道复位即可
    .i_qpll0lock        (w_qpll0lock        ),
    .i_qpll0outclk      (w_qpll0outclk      ),
    .i_qpll0outrefclk   (w_qpll0outrefclk   ),
    .o_qpll1reset       (       ),
    .i_qpll1lock        (w_qpll1lock        ),
    .i_qpll1outclk      (w_qpll1outclk      ),
    .i_qpll1outrefclk   (w_qpll1outrefclk   ),
    .tx_axis_tready     (tx1_axis_tready    ),
    .tx_axis_tvalid     (tx1_axis_tvalid    ),
    .tx_axis_tdata      (tx1_axis_tdata     ),
    .tx_axis_tlast      (tx1_axis_tlast     ),
    .tx_axis_tkeep      (tx1_axis_tkeep     ),
    .tx_axis_tuser      (tx1_axis_tuser     ),
    .rx_axis_tvalid     (rx1_axis_tvalid    ),
    .rx_axis_tdata      (rx1_axis_tdata     ),
    .rx_axis_tlast      (rx1_axis_tlast     ),
    .rx_axis_tkeep      (rx1_axis_tkeep     ),
    .rx_axis_tuser      (rx1_axis_tuser     ) 
);

uplus_ten_gig_channel#(
    .P_MIN_LENGTH       (P_MIN_LENGTH       ),
    .P_MAX_LENGTH       (P_MAX_LENGTH       )
)uplus_ten_gig_channel_u2(
    .i_sys_reset        (i_sys_reset        ),
    .i_dclk             (i_dclk             ),
    .o_gt_txp           (o_gt_txp[2]        ),
    .o_gt_txn           (o_gt_txn[2]        ),
    .i_gt_rxp           (i_gt_rxp[2]        ),
    .i_gt_rxn           (i_gt_rxn[2]        ),
    .o_tx_clk_out       (o_2_tx_clk_out     ),
    .o_rx_clk_out       (o_2_rx_clk_out     ),
    .o_user_tx_reset    (o_2_user_tx_reset  ),
    .o_user_rx_reset    (o_2_user_rx_reset  ),
    .o_stat_rx_status   (o_2_stat_rx_status ),
    .o_qpll0reset       (       ),//只需要一个通道复位即可
    .i_qpll0lock        (w_qpll0lock        ),
    .i_qpll0outclk      (w_qpll0outclk      ),
    .i_qpll0outrefclk   (w_qpll0outrefclk   ),
    .o_qpll1reset       (       ),
    .i_qpll1lock        (w_qpll1lock        ),
    .i_qpll1outclk      (w_qpll1outclk      ),
    .i_qpll1outrefclk   (w_qpll1outrefclk   ),
    .tx_axis_tready     (tx2_axis_tready    ),
    .tx_axis_tvalid     (tx2_axis_tvalid    ),
    .tx_axis_tdata      (tx2_axis_tdata     ),
    .tx_axis_tlast      (tx2_axis_tlast     ),
    .tx_axis_tkeep      (tx2_axis_tkeep     ),
    .tx_axis_tuser      (tx2_axis_tuser     ),
    .rx_axis_tvalid     (rx2_axis_tvalid    ),
    .rx_axis_tdata      (rx2_axis_tdata     ),
    .rx_axis_tlast      (rx2_axis_tlast     ),
    .rx_axis_tkeep      (rx2_axis_tkeep     ),
    .rx_axis_tuser      (rx2_axis_tuser     ) 
);

uplus_ten_gig_channel#(
    .P_MIN_LENGTH       (P_MIN_LENGTH       ),
    .P_MAX_LENGTH       (P_MAX_LENGTH       )
)uplus_ten_gig_channel_u3(
    .i_sys_reset        (i_sys_reset        ),
    .i_dclk             (i_dclk             ),
    .o_gt_txp           (o_gt_txp[3]        ),
    .o_gt_txn           (o_gt_txn[3]        ),
    .i_gt_rxp           (i_gt_rxp[3]        ),
    .i_gt_rxn           (i_gt_rxn[3]        ),
    .o_tx_clk_out       (o_3_tx_clk_out     ),
    .o_rx_clk_out       (o_3_rx_clk_out     ),
    .o_user_tx_reset    (o_3_user_tx_reset  ),
    .o_user_rx_reset    (o_3_user_rx_reset  ),
    .o_stat_rx_status   (o_3_stat_rx_status ),
    .o_qpll0reset       (       ),//只需要一个通道复位即可
    .i_qpll0lock        (w_qpll0lock        ),
    .i_qpll0outclk      (w_qpll0outclk      ),
    .i_qpll0outrefclk   (w_qpll0outrefclk   ),
    .o_qpll1reset       (       ),
    .i_qpll1lock        (w_qpll1lock        ),
    .i_qpll1outclk      (w_qpll1outclk      ),
    .i_qpll1outrefclk   (w_qpll1outrefclk   ),
    .tx_axis_tready     (tx3_axis_tready    ),
    .tx_axis_tvalid     (tx3_axis_tvalid    ),
    .tx_axis_tdata      (tx3_axis_tdata     ),
    .tx_axis_tlast      (tx3_axis_tlast     ),
    .tx_axis_tkeep      (tx3_axis_tkeep     ),
    .tx_axis_tuser      (tx3_axis_tuser     ),
    .rx_axis_tvalid     (rx3_axis_tvalid    ),
    .rx_axis_tdata      (rx3_axis_tdata     ),
    .rx_axis_tlast      (rx3_axis_tlast     ),
    .rx_axis_tkeep      (rx3_axis_tkeep     ),
    .rx_axis_tuser      (rx3_axis_tuser     ) 
);



endmodule
