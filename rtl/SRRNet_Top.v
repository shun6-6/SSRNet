`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/15 10:19:13
// Design Name: 
// Module Name: SRRNet_Top
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


module SRRNet_Top(

);

localparam  P_CROSSBAR_N = 4;

wire                        s0_axis_rx_tvalid   ;
wire [63 :0]                s0_axis_rx_tdata    ;
wire                        s0_axis_rx_tlast    ;
wire [7  :0]                s0_axis_rx_tkeep    ;
wire                        s0_axis_rx_tuser    ;
wire [2 : 0]                s0_axis_rx_tdest    ;
wire                        m0_axis_tx_tvalid   ;
wire [63 :0]                m0_axis_tx_tdata    ;
wire                        m0_axis_tx_tlast    ;
wire [7  :0]                m0_axis_tx_tkeep    ;
wire                        m0_axis_tx_tuser    ;
wire                        s1_axis_rx_tvalid   ;
wire [63 :0]                s1_axis_rx_tdata    ;
wire                        s1_axis_rx_tlast    ;
wire [7  :0]                s1_axis_rx_tkeep    ;
wire                        s1_axis_rx_tuser    ;
wire [2 : 0]                s1_axis_rx_tdest    ;
wire                        m1_axis_tx_tvalid   ;
wire [63 :0]                m1_axis_tx_tdata    ;
wire                        m1_axis_tx_tlast    ;
wire [7  :0]                m1_axis_tx_tkeep    ;
wire                        m1_axis_tx_tuser    ;
wire                        s2_axis_rx_tvalid   ;
wire [63 :0]                s2_axis_rx_tdata    ;
wire                        s2_axis_rx_tlast    ;
wire [7  :0]                s2_axis_rx_tkeep    ;
wire                        s2_axis_rx_tuser    ;
wire [2 : 0]                s2_axis_rx_tdest    ;
wire                        m2_axis_tx_tvalid   ;
wire [63 :0]                m2_axis_tx_tdata    ;
wire                        m2_axis_tx_tlast    ;
wire [7  :0]                m2_axis_tx_tkeep    ;
wire                        m2_axis_tx_tuser    ;
wire                        s3_axis_rx_tvalid   ;
wire [63 :0]                s3_axis_rx_tdata    ;
wire                        s3_axis_rx_tlast    ;
wire [7  :0]                s3_axis_rx_tkeep    ;
wire                        s3_axis_rx_tuser    ;
wire [2 : 0]                s3_axis_rx_tdest    ;
wire                        m3_axis_tx_tvalid   ;
wire [63 :0]                m3_axis_tx_tdata    ;
wire                        m3_axis_tx_tlast    ;
wire [7  :0]                m3_axis_tx_tkeep    ;
wire                        m3_axis_tx_tuser    ;

crossbar#(
    .P_CROSSBAR_N           (4)        
)crossbar_u0(
    .i_clk                   (i_clk             ),
    .i_rst                   (i_rst             ),

    .s0_axis_rx_tvalid       (s0_axis_rx_tvalid ),
    .s0_axis_rx_tdata        (s0_axis_rx_tdata  ),
    .s0_axis_rx_tlast        (s0_axis_rx_tlast  ),
    .s0_axis_rx_tkeep        (s0_axis_rx_tkeep  ),
    .s0_axis_rx_tuser        (s0_axis_rx_tuser  ),
    .s0_axis_rx_tdest        (s0_axis_rx_tdest  ),
    .m0_axis_tx_tvalid       (m0_axis_tx_tvalid ),
    .m0_axis_tx_tdata        (m0_axis_tx_tdata  ),
    .m0_axis_tx_tlast        (m0_axis_tx_tlast  ),
    .m0_axis_tx_tkeep        (m0_axis_tx_tkeep  ),
    .m0_axis_tx_tuser        (m0_axis_tx_tuser  ),     
    .m0_axis_tx_tready       (m0_axis_tx_tready ),          
    .s1_axis_rx_tvalid       (s1_axis_rx_tvalid ),
    .s1_axis_rx_tdata        (s1_axis_rx_tdata  ),
    .s1_axis_rx_tlast        (s1_axis_rx_tlast  ),
    .s1_axis_rx_tkeep        (s1_axis_rx_tkeep  ),
    .s1_axis_rx_tuser        (s1_axis_rx_tuser  ),
    .s1_axis_rx_tdest        (s1_axis_rx_tdest  ),
    .m1_axis_tx_tvalid       (m1_axis_tx_tvalid ),
    .m1_axis_tx_tdata        (m1_axis_tx_tdata  ),
    .m1_axis_tx_tlast        (m1_axis_tx_tlast  ),
    .m1_axis_tx_tkeep        (m1_axis_tx_tkeep  ),
    .m1_axis_tx_tuser        (m1_axis_tx_tuser  ),
    .m1_axis_tx_tready       (m1_axis_tx_tready ),    
    .s2_axis_rx_tvalid       (s2_axis_rx_tvalid ),
    .s2_axis_rx_tdata        (s2_axis_rx_tdata  ),
    .s2_axis_rx_tlast        (s2_axis_rx_tlast  ),
    .s2_axis_rx_tkeep        (s2_axis_rx_tkeep  ),
    .s2_axis_rx_tuser        (s2_axis_rx_tuser  ),
    .s2_axis_rx_tdest        (s2_axis_rx_tdest  ),
    .m2_axis_tx_tvalid       (m2_axis_tx_tvalid ),
    .m2_axis_tx_tdata        (m2_axis_tx_tdata  ),
    .m2_axis_tx_tlast        (m2_axis_tx_tlast  ),
    .m2_axis_tx_tkeep        (m2_axis_tx_tkeep  ),
    .m2_axis_tx_tuser        (m2_axis_tx_tuser  ),
    .m2_axis_tx_tready       (m2_axis_tx_tready ),    
    .s3_axis_rx_tvalid       (s3_axis_rx_tvalid ),
    .s3_axis_rx_tdata        (s3_axis_rx_tdata  ),
    .s3_axis_rx_tlast        (s3_axis_rx_tlast  ),
    .s3_axis_rx_tkeep        (s3_axis_rx_tkeep  ),
    .s3_axis_rx_tuser        (s3_axis_rx_tuser  ),
    .s3_axis_rx_tdest        (s3_axis_rx_tdest  ),
    .m3_axis_tx_tvalid       (m3_axis_tx_tvalid ),
    .m3_axis_tx_tdata        (m3_axis_tx_tdata  ),
    .m3_axis_tx_tlast        (m3_axis_tx_tlast  ),
    .m3_axis_tx_tkeep        (m3_axis_tx_tkeep  ),
    .m3_axis_tx_tuser        (m3_axis_tx_tuser  ),
    .m3_axis_tx_tready       (m3_axis_tx_tready )
); 


endmodule
