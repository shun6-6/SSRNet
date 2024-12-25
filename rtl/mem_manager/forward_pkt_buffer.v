`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 11:13:58
// Design Name: 
// Module Name: forward_pkt_buffer
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


module forward_pkt_buffer(
    input           i_axi0_clk              ,
    input           i_axi0_rst              ,
    input           i_axi1_clk              ,
    input           i_axi1_rst              ,

    output          o_port0_forward_req     ,
    input           i_port0_forward_resp    ,
    output          o_port0_forward_finish  ,
    output          o_port1_forward_req     ,
    input           i_port1_forward_resp    ,
    output          o_port1_forward_finish  ,

    input           s_axis_rx0_tvalid       ,
    input  [63 :0]  s_axis_rx0_tdata        ,
    input           s_axis_rx0_tlast        ,
    input  [7  :0]  s_axis_rx0_tkeep        ,
    input           s_axis_rx0_tuser        ,

    output          m_axis_tx0_tvalid       ,
    output [63 :0]  m_axis_tx0_tdata        ,
    output          m_axis_tx0_tlast        ,
    output [7  :0]  m_axis_tx0_tkeep        ,
    output          m_axis_tx0_tuser        ,
    input           m_axis_tx0_tready       ,

    input           s_axis_rx1_tvalid       ,
    input  [63 :0]  s_axis_rx1_tdata        ,
    input           s_axis_rx1_tlast        ,
    input  [7  :0]  s_axis_rx1_tkeep        ,
    input           s_axis_rx1_tuser        ,

    output          m_axis_tx1_tvalid       ,
    output [63 :0]  m_axis_tx1_tdata        ,
    output          m_axis_tx1_tlast        ,
    output [7  :0]  m_axis_tx1_tkeep        ,
    output          m_axis_tx1_tuser        ,
    input           m_axis_tx1_tready       
);

forward_pkt_module forward_pkt_module_u0(
    .i_clk                  (i_axi0_clk             ),
    .i_rst                  (i_axi0_rst             ),

    .o_forward_req          (o_port0_forward_req    ),
    .i_forward_resp         (i_port0_forward_resp   ),
    .o_forward_finish       (o_port0_forward_finish ),

    .s_axis_tvalid          (s_axis_rx0_tvalid      ),
    .s_axis_tdata           (s_axis_rx0_tdata       ),
    .s_axis_tlast           (s_axis_rx0_tlast       ),
    .s_axis_tkeep           (s_axis_rx0_tkeep       ),
    .s_axis_tuser           (s_axis_rx0_tuser       ),

    .m_axis_tvalid          (m_axis_tx0_tvalid      ),
    .m_axis_tdata           (m_axis_tx0_tdata       ),
    .m_axis_tlast           (m_axis_tx0_tlast       ),
    .m_axis_tkeep           (m_axis_tx0_tkeep       ),
    .m_axis_tuser           (m_axis_tx0_tuser       ),
    .m_axis_tready          (m_axis_tx0_tready      ) 
);

forward_pkt_module forward_pkt_module_u1(
    .i_clk                  (i_axi1_clk             ),
    .i_rst                  (i_axi1_rst             ),

    .o_forward_req          (o_port1_forward_req    ),
    .i_forward_resp         (i_port1_forward_resp   ),
    .o_forward_finish       (o_port1_forward_finish ),

    .s_axis_tvalid          (s_axis_rx1_tvalid      ),
    .s_axis_tdata           (s_axis_rx1_tdata       ),
    .s_axis_tlast           (s_axis_rx1_tlast       ),
    .s_axis_tkeep           (s_axis_rx1_tkeep       ),
    .s_axis_tuser           (s_axis_rx1_tuser       ),

    .m_axis_tvalid          (m_axis_tx1_tvalid      ),
    .m_axis_tdata           (m_axis_tx1_tdata       ),
    .m_axis_tlast           (m_axis_tx1_tlast       ),
    .m_axis_tkeep           (m_axis_tx1_tkeep       ),
    .m_axis_tuser           (m_axis_tx1_tuser       ),
    .m_axis_tready          (m_axis_tx1_tready      )
);

endmodule
