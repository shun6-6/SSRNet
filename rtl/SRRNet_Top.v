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


module SRRNet_Top#(
    parameter                   P_CHANNEL_NUM   = 3 ,
    parameter                   P_MY_TOR_MAC    = 48'h8D_BC_5C_4A_00_00
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
    // input                       i_ctrl_gt_refclk_p  ,
    // input                       i_ctrl_gt_refclk_n  ,
    // output                      o_ctrl_gt_txp       ,
    // output                      o_ctrl_gt_txn       ,
    // input                       i_ctrl_gt_rxp       ,
    // input                       i_ctrl_gt_rxn       ,
    // output                      o_ctrl_sfp_dis      ,

    input                       sys_rst             ,
    output                      C0_DDR4_0_act_n     ,
    output [16:0]               C0_DDR4_0_adr       ,
    output [1:0]                C0_DDR4_0_ba        ,
    output                      C0_DDR4_0_bg        ,
    output                      C0_DDR4_0_ck_c      ,
    output                      C0_DDR4_0_ck_t      ,
    output                      C0_DDR4_0_cke       ,
    output [1:0]                C0_DDR4_0_cs_n      ,
    inout [8:0]                 C0_DDR4_0_dm_n      ,
    inout [71:0]                C0_DDR4_0_dq        ,
    inout [8:0]                 C0_DDR4_0_dqs_c     ,
    inout [8:0]                 C0_DDR4_0_dqs_t     ,
    output                      C0_DDR4_0_odt       ,
    output                      C0_DDR4_0_reset_n   
);

localparam  P_CROSSBAR_N = 4;

wire    w_dclk              ;
wire    w_sys_reset         ;

wire    w_0_tx_clk_out      ;
wire    w_0_rx_clk_out      ;
wire    w_0_user_tx_reset   ;
wire    w_0_user_rx_reset   ;
wire    w_0_stat_rx_status  ;
wire    w_1_tx_clk_out      ;
wire    w_1_rx_clk_out      ;
wire    w_1_user_tx_reset   ;
wire    w_1_user_rx_reset   ;
wire    w_1_stat_rx_status  ;
wire    w_2_tx_clk_out      ;
wire    w_2_rx_clk_out      ;
wire    w_2_user_tx_reset   ;
wire    w_2_user_rx_reset   ;
wire    w_2_stat_rx_status  ;
wire    w_3_tx_clk_out      ;
wire    w_3_rx_clk_out      ;
wire    w_3_user_tx_reset   ;
wire    w_3_user_rx_reset   ;
wire    w_3_stat_rx_status  ;

wire    w_ctrl_tx_clk_out    ;
wire    w_ctrl_rx_clk_out    ;
wire    w_ctrl_user_tx_reset ;
wire    w_ctrl_user_rx_reset ;
wire    w_ctrl_stat_rx_status;
//eth data
wire            tx0_axis_tready     ;
wire            tx0_axis_tvalid     ;
wire [63 :0]    tx0_axis_tdata      ;
wire            tx0_axis_tlast      ;
wire [7  :0]    tx0_axis_tkeep      ;
wire            tx0_axis_tuser      ;
wire            m_rx0_axis_tvalid   ;
wire [63 :0]    m_rx0_axis_tdata    ;
wire            m_rx0_axis_tlast    ;
wire [7  :0]    m_rx0_axis_tkeep    ;
wire            m_rx0_axis_tuser    ;
wire [2 : 0]    m_rx0_axis_tdest    ;
wire            tx1_axis_tready     ;
wire            tx1_axis_tvalid     ;
wire [63 :0]    tx1_axis_tdata      ;
wire            tx1_axis_tlast      ;
wire [7  :0]    tx1_axis_tkeep      ;
wire            tx1_axis_tuser      ;
wire            m_rx1_axis_tvalid   ;
wire [63 :0]    m_rx1_axis_tdata    ;
wire            m_rx1_axis_tlast    ;
wire [7  :0]    m_rx1_axis_tkeep    ;
wire            m_rx1_axis_tuser    ;
wire [2 : 0]    m_rx1_axis_tdest    ;
wire            tx2_axis_tready     ;
wire            tx2_axis_tvalid     ;
wire [63 :0]    tx2_axis_tdata      ;
wire            tx2_axis_tlast      ;
wire [7  :0]    tx2_axis_tkeep      ;
wire            tx2_axis_tuser      ;
wire            m_rx2_axis_tvalid   ;
wire [63 :0]    m_rx2_axis_tdata    ;
wire            m_rx2_axis_tlast    ;
wire [7  :0]    m_rx2_axis_tkeep    ;
wire            m_rx2_axis_tuser    ;
wire [2 : 0]    m_rx2_axis_tdest    ;
wire            tx3_axis_tready     ;
wire            tx3_axis_tvalid     ;
wire [63 :0]    tx3_axis_tdata      ;
wire            tx3_axis_tlast      ;
wire [7  :0]    tx3_axis_tkeep      ;
wire            tx3_axis_tuser      ;
wire            m_rx3_axis_tvalid   ;
wire [63 :0]    m_rx3_axis_tdata    ;
wire            m_rx3_axis_tlast    ;
wire [7  :0]    m_rx3_axis_tkeep    ;
wire            m_rx3_axis_tuser    ;
wire [2 : 0]    m_rx3_axis_tdest    ;
//block design
wire [31:0]                 w_rd_ddr_addr_0;
wire [31:0]                 w_rd_ddr_addr_1;
wire [31:0]                 w_rd_ddr_addr_2;
wire [31:0]                 w_rd_ddr_addr_3;
wire [15:0]                 w_rd_ddr_len_0;
wire [15:0]                 w_rd_ddr_len_1;
wire [15:0]                 w_rd_ddr_len_2;
wire [15:0]                 w_rd_ddr_len_3;
wire [7:0]                  w_rd_ddr_strb_0;
wire [7:0]                  w_rd_ddr_strb_1;
wire [7:0]                  w_rd_ddr_strb_2;
wire [7:0]                  w_rd_ddr_strb_3;
wire                        w_rd_ddr_valid_0;
wire                        w_rd_ddr_valid_1;
wire                        w_rd_ddr_valid_2;
wire                        w_rd_ddr_valid_3;
wire [31:0]                 w_wr_ddr_addr_0;
wire [31:0]                 w_wr_ddr_addr_1;
wire [31:0]                 w_wr_ddr_addr_2;
wire [31:0]                 w_wr_ddr_addr_3;
wire                        w_wr_ddr_cpl_ready_0;
wire                        w_wr_ddr_cpl_ready_1;
wire                        w_wr_ddr_cpl_ready_2;
wire                        w_wr_ddr_cpl_ready_3;
wire                        w_wr_ddr_ready_0;
wire                        w_wr_ddr_ready_1;
wire                        w_wr_ddr_ready_2;
wire                        w_wr_ddr_ready_3;

wire                        w_rd_ddr_cpl_0          ;
wire                        w_rd_ddr_cpl_1          ;
wire                        w_rd_ddr_cpl_2          ;
wire                        w_rd_ddr_cpl_3          ;
wire                        w_rd_ddr_ready_0        ;
wire                        w_rd_ddr_ready_1        ;
wire                        w_rd_ddr_ready_2        ;
wire                        w_rd_ddr_ready_3        ;
wire [31:0]                 w_wr_ddr_cpl_addr_0     ;
wire [31:0]                 w_wr_ddr_cpl_addr_1     ;
wire [31:0]                 w_wr_ddr_cpl_addr_2     ;
wire [31:0]                 w_wr_ddr_cpl_addr_3     ;
wire [15:0]                 w_wr_ddr_cpl_len_0      ;
wire [15:0]                 w_wr_ddr_cpl_len_1      ;
wire [15:0]                 w_wr_ddr_cpl_len_2      ;
wire [15:0]                 w_wr_ddr_cpl_len_3      ;
wire [3:0]                  w_wr_ddr_cpl_queue_0    ;
wire [3:0]                  w_wr_ddr_cpl_queue_1    ;
wire [3:0]                  w_wr_ddr_cpl_queue_2    ;
wire [3:0]                  w_wr_ddr_cpl_queue_3    ;
wire [7:0]                  w_wr_ddr_cpl_strb_0     ;
wire [7:0]                  w_wr_ddr_cpl_strb_1     ;
wire [7:0]                  w_wr_ddr_cpl_strb_2     ;
wire [7:0]                  w_wr_ddr_cpl_strb_3     ;
wire                        w_wr_ddr_cpl_valid_0    ;
wire                        w_wr_ddr_cpl_valid_1    ;
wire                        w_wr_ddr_cpl_valid_2    ;
wire                        w_wr_ddr_cpl_valid_3    ;
wire [15:0]                 w_wr_ddr_len_0          ;
wire [15:0]                 w_wr_ddr_len_1          ;
wire [15:0]                 w_wr_ddr_len_2          ;
wire [15:0]                 w_wr_ddr_len_3          ;
wire [3:0]                  w_wr_ddr_queue_0        ;
wire [3:0]                  w_wr_ddr_queue_1        ;
wire [3:0]                  w_wr_ddr_queue_2        ;
wire [3:0]                  w_wr_ddr_queue_3        ;
wire                        w_wr_ddr_valid_0        ;
wire                        w_wr_ddr_valid_1        ;
wire                        w_wr_ddr_valid_2        ;
wire                        w_wr_ddr_valid_3        ;
//ddr memory manager
wire  [63:0]                m_axis_0_tdata          ;
wire  [7 :0]                m_axis_0_tkeep          ;
wire                        m_axis_0_tlast          ;
wire                        m_axis_0_tready         ;
wire                        m_axis_0_tuser          ;
wire                        m_axis_0_tvalid         ;
wire  [63:0]                m_axis_1_tdata          ;
wire  [7 :0]                m_axis_1_tkeep          ;
wire                        m_axis_1_tlast          ;
wire                        m_axis_1_tready         ;
wire                        m_axis_1_tuser          ;
wire                        m_axis_1_tvalid         ;
wire  [63:0]                m_axis_2_tdata          ;
wire  [7 :0]                m_axis_2_tkeep          ;
wire                        m_axis_2_tlast          ;
wire                        m_axis_2_tready         ;
wire                        m_axis_2_tuser          ;
wire                        m_axis_2_tvalid         ;
wire  [63:0]                m_axis_3_tdata          ;
wire  [7 :0]                m_axis_3_tkeep          ;
wire                        m_axis_3_tlast          ;
wire                        m_axis_3_tready         ;
wire                        m_axis_3_tuser          ;
wire                        m_axis_3_tvalid         ;
//ctrl axis
wire                        s_ctrl_axis_tvalid    ;
wire  [63:0]                s_ctrl_axis_tdata     ;
wire                        s_ctrl_axis_tlast     ;
wire  [7 :0]                s_ctrl_axis_tkeep     ;
wire                        s_ctrl_axis_tuser     ;

wire                        s_ctrl_0_axis_tvalid  ;
wire  [63:0]                s_ctrl_0_axis_tdata   ;
wire                        s_ctrl_0_axis_tlast   ;
wire  [7 :0]                s_ctrl_0_axis_tkeep   ;
wire                        s_ctrl_0_axis_tuser   ;
wire                        s_ctrl_1_axis_tvalid  ;
wire  [63:0]                s_ctrl_1_axis_tdata   ;
wire                        s_ctrl_1_axis_tlast   ;
wire  [7 :0]                s_ctrl_1_axis_tkeep   ;
wire                        s_ctrl_1_axis_tuser   ;

//queue manager
wire                        w_check_queue_req_valid ;
wire                        w_check_queue_resp_ready;
wire  [255:0]               w_local_queue_size      ;
wire  [255:0]               w_unlocal_queue_size    ;

//ddr read ctrl
wire                        w_rd_unlocal_port0_flag         ;
wire [8 - 1 : 0]            w_rd_unlocal_port0_queue        ;
wire [32-1 : 0]             w_rd_unlocal_port0_byte         ;
wire                        w_rd_unlocal_port0_byte_valid   ;
wire                        w_rd_unlocal_port0_finish       ;
wire                        w_rd_unlocal_port0_byte_ready   ;

wire                        w_rd_unlocal_port1_flag         ;
wire [8 - 1 : 0]            w_rd_unlocal_port1_queue        ;
wire [32-1 : 0]             w_rd_unlocal_port1_byte         ;
wire                        w_rd_unlocal_port1_byte_valid   ;
wire                        w_rd_unlocal_port1_finish       ;
wire                        w_rd_unlocal_port1_byte_ready   ;

wire [32-1 : 0]             w_port0_send_local2_pkt_size    ;
wire                        w_port0_send_local2_valid       ;
wire [2 : 0]                w_port0_send_local2_queue       ;
wire [32-1 : 0]             w_port0_local_direct_pkt_size   ;
wire [32-1 : 0]             w_port0_local_direct_pkt_valid  ;
wire [2 : 0]                w_port0_cur_direct_tor          ;
wire [32-1 : 0]             w_port0_unlocal_direct_pkt_size ;
wire [32-1 : 0]             w_port0_unlocal_direct_pkt_valid;
wire [2 : 0]                w_port0_unlocal_direct_pkt_queue;
wire [255 : 0]              w_port0_tx_relay                ;
wire                        w_port0_tx_relay_valid          ;

wire [32-1 : 0]             w_port1_send_local2_pkt_size    ;
wire                        w_port1_send_local2_valid       ;
wire [2 : 0]                w_port1_send_local2_queue       ;
wire [32-1 : 0]             w_port1_local_direct_pkt_size   ;
wire [32-1 : 0]             w_port1_local_direct_pkt_valid  ;
wire [2 : 0]                w_port1_cur_direct_tor          ;
wire [32-1 : 0]             w_port1_unlocal_direct_pkt_size ;
wire [32-1 : 0]             w_port1_unlocal_direct_pkt_valid;
wire [2 : 0]                w_port1_unlocal_direct_pkt_queue;
wire [255 : 0]              w_port1_tx_relay                ;
wire                        w_port1_tx_relay_valid          ;

wire                        w_port0_forward_req             ;
wire                        w_port0_forward_resp            ;
wire                        w_port0_forward_finish          ;
wire                        w_port0_forward_valid           ;
wire                        w_port1_forward_req             ;
wire                        w_port1_forward_resp            ;
wire                        w_port1_forward_finish          ;
wire                        w_port1_forward_valid           ;

//ctrl
wire [63:0]                 w_local_time    ;
wire                        w_cur_slot_id   ;
wire                        w_slot_start    ;


//uplink send data
wire                        uplink0_tx_axis_tvalid          ;
wire [63:0]                 uplink0_tx_axis_tdata           ;
wire                        uplink0_tx_axis_tlast           ;
wire [7 :0]                 uplink0_tx_axis_tkeep           ;
wire                        uplink0_tx_axis_tuser           ;

wire                        uplink1_tx_axis_tvalid          ;
wire [63:0]                 uplink1_tx_axis_tdata           ;
wire                        uplink1_tx_axis_tlast           ;
wire [7 :0]                 uplink1_tx_axis_tkeep           ;
wire                        uplink1_tx_axis_tuser           ;

//forward pkt
wire                        w_port0_forward_axis_tvalid     ;
wire [63:0]                 w_port0_forward_axis_tdata      ;
wire                        w_port0_forward_axis_tlast      ;
wire [7 :0]                 w_port0_forward_axis_tkeep      ;
wire                        w_port0_forward_axis_tuser      ;
wire                        w_port0_forward_axis_tready     ;

wire                        w_port1_forward_axis_tvalid     ;
wire [63:0]                 w_port1_forward_axis_tdata      ;
wire                        w_port1_forward_axis_tlast      ;
wire [7 :0]                 w_port1_forward_axis_tkeep      ;
wire                        w_port1_forward_axis_tuser      ;
wire                        w_port1_forward_axis_tready     ;

wire w_sim_start;

/*  控制器接口，接收来自控制器的消息，控制器消息包括时隙指示数据包
    以及时间同步数据包*/
// eth_10g_ctrl_top#(
//     .P_CHANNEL_NUM          (1                      ),
//     .P_MIN_LENGTH           (8'd64                  ),
//     .P_MAX_LENGTH           (15'd9600               )
// )eth_10g_ctrl_link( 
//     .i_gt_refclk_p          (i_ctrl_gt_refclk_p     ),
//     .i_gt_refclk_n          (i_ctrl_gt_refclk_n     ),
//     .o_gt_txp               (o_ctrl_gt_txp          ),
//     .o_gt_txn               (o_ctrl_gt_txn          ),
//     .i_gt_rxp               (i_ctrl_gt_rxp          ),
//     .i_gt_rxn               (i_ctrl_gt_rxn          ),
//     .o_sfp_dis              (o_ctrl_sfp_dis         ),
//     .i_dclk                 (w_dclk                 ),
//     .i_sys_reset            (w_sys_reset            ),
//     .o_0_tx_clk_out         (w_ctrl_tx_clk_out      ),
//     .o_0_rx_clk_out         (w_ctrl_rx_clk_out      ),
//     .o_0_user_tx_reset      (w_ctrl_user_tx_reset   ),
//     .o_0_user_rx_reset      (w_ctrl_user_rx_reset   ),
//     .o_0_stat_rx_status     (w_ctrl_stat_rx_status  ),
//     .tx0_axis_tready        (tx_ctrl_axis_tready    ),
//     .tx0_axis_tvalid        (tx_ctrl_axis_tvalid    ),
//     .tx0_axis_tdata         (tx_ctrl_axis_tdata     ),
//     .tx0_axis_tlast         (tx_ctrl_axis_tlast     ),
//     .tx0_axis_tkeep         (tx_ctrl_axis_tkeep     ),
//     .tx0_axis_tuser         (tx_ctrl_axis_tuser     ),
//     .rx0_axis_tvalid        (s_ctrl_axis_tvalid     ),
//     .rx0_axis_tdata         (s_ctrl_axis_tdata      ),
//     .rx0_axis_tlast         (s_ctrl_axis_tlast      ),
//     .rx0_axis_tkeep         (s_ctrl_axis_tkeep      ),
//     .rx0_axis_tuser         (s_ctrl_axis_tuser      )
// );

/*  10G以太网高速接口处理模块，接收10G数据，并且完成查表等操作，
    将数据按照本地、非本地、控制信息等不同种类进行分类,
    下行链路通过本地server模块代替，因此暂时只需要俩个
    上行链路数据以太网和一个控制以太网接口即可*/
VCU128_10g_eth_top#(
    .P_CHANNEL_NUM          (P_CHANNEL_NUM      ),
    .P_MIN_LENGTH           (8'd64              ),
    .P_MAX_LENGTH           (15'd9600           ),
    .P_MY_TOR_MAC           (P_MY_TOR_MAC       )
)VCU128_10g_eth_data_ctrl_link( 
    .i_gt_refclk_p          (i_gt_refclk_p      ),
    .i_gt_refclk_n          (i_gt_refclk_n      ),
    .i_sys_clk_p            (i_sys_clk_p        ),
    .i_sys_clk_n            (i_sys_clk_n        ),
    .o_gt_txp               (o_gt_txp           ),
    .o_gt_txn               (o_gt_txn           ),
    .i_gt_rxp               (i_gt_rxp           ),
    .i_gt_rxn               (i_gt_rxn           ),
    .o_sfp_dis              (o_sfp_dis          ),
    .i_sim_start            (w_sim_start        ),
    .o_0_tx_clk_out         (w_0_tx_clk_out     ),
    .o_0_rx_clk_out         (w_0_rx_clk_out     ),
    .o_0_user_tx_reset      (w_0_user_tx_reset  ),
    .o_0_user_rx_reset      (w_0_user_rx_reset  ),
    .o_0_stat_rx_status     (w_0_stat_rx_status ),
    .tx0_axis_tready        (tx0_axis_tready    ),
    .tx0_axis_tvalid        (tx0_axis_tvalid    ),
    .tx0_axis_tdata         (tx0_axis_tdata     ),
    .tx0_axis_tlast         (tx0_axis_tlast     ),
    .tx0_axis_tkeep         (tx0_axis_tkeep     ),
    .tx0_axis_tuser         (tx0_axis_tuser     ),
    .m_rx0_axis_tvalid      (m_rx0_axis_tvalid  ),
    .m_rx0_axis_tdata       (m_rx0_axis_tdata   ),
    .m_rx0_axis_tlast       (m_rx0_axis_tlast   ),
    .m_rx0_axis_tkeep       (m_rx0_axis_tkeep   ),
    .m_rx0_axis_tuser       (m_rx0_axis_tuser   ),
    .m_rx0_axis_tdest       (m_rx0_axis_tdest   ),

    .o_1_tx_clk_out         (w_1_tx_clk_out     ),
    .o_1_rx_clk_out         (w_1_rx_clk_out     ),
    .o_1_user_tx_reset      (w_1_user_tx_reset  ),
    .o_1_user_rx_reset      (w_1_user_rx_reset  ),
    .o_1_stat_rx_status     (w_1_stat_rx_status ),
    .tx1_axis_tready        (tx1_axis_tready    ),
    .tx1_axis_tvalid        (tx1_axis_tvalid    ),
    .tx1_axis_tdata         (tx1_axis_tdata     ),
    .tx1_axis_tlast         (tx1_axis_tlast     ),
    .tx1_axis_tkeep         (tx1_axis_tkeep     ),
    .tx1_axis_tuser         (tx1_axis_tuser     ),
    .m_rx1_axis_tvalid      (m_rx1_axis_tvalid  ),
    .m_rx1_axis_tdata       (m_rx1_axis_tdata   ),
    .m_rx1_axis_tlast       (m_rx1_axis_tlast   ),
    .m_rx1_axis_tkeep       (m_rx1_axis_tkeep   ),
    .m_rx1_axis_tuser       (m_rx1_axis_tuser   ),
    .m_rx1_axis_tdest       (m_rx1_axis_tdest   ),

    .o_2_tx_clk_out         (w_2_tx_clk_out     ),
    .o_2_rx_clk_out         (w_2_rx_clk_out     ),
    .o_2_user_tx_reset      (w_2_user_tx_reset  ),
    .o_2_user_rx_reset      (w_2_user_rx_reset  ),
    .o_2_stat_rx_status     (w_2_stat_rx_status ),
    .tx2_axis_tready        (tx2_axis_tready    ),
    .tx2_axis_tvalid        (tx2_axis_tvalid    ),
    .tx2_axis_tdata         (tx2_axis_tdata     ),
    .tx2_axis_tlast         (tx2_axis_tlast     ),
    .tx2_axis_tkeep         (tx2_axis_tkeep     ),
    .tx2_axis_tuser         (tx2_axis_tuser     ),
    .m_rx2_axis_tvalid      (m_rx2_axis_tvalid  ),
    .m_rx2_axis_tdata       (m_rx2_axis_tdata   ),
    .m_rx2_axis_tlast       (m_rx2_axis_tlast   ),
    .m_rx2_axis_tkeep       (m_rx2_axis_tkeep   ),
    .m_rx2_axis_tuser       (m_rx2_axis_tuser   ),
    .m_rx2_axis_tdest       (m_rx2_axis_tdest   ),

    .o_3_tx_clk_out         (w_3_tx_clk_out     ),
    .o_3_rx_clk_out         (w_3_rx_clk_out     ),
    .o_3_user_tx_reset      (w_3_user_tx_reset  ),
    .o_3_user_rx_reset      (w_3_user_rx_reset  ),
    .o_3_stat_rx_status     (w_3_stat_rx_status ),
    .tx3_axis_tready        (tx3_axis_tready    ),
    .tx3_axis_tvalid        (tx3_axis_tvalid    ),
    .tx3_axis_tdata         (tx3_axis_tdata     ),
    .tx3_axis_tlast         (tx3_axis_tlast     ),
    .tx3_axis_tkeep         (tx3_axis_tkeep     ),
    .tx3_axis_tuser         (tx3_axis_tuser     ),
    .m_rx3_axis_tvalid      (m_rx3_axis_tvalid  ),
    .m_rx3_axis_tdata       (m_rx3_axis_tdata   ),
    .m_rx3_axis_tlast       (m_rx3_axis_tlast   ),
    .m_rx3_axis_tkeep       (m_rx3_axis_tkeep   ),
    .m_rx3_axis_tuser       (m_rx3_axis_tuser   ),
    .m_rx3_axis_tdest       (m_rx3_axis_tdest   ),

    .o_ctrl_tx_clk_out      (w_ctrl_tx_clk_out    ),
    .o_ctrl_rx_clk_out      (w_ctrl_rx_clk_out    ),
    .o_ctrl_user_tx_reset   (w_ctrl_user_tx_reset ),
    .o_ctrl_user_rx_reset   (w_ctrl_user_rx_reset ),
    .o_ctrl_stat_rx_status  (w_ctrl_stat_rx_status),
    .tx_ctrl_axis_tready    (tx_ctrl_axis_tready  ),
    .tx_ctrl_axis_tvalid    (tx_ctrl_axis_tvalid  ),
    .tx_ctrl_axis_tdata     (tx_ctrl_axis_tdata   ),
    .tx_ctrl_axis_tlast     (tx_ctrl_axis_tlast   ),
    .tx_ctrl_axis_tkeep     (tx_ctrl_axis_tkeep   ),
    .tx_ctrl_axis_tuser     (tx_ctrl_axis_tuser   ),
    .s_ctrl_axis_tvalid     (s_ctrl_axis_tvalid   ),
    .s_ctrl_axis_tdata      (s_ctrl_axis_tdata    ),
    .s_ctrl_axis_tlast      (s_ctrl_axis_tlast    ),
    .s_ctrl_axis_tkeep      (s_ctrl_axis_tkeep    ),
    .s_ctrl_axis_tuser      (s_ctrl_axis_tuser    ),

    .i_port0_connect_tor    (w_port0_cur_direct_tor),
    .i_port1_connect_tor    (w_port1_cur_direct_tor)
);

/*  时间同步模块，在一次时隙开始的时候，控制器会下发一次时隙编号
    给所有TOR，收到时隙编号后开始进行时间同步，同步结束后即标志着
    一次时隙开始*/
Time_syn_module#(
    .P_MASTER_TIME_PORT     (0       )   ,
    .P_SLAVER_TIME_PORT     (1       )   ,
    .P_SLOT_ID_TYPE         (16'hff03)
)Time_syn_module_u0(
    .i_clk                  (w_ctrl_tx_clk_out      ),
    .i_rst                  (w_ctrl_user_rx_reset   ),

    .i_stat_rx_status       (w_ctrl_stat_rx_status  ),
    .i_select_std_port      ('d0),//选取该节点作为标准时间节点
    .o_local_time           (w_local_time           ),
    .o_cur_slot_id          (w_cur_slot_id          ),
    .o_slot_start           (w_slot_start           ),
    .o_sim_start            (w_sim_start            ),

    .i_tx_axis_tready       (tx_ctrl_axis_tready    ),
    .o_tx_axis_tvalid       (tx_ctrl_axis_tvalid    ),
    .o_tx_axis_tdata        (tx_ctrl_axis_tdata     ),
    .o_tx_axis_tlast        (tx_ctrl_axis_tlast     ),
    .o_tx_axis_tkeep        (tx_ctrl_axis_tkeep     ),
    .o_tx_axis_tuser        (tx_ctrl_axis_tuser     ),
    .i_rx_axis_tvalid       (s_ctrl_axis_tvalid     ),
    .i_rx_axis_tdata        (s_ctrl_axis_tdata      ),
    .i_rx_axis_tlast        (s_ctrl_axis_tlast      ),
    .i_rx_axis_tkeep        (s_ctrl_axis_tkeep      ),
    .i_rx_axis_tuser        (s_ctrl_axis_tuser      )
);

/*  VLB负载均衡模块接收上行链路收到的控制协议包，按照SRRLB
    算法进行处理*/
VLB_module#(
    .C_M_AXI_ADDR_WIDTH     (32                    ),
    .P_QUEUE_NUM            (8                     ),//== P_TOR_NUM
    .P_CAPACITY_PKT_TYPE    (16'hff00              ),
    .P_OFFER_PKT_TYPE       (16'hff01              ),
    .P_RELAY_PKT_TYPE       (16'hff02              ),
    .P_SLOT_ID_TYPE         (16'hff03              ),
    .P_TIME_STAMP_TYPE      (16'hffff              ),
    .P_SLOT_NUM             (2                     ),
    .P_TOR_NUM              (8                     ),
    .P_OCS_NUM              (2                     ),
    .P_MY_OCS               (0                     ),
    .P_MY_TOR_MAC           (P_MY_TOR_MAC           ),
    .P_MAC_HEAD             (32'h8D_BC_5C_4A       ),
    .P_SLOT_MAX_PKT_NUM     (32'h00_04_00_00       ),
    .P_ETH_MIN_LEN          (8                     )
)VLB_module_u0(
    .i_clk                       (w_2_tx_clk_out        ),
    .i_rst                       (w_2_user_tx_reset     ),  
    .i_syn_time_stamp            (w_local_time          ),
    .i_slot_start                (w_slot_start          ),
    .i_cur_slot_id               (w_cur_slot_id         ),

    .s_uplink0_rx_axis_tvalid    (m_rx2_axis_tvalid     ),
    .s_uplink0_rx_axis_tdata     (m_rx2_axis_tdata      ),
    .s_uplink0_rx_axis_tlast     (m_rx2_axis_tlast      ),
    .s_uplink0_rx_axis_tkeep     (m_rx2_axis_tkeep      ),
    .s_uplink0_rx_axis_tuser     (m_rx2_axis_tuser      ),

    .m_uplink0_tx_axis_tvalid    (s_ctrl_0_axis_tvalid  ),
    .m_uplink0_tx_axis_tdata     (s_ctrl_0_axis_tdata   ),
    .m_uplink0_tx_axis_tlast     (s_ctrl_0_axis_tlast   ),
    .m_uplink0_tx_axis_tkeep     (s_ctrl_0_axis_tkeep   ),
    .m_uplink0_tx_axis_tuser     (s_ctrl_0_axis_tuser   ),
    .m_uplink0_tx_axis_tready    (1'b1),

    .s_uplink1_rx_axis_tvalid    (m_rx3_axis_tvalid     ),
    .s_uplink1_rx_axis_tdata     (m_rx3_axis_tdata      ),
    .s_uplink1_rx_axis_tlast     (m_rx3_axis_tlast      ),
    .s_uplink1_rx_axis_tkeep     (m_rx3_axis_tkeep      ),
    .s_uplink1_rx_axis_tuser     (m_rx3_axis_tuser      ),

    .m_uplink1_tx_axis_tvalid    (s_ctrl_1_axis_tvalid  ),
    .m_uplink1_tx_axis_tdata     (s_ctrl_1_axis_tdata   ),
    .m_uplink1_tx_axis_tlast     (s_ctrl_1_axis_tlast   ),
    .m_uplink1_tx_axis_tkeep     (s_ctrl_1_axis_tkeep   ),
    .m_uplink1_tx_axis_tuser     (s_ctrl_1_axis_tuser   ),
    .m_uplink1_tx_axis_tready    (1'b1),

    .o_check_queue_req_valid     (w_check_queue_req_valid ),
    .i_check_queue_resp_ready    (w_check_queue_resp_ready),
    .i_local_queue_size          (w_local_queue_size      ),
    .i_unlocal_queue_size        (w_unlocal_queue_size    ),

    .o_port0_send_local2_pkt_size       (w_port0_send_local2_pkt_size    ),
    .o_port0_send_local2_valid          (w_port0_send_local2_valid       ),
    .o_port0_send_local2_queue          (w_port0_send_local2_queue       ),
    .o_port0_local_direct_pkt_size      (w_port0_local_direct_pkt_size   ),
    .o_port0_local_direct_pkt_valid     (w_port0_local_direct_pkt_valid  ),
    .o_port0_cur_direct_tor             (w_port0_cur_direct_tor          ),
    .o_port0_unlocal_direct_pkt_size    (w_port0_unlocal_direct_pkt_size ),
    .o_port0_unlocal_direct_pkt_valid   (w_port0_unlocal_direct_pkt_valid),
    .o_port0_unlocal_direct_pkt_queue   (w_port0_unlocal_direct_pkt_queue),
    .o_port0_tx_relay                   (w_port0_tx_relay                ),
    .o_port0_tx_relay_valid             (w_port0_tx_relay_valid          ),

    .o_port1_send_local2_pkt_size       (w_port1_send_local2_pkt_size    ),
    .o_port1_send_local2_valid          (w_port1_send_local2_valid       ),
    .o_port1_send_local2_queue          (w_port1_send_local2_queue       ),
    .o_port1_local_direct_pkt_size      (w_port1_local_direct_pkt_size   ),
    .o_port1_local_direct_pkt_valid     (w_port1_local_direct_pkt_valid  ),
    .o_port1_cur_direct_tor             (w_port1_cur_direct_tor          ),
    .o_port1_unlocal_direct_pkt_size    (w_port1_unlocal_direct_pkt_size ),
    .o_port1_unlocal_direct_pkt_valid   (w_port1_unlocal_direct_pkt_valid),
    .o_port1_unlocal_direct_pkt_queue   (w_port1_unlocal_direct_pkt_queue),
    .o_port1_tx_relay                   (w_port1_tx_relay                ),
    .o_port1_tx_relay_valid             (w_port1_tx_relay_valid          )
);
/*  读DDR控制模块接收VLB负载均衡模块的队列描述符信息，
    从而获知需要转发的直接流量、间接流量大小以及队列等信息，
    除此之外该模块还需要控制待转发的俩跳流量大小，具体规则如下：
    时隙开始后直接开始转发缓存在本地的跨时隙带转发流量，然后
    转发本时隙内的俩跳转发流量，然后转发本地接收到的俩跳流量，
    然后转发本地的直接流量，最后转发中继流量*/
DDR_rd_ctrl#(
    .C_M_AXI_ADDR_WIDTH	     (32             ),
    .P_WRITE_DDR_PORT_NUM    (1              ),
    .P_DDR_LOCAL_QUEUE       (4              ),
    .P_P_WRITE_DDR_PORT      (0              ),
    .P_MAX_ADDR              (32'h0008_0000  ),
    .P_LOCAL_PORT_NUM        (2              ),
    .P_UNLOCAL_PORT_NUM      (2              ),
    .P_QUEUE_NUM             (8              )
)(
    .i_clk                                  (w_2_tx_clk_out        ),
    .i_rst                                  (w_2_user_tx_reset     ),

    .i_port0_send_local2_pkt_size           (w_port0_send_local2_pkt_size    ),
    .i_port0_send_local2_valid              (w_port0_send_local2_valid       ),
    .i_port0_send_local2_queue              (w_port0_send_local2_queue       ),
    .i_port0_local_direct_pkt_size          (w_port0_local_direct_pkt_size   ),
    .i_port0_local_direct_pkt_valid         (w_port0_local_direct_pkt_valid  ),
    .i_port0_cur_direct_tor                 (w_port0_cur_direct_tor          ),
    .i_port0_unlocal_direct_pkt_size        (w_port0_unlocal_direct_pkt_size ),
    .i_port0_unlocal_direct_pkt_valid       (w_port0_unlocal_direct_pkt_valid),
    .i_port0_unlocal_direct_pkt_queue       (w_port0_unlocal_direct_pkt_queue),
    .i_port0_tx_relay                       (w_port0_tx_relay                ),
    .i_port0_tx_relay_valid                 (w_port0_tx_relay_valid          ),

    .i_port1_send_local2_pkt_size           (w_port1_send_local2_pkt_size    ),
    .i_port1_send_local2_valid              (w_port1_send_local2_valid       ),
    .i_port1_send_local2_queue              (w_port1_send_local2_queue       ),
    .i_port1_local_direct_pkt_size          (w_port1_local_direct_pkt_size   ),
    .i_port1_local_direct_pkt_valid         (w_port1_local_direct_pkt_valid  ),
    .i_port1_cur_direct_tor                 (w_port1_cur_direct_tor          ),
    .i_port1_unlocal_direct_pkt_size        (w_port1_unlocal_direct_pkt_size ),
    .i_port1_unlocal_direct_pkt_valid       (w_port1_unlocal_direct_pkt_valid),
    .i_port1_unlocal_direct_pkt_queue       (w_port1_unlocal_direct_pkt_queue),
    .i_port1_tx_relay                       (w_port1_tx_relay                ),
    .i_port1_tx_relay_valid                 (w_port1_tx_relay_valid          ),

    .o_port0_rd_flag                        (w_rd_unlocal_port0_flag        ),
    .o_port0_rd_queue                       (w_rd_unlocal_port0_queue       ),
    .o_port0_rd_byte                        (w_rd_unlocal_port0_byte        ),
    .o_port0_rd_byte_valid                  (w_rd_unlocal_port0_byte_valid  ),
    .i_port0_rd_byte_ready                  (w_rd_unlocal_port0_byte_ready  ),
    .i_port0_rd_queue_finish                (w_rd_unlocal_port0_finish      ),

    .o_port1_rd_flag                        (w_rd_unlocal_port1_flag        ),
    .o_port1_rd_queue                       (w_rd_unlocal_port1_queue       ),
    .o_port1_rd_byte                        (w_rd_unlocal_port1_byte        ),
    .o_port1_rd_byte_valid                  (w_rd_unlocal_port1_byte_valid  ),
    .i_port1_rd_byte_ready                  (w_rd_unlocal_port1_byte_ready  ),
    .i_port1_rd_queue_finish                (w_rd_unlocal_port1_finish      ),

    .i_port0_forward_req                    (w_port0_forward_req            ),
    .o_port0_forward_resp                   (w_port0_forward_resp           ),
    .i_port0_forward_finish                 (w_port0_forward_finish         ),
    .o_port0_forward_valid                  (w_port0_forward_valid          ),
    .i_port1_forward_req                    (w_port1_forward_req            ),
    .o_port1_forward_resp                   (w_port1_forward_resp           ),
    .i_port1_forward_finish                 (w_port1_forward_finish         ),
    .o_port1_forward_valid                  (w_port1_forward_valid          )
);


forward_pkt_buffer forward_pkt_buffer_u0(
    .i_axi0_clk                 (w_2_tx_clk_out         ),
    .i_axi0_rst                 (w_2_user_tx_reset      ),
    .i_axi1_clk                 (w_3_tx_clk_out         ),
    .i_axi1_rst                 (w_3_user_tx_reset      ),

    .o_port0_forward_req        (w_port0_forward_req    ),
    .i_port0_forward_resp       (w_port0_forward_resp   ),
    .o_port0_forward_finish     (w_port0_forward_finish ),
    .o_port1_forward_req        (w_port1_forward_req    ),
    .i_port1_forward_resp       (w_port1_forward_resp   ),
    .o_port1_forward_finish     (w_port1_forward_finish ),
 
    .s_axis_rx0_tvalid          (m_rx2_axis_tvalid      ),
    .s_axis_rx0_tdata           (m_rx2_axis_tdata       ),
    .s_axis_rx0_tlast           (m_rx2_axis_tlast       ),
    .s_axis_rx0_tkeep           (m_rx2_axis_tkeep       ),
    .s_axis_rx0_tuser           (m_rx2_axis_tuser       ),

    .m_axis_tx0_tvalid          (w_port0_forward_axis_tvalid),
    .m_axis_tx0_tdata           (w_port0_forward_axis_tdata ),
    .m_axis_tx0_tlast           (w_port0_forward_axis_tlast ),
    .m_axis_tx0_tkeep           (w_port0_forward_axis_tkeep ),
    .m_axis_tx0_tuser           (w_port0_forward_axis_tuser ),
    .m_axis_tx0_tready          (w_port0_forward_axis_tready),

    .s_axis_rx1_tvalid          (m_rx3_axis_tvalid      ),
    .s_axis_rx1_tdata           (m_rx3_axis_tdata       ),
    .s_axis_rx1_tlast           (m_rx3_axis_tlast       ),
    .s_axis_rx1_tkeep           (m_rx3_axis_tkeep       ),
    .s_axis_rx1_tuser           (m_rx3_axis_tuser       ),

    .m_axis_tx1_tvalid          (w_port1_forward_axis_tvalid),
    .m_axis_tx1_tdata           (w_port1_forward_axis_tdata ),
    .m_axis_tx1_tlast           (w_port1_forward_axis_tlast ),
    .m_axis_tx1_tkeep           (w_port1_forward_axis_tkeep ),
    .m_axis_tx1_tuser           (w_port1_forward_axis_tuser ),
    .m_axis_tx1_tready          (w_port1_forward_axis_tready)
);

/*  上行链路发送数据时，需要判断数据是控制包还是数据包，
    该模块接收来自VLB控制模块和DDR读出的有效数据，然后
    选择数据进行发送，控制数据包的发送优先级最高*/
eth_uplink_port eth_uplink_port_u0(
    .i_crtl_clk             (w_ctrl_tx_clk_out      ),
    .i_crtl_rst             (w_ctrl_user_tx_reset   ),
    .i_data_clk             (w_2_tx_clk_out         ),
    .i_data_rst             (w_2_user_tx_reset      ),

    .s_ctrl_axis_tvalid     (s_ctrl_0_axis_tvalid   ),
    .s_ctrl_axis_tdata      (s_ctrl_0_axis_tdata    ),
    .s_ctrl_axis_tlast      (s_ctrl_0_axis_tlast    ),
    .s_ctrl_axis_tkeep      (s_ctrl_0_axis_tkeep    ),
    .s_ctrl_axis_tuser      (s_ctrl_0_axis_tuser    ),
     
    .s_data_axis_tvalid     (m_axis_2_tvalid        ),
    .s_data_axis_tdata      (m_axis_2_tdata         ),
    .s_data_axis_tlast      (m_axis_2_tlast         ),
    .s_data_axis_tkeep      (m_axis_2_tkeep         ),
    .s_data_axis_tuser      (m_axis_2_tuser         ),
    .s_data_axis_tready     (m_axis_2_tready        ),

    .i_forward_pkt_valid    (w_port0_forward_valid  ),
    .s_forward_axis_tvalid  (w_port0_forward_axis_tvalid),
    .s_forward_axis_tdata   (w_port0_forward_axis_tdata ),
    .s_forward_axis_tlast   (w_port0_forward_axis_tlast ),
    .s_forward_axis_tkeep   (w_port0_forward_axis_tkeep ),
    .s_forward_axis_tuser   (w_port0_forward_axis_tuser ),
    .s_forward_axis_tready  (w_port0_forward_axis_tready),
         
    .m_tx_axis_tvalid       (uplink0_tx_axis_tvalid ),
    .m_tx_axis_tdata        (uplink0_tx_axis_tdata  ),
    .m_tx_axis_tlast        (uplink0_tx_axis_tlast  ),
    .m_tx_axis_tkeep        (uplink0_tx_axis_tkeep  ),
    .m_tx_axis_tuser        (uplink0_tx_axis_tuser  ),
    .m_tx_axis_tready       (tx2_axis_tready        ) 
);

eth_uplink_port eth_uplink_port_u1(
    .i_crtl_clk             (w_ctrl_tx_clk_out      ),
    .i_crtl_rst             (w_ctrl_user_tx_reset   ),
    .i_data_clk             (w_3_tx_clk_out         ),
    .i_data_rst             (w_3_user_tx_reset      ),

    .s_ctrl_axis_tvalid     (s_ctrl_1_axis_tvalid   ),
    .s_ctrl_axis_tdata      (s_ctrl_1_axis_tdata    ),
    .s_ctrl_axis_tlast      (s_ctrl_1_axis_tlast    ),
    .s_ctrl_axis_tkeep      (s_ctrl_1_axis_tkeep    ),
    .s_ctrl_axis_tuser      (s_ctrl_1_axis_tuser    ),
     
    .s_data_axis_tvalid     (m_axis_3_tvalid        ),
    .s_data_axis_tdata      (m_axis_3_tdata         ),
    .s_data_axis_tlast      (m_axis_3_tlast         ),
    .s_data_axis_tkeep      (m_axis_3_tkeep         ),
    .s_data_axis_tuser      (m_axis_3_tuser         ),
    .s_data_axis_tready     (m_axis_3_tready        ),

    .i_forward_pkt_valid    (w_port1_forward_valid  ),
    .s_forward_axis_tvalid  (w_port1_forward_axis_tvalid),
    .s_forward_axis_tdata   (w_port1_forward_axis_tdata ),
    .s_forward_axis_tlast   (w_port1_forward_axis_tlast ),
    .s_forward_axis_tkeep   (w_port1_forward_axis_tkeep ),
    .s_forward_axis_tuser   (w_port1_forward_axis_tuser ),
    .s_forward_axis_tready  (w_port1_forward_axis_tready),
         
    .m_tx_axis_tvalid       (uplink1_tx_axis_tvalid ),
    .m_tx_axis_tdata        (uplink1_tx_axis_tdata  ),
    .m_tx_axis_tlast        (uplink1_tx_axis_tlast  ),
    .m_tx_axis_tkeep        (uplink1_tx_axis_tkeep  ),
    .m_tx_axis_tuser        (uplink1_tx_axis_tuser  ),
    .m_tx_axis_tready       (tx3_axis_tready        ) 
);

/*  crossbar交换机模块，完成本地数据的转发，包括下行链路之间的转发
    以及上行链路接收的本地服务器数据*/
crossbar#(
    .P_CROSSBAR_N               (P_CROSSBAR_N)        
)crossbar_u0(
    .i_clk                      (i_clk             ),
    .i_rst                      (i_rst             ),

    .s0_axis_rx_tvalid          (m_rx0_axis_tvalid  ),
    .s0_axis_rx_tdata           (m_rx0_axis_tdata   ),
    .s0_axis_rx_tlast           (m_rx0_axis_tlast   ),
    .s0_axis_rx_tkeep           (m_rx0_axis_tkeep   ),
    .s0_axis_rx_tuser           (m_rx0_axis_tuser   ),
    .s0_axis_rx_tdest           (m_rx0_axis_tdest   ),
    .m0_axis_tx_tvalid          (tx0_axis_tvalid    ),
    .m0_axis_tx_tdata           (tx0_axis_tdata     ),
    .m0_axis_tx_tlast           (tx0_axis_tlast     ),
    .m0_axis_tx_tkeep           (tx0_axis_tkeep     ),
    .m0_axis_tx_tuser           (tx0_axis_tuser     ),     
    .m0_axis_tx_tready          (tx0_axis_tready    ),          
    .s1_axis_rx_tvalid          (m_rx1_axis_tvalid  ),
    .s1_axis_rx_tdata           (m_rx1_axis_tdata   ),
    .s1_axis_rx_tlast           (m_rx1_axis_tlast   ),
    .s1_axis_rx_tkeep           (m_rx1_axis_tkeep   ),
    .s1_axis_rx_tuser           (m_rx1_axis_tuser   ),
    .s1_axis_rx_tdest           (m_rx1_axis_tdest   ),
    .m1_axis_tx_tvalid          (tx1_axis_tvalid    ),
    .m1_axis_tx_tdata           (tx1_axis_tdata     ),
    .m1_axis_tx_tlast           (tx1_axis_tlast     ),
    .m1_axis_tx_tkeep           (tx1_axis_tkeep     ),
    .m1_axis_tx_tuser           (tx1_axis_tuser     ),
    .m1_axis_tx_tready          (tx1_axis_tready    ),    
    .s2_axis_rx_tvalid          (m_rx2_axis_tvalid  ),
    .s2_axis_rx_tdata           (m_rx2_axis_tdata   ),
    .s2_axis_rx_tlast           (m_rx2_axis_tlast   ),
    .s2_axis_rx_tkeep           (m_rx2_axis_tkeep   ),
    .s2_axis_rx_tuser           (m_rx2_axis_tuser   ),
    .s2_axis_rx_tdest           (m_rx2_axis_tdest   ),
    .m2_axis_tx_tvalid          (tx2_axis_tvalid    ),
    .m2_axis_tx_tdata           (tx2_axis_tdata     ),
    .m2_axis_tx_tlast           (tx2_axis_tlast     ),
    .m2_axis_tx_tkeep           (tx2_axis_tkeep     ),
    .m2_axis_tx_tuser           (tx2_axis_tuser     ),
    .m2_axis_tx_tready          (tx2_axis_tready    ),    
    .s3_axis_rx_tvalid          (m_rx3_axis_tvalid  ),
    .s3_axis_rx_tdata           (m_rx3_axis_tdata   ),
    .s3_axis_rx_tlast           (m_rx3_axis_tlast   ),
    .s3_axis_rx_tkeep           (m_rx3_axis_tkeep   ),
    .s3_axis_rx_tuser           (m_rx3_axis_tuser   ),
    .s3_axis_rx_tdest           (m_rx3_axis_tdest   ),
    .m3_axis_tx_tvalid          (tx3_axis_tvalid    ),
    .m3_axis_tx_tdata           (tx3_axis_tdata     ),
    .m3_axis_tx_tlast           (tx3_axis_tlast     ),
    .m3_axis_tx_tkeep           (tx3_axis_tkeep     ),
    .m3_axis_tx_tuser           (tx3_axis_tuser     ),
    .m3_axis_tx_tready          (tx3_axis_tready    )
); 

/*  DDR读写模块，进行AXIS以及AXI直接的转换以及跨时钟处理，
    相当于一个DMA，用户只需要发送读写描述符（数据地址、大小等）
    即可完成DDR的读写过程*/
design_1_wrapper design_1_wrapper_u0(
    .C0_DDR4_0_act_n                (c0_ddr4_act_n			),           
    .C0_DDR4_0_adr                  (c0_ddr4_adr			),
    .C0_DDR4_0_ba                   (c0_ddr4_ba				),
    .C0_DDR4_0_bg                   (c0_ddr4_bg				),
    .C0_DDR4_0_ck_c                 (c0_ddr4_ck_c_int       ),
    .C0_DDR4_0_ck_t                 (c0_ddr4_ck_t_int       ),
    .C0_DDR4_0_cke                  (c0_ddr4_cke			),
    .C0_DDR4_0_cs_n                 (c0_ddr4_cs_n			),
    .C0_DDR4_0_dm_n                 (c0_ddr4_dm_dbi_n       ),
    .C0_DDR4_0_dq                   (c0_ddr4_dq				),
    .C0_DDR4_0_dqs_c                (c0_ddr4_dqs_c			),
    .C0_DDR4_0_dqs_t                (c0_ddr4_dqs_t			),
    .C0_DDR4_0_odt                  (c0_ddr4_odt			),
    .C0_DDR4_0_reset_n              (c0_ddr4_reset_n	    ),
    .C0_DDR4_S_AXI_CTRL_0_araddr    (32'd0  ),
    .C0_DDR4_S_AXI_CTRL_0_arready   (       ),
    .C0_DDR4_S_AXI_CTRL_0_arvalid   (1'd0   ),
    .C0_DDR4_S_AXI_CTRL_0_awaddr    (32'd0  ),
    .C0_DDR4_S_AXI_CTRL_0_awready   (       ),
    .C0_DDR4_S_AXI_CTRL_0_awvalid   (1'd0   ),
    .C0_DDR4_S_AXI_CTRL_0_bready    (1'd0   ),
    .C0_DDR4_S_AXI_CTRL_0_bresp     (       ),
    .C0_DDR4_S_AXI_CTRL_0_bvalid    (       ),
    .C0_DDR4_S_AXI_CTRL_0_rdata     (       ),
    .C0_DDR4_S_AXI_CTRL_0_rready    (1'd0   ),
    .C0_DDR4_S_AXI_CTRL_0_rresp     (       ),
    .C0_DDR4_S_AXI_CTRL_0_rvalid    (       ),
    .C0_DDR4_S_AXI_CTRL_0_wdata     (32'd0  ),
    .C0_DDR4_S_AXI_CTRL_0_wready    (       ),
    .C0_DDR4_S_AXI_CTRL_0_wvalid    (1'd0   ),
    .C0_SYS_CLK_0_clk_n             (c0_sys_clk_n),
    .C0_SYS_CLK_0_clk_p             (c0_sys_clk_p),
    .c0_ddr4_ui_clk_0               (ddr4_ui_clk),
    .c0_ddr4_ui_clk_sync_rst_0      (ddr4_ui_rst),
    .c0_init_calib_complete_0       (c0_init_calib_complete_0),
    .i_axis_clk_0                   (w_0_tx_clk_out     ),
    .i_axis_rst_0                   (w_0_user_tx_reset  ),
    .i_axis_clk_1                   (w_0_tx_clk_out     ),
    .i_axis_rst_1                   (w_0_user_tx_reset  ),
    .i_axis_clk_2                   (w_0_tx_clk_out     ),
    .i_axis_rst_2                   (w_0_user_tx_reset  ),
    .i_axis_clk_3                   (w_0_tx_clk_out     ),
    .i_axis_rst_3                   (w_0_user_tx_reset  ),
     
    .i_rd_ddr_addr_0                (w_rd_ddr_addr_0     ),
    .i_rd_ddr_addr_1                (w_rd_ddr_addr_1     ),
    .i_rd_ddr_addr_2                (w_rd_ddr_addr_2     ),
    .i_rd_ddr_addr_3                (w_rd_ddr_addr_3     ),
    .i_rd_ddr_len_0                 (w_rd_ddr_len_0      ),
    .i_rd_ddr_len_1                 (w_rd_ddr_len_1      ),
    .i_rd_ddr_len_2                 (w_rd_ddr_len_2      ),
    .i_rd_ddr_len_3                 (w_rd_ddr_len_3      ),
    .i_rd_ddr_strb_0                (w_rd_ddr_strb_0     ),
    .i_rd_ddr_strb_1                (w_rd_ddr_strb_1     ),
    .i_rd_ddr_strb_2                (w_rd_ddr_strb_2     ),
    .i_rd_ddr_strb_3                (w_rd_ddr_strb_3     ),
    .i_rd_ddr_valid_0               (w_rd_ddr_valid_0    ),
    .i_rd_ddr_valid_1               (w_rd_ddr_valid_1    ),
    .i_rd_ddr_valid_2               (w_rd_ddr_valid_2    ),
    .i_rd_ddr_valid_3               (w_rd_ddr_valid_3    ),
    .i_wr_ddr_addr_0                (w_wr_ddr_addr_0     ),
    .i_wr_ddr_addr_1                (w_wr_ddr_addr_1     ),
    .i_wr_ddr_addr_2                (w_wr_ddr_addr_2     ),
    .i_wr_ddr_addr_3                (w_wr_ddr_addr_3     ),
    .i_wr_ddr_cpl_ready_0           (w_wr_ddr_cpl_ready_0),
    .i_wr_ddr_cpl_ready_1           (w_wr_ddr_cpl_ready_1),
    .i_wr_ddr_cpl_ready_2           (w_wr_ddr_cpl_ready_2),
    .i_wr_ddr_cpl_ready_3           (w_wr_ddr_cpl_ready_3),
    .i_wr_ddr_ready_0               (w_wr_ddr_ready_0    ),
    .i_wr_ddr_ready_1               (w_wr_ddr_ready_1    ),
    .i_wr_ddr_ready_2               (w_wr_ddr_ready_2    ),
    .i_wr_ddr_ready_3               (w_wr_ddr_ready_3    ),
    .m_axis_0_tdata                 (m_axis_0_tdata     ),
    .m_axis_0_tkeep                 (m_axis_0_tkeep     ),
    .m_axis_0_tlast                 (m_axis_0_tlast     ),
    .m_axis_0_tready                (m_axis_0_tready    ),
    .m_axis_0_tuser                 (m_axis_0_tuser     ),
    .m_axis_0_tvalid                (m_axis_0_tvalid    ),
    .m_axis_1_tdata                 (m_axis_1_tdata     ),
    .m_axis_1_tkeep                 (m_axis_1_tkeep     ),
    .m_axis_1_tlast                 (m_axis_1_tlast     ),
    .m_axis_1_tready                (m_axis_1_tready    ),
    .m_axis_1_tuser                 (m_axis_1_tuser     ),
    .m_axis_1_tvalid                (m_axis_1_tvalid    ),
    .m_axis_2_tdata                 (m_axis_2_tdata     ),
    .m_axis_2_tkeep                 (m_axis_2_tkeep     ),
    .m_axis_2_tlast                 (m_axis_2_tlast     ),
    .m_axis_2_tready                (m_axis_2_tready    ),
    .m_axis_2_tuser                 (m_axis_2_tuser     ),
    .m_axis_2_tvalid                (m_axis_2_tvalid    ),
    .m_axis_3_tdata                 (m_axis_3_tdata     ),
    .m_axis_3_tkeep                 (m_axis_3_tkeep     ),
    .m_axis_3_tlast                 (m_axis_3_tlast     ),
    .m_axis_3_tready                (m_axis_3_tready    ),
    .m_axis_3_tuser                 (m_axis_3_tuser     ),
    .m_axis_3_tvalid                (m_axis_3_tvalid    ),
    .o_rd_ddr_cpl_0                 (w_rd_ddr_cpl_0         ),
    .o_rd_ddr_cpl_1                 (w_rd_ddr_cpl_1         ),
    .o_rd_ddr_cpl_2                 (w_rd_ddr_cpl_2         ),
    .o_rd_ddr_cpl_3                 (w_rd_ddr_cpl_3         ),
    .o_rd_ddr_ready_0               (w_rd_ddr_ready_0       ),
    .o_rd_ddr_ready_1               (w_rd_ddr_ready_1       ),
    .o_rd_ddr_ready_2               (w_rd_ddr_ready_2       ),
    .o_rd_ddr_ready_3               (w_rd_ddr_ready_3       ),
    .o_wr_ddr_cpl_addr_0            (w_wr_ddr_cpl_addr_0    ),
    .o_wr_ddr_cpl_addr_1            (w_wr_ddr_cpl_addr_1    ),
    .o_wr_ddr_cpl_addr_2            (w_wr_ddr_cpl_addr_2    ),
    .o_wr_ddr_cpl_addr_3            (w_wr_ddr_cpl_addr_3    ),
    .o_wr_ddr_cpl_len_0             (w_wr_ddr_cpl_len_0     ),
    .o_wr_ddr_cpl_len_1             (w_wr_ddr_cpl_len_1     ),
    .o_wr_ddr_cpl_len_2             (w_wr_ddr_cpl_len_2     ),
    .o_wr_ddr_cpl_len_3             (w_wr_ddr_cpl_len_3     ),
    .o_wr_ddr_cpl_queue_0           (w_wr_ddr_cpl_queue_0   ),
    .o_wr_ddr_cpl_queue_1           (w_wr_ddr_cpl_queue_1   ),
    .o_wr_ddr_cpl_queue_2           (w_wr_ddr_cpl_queue_2   ),
    .o_wr_ddr_cpl_queue_3           (w_wr_ddr_cpl_queue_3   ),
    .o_wr_ddr_cpl_strb_0            (w_wr_ddr_cpl_strb_0    ),
    .o_wr_ddr_cpl_strb_1            (w_wr_ddr_cpl_strb_1    ),
    .o_wr_ddr_cpl_strb_2            (w_wr_ddr_cpl_strb_2    ),
    .o_wr_ddr_cpl_strb_3            (w_wr_ddr_cpl_strb_3    ),
    .o_wr_ddr_cpl_valid_0           (w_wr_ddr_cpl_valid_0   ),
    .o_wr_ddr_cpl_valid_1           (w_wr_ddr_cpl_valid_1   ),
    .o_wr_ddr_cpl_valid_2           (w_wr_ddr_cpl_valid_2   ),
    .o_wr_ddr_cpl_valid_3           (w_wr_ddr_cpl_valid_3   ),
    .o_wr_ddr_len_0                 (w_wr_ddr_len_0         ),
    .o_wr_ddr_len_1                 (w_wr_ddr_len_1         ),
    .o_wr_ddr_len_2                 (w_wr_ddr_len_2         ),
    .o_wr_ddr_len_3                 (w_wr_ddr_len_3         ),
    .o_wr_ddr_queue_0               (w_wr_ddr_queue_0       ),
    .o_wr_ddr_queue_1               (w_wr_ddr_queue_1       ),
    .o_wr_ddr_queue_2               (w_wr_ddr_queue_2       ),
    .o_wr_ddr_queue_3               (w_wr_ddr_queue_3       ),
    .o_wr_ddr_valid_0               (w_wr_ddr_valid_0       ),
    .o_wr_ddr_valid_1               (w_wr_ddr_valid_1       ),
    .o_wr_ddr_valid_2               (w_wr_ddr_valid_2       ),
    .o_wr_ddr_valid_3               (w_wr_ddr_valid_3       ),
    .s_axis_0_tdata                 (m_rx0_axis_tdata       ),  
    .s_axis_0_tdest                 (m_rx0_axis_tdest       ),   
    .s_axis_0_tkeep                 (m_rx0_axis_tkeep       ),   
    .s_axis_0_tlast                 (m_rx0_axis_tlast       ),   
    .s_axis_0_tuser                 (m_rx0_axis_tuser       ),   
    .s_axis_0_tvalid                (m_rx0_axis_tvalid      ),   
    .s_axis_1_tdata                 (m_rx1_axis_tdata       ),
    .s_axis_1_tdest                 (m_rx1_axis_tdest       ),
    .s_axis_1_tkeep                 (m_rx1_axis_tkeep       ),
    .s_axis_1_tlast                 (m_rx1_axis_tlast       ),
    .s_axis_1_tuser                 (m_rx1_axis_tuser       ),
    .s_axis_1_tvalid                (m_rx1_axis_tvalid      ),
    .s_axis_2_tdata                 (m_rx2_axis_tdata       ),
    .s_axis_2_tdest                 (m_rx2_axis_tdest       ),
    .s_axis_2_tkeep                 (m_rx2_axis_tkeep       ),
    .s_axis_2_tlast                 (m_rx2_axis_tlast       ),
    .s_axis_2_tuser                 (m_rx2_axis_tuser       ),
    .s_axis_2_tvalid                (m_rx2_axis_tvalid      ),
    .s_axis_3_tdata                 (m_rx3_axis_tdata       ),
    .s_axis_3_tdest                 (m_rx3_axis_tdest       ),
    .s_axis_3_tkeep                 (m_rx3_axis_tkeep       ),
    .s_axis_3_tlast                 (m_rx3_axis_tlast       ),
    .s_axis_3_tuser                 (m_rx3_axis_tuser       ),
    .s_axis_3_tvalid                (m_rx3_axis_tvalid      ),
    .sys_rst_0                      (sys_rst                )
);
/*  内存管理模块，与design_1_wrapper模块配合完成DDR的读写过程，
    同时记录所有队列里面数据包信息，即首地址、数据长度、尾端KEEP等
    信号，将队列信息告知VLB模块，帮助VLB模块进行负载均衡计算*/
mem_manager#(
    .C_M_AXI_ADDR_WIDTH	     (32            ),
    .P_WRITE_DDR_PORT_NUM    (1             ),
    .P_DDR_LOCAL_QUEUE       (4             ),
    .P_P_WRITE_DDR_PORT      (0             ),
    .P_MAX_ADDR              (32'h003F_FFFF ),
    .P_LOCAL_PORT_NUM        (2             ),
    .P_QUEUE_NUM             (8             )
)mem_manager_u0(
    .i_clk                           (ddr4_ui_clk           ),
    .i_rst                           (ddr4_ui_rst           ),

    .i_wr_local_port0_valid          (w_wr_ddr_valid_0      ),
    .i_wr_local_port0_len            (w_wr_ddr_len_0        ),
    .i_wr_local_port0_queue          (w_wr_ddr_queue_0      ),
    .o_wr_local_port0_addr           (w_wr_ddr_addr_0       ),     
    .o_wr_local_port0_ready          (w_wr_ddr_ready_0      ),
    .i_wr_local_port0_cpl_valid      (w_wr_ddr_cpl_valid_0  ),
    .o_wr_local_port0_cpl_ready      (w_wr_ddr_cpl_ready_0  ),
    .i_wr_local_port0_cpl_queue      (w_wr_ddr_cpl_queue_0  ),
    .i_wr_local_port0_cpl_len        (w_wr_ddr_cpl_len_0    ),
    .i_wr_local_port0_cpl_addr       (w_wr_ddr_cpl_addr_0   ),
    .i_wr_local_port0_cpl_strb       (w_wr_ddr_cpl_strb_0   ),

    .i_wr_local_port1_valid          (w_wr_ddr_valid_1      ),
    .i_wr_local_port1_len            (w_wr_ddr_len_1        ),
    .i_wr_local_port1_queue          (w_wr_ddr_queue_1      ),
    .o_wr_local_port1_addr           (w_wr_ddr_addr_1       ),
    .o_wr_local_port1_ready          (w_wr_ddr_ready_1      ),
    .i_wr_local_port1_cpl_valid      (w_wr_ddr_cpl_valid_1  ),
    .o_wr_local_port1_cpl_ready      (w_wr_ddr_cpl_ready_1  ),
    .i_wr_local_port1_cpl_queue      (w_wr_ddr_cpl_queue_1  ),
    .i_wr_local_port1_cpl_len        (w_wr_ddr_cpl_len_1    ),
    .i_wr_local_port1_cpl_addr       (w_wr_ddr_cpl_addr_1   ),
    .i_wr_local_port1_cpl_strb       (w_wr_ddr_cpl_strb_1   ),


    .i_wr_unlocal_port0_valid        (w_wr_ddr_valid_2      ),
    .i_wr_unlocal_port0_len          (w_wr_ddr_len_2        ),
    .i_wr_unlocal_port0_queue        (w_wr_ddr_queue_2      ),
    .o_wr_unlocal_port0_addr         (w_wr_ddr_addr_2       ),
    .o_wr_unlocal_port0_ready        (w_wr_ddr_ready_2      ),
    .i_wr_unlocal_port0_cpl_valid    (w_wr_ddr_cpl_valid_2  ),
    .o_wr_unlocal_port0_cpl_ready    (w_wr_ddr_cpl_ready_2  ),
    .i_wr_unlocal_port0_cpl_queue    (w_wr_ddr_cpl_queue_2  ),
    .i_wr_unlocal_port0_cpl_len      (w_wr_ddr_cpl_len_2    ),
    .i_wr_unlocal_port0_cpl_addr     (w_wr_ddr_cpl_addr_2   ),
    .i_wr_unlocal_port0_cpl_strb     (w_wr_ddr_cpl_strb_2   ),

    .i_rd_unlocal_port0_flag         (w_rd_unlocal_port0_flag      ),
    .i_rd_unlocal_port0_queue        (w_rd_unlocal_port0_queue     ),
    .i_rd_unlocal_port0_byte         (w_rd_unlocal_port0_byte      ),
    .i_rd_unlocal_port0_byte_valid   (w_rd_unlocal_port0_byte_valid),
    .o_rd_unlocal_port0_finish       (w_rd_unlocal_port0_finish    ),
    .o_rd_unlocal_port0_byte_ready   (w_rd_unlocal_port0_byte_ready),
    .o_rd_unlocal_port0_addr         (w_rd_ddr_addr_2       ),
    .o_rd_unlocal_port0_len          (w_rd_ddr_len_2        ),
    .o_rd_unlocal_port0_strb         (w_rd_ddr_strb_2       ),
    .o_rd_unlocal_port0_valid        (w_rd_ddr_valid_2      ),
    .i_rd_unlocal_port0_cpl          (w_rd_ddr_cpl_2        ),
    .i_rd_unlocal_port0_ready        (w_rd_ddr_ready_2      ),

    .i_wr_unlocal_port1_valid        (w_wr_ddr_valid_3      ),
    .i_wr_unlocal_port1_len          (w_wr_ddr_len_3        ),
    .i_wr_unlocal_port1_queue        (w_wr_ddr_queue_3      ),
    .o_wr_unlocal_port1_addr         (w_wr_ddr_addr_3       ),
    .o_wr_unlocal_port1_ready        (w_wr_ddr_ready_3      ),
    .i_wr_unlocal_port1_cpl_valid    (w_wr_ddr_cpl_valid_3  ),
    .o_wr_unlocal_port1_cpl_ready    (w_wr_ddr_cpl_ready_3  ),
    .i_wr_unlocal_port1_cpl_queue    (w_wr_ddr_cpl_queue_3  ),
    .i_wr_unlocal_port1_cpl_len      (w_wr_ddr_cpl_len_3    ),
    .i_wr_unlocal_port1_cpl_addr     (w_wr_ddr_cpl_addr_3   ),
    .i_wr_unlocal_port1_cpl_strb     (w_wr_ddr_cpl_strb_3   ),

    .i_rd_unlocal_port1_flag         (w_rd_unlocal_port1_flag      ),
    .i_rd_unlocal_port1_queue        (w_rd_unlocal_port1_queue     ),
    .i_rd_unlocal_port1_byte         (w_rd_unlocal_port1_byte      ),
    .i_rd_unlocal_port1_byte_valid   (w_rd_unlocal_port1_byte_valid),
    .o_rd_unlocal_port1_finish       (w_rd_unlocal_port1_finish    ),
    .o_rd_unlocal_port1_byte_ready   (w_rd_unlocal_port1_byte_ready),
    .o_rd_unlocal_port1_addr         (w_rd_ddr_addr_3       ),
    .o_rd_unlocal_port1_len          (w_rd_ddr_len_3        ),
    .o_rd_unlocal_port1_strb         (w_rd_ddr_strb_3       ),
    .o_rd_unlocal_port1_valid        (w_rd_ddr_valid_3      ),
    .i_rd_unlocal_port1_cpl          (w_rd_ddr_cpl_3        ),
    .i_rd_unlocal_port1_ready        (w_rd_ddr_ready_3      ),

    .i_check_queue_req_valid         (w_check_queue_req_valid ),
    .o_check_queue_resp_ready        (w_check_queue_resp_ready),
    .o_local_queue_size              (w_local_queue_size  ),
    .o_unlocal_queue_size            (w_unlocal_queue_size)
);


endmodule
