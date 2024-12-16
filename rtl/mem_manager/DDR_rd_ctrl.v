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
    parameter integer   P_DDR_LOCAL_QUEUE       = 4 ,
    parameter integer   P_P_WRITE_DDR_PORT      = 0 ,
    parameter           P_MAX_ADDR              = 32'h003F_FFFF,
    parameter           P_LOCAL_PORT_NUM        = 2 ,
    parameter           P_UNLOCAL_PORT_NUM      = 2 ,
    parameter           P_QUEUE_NUM             = 8
)(
    input                                   i_clk                   ,
    input                                   i_rst                   ,

    //uplink port0 send data
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_port0_local2_pkt_size     ,
    input                                           i_port0_send_local2_valid   ,
    input  [2 : 0]                                  i_port0_cur_direct_tor      ,
    input  [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   i_port0_tx_relay            ,
    input                                           i_port0_tx_relay_valid      ,
    //uplink port1 send data
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_port1_local2_pkt_size     ,
    input                                           i_port1_send_local2_valid   ,
    input  [2 : 0]                                  i_port1_cur_direct_tor      ,
    input  [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   i_port1_tx_relay            ,
    input                                           i_port1_tx_relay_valid      ,

    output                                  o_port0_rd_flag         ,
    output [P_DDR_LOCAL_QUEUE - 1 : 0]      o_port0_rd_queue        ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]       o_port0_rd_byte         ,
    output                                  o_port0_rd_byte_valid   ,
    input                                   i_port0_rd_byte_ready   ,

    output                                  o_port1_rd_flag         ,
    output [P_DDR_LOCAL_QUEUE - 1 : 0]      o_port1_rd_queue        ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]       o_port1_rd_byte         ,
    output                                  o_port1_rd_byte_valid   ,
    input                                   i_port1_rd_byte_ready   
);
endmodule
