

/******************************************************************************
// (c) Copyright 2013 - 2014 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
******************************************************************************/
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor             : Xilinx
// \   \   \/     Version            : 1.0
//  \   \         Application        : MIG
//  /   /         Filename           : sim_tb_top.sv
// /___/   /\     Date Last Modified : $Date: 2014/09/03 $
// \   \  /  \    Date Created       : Thu Apr 18 2013
//  \___\/\___\
//
// Device           : UltraScale
// Design Name      : DDR4_SDRAM
// Purpose          :
//                   Top-level testbench for testing Memory interface.
//                   Instantiates:
//                     1. IP_TOP (top-level representing FPGA, contains core,
//                        clocking, built-in testbench/memory checker and other
//                        support structures)
//                     2. Memory Model
//                     3. Miscellaneous clock generation and reset logic
// Reference        :
// Revision History :
//*****************************************************************************

`timescale 1ps/1ps

`ifdef XILINX_SIMULATOR
module short(in1, in1);
inout in1;
endmodule
`endif

module ddr_tb;

  localparam ADDR_WIDTH                    = 17;
  localparam DQ_WIDTH                      = 72;
  localparam DQS_WIDTH                     = 9;
  localparam DM_WIDTH                      = 9;
  localparam DRAM_WIDTH                    = 16;
  localparam tCK                           = 750 ; //DDR4 interface clock period in ps
  localparam real SYSCLK_PERIOD            = tCK; 
  localparam NUM_PHYSICAL_PARTS = (DQ_WIDTH/DRAM_WIDTH) ;
  localparam           CLAMSHELL_PARTS = (NUM_PHYSICAL_PARTS/2);
  localparam           ODD_PARTS = ((CLAMSHELL_PARTS*2) < NUM_PHYSICAL_PARTS) ? 1 : 0;
  parameter RANK_WIDTH                       = 1;
  parameter CS_WIDTH                       = 2;
  parameter ODT_WIDTH                      = 1;
  parameter CA_MIRROR                      = "ON";


  localparam MRS                           = 3'b000;
  localparam REF                           = 3'b001;
  localparam PRE                           = 3'b010;
  localparam ACT                           = 3'b011;
  localparam WR                            = 3'b100;
  localparam RD                            = 3'b101;
  localparam ZQC                           = 3'b110;
  localparam NOP                           = 3'b111;

  import arch_package::*;
  parameter UTYPE_density CONFIGURED_DENSITY = _8G;

  // Input clock is assumed to be equal to the memory clock frequency
  // User should change the parameter as necessary if a different input
  // clock frequency is used
  localparam real CLKIN_PERIOD_NS = 10000 / 1000.0;

  //initial begin
  //   $shm_open("waves.shm");
  //   $shm_probe("ACMTF");
  //end

  reg                  sys_clk_i;
  reg                  sys_rst;
  reg axis_clk;
  wire                 c0_sys_clk_p;
  wire                 c0_sys_clk_n;

  reg  [16:0]            c0_ddr4_adr_sdram[1:0];
  reg  [1:0]           c0_ddr4_ba_sdram[1:0];
  reg  [0:0]           c0_ddr4_bg_sdram[1:0];


  wire                 c0_ddr4_act_n;
  wire  [16:0]          c0_ddr4_adr;
  wire  [1:0]          c0_ddr4_ba;
  wire  [0:0]    c0_ddr4_bg;
  wire  [0:0]           c0_ddr4_cke;
  wire  [0:0]           c0_ddr4_odt;
  wire  [1:0]            c0_ddr4_cs_n;

  wire  [0:0]  c0_ddr4_ck_t_int;
  wire  [0:0]  c0_ddr4_ck_c_int;

  wire    c0_ddr4_ck_t;
  wire    c0_ddr4_ck_c;

  wire                 c0_ddr4_reset_n;

  wire  [8:0]          c0_ddr4_dm_dbi_n;
  wire  [71:0]          c0_ddr4_dq;
  wire  [8:0]          c0_ddr4_dqs_c;
  wire  [8:0]          c0_ddr4_dqs_t;
  wire                 c0_init_calib_complete;
  wire                 c0_data_compare_error;


  reg  [31:0] cmdName;
  bit  en_model;
  tri        model_enable = en_model;



  //**************************************************************************//
  // Reset Generation
  //**************************************************************************//
  initial begin
     sys_rst = 1'b0;
     #200
     sys_rst = 1'b1;
     en_model = 1'b0; 
     #5 en_model = 1'b1;
     #200;
     sys_rst = 1'b0;
     #100;
  end

  //**************************************************************************//
  // Clock Generation
  //**************************************************************************//

  initial
    sys_clk_i = 1'b0;
  always
    sys_clk_i = #(10000/2.0) ~sys_clk_i;


  initial
    axis_clk = 1'b0;
  always
    axis_clk = #(6400/2.0) ~axis_clk;

  assign c0_sys_clk_p = sys_clk_i;
  assign c0_sys_clk_n = ~sys_clk_i;

  assign c0_ddr4_ck_t = c0_ddr4_ck_t_int[0];
  assign c0_ddr4_ck_c = c0_ddr4_ck_c_int[0];

   always @( * ) begin
     c0_ddr4_adr_sdram[0]   <=  c0_ddr4_adr;
     c0_ddr4_adr_sdram[1]   <=  (CA_MIRROR == "ON") ?
                                       {c0_ddr4_adr[ADDR_WIDTH-1:14],
                                        c0_ddr4_adr[11], c0_ddr4_adr[12],
                                        c0_ddr4_adr[13], c0_ddr4_adr[10:9],
                                        c0_ddr4_adr[7], c0_ddr4_adr[8],
                                        c0_ddr4_adr[5], c0_ddr4_adr[6],
                                        c0_ddr4_adr[3], c0_ddr4_adr[4],
                                        c0_ddr4_adr[2:0]} :
                                        c0_ddr4_adr;
     c0_ddr4_ba_sdram[0]    <=  c0_ddr4_ba;
     c0_ddr4_ba_sdram[1]    <=  (CA_MIRROR == "ON") ?
                                        {c0_ddr4_ba[0],
                                         c0_ddr4_ba[1]} :
                                         c0_ddr4_ba;
     c0_ddr4_bg_sdram[0]    <=  c0_ddr4_bg;
      c0_ddr4_bg_sdram[1]    <=  c0_ddr4_bg;
    end


  //===========================================================================
  //                         FPGA Memory Controller instantiation
  //===========================================================================

// reg [39:0] r_st_monitor;

// localparam      P_ST_IDLE   = 0 ,
//                 P_ST_WRITE  = 1 ,
//                 P_ST_READ   = 2 ;    

// always@(*)begin
//   case(design_1_wrapper_u0.AXI_FULL_Master_modu_0.design_1_AXI_FULL_Master_modu_0_0.inst.r_cur_state)
//     P_ST_IDLE  : r_st_monitor = "IDLE ";
//     P_ST_WRITE : r_st_monitor = "WRITE";
//     P_ST_READ  : r_st_monitor = "READ ";
//     default : r_st_monitor = "IDLE ";
//   endcase
// end


reg clk_in1;

initial
clk_in1 = 1'b0;
always
clk_in1 = #(6400/2.0) ~clk_in1;

reg             s_axis_tvalid   ;
reg  [63 :0]    s_axis_tdata    ;
reg             s_axis_tlast    ;
reg  [7  :0]    s_axis_tkeep    ;
reg             s_axis_tuser    ;
reg  [2 : 0]    s_axis_tdest    ;

reg             r_axis_rst = 0  ;
reg             r_axis_rst_1d = 0   ;

reg             r_rd_unlocal_port0_byte_valid;
reg  [31:0]     r_rd_unlocal_port0_byte;

wire            c0_init_calib_complete_0;
wire            ddr4_ui_clk     ;
wire            ddr4_ui_rst     ;
wire            axis_rst        ;
//DDR ctrl
wire            o_rd_ddr_cpl_0       ;
wire            o_rd_ddr_cpl_1       ;
wire            o_rd_ddr_ready_0     ;
wire            o_rd_ddr_ready_1     ;
wire  [31:0]    o_wr_ddr_cpl_addr_0  ;
wire  [31:0]    o_wr_ddr_cpl_addr_1  ;
wire  [15:0]    o_wr_ddr_cpl_len_0   ;
wire  [15:0]    o_wr_ddr_cpl_len_1   ;
wire  [3: 0]    o_wr_ddr_cpl_queue_0    ;
wire  [3: 0]    o_wr_ddr_cpl_queue_1    ;
wire  [7 :0]    o_wr_ddr_cpl_strb_0  ;
wire  [7 :0]    o_wr_ddr_cpl_strb_1  ;
wire            o_wr_ddr_cpl_valid_0 ;
wire            o_wr_ddr_cpl_valid_1 ;
wire  [15:0]    o_wr_ddr_len_0       ;
wire  [15:0]    o_wr_ddr_len_1       ;
wire  [3 :0]    o_wr_ddr_queue_0     ;
wire  [3 :0]    o_wr_ddr_queue_1     ;
wire            o_wr_ddr_valid_0     ;
wire            o_wr_ddr_valid_1     ;
wire [32-1 : 0] w_rd_unlocal_port0_addr   ;
wire [15 :0]    w_rd_unlocal_port0_len    ;
wire [7 : 0]    w_rd_unlocal_port0_strb   ;
wire            w_rd_unlocal_port0_valid  ;

//memory ctrl
wire  [31:0]    i_wr_ddr_addr_0         ;
wire            i_wr_ddr_ready_0        ;
wire            i_wr_ddr_cpl_ready_0    ;
wire  [31:0]    i_wr_ddr_addr_1         ;
wire            i_wr_ddr_ready_1        ;
wire            i_wr_ddr_cpl_ready_1    ;

wire [255:0]  w_local_queue_size  ;
wire [255:0]  w_unlocal_queue_size;

wire [31:0]w_queue0_size;

assign w_queue0_size = w_local_queue_size[31:0];

assign axis_rst = r_axis_rst_1d;

always @(posedge ddr4_ui_clk)begin
    r_axis_rst <= ddr4_ui_rst;
    r_axis_rst_1d <= r_axis_rst;
end


design_1_wrapper design_1_wrapper_u0(
    .C0_DDR4_0_act_n                (c0_ddr4_act_n			),           
    .C0_DDR4_0_adr                  (c0_ddr4_adr			  ),
    .C0_DDR4_0_ba                   (c0_ddr4_ba				  ),
    .C0_DDR4_0_bg                   (c0_ddr4_bg				  ),
    .C0_DDR4_0_ck_c                 (c0_ddr4_ck_c_int   ),
    .C0_DDR4_0_ck_t                 (c0_ddr4_ck_t_int   ),
    .C0_DDR4_0_cke                  (c0_ddr4_cke			  ),
    .C0_DDR4_0_cs_n                 (c0_ddr4_cs_n			  ),
    .C0_DDR4_0_dm_n                 (c0_ddr4_dm_dbi_n   ),
    .C0_DDR4_0_dq                   (c0_ddr4_dq				  ),
    .C0_DDR4_0_dqs_c                (c0_ddr4_dqs_c      ),
    .C0_DDR4_0_dqs_t                (c0_ddr4_dqs_t			),
    .C0_DDR4_0_odt                  (c0_ddr4_odt        ),
    .C0_DDR4_0_reset_n              (c0_ddr4_reset_n    ),
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
    .i_axis_clk_0                   (axis_clk),
    .i_axis_rst_0                   (axis_rst),
    .i_axis_clk_1                   (axis_clk),
    .i_axis_rst_1                   (axis_rst),
     
    .i_rd_ddr_addr_0                (w_rd_unlocal_port0_addr),
    .i_rd_ddr_addr_1                ('d0),
    .i_rd_ddr_len_0                 (w_rd_unlocal_port0_len),
    .i_rd_ddr_len_1                 ('d0),
    .i_rd_ddr_strb_0                (w_rd_unlocal_port0_strb),
    .i_rd_ddr_strb_1                ('d0),
    .i_rd_ddr_valid_0               (w_rd_unlocal_port0_valid),
    .i_rd_ddr_valid_1               ('d0),
    .i_wr_ddr_addr_0                (i_wr_ddr_addr_0        ),
    .i_wr_ddr_addr_1                (i_wr_ddr_addr_1        ),
    .i_wr_ddr_cpl_ready_0           (i_wr_ddr_cpl_ready_0   ),
    .i_wr_ddr_cpl_ready_1           (i_wr_ddr_cpl_ready_1   ),
    .i_wr_ddr_ready_0               (i_wr_ddr_ready_0       ),
    .i_wr_ddr_ready_1               (i_wr_ddr_ready_1       ),
    .m_axis_0_tdata                 (),
    .m_axis_0_tkeep                 (),
    .m_axis_0_tlast                 (),
    .m_axis_0_tready                (1'b1),
    .m_axis_0_tuser                 (),
    .m_axis_0_tvalid                (),
    .m_axis_1_tdata                 (),
    .m_axis_1_tkeep                 (),
    .m_axis_1_tlast                 (),
    .m_axis_1_tready                (1'b1),
    .m_axis_1_tuser                 (),
    .m_axis_1_tvalid                (),
    .o_rd_ddr_cpl_0                 (o_rd_ddr_cpl_0       ),
    .o_rd_ddr_cpl_1                 (o_rd_ddr_cpl_1       ),
    .o_rd_ddr_ready_0               (o_rd_ddr_ready_0     ),
    .o_rd_ddr_ready_1               (o_rd_ddr_ready_1     ),
    .o_wr_ddr_cpl_addr_0            (o_wr_ddr_cpl_addr_0  ),
    .o_wr_ddr_cpl_addr_1            (o_wr_ddr_cpl_addr_1  ),
    .o_wr_ddr_cpl_len_0             (o_wr_ddr_cpl_len_0   ),
    .o_wr_ddr_cpl_len_1             (o_wr_ddr_cpl_len_1   ),
    .o_wr_ddr_cpl_queue_0           (o_wr_ddr_cpl_queue_0   ),
    .o_wr_ddr_cpl_queue_1           (o_wr_ddr_cpl_queue_1   ),
    .o_wr_ddr_cpl_strb_0            (o_wr_ddr_cpl_strb_0  ),
    .o_wr_ddr_cpl_strb_1            (o_wr_ddr_cpl_strb_1  ),
    .o_wr_ddr_cpl_valid_0           (o_wr_ddr_cpl_valid_0 ),
    .o_wr_ddr_cpl_valid_1           (o_wr_ddr_cpl_valid_1 ),
    .o_wr_ddr_len_0                 (o_wr_ddr_len_0       ),
    .o_wr_ddr_len_1                 (o_wr_ddr_len_1       ),
    .o_wr_ddr_queue_0               (o_wr_ddr_queue_0     ),
    .o_wr_ddr_queue_1               (o_wr_ddr_queue_1     ),
    .o_wr_ddr_valid_0               (o_wr_ddr_valid_0     ),
    .o_wr_ddr_valid_1               (o_wr_ddr_valid_1     ),
    .s_axis_0_tdata                 (s_axis_tdata   ),
    .s_axis_0_tdest                 (s_axis_tdest   ),
    .s_axis_0_tkeep                 (s_axis_tkeep   ),
    .s_axis_0_tlast                 (s_axis_tlast   ),
    .s_axis_0_tuser                 (s_axis_tuser   ),
    .s_axis_0_tvalid                (s_axis_tvalid  ),
    .s_axis_1_tdata                 (s_axis_tdata   ),
    .s_axis_1_tdest                 (s_axis_tdest   ),
    .s_axis_1_tkeep                 (s_axis_tkeep   ),
    .s_axis_1_tlast                 (s_axis_tlast   ),
    .s_axis_1_tuser                 (s_axis_tuser   ),
    .s_axis_1_tvalid                (s_axis_tvalid  ),
    .sys_rst_0                      (sys_rst    )
);

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

    .i_wr_local_port0_valid          (o_wr_ddr_valid_0      ),
    .i_wr_local_port0_len            (o_wr_ddr_len_0        ),
    .i_wr_local_port0_queue          (o_wr_ddr_queue_0      ),
    .o_wr_local_port0_addr           (i_wr_ddr_addr_0       ),     
    .o_wr_local_port0_ready          (i_wr_ddr_ready_0      ),
    .i_wr_local_port0_cpl_valid      (o_wr_ddr_cpl_valid_0  ),
    .o_wr_local_port0_cpl_ready      (i_wr_ddr_cpl_ready_0  ),
    .i_wr_local_port0_cpl_queue      (o_wr_ddr_cpl_queue_0  ),
    .i_wr_local_port0_cpl_len        (o_wr_ddr_cpl_len_0    ),
    .i_wr_local_port0_cpl_addr       (o_wr_ddr_cpl_addr_0   ),
    .i_wr_local_port0_cpl_strb       (o_wr_ddr_cpl_strb_0   ),

    .i_wr_local_port1_valid          (o_wr_ddr_valid_1      ),
    .i_wr_local_port1_len            (o_wr_ddr_len_1        ),
    .i_wr_local_port1_queue          (o_wr_ddr_queue_1      ),
    .o_wr_local_port1_addr           (i_wr_ddr_addr_1       ),  
    .o_wr_local_port1_ready          (i_wr_ddr_ready_1      ),
    .i_wr_local_port1_cpl_valid      (o_wr_ddr_cpl_valid_1  ),
    .o_wr_local_port1_cpl_ready      (i_wr_ddr_cpl_ready_1  ),
    .i_wr_local_port1_cpl_queue      (o_wr_ddr_cpl_queue_1  ),
    .i_wr_local_port1_cpl_len        (o_wr_ddr_cpl_len_1    ),
    .i_wr_local_port1_cpl_addr       (o_wr_ddr_cpl_addr_1   ),
    .i_wr_local_port1_cpl_strb       (o_wr_ddr_cpl_strb_1   ),


    .i_wr_unlocal_port0_valid        ('d0),
    .i_wr_unlocal_port0_len          ('d0),
    .i_wr_unlocal_port0_queue        ('d0),
    .o_wr_unlocal_port0_addr         (),
    .o_wr_unlocal_port0_ready        (),
    .i_wr_unlocal_port0_cpl_valid    ('d0),
    .o_wr_unlocal_port0_cpl_ready    (),
    .i_wr_unlocal_port0_cpl_queue    ('d0),
    .i_wr_unlocal_port0_cpl_len      ('d0),
    .i_wr_unlocal_port0_cpl_addr     ('d0),
    .i_wr_unlocal_port0_cpl_strb     ('d0),

    .i_rd_unlocal_port0_queue        ('d0),
    .i_rd_unlocal_port0_byte         (r_rd_unlocal_port0_byte),
    .i_rd_unlocal_port0_byte_valid   (r_rd_unlocal_port0_byte_valid),
    .o_rd_unlocal_port0_addr         (w_rd_unlocal_port0_addr ),
    .o_rd_unlocal_port0_len          (w_rd_unlocal_port0_len  ),
    .o_rd_unlocal_port0_strb         (w_rd_unlocal_port0_strb ),
    .o_rd_unlocal_port0_valid        (w_rd_unlocal_port0_valid),
    .i_rd_unlocal_port0_cpl          (o_rd_ddr_cpl_0),
    .i_rd_unlocal_port0_ready        (o_rd_ddr_ready_0),

    .i_wr_unlocal_port1_valid        ('d0),
    .i_wr_unlocal_port1_len          ('d0),
    .i_wr_unlocal_port1_queue        ('d0),
    .o_wr_unlocal_port1_addr         (),
    .o_wr_unlocal_port1_ready        (),
    .i_wr_unlocal_port1_cpl_valid    ('d0),
    .o_wr_unlocal_port1_cpl_ready    (),
    .i_wr_unlocal_port1_cpl_queue    ('d0),
    .i_wr_unlocal_port1_cpl_len      ('d0),
    .i_wr_unlocal_port1_cpl_addr     ('d0),
    .i_wr_unlocal_port1_cpl_strb     ('d0),

    .i_rd_unlocal_port1_queue        ('d0),
    .i_rd_unlocal_port1_byte         ('d0),
    .i_rd_unlocal_port1_byte_valid   ('d0),
    .o_rd_unlocal_port1_addr         (),
    .o_rd_unlocal_port1_len          (),
    .o_rd_unlocal_port1_strb         (),
    .o_rd_unlocal_port1_valid        (),
    .i_rd_unlocal_port1_cpl          ('d0),
    .i_rd_unlocal_port1_ready        ('d0),

    .o_local_queue_size              (w_local_queue_size  ),
    .o_unlocal_queue_size            (w_unlocal_queue_size)
);

initial begin
    s_axis_tvalid = 'd0;
    s_axis_tdata  = 'd0;
    s_axis_tlast  = 'd0;
    s_axis_tkeep  = 'd0;
    s_axis_tuser  = 'd0;
    s_axis_tdest  = 'd0;
    wait(c0_init_calib_complete_0);
    repeat(10) @(posedge axis_clk);
    repeat(100)axis_to_axi(16,8'hff,3'd1);
end

initial begin
    r_rd_unlocal_port0_byte_valid = 'd0;
    r_rd_unlocal_port0_byte = 'd0;
    rd_ddr_local_queue_0();
end


//============= 产生写AXIS数据 =============//
task axis_to_axi(
    input [15:0] len, 
    input [7 :0] keep, 
    input [2 :0] dest
);
begin:axis_to_axi
    integer i;
    s_axis_tvalid <= 'd0;
    s_axis_tdata  <= 'd0;
    s_axis_tlast  <= 'd0;
    s_axis_tkeep  <= 'd0;
    s_axis_tuser  <= 'd0;
    s_axis_tdest  <= 'd0;
    wait(!axis_rst);
    repeat(2) @(posedge axis_clk);
    for(i = 0; i < len; i = i + 1)begin
        s_axis_tvalid <= 'd1;
        s_axis_tdata  <= i + 1;
        s_axis_tuser  <= 'd0;
        s_axis_tdest  <= dest;
        if(i == len - 1)begin
            s_axis_tlast  <= 'd1;
            s_axis_tkeep  <= keep;
        end else begin
            s_axis_tlast  <= 'd0;
            s_axis_tkeep  <= 8'hff;
        end
        @(posedge axis_clk);
    end
    s_axis_tvalid <= 'd0;
    s_axis_tdata  <= 'd0;
    s_axis_tlast  <= 'd0;
    s_axis_tkeep  <= 'd0;
    s_axis_tuser  <= 'd0;
    s_axis_tdest  <= 'd0;
end
endtask
//============= 产生写ddr地址 =============//

//============= 产生读ddr描述符 =============//

task rd_ddr_local_queue_0();
begin : rd_ddr_local_queue_0
    r_rd_unlocal_port0_byte_valid <= 'd0;
    r_rd_unlocal_port0_byte <= 'd0;
    wait(w_queue0_size == 'd2048);
    r_rd_unlocal_port0_byte_valid <= 'd1;
    r_rd_unlocal_port0_byte <= w_queue0_size;
    @(posedge ddr4_ui_clk);
    r_rd_unlocal_port0_byte_valid <= 'd0;
    r_rd_unlocal_port0_byte <= 'd0;
end
endtask

  reg [ADDR_WIDTH-1:0] DDR4_ADRMOD[1:0];

  always @(*)
    if (c0_ddr4_cs_n == 4'b1111)
      cmdName = "DSEL";
    else
    if (c0_ddr4_act_n)
      casez (DDR4_ADRMOD[0][16:14])
       MRS:     cmdName = "MRS";
       REF:     cmdName = "REF";
       PRE:     cmdName = "PRE";
       WR:      cmdName = "WR";
       RD:      cmdName = "RD";
       ZQC:     cmdName = "ZQC";
       NOP:     cmdName = "NOP";
      default:  cmdName = "***";
      endcase
    else
      cmdName = "ACT";

   reg wr_en ;
   always@(posedge c0_ddr4_ck_t)begin
     if(!c0_ddr4_reset_n)begin
       wr_en <= #100 1'b0 ;
     end else begin
       if(cmdName == "WR")begin
         wr_en <= #100 1'b1 ;
       end else if (cmdName == "RD")begin
         wr_en <= #100 1'b0 ;
       end
     end
   end

genvar rnk;
generate
localparam IDX = CS_WIDTH;
for (rnk = 0; rnk < IDX; rnk++) begin:rankup
 always @(*)
    if (c0_ddr4_act_n)
      casez (c0_ddr4_adr_sdram[0][16:14])
      WR, RD: begin
        DDR4_ADRMOD[rnk] = c0_ddr4_adr_sdram[rnk] & 18'h1C7FF;
      end
      default: begin
        DDR4_ADRMOD[rnk] = c0_ddr4_adr_sdram[rnk];
      end
      endcase
    else begin
      DDR4_ADRMOD[rnk] = c0_ddr4_adr_sdram[rnk];
    end
end
endgenerate

  //===========================================================================
  //                         Memory Model instantiation
  //===========================================================================
  genvar i;
  genvar r;
  genvar s;

  generate
    if (DRAM_WIDTH == 4) begin: mem_model_x4

      DDR4_if #(.CONFIGURED_DQ_BITS (4)) iDDR4[0:(RANK_WIDTH*NUM_PHYSICAL_PARTS)-1]();
      for (r = 0; r < RANK_WIDTH; r++) begin:memModels_Ri
        for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:memModel
        ddr4_model  #
          (
           .CONFIGURED_DQ_BITS (4),
           .CONFIGURED_DENSITY (CONFIGURED_DENSITY)
           ) ddr4_model(
            .model_enable (model_enable),
            .iDDR4        (iDDR4[(r*NUM_PHYSICAL_PARTS)+i])
        );
        end
      end

      for (r = 0; r < RANK_WIDTH; r++) begin:tranDQ
        for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:tranDQ1
          for (s = 0; s < 4; s++) begin:tranDQp
            `ifdef XILINX_SIMULATOR
             short bidiDQ(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQ[s], c0_ddr4_dq[s+i*4]);
             `else
              tran bidiDQ(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQ[s], c0_ddr4_dq[s+i*4]);
             `endif
       end
    end
      end

      for (r = 0; r < RANK_WIDTH; r++) begin:tranDQS
        for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:tranDQS1
        `ifdef XILINX_SIMULATOR
        short bidiDQS(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t, c0_ddr4_dqs_t[i]);
        short bidiDQS_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c, c0_ddr4_dqs_c[i]);
        `else
          tran bidiDQS(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t, c0_ddr4_dqs_t[i]);
          tran bidiDQS_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c, c0_ddr4_dqs_c[i]);
        `endif
      end
      end

       for (i = 0; i < (CLAMSHELL_PARTS+ODD_PARTS); i++) begin:upperparts
         assign iDDR4[i*2].BG        = c0_ddr4_bg_sdram[0];
         assign iDDR4[i*2].BA        = c0_ddr4_ba_sdram[0];
         assign iDDR4[i*2].ADDR_17   = (ADDR_WIDTH == 18) ? DDR4_ADRMOD[0][ADDR_WIDTH-1] : 1'b0;
         assign iDDR4[i*2].ADDR      = DDR4_ADRMOD[0][13:0];
           assign iDDR4[i*2].CS_n      = c0_ddr4_cs_n[0];
       end
       for (i = 0; i < CLAMSHELL_PARTS; i++) begin:lowerparts
         assign iDDR4[(i*2)+1].BG        = c0_ddr4_bg_sdram[1];
         assign iDDR4[(i*2)+1].BA        = c0_ddr4_ba_sdram[1];
         assign iDDR4[(i*2)+1].ADDR_17   = (ADDR_WIDTH == 18) ? DDR4_ADRMOD[1][ADDR_WIDTH-1] : 1'b0;
         assign iDDR4[(i*2)+1].ADDR      = DDR4_ADRMOD[1][13:0];
           assign iDDR4[(i*2)+1].CS_n      = c0_ddr4_cs_n[1];
       end


     for (r = 0; r < RANK_WIDTH; r++) begin:tranADCTL_RANKS
        for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:tranADCTL
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CK = {c0_ddr4_ck_t, c0_ddr4_ck_c};
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ACT_n     = c0_ddr4_act_n;
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].RAS_n_A16 = DDR4_ADRMOD[r][16];
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CAS_n_A15 = DDR4_ADRMOD[r][15];
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].WE_n_A14  = DDR4_ADRMOD[r][14];
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CKE       = c0_ddr4_cke[r];
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ODT       = c0_ddr4_odt[r];
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].PARITY  = 1'b0;
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].TEN     = 1'b0;
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ZQ      = 1'b1;
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].PWR     = 1'b1;
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].VREF_CA = 1'b1;
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].VREF_DQ = 1'b1;
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].RESET_n = c0_ddr4_reset_n;
      end
      end
    end
    else if (DRAM_WIDTH == 8) begin: mem_model_x8

      DDR4_if #(.CONFIGURED_DQ_BITS(8)) iDDR4[0:(RANK_WIDTH*NUM_PHYSICAL_PARTS)-1]();

      for (r = 0; r < RANK_WIDTH; r++) begin:memModels_Ri1
        for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:memModel1
            ddr4_model #(
              .CONFIGURED_DQ_BITS(8),
              .CONFIGURED_DENSITY (CONFIGURED_DENSITY)
                ) ddr4_model(
              .model_enable (model_enable)
             ,.iDDR4        (iDDR4[(r*NUM_PHYSICAL_PARTS)+i])
           );
         end
       end

      for (r = 0; r < RANK_WIDTH; r++) begin:tranDQ2
        for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:tranDQ12
          for (s = 0; s < 8; s++) begin:tranDQ2
           `ifdef XILINX_SIMULATOR
           short bidiDQ(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQ[s], c0_ddr4_dq[s+i*8]);
           `else
            tran bidiDQ(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQ[s], c0_ddr4_dq[s+i*8]);
           `endif
          end
        end
      end

      for (r = 0; r < RANK_WIDTH; r++) begin:tranDQS2
        for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:tranDQS12
        `ifdef XILINX_SIMULATOR
          short bidiDQS(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t, c0_ddr4_dqs_t[i]);
          short bidiDQS_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c, c0_ddr4_dqs_c[i]);
          short bidiDM(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DM_n, c0_ddr4_dm_dbi_n[i]);
        `else
          tran bidiDQS(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t, c0_ddr4_dqs_t[i]);
          tran bidiDQS_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c, c0_ddr4_dqs_c[i]);
          tran bidiDM(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DM_n, c0_ddr4_dm_dbi_n[i]);
        `endif
        end
      end

       for (i = 0; i < (CLAMSHELL_PARTS+ODD_PARTS); i++) begin:upperparts
         assign iDDR4[i*2].BG        = c0_ddr4_bg_sdram[0];
         assign iDDR4[i*2].BA        = c0_ddr4_ba_sdram[0];
         assign iDDR4[i*2].ADDR_17   = (ADDR_WIDTH == 18) ? DDR4_ADRMOD[0][ADDR_WIDTH-1] : 1'b0;
         assign iDDR4[i*2].ADDR      = DDR4_ADRMOD[0][13:0];
         assign iDDR4[i*2].CS_n      = c0_ddr4_cs_n[0];
       end
       for (i = 0; i < CLAMSHELL_PARTS; i++) begin:lowerparts
         assign iDDR4[(i*2)+1].BG        = c0_ddr4_bg_sdram[1];
         assign iDDR4[(i*2)+1].BA        = c0_ddr4_ba_sdram[1];
         assign iDDR4[(i*2)+1].ADDR_17   = (ADDR_WIDTH == 18) ? DDR4_ADRMOD[1][ADDR_WIDTH-1] : 1'b0;
         assign iDDR4[(i*2)+1].ADDR      = DDR4_ADRMOD[1][13:0];
         assign iDDR4[(i*2)+1].CS_n      = c0_ddr4_cs_n[1];
       end


      for (r = 0; r < RANK_WIDTH; r++) begin:tranADCTL_RANKS1
        for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:tranADCTL1
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CK = {c0_ddr4_ck_t, c0_ddr4_ck_c};
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ACT_n     = c0_ddr4_act_n;
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].RAS_n_A16 = DDR4_ADRMOD[r][16];
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CAS_n_A15 = DDR4_ADRMOD[r][15];
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].WE_n_A14  = DDR4_ADRMOD[r][14];

          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CKE       = c0_ddr4_cke[r];
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ODT       = c0_ddr4_odt[r];
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].PARITY  = 1'b0;
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].TEN     = 1'b0;
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ZQ      = 1'b1;
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].PWR     = 1'b1;
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].VREF_CA = 1'b1;
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].VREF_DQ = 1'b1;
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].RESET_n = c0_ddr4_reset_n;
         end
      end

    end else begin: mem_model_x16

      if (DQ_WIDTH/16) begin: mem

      DDR4_if #(.CONFIGURED_DQ_BITS (16)) iDDR4[0:(RANK_WIDTH*NUM_PHYSICAL_PARTS)-1]();

        for (r = 0; r < RANK_WIDTH; r++) begin:memModels_Ri2
          for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:memModel2
            ddr4_model  #
            (
             .CONFIGURED_DQ_BITS (16),
             .CONFIGURED_DENSITY (CONFIGURED_DENSITY)
             )  ddr4_model(
                .model_enable (model_enable),
                .iDDR4        (iDDR4[(r*NUM_PHYSICAL_PARTS)+i])
            );
          end
        end

        for (r = 0; r < RANK_WIDTH; r++) begin:tranDQ3
          for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:tranDQ13
            for (s = 0; s < 16; s++) begin:tranDQ2
              `ifdef XILINX_SIMULATOR
              short bidiDQ(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQ[s], c0_ddr4_dq[s+i*16]);
              `else
              tran bidiDQ(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQ[s], c0_ddr4_dq[s+i*16]);
              `endif
            end
          end
        end

        for (r = 0; r < RANK_WIDTH; r++) begin:tranDQS3
          for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:tranDQS13
          `ifdef XILINX_SIMULATOR
            short bidiDQS0(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t[0], c0_ddr4_dqs_t[(2*i)]);
            short bidiDQS0_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c[0], c0_ddr4_dqs_c[(2*i)]);
            short bidiDM0(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DM_n[0], c0_ddr4_dm_dbi_n[(2*i)]);
            short bidiDQS1(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t[1], c0_ddr4_dqs_t[((2*i)+1)]);
            short bidiDQS1_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c[1], c0_ddr4_dqs_c[((2*i)+1)]);
            short bidiDM1(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DM_n[1], c0_ddr4_dm_dbi_n[((2*i)+1)]);

          `else
            tran bidiDQS0(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t[0], c0_ddr4_dqs_t[(2*i)]);
            tran bidiDQS0_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c[0], c0_ddr4_dqs_c[(2*i)]);
            tran bidiDM0(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DM_n[0], c0_ddr4_dm_dbi_n[(2*i)]);
            tran bidiDQS1(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t[1], c0_ddr4_dqs_t[((2*i)+1)]);
            tran bidiDQS1_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c[1], c0_ddr4_dqs_c[((2*i)+1)]);
            tran bidiDM1(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DM_n[1], c0_ddr4_dm_dbi_n[((2*i)+1)]);
          `endif
        end
      end

       for (i = 0; i < (CLAMSHELL_PARTS+ODD_PARTS); i++) begin:upperparts
         assign iDDR4[i*2].BG        = c0_ddr4_bg_sdram[0];
         assign iDDR4[i*2].BA        = c0_ddr4_ba_sdram[0];
         assign iDDR4[i*2].ADDR_17   = (ADDR_WIDTH == 18) ? DDR4_ADRMOD[0][ADDR_WIDTH-1] : 1'b0;
         assign iDDR4[i*2].ADDR      = DDR4_ADRMOD[0][13:0];
         assign iDDR4[i*2].CS_n      = c0_ddr4_cs_n[0];
       end
       for (i = 0; i < CLAMSHELL_PARTS; i++) begin:lowerparts
         assign iDDR4[(i*2)+1].BG        = c0_ddr4_bg_sdram[1];
         assign iDDR4[(i*2)+1].BA        = c0_ddr4_ba_sdram[1];
         assign iDDR4[(i*2)+1].ADDR_17   = (ADDR_WIDTH == 18) ? DDR4_ADRMOD[1][ADDR_WIDTH-1] : 1'b0;
         assign iDDR4[(i*2)+1].ADDR      = DDR4_ADRMOD[1][13:0];
         assign iDDR4[(i*2)+1].CS_n      = c0_ddr4_cs_n[1];
       end


    for (r = 0; r < RANK_WIDTH; r++) begin:tranADCTL_RANKS1
      for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:tranADCTL1
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CK = {c0_ddr4_ck_t, c0_ddr4_ck_c};
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ACT_n     = c0_ddr4_act_n;
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].RAS_n_A16 = DDR4_ADRMOD[r][16];
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CAS_n_A15 = DDR4_ADRMOD[r][15];
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].WE_n_A14  = DDR4_ADRMOD[r][14];
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CKE       = c0_ddr4_cke[r];
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ODT       = c0_ddr4_odt[r];
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].PARITY  = 1'b0;
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].TEN     = 1'b0;
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ZQ      = 1'b1;
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].PWR     = 1'b1;
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].VREF_CA = 1'b1;
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].VREF_DQ = 1'b1;
          assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].RESET_n = c0_ddr4_reset_n;
          end
        end
      end

      if (DQ_WIDTH%16) begin: mem_extra_bits
       // DDR4 X16 dual rank is not supported
        DDR4_if #(.CONFIGURED_DQ_BITS (16)) iDDR4[(DQ_WIDTH/DRAM_WIDTH):(DQ_WIDTH/DRAM_WIDTH)]();

        ddr4_model  #
          (
           .CONFIGURED_DQ_BITS (16),
           .CONFIGURED_DENSITY (CONFIGURED_DENSITY)
           )  ddr4_model(
            .model_enable (model_enable),
            .iDDR4        (iDDR4[(DQ_WIDTH/DRAM_WIDTH)])
        );

        for (i = (DQ_WIDTH/DRAM_WIDTH)*16; i < DQ_WIDTH; i=i+1) begin:tranDQ
          `ifdef XILINX_SIMULATOR
          short bidiDQ(iDDR4[i/16].DQ[i%16], c0_ddr4_dq[i]);
          short bidiDQ_msb(iDDR4[i/16].DQ[(i%16)+8], c0_ddr4_dq[i]);
          `else
          tran bidiDQ(iDDR4[i/16].DQ[i%16], c0_ddr4_dq[i]);
          tran bidiDQ_msb(iDDR4[i/16].DQ[(i%16)+8], c0_ddr4_dq[i]);
          `endif
        end

        `ifdef XILINX_SIMULATOR
        short bidiDQS0(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_t[0], c0_ddr4_dqs_t[DQS_WIDTH-1]);
        short bidiDQS0_(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_c[0], c0_ddr4_dqs_c[DQS_WIDTH-1]);
        short bidiDM0(iDDR4[DQ_WIDTH/DRAM_WIDTH].DM_n[0], c0_ddr4_dm_dbi_n[DM_WIDTH-1]);
        short bidiDQS1(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_t[1], c0_ddr4_dqs_t[DQS_WIDTH-1]);
        short bidiDQS1_(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_c[1], c0_ddr4_dqs_c[DQS_WIDTH-1]);
        short bidiDM1(iDDR4[DQ_WIDTH/DRAM_WIDTH].DM_n[1], c0_ddr4_dm_dbi_n[DM_WIDTH-1]);
        `else
        tran bidiDQS0(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_t[0], c0_ddr4_dqs_t[DQS_WIDTH-1]);
        tran bidiDQS0_(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_c[0], c0_ddr4_dqs_c[DQS_WIDTH-1]);
        tran bidiDM0(iDDR4[DQ_WIDTH/DRAM_WIDTH].DM_n[0], c0_ddr4_dm_dbi_n[DM_WIDTH-1]);
        tran bidiDQS1(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_t[1], c0_ddr4_dqs_t[DQS_WIDTH-1]);
        tran bidiDQS1_(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_c[1], c0_ddr4_dqs_c[DQS_WIDTH-1]);
        tran bidiDM1(iDDR4[DQ_WIDTH/DRAM_WIDTH].DM_n[1], c0_ddr4_dm_dbi_n[DM_WIDTH-1]);
        `endif

        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].CK = {c0_ddr4_ck_t, c0_ddr4_ck_c};
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].ACT_n = c0_ddr4_act_n;
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].RAS_n_A16 = DDR4_ADRMOD[0][16];
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].CAS_n_A15 = DDR4_ADRMOD[0][15];
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].WE_n_A14 = DDR4_ADRMOD[0][14];
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].CKE = c0_ddr4_cke[0];
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].ODT = c0_ddr4_odt[0];
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].BG = c0_ddr4_bg_sdram[0];
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].BA = c0_ddr4_ba_sdram[0];
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].ADDR_17 = (ADDR_WIDTH == 18) ? DDR4_ADRMOD[0][ADDR_WIDTH-1] : 1'b0;
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].ADDR = DDR4_ADRMOD[0][13:0];
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].RESET_n = c0_ddr4_reset_n;
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].TEN     = 1'b0;
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].ZQ      = 1'b1;
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].PWR     = 1'b1;
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].VREF_CA = 1'b1;
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].VREF_DQ = 1'b1;
        assign iDDR4[DQ_WIDTH/DRAM_WIDTH].CS_n = c0_ddr4_cs_n[0];
      end
    end
  endgenerate

endmodule
