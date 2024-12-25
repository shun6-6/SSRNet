`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/16 11:25:06
// Design Name: 
// Module Name: DDR_rd_ctrl
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


module DDR_rd_ctrl#(
    parameter integer   C_M_AXI_ADDR_WIDTH	    = 32,
    parameter integer   P_WRITE_DDR_PORT_NUM    = 1 ,
    parameter integer   P_DDR_LOCAL_QUEUE       = 3 ,
    parameter integer   P_P_WRITE_DDR_PORT      = 0 ,
    parameter           P_MAX_ADDR              = 32'h003F_FFFF,
    parameter           P_LOCAL_PORT_NUM        = 2 ,
    parameter           P_UNLOCAL_PORT_NUM      = 2 ,
    parameter           P_QUEUE_NUM             = 8
)(
    input                                           i_clk                   ,
    input                                           i_rst                   ,

    //uplink port0 send data
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_port0_send_local2_pkt_size    ,
    input                                           i_port0_send_local2_valid       ,
    input  [2 : 0]                                  i_port0_send_local2_queue       ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_port0_local_direct_pkt_size   ,
    input                                           i_port0_local_direct_pkt_valid  ,
    input  [2 : 0]                                  i_port0_cur_direct_tor          ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_port0_unlocal_direct_pkt_size ,
    input                                           i_port0_unlocal_direct_pkt_valid,
    input  [2 : 0]                                  i_port0_unlocal_direct_pkt_queue,
    input  [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   i_port0_tx_relay                ,
    input                                           i_port0_tx_relay_valid          ,
    //uplink port1 send data
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_port1_send_local2_pkt_size    ,
    input                                           i_port1_send_local2_valid       ,
    input  [2 : 0]                                  i_port1_send_local2_queue       ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_port1_local_direct_pkt_size   ,
    input                                           i_port1_local_direct_pkt_valid  ,
    input  [2 : 0]                                  i_port1_cur_direct_tor          ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_port1_unlocal_direct_pkt_size ,
    input                                           i_port1_unlocal_direct_pkt_valid,
    input  [2 : 0]                                  i_port1_unlocal_direct_pkt_queue,
    input  [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   i_port1_tx_relay                ,
    input                                           i_port1_tx_relay_valid          ,

    output                                          o_port0_rd_flag             ,
    output [P_DDR_LOCAL_QUEUE - 1 : 0]              o_port0_rd_queue            ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_port0_rd_byte             ,
    output                                          o_port0_rd_byte_valid       ,
    input                                           i_port0_rd_byte_ready       ,
    input                                           i_port0_rd_queue_finish     ,

    output                                          o_port1_rd_flag             ,
    output [P_DDR_LOCAL_QUEUE - 1 : 0]              o_port1_rd_queue            ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_port1_rd_byte             ,
    output                                          o_port1_rd_byte_valid       ,
    input                                           i_port1_rd_byte_ready       ,
    input                                           i_port1_rd_queue_finish     ,

    input                                           i_port0_forward_req         ,
    output                                          o_port0_forward_resp        ,
    input                                           i_port0_forward_finish      ,
    output                                          o_port0_forward_valid       ,

    input                                           i_port1_forward_req         ,
    output                                          o_port1_forward_resp        ,
    input                                           i_port1_forward_finish      ,
    output                                          o_port1_forward_valid
);

rd_ddr_port_ctrl#(
    .C_M_AXI_ADDR_WIDTH	            (C_M_AXI_ADDR_WIDTH	    ),
    .P_WRITE_DDR_PORT_NUM           (P_WRITE_DDR_PORT_NUM   ),
    .P_DDR_LOCAL_QUEUE              (P_DDR_LOCAL_QUEUE      ),
    .P_P_WRITE_DDR_PORT             (P_P_WRITE_DDR_PORT     ),
    .P_MAX_ADDR                     (P_MAX_ADDR             ),
    .P_LOCAL_PORT_NUM               (P_LOCAL_PORT_NUM       ),
    .P_UNLOCAL_PORT_NUM             (P_UNLOCAL_PORT_NUM     ),
    .P_QUEUE_NUM                    (P_QUEUE_NUM            )
)rd_ddr_port_ctrl_u0(
    .i_clk                          (i_clk                  ),
    .i_rst                          (i_rst                  ),

    .i_send_local2_pkt_size         (i_port0_send_local2_pkt_size    ),
    .i_send_local2_valid            (i_port0_send_local2_valid       ),
    .i_send_local2_queue            (i_port0_send_local2_queue       ),
    .i_local_direct_pkt_size        (i_port0_local_direct_pkt_size   ),
    .i_local_direct_pkt_valid       (i_port0_local_direct_pkt_valid  ),
    .i_cur_direct_tor               (i_port0_cur_direct_tor          ),
    .i_unlocal_direct_pkt_size      (i_port0_unlocal_direct_pkt_size ),
    .i_unlocal_direct_pkt_valid     (i_port0_unlocal_direct_pkt_valid),
    .i_unlocal_direct_pkt_queue     (i_port0_unlocal_direct_pkt_queue),
    .i_tx_relay                     (i_port0_tx_relay                ),
    .i_tx_relay_valid               (i_port0_tx_relay_valid          ),

    .o_rd_flag                      (o_port0_rd_flag                ),
    .o_rd_queue                     (o_port0_rd_queue               ),
    .o_rd_byte                      (o_port0_rd_byte                ),
    .o_rd_byte_valid                (o_port0_rd_byte_valid          ),
    .i_rd_byte_ready                (i_port0_rd_byte_ready          ),
    .i_rd_queue_finish              (i_port0_rd_queue_finish        ),

    .i_forward_req                  (i_port0_forward_req            ),
    .o_forward_resp                 (o_port0_forward_resp           ),
    .i_forward_finish               (i_port0_forward_finish         ),
    .o_forward_valid                (o_port0_forward_valid          )
);

rd_ddr_port_ctrl#(
    .C_M_AXI_ADDR_WIDTH	            (C_M_AXI_ADDR_WIDTH	    ),
    .P_WRITE_DDR_PORT_NUM           (P_WRITE_DDR_PORT_NUM   ),
    .P_DDR_LOCAL_QUEUE              (P_DDR_LOCAL_QUEUE      ),
    .P_P_WRITE_DDR_PORT             (P_P_WRITE_DDR_PORT     ),
    .P_MAX_ADDR                     (P_MAX_ADDR             ),
    .P_LOCAL_PORT_NUM               (P_LOCAL_PORT_NUM       ),
    .P_UNLOCAL_PORT_NUM             (P_UNLOCAL_PORT_NUM     ),
    .P_QUEUE_NUM                    (P_QUEUE_NUM            )
)rd_ddr_port_ctrl_u1(
    .i_clk                          (i_clk                  ),
    .i_rst                          (i_rst                  ),

    .i_send_local2_pkt_size         (i_port1_send_local2_pkt_size    ),
    .i_send_local2_valid            (i_port1_send_local2_valid       ),
    .i_send_local2_queue            (i_port1_send_local2_queue       ),
    .i_local_direct_pkt_size        (i_port1_local_direct_pkt_size   ),
    .i_local_direct_pkt_valid       (i_port1_local_direct_pkt_valid  ),
    .i_cur_direct_tor               (i_port1_cur_direct_tor          ),
    .i_unlocal_direct_pkt_size      (i_port1_unlocal_direct_pkt_size ),
    .i_unlocal_direct_pkt_valid     (i_port1_unlocal_direct_pkt_valid),
    .i_unlocal_direct_pkt_queue     (i_port1_unlocal_direct_pkt_queue),
    .i_tx_relay                     (i_port1_tx_relay                ),
    .i_tx_relay_valid               (i_port1_tx_relay_valid          ),

    .o_rd_flag                      (o_port1_rd_flag                ),
    .o_rd_queue                     (o_port1_rd_queue               ),
    .o_rd_byte                      (o_port1_rd_byte                ),
    .o_rd_byte_valid                (o_port1_rd_byte_valid          ),
    .i_rd_byte_ready                (i_port1_rd_byte_ready          ),
    .i_rd_queue_finish              (i_port1_rd_queue_finish        ),

    .i_forward_req                  (i_port1_forward_req            ),
    .o_forward_resp                 (o_port1_forward_resp           ),
    .i_forward_finish               (i_port1_forward_finish         ),
    .o_forward_valid                (o_port1_forward_valid          )
);

endmodule
