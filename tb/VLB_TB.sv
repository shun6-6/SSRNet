`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/11 15:14:52
// Design Name: 
// Module Name: VLB_TB
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


module VLB_TB();


reg clk,rst;

always begin
    clk = 0;
    #10;
    clk = 1;
    #10;
end

initial begin
    rst = 1;
    #100;
    @(posedge clk) rst = 0;
end

reg             rs_ctrl_rx_axis_tvalid;
reg  [63 :0]    rs_ctrl_rx_axis_tdata ;
reg             rs_ctrl_rx_axis_tlast ;
reg  [7  :0]    rs_ctrl_rx_axis_tkeep ;
reg             rs_ctrl_rx_axis_tuser ;

reg             rs0_uplink0_rx_axis_tvalid;
reg  [63 :0]    rs0_uplink0_rx_axis_tdata ;
reg             rs0_uplink0_rx_axis_tlast ;
reg  [7  :0]    rs0_uplink0_rx_axis_tkeep ;
reg             rs0_uplink0_rx_axis_tuser ;

reg             r0_check_queue_resp_ready;
reg  [255:0]    r0_local_queue_size      ;
reg  [255:0]    r0_unlocal_queue_size    ;

reg             r1_check_queue_resp_ready;
reg  [255:0]    r1_local_queue_size      ;
reg  [255:0]    r1_unlocal_queue_size    ;

wire w0_check_queue_req_valid;
wire w1_check_queue_req_valid;

wire            wm_uplink0_tx_axis_tvalid ;
wire [63 :0]    wm_uplink0_tx_axis_tdata  ;
wire            wm_uplink0_tx_axis_tlast  ;
wire [7  :0]    wm_uplink0_tx_axis_tkeep  ;
wire            wm_uplink0_tx_axis_tuser  ;
wire            wm_uplink1_tx_axis_tvalid ;
wire [63 :0]    wm_uplink1_tx_axis_tdata  ;
wire            wm_uplink1_tx_axis_tlast  ;
wire [7  :0]    wm_uplink1_tx_axis_tkeep  ;
wire            wm_uplink1_tx_axis_tuser  ;

wire            wm1_uplink0_tx_axis_tvalid;
wire [63 :0]    wm1_uplink0_tx_axis_tdata ;
wire            wm1_uplink0_tx_axis_tlast ;
wire [7  :0]    wm1_uplink0_tx_axis_tkeep ;
wire            wm1_uplink0_tx_axis_tuser ;
wire            wm1_uplink1_tx_axis_tvalid;
wire [63 :0]    wm1_uplink1_tx_axis_tdata ;
wire            wm1_uplink1_tx_axis_tlast ;
wire [7  :0]    wm1_uplink1_tx_axis_tkeep ;
wire            wm1_uplink1_tx_axis_tuser ;


reg [127:0] r_tx_state_monitor;
reg [127:0] r_rx_state_monitor;

localparam      P_TX_IDLE           = 'd0,
                P_COMPT_CAPACITY    = 'd1,
                P_TX_CAPACITY       = 'd2,
                P_COMPT_OFFER       = 'd3,
                P_TX_OFFER          = 'd4,
                P_COMPT_RELAY       = 'd5,
                P_TX_RELAY          = 'd6;

localparam      P_RX_IDLE           = 'd0,
                P_RX_CAPACITY       = 'd1,
                P_RX_OFFER          = 'd2,
                P_RX_RELAY          = 'd3;  

always@(*)begin
  case(VLB_module_u0.VLB_port_module_port0.r_tx_cur_state)
        P_TX_IDLE        : r_tx_state_monitor = "TX_IDLE       ";
        P_COMPT_CAPACITY : r_tx_state_monitor = "COMPT_CAPACITY";
        P_TX_CAPACITY    : r_tx_state_monitor = "TX_CAPACITY   ";
        P_COMPT_OFFER    : r_tx_state_monitor = "COMPT_OFFER   ";
        P_TX_OFFER       : r_tx_state_monitor = "TX_OFFER      ";
        P_COMPT_RELAY    : r_tx_state_monitor = "COMPT_RELAY   ";
        P_TX_RELAY       : r_tx_state_monitor = "TX_RELAY      ";
    default : r_tx_state_monitor = "TX_IDLE ";
  endcase
end

always@(*)begin
    case(VLB_module_u0.VLB_port_module_port0.r_rx_cur_state)
        P_RX_IDLE     : r_rx_state_monitor = "RX_IDLE    ";
        P_RX_CAPACITY : r_rx_state_monitor = "RX_CAPACITY";
        P_RX_OFFER    : r_rx_state_monitor = "RX_OFFER   ";
        P_RX_RELAY    : r_rx_state_monitor = "RX_RELAY   ";
      default : r_tx_state_monitor = "RX_IDLE ";
    endcase
  end

VLB_module#(
    .C_M_AXI_ADDR_WIDTH  (32                    ),
    .P_QUEUE_NUM         (8                     ),//== P_TOR_NUM
    .P_CAPACITY_PKT_TYPE (16'hff00              ),
    .P_OFFER_PKT_TYPE    (16'hff01              ),
    .P_RELAY_PKT_TYPE    (16'hff02              ),
    .P_SLOT_ID_TYPE      (16'hff03              ),
    .P_TIME_STAMP_TYPE   (16'hffff              ),
    .P_SLOT_NUM          (2                     ),
    .P_TOR_NUM           (8                     ),
    .P_OCS_NUM           (2                     ),
    .P_MY_OCS            (0                     ),
    .P_MY_TOR_MAC        (48'h8D_BC_5C_4A_10_00 ),
    .P_MAC_HEAD          (32'h8D_BC_5C_4A       ),
    .P_SLOT_MAX_PKT_NUM  (32'd100       ),
    .P_ETH_MIN_LEN       (8  )
)VLB_module_u0(
    .i_clk                       (clk),
    .i_rst                       (rst),  
    .i_syn_time_stamp            (64'd0),

    .s_ctrl_rx_axis_tvalid       (rs_ctrl_rx_axis_tvalid    ),
    .s_ctrl_rx_axis_tdata        (rs_ctrl_rx_axis_tdata     ),
    .s_ctrl_rx_axis_tlast        (rs_ctrl_rx_axis_tlast     ),
    .s_ctrl_rx_axis_tkeep        (rs_ctrl_rx_axis_tkeep     ),
    .s_ctrl_rx_axis_tuser        (rs_ctrl_rx_axis_tuser     ),

    .s_uplink0_rx_axis_tvalid    (rs0_uplink0_rx_axis_tvalid),
    .s_uplink0_rx_axis_tdata     (rs0_uplink0_rx_axis_tdata ),
    .s_uplink0_rx_axis_tlast     (rs0_uplink0_rx_axis_tlast ),
    .s_uplink0_rx_axis_tkeep     (rs0_uplink0_rx_axis_tkeep ),
    .s_uplink0_rx_axis_tuser     (rs0_uplink0_rx_axis_tuser ),

    .m_uplink0_tx_axis_tvalid    (wm_uplink0_tx_axis_tvalid ),
    .m_uplink0_tx_axis_tdata     (wm_uplink0_tx_axis_tdata  ),
    .m_uplink0_tx_axis_tlast     (wm_uplink0_tx_axis_tlast  ),
    .m_uplink0_tx_axis_tkeep     (wm_uplink0_tx_axis_tkeep  ),
    .m_uplink0_tx_axis_tuser     (wm_uplink0_tx_axis_tuser  ),
    .m_uplink0_tx_axis_tready    ('d1                       ),

    .s_uplink1_rx_axis_tvalid    (wm1_uplink1_tx_axis_tvalid),
    .s_uplink1_rx_axis_tdata     (wm1_uplink1_tx_axis_tdata ),
    .s_uplink1_rx_axis_tlast     (wm1_uplink1_tx_axis_tlast ),
    .s_uplink1_rx_axis_tkeep     (wm1_uplink1_tx_axis_tkeep ),
    .s_uplink1_rx_axis_tuser     (wm1_uplink1_tx_axis_tuser ),

    .m_uplink1_tx_axis_tvalid    (wm_uplink1_tx_axis_tvalid ),
    .m_uplink1_tx_axis_tdata     (wm_uplink1_tx_axis_tdata  ),
    .m_uplink1_tx_axis_tlast     (wm_uplink1_tx_axis_tlast  ),
    .m_uplink1_tx_axis_tkeep     (wm_uplink1_tx_axis_tkeep  ),
    .m_uplink1_tx_axis_tuser     (wm_uplink1_tx_axis_tuser  ),
    .m_uplink1_tx_axis_tready    ('d1                       ),

    .o_check_queue_req_valid     (w0_check_queue_req_valid   ),//握手跨时钟
    .i_check_queue_resp_ready    (r0_check_queue_resp_ready ),
    .i_local_queue_size          (r0_local_queue_size       ),
    .i_unlocal_queue_size        (r0_unlocal_queue_size     ),

    .o_port0_my_local2_pkt_size  (),
    .o_port0_send_local2_valid   (),
    .o_port0_cur_direct_tor      (),
    .o_port0_tx_relay            (),
    .o_port0_tx_relay_valid      (),

    .o_port1_my_local2_pkt_size  (),
    .o_port1_send_local2_valid   (),
    .o_port1_cur_direct_tor      (),
    .o_port1_tx_relay            (),
    .o_port1_tx_relay_valid      ()
);

VLB_module#(
    .C_M_AXI_ADDR_WIDTH  (32                    ),
    .P_QUEUE_NUM         (8                     ),//== P_TOR_NUM
    .P_CAPACITY_PKT_TYPE (16'hff00              ),
    .P_OFFER_PKT_TYPE    (16'hff01              ),
    .P_RELAY_PKT_TYPE    (16'hff02              ),
    .P_SLOT_ID_TYPE      (16'hff03              ),
    .P_TIME_STAMP_TYPE   (16'hffff              ),
    .P_SLOT_NUM          (2                     ),
    .P_TOR_NUM           (8                     ),
    .P_OCS_NUM           (2                     ),
    .P_MY_OCS            (0                     ),
    .P_MY_TOR_MAC        (48'h8D_BC_5C_4A_10_01 ),
    .P_MAC_HEAD          (32'h8D_BC_5C_4A       ),
    .P_SLOT_MAX_PKT_NUM  (32'd100       ),
    .P_ETH_MIN_LEN       (8  )
)VLB_module_u1(
    .i_clk                       (clk),
    .i_rst                       (rst),  
    .i_syn_time_stamp            (64'd0),

    .s_ctrl_rx_axis_tvalid       (rs_ctrl_rx_axis_tvalid    ),
    .s_ctrl_rx_axis_tdata        (rs_ctrl_rx_axis_tdata     ),
    .s_ctrl_rx_axis_tlast        (rs_ctrl_rx_axis_tlast     ),
    .s_ctrl_rx_axis_tkeep        (rs_ctrl_rx_axis_tkeep     ),
    .s_ctrl_rx_axis_tuser        (rs_ctrl_rx_axis_tuser     ),

    .s_uplink0_rx_axis_tvalid    (wm_uplink0_tx_axis_tvalid),
    .s_uplink0_rx_axis_tdata     (wm_uplink0_tx_axis_tdata ),
    .s_uplink0_rx_axis_tlast     (wm_uplink0_tx_axis_tlast ),
    .s_uplink0_rx_axis_tkeep     (wm_uplink0_tx_axis_tkeep ),
    .s_uplink0_rx_axis_tuser     (wm_uplink0_tx_axis_tuser ),

    .m_uplink0_tx_axis_tvalid    (wm1_uplink0_tx_axis_tvalid ),
    .m_uplink0_tx_axis_tdata     (wm1_uplink0_tx_axis_tdata  ),
    .m_uplink0_tx_axis_tlast     (wm1_uplink0_tx_axis_tlast  ),
    .m_uplink0_tx_axis_tkeep     (wm1_uplink0_tx_axis_tkeep  ),
    .m_uplink0_tx_axis_tuser     (wm1_uplink0_tx_axis_tuser  ),
    .m_uplink0_tx_axis_tready    ('d1                       ),

    .s_uplink1_rx_axis_tvalid    (),
    .s_uplink1_rx_axis_tdata     (),
    .s_uplink1_rx_axis_tlast     (),
    .s_uplink1_rx_axis_tkeep     (),
    .s_uplink1_rx_axis_tuser     (),

    .m_uplink1_tx_axis_tvalid    (wm1_uplink1_tx_axis_tvalid ),
    .m_uplink1_tx_axis_tdata     (wm1_uplink1_tx_axis_tdata  ),
    .m_uplink1_tx_axis_tlast     (wm1_uplink1_tx_axis_tlast  ),
    .m_uplink1_tx_axis_tkeep     (wm1_uplink1_tx_axis_tkeep  ),
    .m_uplink1_tx_axis_tuser     (wm1_uplink1_tx_axis_tuser  ),
    .m_uplink1_tx_axis_tready    ('d1                       ),

    .o_check_queue_req_valid     (w1_check_queue_req_valid   ),//握手跨时钟
    .i_check_queue_resp_ready    (r1_check_queue_resp_ready ),
    .i_local_queue_size          (r1_local_queue_size       ),
    .i_unlocal_queue_size        (r1_unlocal_queue_size     ),

    .o_port0_my_local2_pkt_size  (),
    .o_port0_send_local2_valid   (),
    .o_port0_cur_direct_tor      (),
    .o_port0_tx_relay            (),
    .o_port0_tx_relay_valid      (),

    .o_port1_my_local2_pkt_size  (),
    .o_port1_send_local2_valid   (),
    .o_port1_cur_direct_tor      (),
    .o_port1_tx_relay            (),
    .o_port1_tx_relay_valid      ()
);

initial begin
    rs_ctrl_rx_axis_tvalid = 'd0;
    rs_ctrl_rx_axis_tdata  = 'd0;
    rs_ctrl_rx_axis_tlast  = 'd0;
    rs_ctrl_rx_axis_tkeep  = 'd0;
    rs_ctrl_rx_axis_tuser  = 'd0;
    wait(!rst);
    repeat(5)@(posedge clk);
    controller();
end

initial begin
    r0_check_queue_resp_ready = 'd0;
    r0_local_queue_size       = 'd0;
    r0_unlocal_queue_size     = 'd0; 
    wait(!rst);
    repeat(5)@(posedge clk);
    fork
        port0_queue_size();
        port1_queue_size();
    join
end


task controller();
begin:controller
    integer i;
    rs_ctrl_rx_axis_tvalid <= 'd0;
    rs_ctrl_rx_axis_tdata  <= 'd0;
    rs_ctrl_rx_axis_tlast  <= 'd0;
    rs_ctrl_rx_axis_tkeep  <= 'd0;
    rs_ctrl_rx_axis_tuser  <= 'd0;
    wait(!rst);
    repeat(5)@(posedge clk);
    for(i = 0; i < 8; i = i + 1)begin
        rs_ctrl_rx_axis_tvalid <= 'd1;
        rs_ctrl_rx_axis_tkeep  <= 8'hff;
        rs_ctrl_rx_axis_tuser  <= 'd0; 
        if(i == 7)
            rs_ctrl_rx_axis_tlast  <= 'd1;
        else
            rs_ctrl_rx_axis_tlast  <= 'd0;
        if(i == 0)
            rs_ctrl_rx_axis_tdata  <= {48'h8D_BC_5C_4A_10_00,16'd0};
        else if(i == 1)
            rs_ctrl_rx_axis_tdata  <= {32'd0,16'hff03,15'd0,1'b0};
        else
            rs_ctrl_rx_axis_tdata <= 'd0;
        @(posedge clk);
    end
    rs_ctrl_rx_axis_tvalid <= 'd0;
    rs_ctrl_rx_axis_tdata  <= 'd0;
    rs_ctrl_rx_axis_tlast  <= 'd0;
    rs_ctrl_rx_axis_tkeep  <= 'd0;
    rs_ctrl_rx_axis_tuser  <= 'd0;
end
endtask

 
task port0_queue_size();
begin:queue_size
    r0_check_queue_resp_ready <= 'd0;
    r0_local_queue_size       <= 'd0;
    r0_unlocal_queue_size     <= 'd0;    
    wait(w0_check_queue_req_valid);
    @(posedge clk);
    r0_check_queue_resp_ready <= 'd1;
    r0_local_queue_size       <= {32'd10,32'd10,32'd10,32'd10,32'd10,32'd10,32'd10,32'd00};
    r0_unlocal_queue_size     <= {32'd10,32'd00,32'd10,32'd00,32'd10,32'd00,32'd10,32'd00}; 
    @(posedge clk);
    r0_check_queue_resp_ready <= 'd0;
    r0_local_queue_size       <= r0_local_queue_size  ;
    r0_unlocal_queue_size     <= r0_unlocal_queue_size;  
end
endtask

task port1_queue_size();
begin:queue_size
    r1_check_queue_resp_ready <= 'd0;
    r1_local_queue_size       <= 'd0;
    r1_unlocal_queue_size     <= 'd0;    
    wait(w0_check_queue_req_valid);
    @(posedge clk);
    r1_check_queue_resp_ready <= 'd1;
    r1_local_queue_size       <= {32'd10,32'd10,32'd10,32'd10,32'd10,32'd10,32'd00,32'd20};
    r1_unlocal_queue_size     <= {32'd00,32'd10,32'd00,32'd10,32'd00,32'd10,32'd00,32'd20}; 
    @(posedge clk);
    r1_check_queue_resp_ready <= 'd0;
    r1_local_queue_size       <= r1_local_queue_size  ;
    r1_unlocal_queue_size     <= r1_unlocal_queue_size;  
end
endtask

endmodule
