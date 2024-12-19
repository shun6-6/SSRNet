`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/19 17:35:24
// Design Name: 
// Module Name: SRRNet_top_tb
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


module SRRNet_top_tb();

reg sys_clk,gt_clk;

always begin
    gt_clk = 0;
    #1.6;
    gt_clk = 1;
    #1.6;
end

always begin
    sys_clk = 0;
    #5;
    sys_clk = 1;
    #5;
end

wire [1:0]  w_tor_0_down_txp;
wire [1:0]  w_tor_0_down_rxp;
wire [1:0]  w_tor_0_down_txn;
wire [1:0]  w_tor_0_down_rxn;
wire [1:0]  w_tor_0_up_txp  ;
wire [1:0]  w_tor_0_up_rxp  ;
wire [1:0]  w_tor_0_up_txn  ;
wire [1:0]  w_tor_0_up_rxn  ;

ToR_DDR_tb#(
    .P_CHANNEL_NUM      (4                    )  ,
    .P_MY_TOR_MAC       (48'h8D_BC_5C_4A_00_00)
)ToR_DDR_tb_u0(
    .i_gt_refclk_p          (gt_clk         ),
    .i_gt_refclk_n          (~gt_clk        ),
    .i_sys_clk_p            (sys_clk        ),
    .i_sys_clk_n            (~sys_clk       ),
    .o_gt_txp               ({w_tor_0_up_txp,w_tor_0_down_txp}),
    .o_gt_txn               ({w_tor_0_up_txn,w_tor_0_down_txn}),
    .i_gt_rxp               ({w_tor_0_up_rxp,w_tor_0_down_rxp}),
    .i_gt_rxn               ({w_tor_0_up_rxn,w_tor_0_down_rxn}),
    .o_sfp_dis              (),
    .i_ctrl_gt_refclk_p     (),
    .i_ctrl_gt_refclk_n     (),
    .o_ctrl_gt_txp          (),
    .o_ctrl_gt_txn          (),
    .i_ctrl_gt_rxp          (),
    .i_ctrl_gt_rxn          (),
    .o_ctrl_sfp_dis         () 
);

endmodule
