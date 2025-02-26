`timescale 1ps/1ps
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
    #1600;
    gt_clk = 1;
    #1600;
end

always begin
    sys_clk = 0;
    #5000;
    sys_clk = 1;
    #5000;
end

wire [7:0]  w_tor_ctrl_txp  ;
wire [7:0]  w_tor_ctrl_txn  ;
wire [7:0]  w_tor_ctrl_rxp  ;
wire [7:0]  w_tor_ctrl_rxn  ;

wire [7:0]  w_tor_up0_txp   ;
wire [7:0]  w_tor_up0_txn   ;
wire [7:0]  w_tor_up0_rxp   ;
wire [7:0]  w_tor_up0_rxn   ;

wire [7:0]  w_tor_up1_txp   ;
wire [7:0]  w_tor_up1_txn   ;
wire [7:0]  w_tor_up1_rxp   ;
wire [7:0]  w_tor_up1_rxn   ;

wire        w_slot_id       ;

/*控制器有8个channel，连接8个ToR，当对应连接的所有的ToR的链路
状态稳定后，第一个时隙开始，下发一个仿真开始指令给所有ToR，
所有ToR下行连接的server开始产生数据，等待一个完整的时隙后，开始切换
ocs状态，等待切换时延结束后，下发一次时间同步，标志一次全新的时隙开始
时隙一次最多传输8KByte数据，所需时间1024 x 6.4 = 6us
仿真暂定配置时延0.8微妙（234 clk），时隙持续8（1200 clk）微妙，具体修改需要控制VLB模块的
P_SLOT_MAX_BYTE_NUM参数
*/

//9:1
// localparam  P_CONFIG_DELAY      = 32'h0000_00AA;//1us
// localparam  P_SLOT_LEN          = 32'h0000_0680;//10us
// localparam  P_SLOT_MAX_BYTE_NUM = 32'h0000_2000;//8KBytes //time + 4.5us(700 clk)

localparam  P_CONFIG_DELAY      = 32'h0000_00AA;//1us
localparam  P_SLOT_LEN          = 32'h0000_0753;//11us
localparam  P_SLOT_MAX_BYTE_NUM = 32'h0000_2000;//8KBytes //time + 4.5us(700 clk)


reg [127:0] r_state_monitor;
localparam  P_S_IDLE = 0;
localparam  P_S_WAIT_S_TS   =   1;
localparam  P_S_RETURN_TS   =   2;
localparam  P_S_SEND_M_STD  =   3;
always@(*)begin
  case(OCS_controller_u0.ocs_ctrl_trx_port_0.r_cur_m_state)
        P_S_WAIT_S_TS  : r_state_monitor = "WAIT_S_TS";
        P_S_RETURN_TS  : r_state_monitor = "RETURN_TS";
        P_S_SEND_M_STD : r_state_monitor = "SEND_M_STD";
    default         : r_state_monitor = "IDLE";
  endcase
end

OCS_controller#(
    .P_CHANNEL_NUM      (8              ),
    .P_MIN_LENGTH       (8'd64          ),
    .P_MAX_LENGTH       (15'd9600       ),
    .P_CONFIG_DELAY     (P_CONFIG_DELAY ),
    .P_SLOT_LEN         (P_SLOT_LEN     ) 
)OCS_controller_u0(
    .i_gt_0_refclk_p    (gt_clk         ),
    .i_gt_0_refclk_n    (~gt_clk        ),
    .i_gt_1_refclk_p    (gt_clk         ),
    .i_gt_1_refclk_n    (~gt_clk        ),
    .i_sys_clk_p        (sys_clk        ),
    .i_sys_clk_n        (~sys_clk       ),
    .o_gt_txp           (w_tor_ctrl_rxp ),
    .o_gt_txn           (w_tor_ctrl_rxn ),
    .i_gt_rxp           (w_tor_ctrl_txp ),
    .i_gt_rxn           (w_tor_ctrl_txn ),
    .o_sfp_dis          (),
    .o_slot_id          (w_slot_id  )
);

OCS0_module OCS0_module_u(
    .i_slot_id      (w_slot_id      ),
    .i_tor_txp      (w_tor_up0_txp  ),
    .i_tor_txn      (w_tor_up0_txn  ),
    .o_tor_rxp      (w_tor_up0_rxp  ),
    .o_tor_rxn      (w_tor_up0_rxn  ) 
);

OCS1_module OCS1_module_u(
    .i_slot_id      (w_slot_id      ),
    .i_tor_txp      (w_tor_up1_txp  ),
    .i_tor_txn      (w_tor_up1_txn  ),
    .o_tor_rxp      (w_tor_up1_rxp  ),
    .o_tor_rxn      (w_tor_up1_rxn  ) 
);

genvar i;
generate
    for(i = 0; i < 8; i = i + 1) begin : gen_loop
        ToR_DDR_tb#(
            .P_CHANNEL_NUM          (3),
            .P_MY_TOR_MAC           ({8'h8D, 8'hBC, 8'h5C, 8'h4A, i[7:0], 8'h00}),  // 修改此行
            .P_RANDOM_SEED          ({4'ha,i[3:0]}),
            .P_SLOT_MAX_BYTE_NUM    (P_SLOT_MAX_BYTE_NUM)
        )ToR_DDR_tb_u0(
            .i_gt_refclk_p          (gt_clk         ),
            .i_gt_refclk_n          (~gt_clk        ),
            .i_sys_clk_p            (sys_clk        ),
            .i_sys_clk_n            (~sys_clk       ),
            .o_gt_txp               ({w_tor_ctrl_txp[i], w_tor_up1_txp[i], w_tor_up0_txp[i]}),  // 修改索引
            .o_gt_txn               ({w_tor_ctrl_txn[i], w_tor_up1_txn[i], w_tor_up0_txn[i]}),  // 修改索引
            .i_gt_rxp               ({w_tor_ctrl_rxp[i], w_tor_up1_rxp[i], w_tor_up0_rxp[i]}),  // 修改索引
            .i_gt_rxn               ({w_tor_ctrl_rxn[i], w_tor_up1_rxn[i], w_tor_up0_rxn[i]}),  // 修改索引
            .o_sfp_dis              ()
        );
    end
endgenerate


endmodule
