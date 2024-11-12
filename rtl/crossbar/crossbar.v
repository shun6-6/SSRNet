`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 12:36:35
// Design Name: 
// Module Name: crossbar
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


module crossbar#(
    parameter       P_CROSSBAR_N = 4        
)(
    input                           i_clk                   ,
    input                           i_rst                   ,

    input                           s0_axis_rx_tvalid       ,
    input  [63 :0]                  s0_axis_rx_tdata        ,
    input                           s0_axis_rx_tlast        ,
    input  [7  :0]                  s0_axis_rx_tkeep        ,
    input                           s0_axis_rx_tuser        ,
    input  [2 : 0]                  s0_axis_rx_tdest        ,
    output                          m0_axis_tx_tvalid       ,
    output [63 :0]                  m0_axis_tx_tdata        ,
    output                          m0_axis_tx_tlast        ,
    output [7  :0]                  m0_axis_tx_tkeep        ,
    output                          m0_axis_tx_tuser        ,     
    input                           m0_axis_tx_tready       ,          
    input                           s1_axis_rx_tvalid       ,
    input  [63 :0]                  s1_axis_rx_tdata        ,
    input                           s1_axis_rx_tlast        ,
    input  [7  :0]                  s1_axis_rx_tkeep        ,
    input                           s1_axis_rx_tuser        ,
    input  [2 : 0]                  s1_axis_rx_tdest        ,
    output                          m1_axis_tx_tvalid       ,
    output [63 :0]                  m1_axis_tx_tdata        ,
    output                          m1_axis_tx_tlast        ,
    output [7  :0]                  m1_axis_tx_tkeep        ,
    output                          m1_axis_tx_tuser        ,
    input                           m1_axis_tx_tready       ,    
    input                           s2_axis_rx_tvalid       ,
    input  [63 :0]                  s2_axis_rx_tdata        ,
    input                           s2_axis_rx_tlast        ,
    input  [7  :0]                  s2_axis_rx_tkeep        ,
    input                           s2_axis_rx_tuser        ,
    input  [2 : 0]                  s2_axis_rx_tdest        ,
    output                          m2_axis_tx_tvalid       ,
    output [63 :0]                  m2_axis_tx_tdata        ,
    output                          m2_axis_tx_tlast        ,
    output [7  :0]                  m2_axis_tx_tkeep        ,
    output                          m2_axis_tx_tuser        ,
    input                           m2_axis_tx_tready       ,    
    input                           s3_axis_rx_tvalid       ,
    input  [63 :0]                  s3_axis_rx_tdata        ,
    input                           s3_axis_rx_tlast        ,
    input  [7  :0]                  s3_axis_rx_tkeep        ,
    input                           s3_axis_rx_tuser        ,
    input  [2 : 0]                  s3_axis_rx_tdest        ,
    output                          m3_axis_tx_tvalid       ,
    output [63 :0]                  m3_axis_tx_tdata        ,
    output                          m3_axis_tx_tlast        ,
    output [7  :0]                  m3_axis_tx_tkeep        ,
    output                          m3_axis_tx_tuser        ,
    input                           m3_axis_tx_tready       
); 

reg                         r_req0_valid        ;
reg                         r_req1_valid        ;
reg                         r_req2_valid        ;
reg                         r_req3_valid        ;
reg                         r_req0_lock         ;
reg                         r_req1_lock         ;
reg                         r_req2_lock         ;
reg                         r_req3_lock         ;

wire                        w_next_arbit0       ;
wire                        w_next_arbit1       ;
wire                        w_next_arbit2       ;
wire                        w_next_arbit3       ;

wire [P_CROSSBAR_N - 1 : 0] w_trans_0_req       ;
wire [P_CROSSBAR_N - 1 : 0] w_trans_0_grant     ;
wire [P_CROSSBAR_N - 1 : 0] w_trans_1_req       ;
wire [P_CROSSBAR_N - 1 : 0] w_trans_1_grant     ;
wire [P_CROSSBAR_N - 1 : 0] w_trans_2_req       ;
wire [P_CROSSBAR_N - 1 : 0] w_trans_2_grant     ;
wire [P_CROSSBAR_N - 1 : 0] w_trans_3_req       ;
wire [P_CROSSBAR_N - 1 : 0] w_trans_3_grant     ;

wire [P_CROSSBAR_N - 1 : 0] w_trans0_grant      ;
wire                        w_grant0_valid      ;
wire [P_CROSSBAR_N - 1 : 0] w_trans1_grant      ;
wire                        w_grant1_valid      ;
wire [P_CROSSBAR_N - 1 : 0] w_trans2_grant      ;
wire                        w_grant2_valid      ;
wire [P_CROSSBAR_N - 1 : 0] w_trans3_grant      ;
wire                        w_grant3_valid      ;

wire [P_CROSSBAR_N - 1 : 0] w_trans0_req        ;
wire [P_CROSSBAR_N - 1 : 0] w_trans1_req        ;
wire [P_CROSSBAR_N - 1 : 0] w_trans2_req        ;
wire [P_CROSSBAR_N - 1 : 0] w_trans3_req        ;

wire                        m0_axis_tx0_tvalid  ;
wire [63 :0]                m0_axis_tx0_tdata   ;
wire                        m0_axis_tx0_tlast   ;
wire [7  :0]                m0_axis_tx0_tkeep   ;
wire                        m0_axis_tx0_tuser   ;
wire                        m0_axis_tx0_tready  ;
wire                        m0_axis_tx1_tvalid  ;
wire [63 :0]                m0_axis_tx1_tdata   ;
wire                        m0_axis_tx1_tlast   ;
wire [7  :0]                m0_axis_tx1_tkeep   ;
wire                        m0_axis_tx1_tuser   ;
wire                        m0_axis_tx1_tready  ;
wire                        m0_axis_tx2_tvalid  ;
wire [63 :0]                m0_axis_tx2_tdata   ;
wire                        m0_axis_tx2_tlast   ;
wire [7  :0]                m0_axis_tx2_tkeep   ;
wire                        m0_axis_tx2_tuser   ;
wire                        m0_axis_tx2_tready  ;
wire                        m0_axis_tx3_tvalid  ;
wire [63 :0]                m0_axis_tx3_tdata   ;
wire                        m0_axis_tx3_tlast   ;
wire [7  :0]                m0_axis_tx3_tkeep   ;
wire                        m0_axis_tx3_tuser   ;
wire                        m0_axis_tx3_tready  ;

wire                        m1_axis_tx0_tvalid  ;
wire [63 :0]                m1_axis_tx0_tdata   ;
wire                        m1_axis_tx0_tlast   ;
wire [7  :0]                m1_axis_tx0_tkeep   ;
wire                        m1_axis_tx0_tuser   ;
wire                        m1_axis_tx0_tready  ;
wire                        m1_axis_tx1_tvalid  ;
wire [63 :0]                m1_axis_tx1_tdata   ;
wire                        m1_axis_tx1_tlast   ;
wire [7  :0]                m1_axis_tx1_tkeep   ;
wire                        m1_axis_tx1_tuser   ;
wire                        m1_axis_tx1_tready  ;
wire                        m1_axis_tx2_tvalid  ;
wire [63 :0]                m1_axis_tx2_tdata   ;
wire                        m1_axis_tx2_tlast   ;
wire [7  :0]                m1_axis_tx2_tkeep   ;
wire                        m1_axis_tx2_tuser   ;
wire                        m1_axis_tx2_tready  ;
wire                        m1_axis_tx3_tvalid  ;
wire [63 :0]                m1_axis_tx3_tdata   ;
wire                        m1_axis_tx3_tlast   ;
wire [7  :0]                m1_axis_tx3_tkeep   ;
wire                        m1_axis_tx3_tuser   ;
wire                        m1_axis_tx3_tready  ;

wire                        m2_axis_tx0_tvalid  ;
wire [63 :0]                m2_axis_tx0_tdata   ;
wire                        m2_axis_tx0_tlast   ;
wire [7  :0]                m2_axis_tx0_tkeep   ;
wire                        m2_axis_tx0_tuser   ;
wire                        m2_axis_tx0_tready  ;
wire                        m2_axis_tx1_tvalid  ;
wire [63 :0]                m2_axis_tx1_tdata   ;
wire                        m2_axis_tx1_tlast   ;
wire [7  :0]                m2_axis_tx1_tkeep   ;
wire                        m2_axis_tx1_tuser   ;
wire                        m2_axis_tx1_tready  ;
wire                        m2_axis_tx2_tvalid  ;
wire [63 :0]                m2_axis_tx2_tdata   ;
wire                        m2_axis_tx2_tlast   ;
wire [7  :0]                m2_axis_tx2_tkeep   ;
wire                        m2_axis_tx2_tuser   ;
wire                        m2_axis_tx2_tready  ;
wire                        m2_axis_tx3_tvalid  ;
wire [63 :0]                m2_axis_tx3_tdata   ;
wire                        m2_axis_tx3_tlast   ;
wire [7  :0]                m2_axis_tx3_tkeep   ;
wire                        m2_axis_tx3_tuser   ;
wire                        m2_axis_tx3_tready  ;

wire                        m3_axis_tx0_tvalid  ;
wire [63 :0]                m3_axis_tx0_tdata   ;
wire                        m3_axis_tx0_tlast   ;
wire [7  :0]                m3_axis_tx0_tkeep   ;
wire                        m3_axis_tx0_tuser   ;
wire                        m3_axis_tx0_tready  ;
wire                        m3_axis_tx1_tvalid  ;
wire [63 :0]                m3_axis_tx1_tdata   ;
wire                        m3_axis_tx1_tlast   ;
wire [7  :0]                m3_axis_tx1_tkeep   ;
wire                        m3_axis_tx1_tuser   ;
wire                        m3_axis_tx1_tready  ;
wire                        m3_axis_tx2_tvalid  ;
wire [63 :0]                m3_axis_tx2_tdata   ;
wire                        m3_axis_tx2_tlast   ;
wire [7  :0]                m3_axis_tx2_tkeep   ;
wire                        m3_axis_tx2_tuser   ;
wire                        m3_axis_tx2_tready  ;
wire                        m3_axis_tx3_tvalid  ;
wire [63 :0]                m3_axis_tx3_tdata   ;
wire                        m3_axis_tx3_tlast   ;
wire [7  :0]                m3_axis_tx3_tkeep   ;
wire                        m3_axis_tx3_tuser   ;
wire                        m3_axis_tx3_tready  ;

assign w_trans0_req = {w_trans_3_req[0],w_trans_2_req[0],w_trans_1_req[0],w_trans_0_req[0]};
assign w_trans1_req = {w_trans_3_req[1],w_trans_2_req[1],w_trans_1_req[1],w_trans_0_req[1]};
assign w_trans2_req = {w_trans_3_req[2],w_trans_2_req[2],w_trans_1_req[2],w_trans_0_req[2]};
assign w_trans3_req = {w_trans_3_req[3],w_trans_2_req[3],w_trans_1_req[3],w_trans_0_req[3]};

assign w_trans_0_grant = {w_trans3_grant[0],w_trans2_grant[0],w_trans1_grant[0],w_trans0_grant[0]};
assign w_trans_1_grant = {w_trans3_grant[1],w_trans2_grant[1],w_trans1_grant[1],w_trans0_grant[1]};
assign w_trans_2_grant = {w_trans3_grant[2],w_trans2_grant[2],w_trans1_grant[2],w_trans0_grant[2]};
assign w_trans_3_grant = {w_trans3_grant[3],w_trans2_grant[3],w_trans1_grant[3],w_trans0_grant[3]};

assign w_next_arbit0 = m0_axis_tx0_tlast || m1_axis_tx0_tlast || m2_axis_tx0_tlast || m3_axis_tx0_tlast;
assign w_next_arbit1 = m0_axis_tx1_tlast || m1_axis_tx1_tlast || m2_axis_tx1_tlast || m3_axis_tx1_tlast;
assign w_next_arbit2 = m0_axis_tx2_tlast || m1_axis_tx2_tlast || m2_axis_tx2_tlast || m3_axis_tx2_tlast;
assign w_next_arbit3 = m0_axis_tx3_tlast || m1_axis_tx3_tlast || m2_axis_tx3_tlast || m3_axis_tx3_tlast;

assign m0_axis_tx_tvalid =    w_trans0_grant[0] ? m0_axis_tx0_tvalid
                            : w_trans0_grant[1] ? m1_axis_tx0_tvalid
                            : w_trans0_grant[2] ? m2_axis_tx0_tvalid
                            : w_trans0_grant[3] ? m3_axis_tx0_tvalid : 'd0;

assign m0_axis_tx_tdata  =    w_trans0_grant[0] ? m0_axis_tx0_tdata
                            : w_trans0_grant[1] ? m1_axis_tx0_tdata
                            : w_trans0_grant[2] ? m2_axis_tx0_tdata
                            : w_trans0_grant[3] ? m3_axis_tx0_tdata : 'd0 ;

assign m0_axis_tx_tlast  =    w_trans0_grant[0] ? m0_axis_tx0_tlast
                            : w_trans0_grant[1] ? m1_axis_tx0_tlast
                            : w_trans0_grant[2] ? m2_axis_tx0_tlast
                            : w_trans0_grant[3] ? m3_axis_tx0_tlast : 'd0 ;

assign m0_axis_tx_tkeep  =    w_trans0_grant[0] ? m0_axis_tx0_tkeep
                            : w_trans0_grant[1] ? m1_axis_tx0_tkeep
                            : w_trans0_grant[2] ? m2_axis_tx0_tkeep
                            : w_trans0_grant[3] ? m3_axis_tx0_tkeep : 'd0 ;

assign m0_axis_tx_tuser  =    w_trans0_grant[0] ? m0_axis_tx0_tuser
                            : w_trans0_grant[1] ? m1_axis_tx0_tuser
                            : w_trans0_grant[2] ? m2_axis_tx0_tuser
                            : w_trans0_grant[3] ? m3_axis_tx0_tuser : 'd0 ;

assign m1_axis_tx_tvalid =    w_trans1_grant[0] ? m0_axis_tx1_tvalid
                            : w_trans1_grant[1] ? m1_axis_tx1_tvalid
                            : w_trans1_grant[2] ? m2_axis_tx1_tvalid
                            : w_trans1_grant[3] ? m3_axis_tx1_tvalid : 'd0;

assign m1_axis_tx_tdata  =    w_trans1_grant[0] ? m0_axis_tx1_tdata
                            : w_trans1_grant[1] ? m1_axis_tx1_tdata
                            : w_trans1_grant[2] ? m2_axis_tx1_tdata
                            : w_trans1_grant[3] ? m3_axis_tx1_tdata : 'd0 ;

assign m1_axis_tx_tlast  =    w_trans1_grant[0] ? m0_axis_tx1_tlast
                            : w_trans1_grant[1] ? m1_axis_tx1_tlast
                            : w_trans1_grant[2] ? m2_axis_tx1_tlast
                            : w_trans1_grant[3] ? m3_axis_tx1_tlast : 'd0 ;

assign m1_axis_tx_tkeep  =    w_trans1_grant[0] ? m0_axis_tx1_tkeep
                            : w_trans1_grant[1] ? m1_axis_tx1_tkeep
                            : w_trans1_grant[2] ? m2_axis_tx1_tkeep
                            : w_trans1_grant[3] ? m3_axis_tx1_tkeep : 'd0 ;

assign m1_axis_tx_tuser  =    w_trans1_grant[0] ? m0_axis_tx1_tuser
                            : w_trans1_grant[1] ? m1_axis_tx1_tuser
                            : w_trans1_grant[2] ? m2_axis_tx1_tuser
                            : w_trans1_grant[3] ? m3_axis_tx1_tuser : 'd0 ;

assign m2_axis_tx_tvalid =    w_trans2_grant[0] ? m0_axis_tx2_tvalid
                            : w_trans2_grant[1] ? m1_axis_tx2_tvalid
                            : w_trans2_grant[2] ? m2_axis_tx2_tvalid
                            : w_trans2_grant[3] ? m3_axis_tx2_tvalid : 'd0;

assign m2_axis_tx_tdata  =    w_trans2_grant[0] ? m0_axis_tx2_tdata
                            : w_trans2_grant[1] ? m1_axis_tx2_tdata
                            : w_trans2_grant[2] ? m2_axis_tx2_tdata
                            : w_trans2_grant[3] ? m3_axis_tx2_tdata : 'd0 ;

assign m2_axis_tx_tlast  =    w_trans2_grant[0] ? m0_axis_tx2_tlast
                            : w_trans2_grant[1] ? m1_axis_tx2_tlast
                            : w_trans2_grant[2] ? m2_axis_tx2_tlast
                            : w_trans2_grant[3] ? m3_axis_tx2_tlast : 'd0 ;

assign m2_axis_tx_tkeep  =    w_trans2_grant[0] ? m0_axis_tx2_tkeep
                            : w_trans2_grant[1] ? m1_axis_tx2_tkeep
                            : w_trans2_grant[2] ? m2_axis_tx2_tkeep
                            : w_trans2_grant[3] ? m3_axis_tx2_tkeep : 'd0 ;

assign m2_axis_tx_tuser  =    w_trans2_grant[0] ? m0_axis_tx2_tuser
                            : w_trans2_grant[1] ? m1_axis_tx2_tuser
                            : w_trans2_grant[2] ? m2_axis_tx2_tuser
                            : w_trans2_grant[3] ? m3_axis_tx2_tuser : 'd0 ;

assign m3_axis_tx_tvalid =    w_trans3_grant[0] ? m0_axis_tx3_tvalid
                            : w_trans3_grant[1] ? m1_axis_tx3_tvalid
                            : w_trans3_grant[2] ? m2_axis_tx3_tvalid
                            : w_trans3_grant[3] ? m3_axis_tx3_tvalid : 'd0;

assign m3_axis_tx_tdata  =    w_trans3_grant[0] ? m0_axis_tx3_tdata
                            : w_trans3_grant[1] ? m1_axis_tx3_tdata
                            : w_trans3_grant[2] ? m2_axis_tx3_tdata
                            : w_trans3_grant[3] ? m3_axis_tx3_tdata : 'd0 ;

assign m3_axis_tx_tlast  =    w_trans3_grant[0] ? m0_axis_tx3_tlast
                            : w_trans3_grant[1] ? m1_axis_tx3_tlast
                            : w_trans3_grant[2] ? m2_axis_tx3_tlast
                            : w_trans3_grant[3] ? m3_axis_tx3_tlast : 'd0 ;

assign m3_axis_tx_tkeep  =    w_trans3_grant[0] ? m0_axis_tx3_tkeep
                            : w_trans3_grant[1] ? m1_axis_tx3_tkeep
                            : w_trans3_grant[2] ? m2_axis_tx3_tkeep
                            : w_trans3_grant[3] ? m3_axis_tx3_tkeep : 'd0 ;

assign m3_axis_tx_tuser  =    w_trans3_grant[0] ? m0_axis_tx3_tuser
                            : w_trans3_grant[1] ? m1_axis_tx3_tuser
                            : w_trans3_grant[2] ? m2_axis_tx3_tuser
                            : w_trans3_grant[3] ? m3_axis_tx3_tuser : 'd0 ;

Arbiter#(
    .P_CHANNEL_NUM      (4)
)Arbiter_u0(
    .i_clk              (i_clk              ),
    .i_rst              (i_rst              ),
    .i_req              (w_trans0_req       ),
    .i_req_valid        (r_req0_valid       ),
    .o_grant            (w_trans0_grant     ),
    .o_grant_valid      (w_grant0_valid     ),
    .reset_priority     (0)
);

Arbiter#(
    .P_CHANNEL_NUM      (4)
)Arbiter_u1(
    .i_clk              (i_clk              ),
    .i_rst              (i_rst              ),
    .i_req              (w_trans1_req       ),
    .i_req_valid        (r_req1_valid       ),
    .o_grant            (w_trans1_grant     ),
    .o_grant_valid      (w_grant1_valid     ),
    .reset_priority     (0)
);

Arbiter#(
    .P_CHANNEL_NUM      (4)
)Arbiter_u2(
    .i_clk              (i_clk              ),
    .i_rst              (i_rst              ),
    .i_req              (w_trans2_req       ),
    .i_req_valid        (r_req2_valid       ),
    .o_grant            (w_trans2_grant     ),
    .o_grant_valid      (w_grant2_valid     ),
    .reset_priority     (0)
);

Arbiter#(
    .P_CHANNEL_NUM      (4)
)Arbiter_u3(
    .i_clk              (i_clk              ),
    .i_rst              (i_rst              ),
    .i_req              (w_trans3_req       ),
    .i_req_valid        (r_req3_valid       ),
    .o_grant            (w_trans3_grant     ),
    .o_grant_valid      (w_grant3_valid     ),
    .reset_priority     (0)
);

crossbar_line#(
    .P_CROSSBAR_N       (4              )        
)crossbar_line_u0(  
    .i_clk              (i_clk              ),
    .i_rst              (i_rst              ),

    .o_trans_req        (w_trans_0_req      ),
    .i_trans_grant      (w_trans_0_grant    ),

    .s_axis_rx_tvalid   (s0_axis_rx_tvalid  ),
    .s_axis_rx_tdata    (s0_axis_rx_tdata   ),
    .s_axis_rx_tlast    (s0_axis_rx_tlast   ),
    .s_axis_rx_tkeep    (s0_axis_rx_tkeep   ),
    .s_axis_rx_tuser    (s0_axis_rx_tuser   ),
    .s_axis_rx_tdest    (s0_axis_rx_tdest   ),

    .m0_axis_tx_tvalid  (m0_axis_tx0_tvalid ),
    .m0_axis_tx_tdata   (m0_axis_tx0_tdata  ),
    .m0_axis_tx_tlast   (m0_axis_tx0_tlast  ),
    .m0_axis_tx_tkeep   (m0_axis_tx0_tkeep  ),
    .m0_axis_tx_tuser   (m0_axis_tx0_tuser  ),
    .m0_axis_tx_tready  (m0_axis_tx_tready  ), 

    .m1_axis_tx_tvalid  (m0_axis_tx1_tvalid ),
    .m1_axis_tx_tdata   (m0_axis_tx1_tdata  ),
    .m1_axis_tx_tlast   (m0_axis_tx1_tlast  ),
    .m1_axis_tx_tkeep   (m0_axis_tx1_tkeep  ),
    .m1_axis_tx_tuser   (m0_axis_tx1_tuser  ),
    .m1_axis_tx_tready  (m1_axis_tx_tready  ), 

    .m2_axis_tx_tvalid  (m0_axis_tx2_tvalid ),
    .m2_axis_tx_tdata   (m0_axis_tx2_tdata  ),
    .m2_axis_tx_tlast   (m0_axis_tx2_tlast  ),
    .m2_axis_tx_tkeep   (m0_axis_tx2_tkeep  ),
    .m2_axis_tx_tuser   (m0_axis_tx2_tuser  ),
    .m2_axis_tx_tready  (m2_axis_tx_tready  ),

    .m3_axis_tx_tvalid  (m0_axis_tx3_tvalid ),
    .m3_axis_tx_tdata   (m0_axis_tx3_tdata  ),
    .m3_axis_tx_tlast   (m0_axis_tx3_tlast  ),
    .m3_axis_tx_tkeep   (m0_axis_tx3_tkeep  ),
    .m3_axis_tx_tuser   (m0_axis_tx3_tuser  ),
    .m3_axis_tx_tready  (m3_axis_tx_tready  )
);

crossbar_line#(
    .P_CROSSBAR_N       (4              )        
)crossbar_line_u1(  
    .i_clk              (i_clk              ),
    .i_rst              (i_rst              ),

    .o_trans_req        (w_trans_1_req      ),
    .i_trans_grant      (w_trans_1_grant    ),

    .s_axis_rx_tvalid   (s1_axis_rx_tvalid  ),
    .s_axis_rx_tdata    (s1_axis_rx_tdata   ),
    .s_axis_rx_tlast    (s1_axis_rx_tlast   ),
    .s_axis_rx_tkeep    (s1_axis_rx_tkeep   ),
    .s_axis_rx_tuser    (s1_axis_rx_tuser   ),
    .s_axis_rx_tdest    (s1_axis_rx_tdest   ),

    .m0_axis_tx_tvalid  (m1_axis_tx0_tvalid ),
    .m0_axis_tx_tdata   (m1_axis_tx0_tdata  ),
    .m0_axis_tx_tlast   (m1_axis_tx0_tlast  ),
    .m0_axis_tx_tkeep   (m1_axis_tx0_tkeep  ),
    .m0_axis_tx_tuser   (m1_axis_tx0_tuser  ),
    .m0_axis_tx_tready  (m0_axis_tx_tready   ), 

    .m1_axis_tx_tvalid  (m1_axis_tx1_tvalid ),
    .m1_axis_tx_tdata   (m1_axis_tx1_tdata  ),
    .m1_axis_tx_tlast   (m1_axis_tx1_tlast  ),
    .m1_axis_tx_tkeep   (m1_axis_tx1_tkeep  ),
    .m1_axis_tx_tuser   (m1_axis_tx1_tuser  ),
    .m1_axis_tx_tready  (m1_axis_tx_tready  ), 

    .m2_axis_tx_tvalid  (m1_axis_tx2_tvalid ),
    .m2_axis_tx_tdata   (m1_axis_tx2_tdata  ),
    .m2_axis_tx_tlast   (m1_axis_tx2_tlast  ),
    .m2_axis_tx_tkeep   (m1_axis_tx2_tkeep  ),
    .m2_axis_tx_tuser   (m1_axis_tx2_tuser  ),
    .m2_axis_tx_tready  (m2_axis_tx_tready ),

    .m3_axis_tx_tvalid  (m1_axis_tx3_tvalid ),
    .m3_axis_tx_tdata   (m1_axis_tx3_tdata  ),
    .m3_axis_tx_tlast   (m1_axis_tx3_tlast  ),
    .m3_axis_tx_tkeep   (m1_axis_tx3_tkeep  ),
    .m3_axis_tx_tuser   (m1_axis_tx3_tuser  ),
    .m3_axis_tx_tready  (m3_axis_tx_tready )
);

crossbar_line#(
    .P_CROSSBAR_N       (4              )        
)crossbar_line_u2(  
    .i_clk              (i_clk              ),
    .i_rst              (i_rst              ),

    .o_trans_req        (w_trans_2_req      ),
    .i_trans_grant      (w_trans_2_grant    ),

    .s_axis_rx_tvalid   (s2_axis_rx_tvalid  ),
    .s_axis_rx_tdata    (s2_axis_rx_tdata   ),
    .s_axis_rx_tlast    (s2_axis_rx_tlast   ),
    .s_axis_rx_tkeep    (s2_axis_rx_tkeep   ),
    .s_axis_rx_tuser    (s2_axis_rx_tuser   ),
    .s_axis_rx_tdest    (s2_axis_rx_tdest   ),

    .m0_axis_tx_tvalid  (m2_axis_tx0_tvalid ),
    .m0_axis_tx_tdata   (m2_axis_tx0_tdata  ),
    .m0_axis_tx_tlast   (m2_axis_tx0_tlast  ),
    .m0_axis_tx_tkeep   (m2_axis_tx0_tkeep  ),
    .m0_axis_tx_tuser   (m2_axis_tx0_tuser  ),
    .m0_axis_tx_tready  (m0_axis_tx_tready  ), 

    .m1_axis_tx_tvalid  (m2_axis_tx1_tvalid ),
    .m1_axis_tx_tdata   (m2_axis_tx1_tdata  ),
    .m1_axis_tx_tlast   (m2_axis_tx1_tlast  ),
    .m1_axis_tx_tkeep   (m2_axis_tx1_tkeep  ),
    .m1_axis_tx_tuser   (m2_axis_tx1_tuser  ),
    .m1_axis_tx_tready  (m1_axis_tx_tready ), 

    .m2_axis_tx_tvalid  (m2_axis_tx2_tvalid ),
    .m2_axis_tx_tdata   (m2_axis_tx2_tdata  ),
    .m2_axis_tx_tlast   (m2_axis_tx2_tlast  ),
    .m2_axis_tx_tkeep   (m2_axis_tx2_tkeep  ),
    .m2_axis_tx_tuser   (m2_axis_tx2_tuser  ),
    .m2_axis_tx_tready  (m2_axis_tx_tready ),

    .m3_axis_tx_tvalid  (m2_axis_tx3_tvalid ),
    .m3_axis_tx_tdata   (m2_axis_tx3_tdata  ),
    .m3_axis_tx_tlast   (m2_axis_tx3_tlast  ),
    .m3_axis_tx_tkeep   (m2_axis_tx3_tkeep  ),
    .m3_axis_tx_tuser   (m2_axis_tx3_tuser  ),
    .m3_axis_tx_tready  (m3_axis_tx_tready )
);

crossbar_line#(
    .P_CROSSBAR_N       (4              )        
)crossbar_line_u3(  
    .i_clk              (i_clk              ),
    .i_rst              (i_rst              ),

    .o_trans_req        (w_trans_3_req      ),
    .i_trans_grant      (w_trans_3_grant    ),

    .s_axis_rx_tvalid   (s3_axis_rx_tvalid  ),
    .s_axis_rx_tdata    (s3_axis_rx_tdata   ),
    .s_axis_rx_tlast    (s3_axis_rx_tlast   ),
    .s_axis_rx_tkeep    (s3_axis_rx_tkeep   ),
    .s_axis_rx_tuser    (s3_axis_rx_tuser   ),
    .s_axis_rx_tdest    (s3_axis_rx_tdest   ),

    .m0_axis_tx_tvalid  (m3_axis_tx0_tvalid ),
    .m0_axis_tx_tdata   (m3_axis_tx0_tdata  ),
    .m0_axis_tx_tlast   (m3_axis_tx0_tlast  ),
    .m0_axis_tx_tkeep   (m3_axis_tx0_tkeep  ),
    .m0_axis_tx_tuser   (m3_axis_tx0_tuser  ),
    .m0_axis_tx_tready  (m0_axis_tx_tready ), 

    .m1_axis_tx_tvalid  (m3_axis_tx1_tvalid ),
    .m1_axis_tx_tdata   (m3_axis_tx1_tdata  ),
    .m1_axis_tx_tlast   (m3_axis_tx1_tlast  ),
    .m1_axis_tx_tkeep   (m3_axis_tx1_tkeep  ),
    .m1_axis_tx_tuser   (m3_axis_tx1_tuser  ),
    .m1_axis_tx_tready  (m1_axis_tx_tready ), 

    .m2_axis_tx_tvalid  (m3_axis_tx2_tvalid ),
    .m2_axis_tx_tdata   (m3_axis_tx2_tdata  ),
    .m2_axis_tx_tlast   (m3_axis_tx2_tlast  ),
    .m2_axis_tx_tkeep   (m3_axis_tx2_tkeep  ),
    .m2_axis_tx_tuser   (m3_axis_tx2_tuser  ),
    .m2_axis_tx_tready  (m2_axis_tx_tready ),

    .m3_axis_tx_tvalid  (m3_axis_tx3_tvalid ),
    .m3_axis_tx_tdata   (m3_axis_tx3_tdata  ),
    .m3_axis_tx_tlast   (m3_axis_tx3_tlast  ),
    .m3_axis_tx_tkeep   (m3_axis_tx3_tkeep  ),
    .m3_axis_tx_tuser   (m3_axis_tx3_tuser  ),
    .m3_axis_tx_tready  (m3_axis_tx_tready )
);
//arbiter0
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_req0_valid <= 'd0;
    else if(r_req0_valid)
        r_req0_valid <= 'd0;
    else if(!r_req0_lock && (|w_trans0_req))
        r_req0_valid <= 'd1;
    else
        r_req0_valid <= 'd0;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_req0_lock <= 'd0;
    else if(w_next_arbit0)
        r_req0_lock <= 'd0;
    else if(r_req0_valid)
        r_req0_lock <= 'd1;
    else
        r_req0_lock <= r_req0_lock;
end
//arbiter1
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_req1_valid <= 'd0;
    else if(r_req1_valid)
        r_req1_valid <= 'd0;        
    else if(!r_req1_lock && (|w_trans1_req))
        r_req1_valid <= 'd1;
    else
        r_req1_valid <= 'd0;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_req1_lock <= 'd0;
    else if(w_next_arbit1)
        r_req1_lock <= 'd0;
    else if(r_req1_valid)
        r_req1_lock <= 'd1;
    else
        r_req1_lock <= r_req1_lock;
end
//arbiter2
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_req2_valid <= 'd0;
    else if(r_req2_valid)
        r_req2_valid <= 'd0;
    else if(!r_req2_lock && (|w_trans2_req))
        r_req2_valid <= 'd1;
    else
        r_req2_valid <= 'd0;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_req2_lock <= 'd0;
    else if(w_next_arbit2)
        r_req2_lock <= 'd0;
    else if(r_req2_valid)
        r_req2_lock <= 'd1;
    else
        r_req2_lock <= r_req2_lock;
end
//arbiter3
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_req3_valid <= 'd0;
    else if(r_req3_valid)
        r_req3_valid <= 'd0;
    else if(!r_req3_lock && (|w_trans3_req))
        r_req3_valid <= 'd1;
    else
        r_req3_valid <= 'd0;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_req3_lock <= 'd0;
    else if(w_next_arbit3)
        r_req3_lock <= 'd0;
    else if(r_req3_valid)
        r_req3_lock <= 'd1;
    else
        r_req3_lock <= r_req3_lock;
end

endmodule
