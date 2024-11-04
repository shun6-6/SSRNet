`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 13:31:20
// Design Name: 
// Module Name: crossbar_line
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


module crossbar_line#(
    parameter       P_CROSSBAR_N = 4        
)(
    input                           i_clk                   ,
    input                           i_rst                   ,

    output [P_CROSSBAR_N - 1 : 0]   o_trans_req             ,
    input  [P_CROSSBAR_N - 1 : 0]   i_trans_grant           ,

    input                           s_axis_rx_tvalid        ,
    input  [63 :0]                  s_axis_rx_tdata         ,
    input                           s_axis_rx_tlast         ,
    input  [7  :0]                  s_axis_rx_tkeep         ,
    input                           s_axis_rx_tuser         ,
    input  [2 : 0]                  s_axis_rx_tdest         ,

    output                          m0_axis_tx_tvalid       ,
    output [63 :0]                  m0_axis_tx_tdata        ,
    output                          m0_axis_tx_tlast        ,
    output [7  :0]                  m0_axis_tx_tkeep        ,
    output                          m0_axis_tx_tuser        ,
    input                           m0_axis_tx_tready       , 

    output                          m1_axis_tx_tvalid       ,
    output [63 :0]                  m1_axis_tx_tdata        ,
    output                          m1_axis_tx_tlast        ,
    output [7  :0]                  m1_axis_tx_tkeep        ,
    output                          m1_axis_tx_tuser        ,
    input                           m1_axis_tx_tready       , 

    output                          m2_axis_tx_tvalid       ,
    output [63 :0]                  m2_axis_tx_tdata        ,
    output                          m2_axis_tx_tlast        ,
    output [7  :0]                  m2_axis_tx_tkeep        ,
    output                          m2_axis_tx_tuser        ,
    input                           m2_axis_tx_tready       , 

    output                          m3_axis_tx_tvalid       ,
    output [63 :0]                  m3_axis_tx_tdata        ,
    output                          m3_axis_tx_tlast        ,
    output [7  :0]                  m3_axis_tx_tkeep        ,
    output                          m3_axis_tx_tuser        ,
    input                           m3_axis_tx_tready        
);

crossbar_point#(
    .P_DEST             (3'd0)
)crossbar_point_u0(
    .i_clk              (i_clk              ),
    .i_rst              (i_rst              ),

    .o_trans_req        (o_trans_req[0]     ),
    .i_trans_grant      (i_trans_grant[0]   ),

    .s_axis_rx_tvalid   (s_axis_rx_tvalid   ),
    .s_axis_rx_tdata    (s_axis_rx_tdata    ),
    .s_axis_rx_tlast    (s_axis_rx_tlast    ),
    .s_axis_rx_tkeep    (s_axis_rx_tkeep    ),
    .s_axis_rx_tuser    (s_axis_rx_tuser    ),
    .s_axis_rx_tdest    (s_axis_rx_tdest    ),

    .m_axis_tx_tvalid   (m0_axis_tx_tvalid  ),
    .m_axis_tx_tdata    (m0_axis_tx_tdata   ),
    .m_axis_tx_tlast    (m0_axis_tx_tlast   ),
    .m_axis_tx_tkeep    (m0_axis_tx_tkeep   ),
    .m_axis_tx_tuser    (m0_axis_tx_tuser   ),
    .m_axis_tx_tready   (m0_axis_tx_tready  ) 
);

crossbar_point#(
    .P_DEST             (3'd1)
)crossbar_point_u1(
    .i_clk              (i_clk              ),
    .i_rst              (i_rst              ),

    .o_trans_req        (o_trans_req[1]     ),
    .i_trans_grant      (i_trans_grant[1]   ),

    .s_axis_rx_tvalid   (s_axis_rx_tvalid   ),
    .s_axis_rx_tdata    (s_axis_rx_tdata    ),
    .s_axis_rx_tlast    (s_axis_rx_tlast    ),
    .s_axis_rx_tkeep    (s_axis_rx_tkeep    ),
    .s_axis_rx_tuser    (s_axis_rx_tuser    ),
    .s_axis_rx_tdest    (s_axis_rx_tdest    ),

    .m_axis_tx_tvalid   (m1_axis_tx_tvalid  ),
    .m_axis_tx_tdata    (m1_axis_tx_tdata   ),
    .m_axis_tx_tlast    (m1_axis_tx_tlast   ),
    .m_axis_tx_tkeep    (m1_axis_tx_tkeep   ),
    .m_axis_tx_tuser    (m1_axis_tx_tuser   ),
    .m_axis_tx_tready   (m1_axis_tx_tready  ) 
);

crossbar_point#(
    .P_DEST             (3'd2)
)crossbar_point_u2(
    .i_clk              (i_clk              ),
    .i_rst              (i_rst              ),

    .o_trans_req        (o_trans_req[2]     ),
    .i_trans_grant      (i_trans_grant[2]   ),

    .s_axis_rx_tvalid   (s_axis_rx_tvalid   ),
    .s_axis_rx_tdata    (s_axis_rx_tdata    ),
    .s_axis_rx_tlast    (s_axis_rx_tlast    ),
    .s_axis_rx_tkeep    (s_axis_rx_tkeep    ),
    .s_axis_rx_tuser    (s_axis_rx_tuser    ),
    .s_axis_rx_tdest    (s_axis_rx_tdest    ),

    .m_axis_tx_tvalid   (m2_axis_tx_tvalid  ),
    .m_axis_tx_tdata    (m2_axis_tx_tdata   ),
    .m_axis_tx_tlast    (m2_axis_tx_tlast   ),
    .m_axis_tx_tkeep    (m2_axis_tx_tkeep   ),
    .m_axis_tx_tuser    (m2_axis_tx_tuser   ),
    .m_axis_tx_tready   (m2_axis_tx_tready  ) 
);

crossbar_point#(
    .P_DEST             (3'd3)
)crossbar_point_u3(
    .i_clk              (i_clk              ),
    .i_rst              (i_rst              ),

    .o_trans_req        (o_trans_req[3]     ),
    .i_trans_grant      (i_trans_grant[3]   ),

    .s_axis_rx_tvalid   (s_axis_rx_tvalid   ),
    .s_axis_rx_tdata    (s_axis_rx_tdata    ),
    .s_axis_rx_tlast    (s_axis_rx_tlast    ),
    .s_axis_rx_tkeep    (s_axis_rx_tkeep    ),
    .s_axis_rx_tuser    (s_axis_rx_tuser    ),
    .s_axis_rx_tdest    (s_axis_rx_tdest    ),

    .m_axis_tx_tvalid   (m3_axis_tx_tvalid  ),
    .m_axis_tx_tdata    (m3_axis_tx_tdata   ),
    .m_axis_tx_tlast    (m3_axis_tx_tlast   ),
    .m_axis_tx_tkeep    (m3_axis_tx_tkeep   ),
    .m_axis_tx_tuser    (m3_axis_tx_tuser   ),
    .m_axis_tx_tready   (m3_axis_tx_tready  ) 
);

endmodule
