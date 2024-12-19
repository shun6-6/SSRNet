`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 18:34:47
// Design Name: 
// Module Name: time_syn_rx
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


module time_syn_rx#(
    parameter       P_SLOT_ID_TYPE       = 16'hff03
)(
    input           i_clk                   ,
    input           i_rst                   ,
    /*----ctrl port----*/   
    output [63:0]   o_recv_time_stamp       ,
    output          o_recv_ts_valid         ,
    output [63:0]   o_recv_std_time         ,
    output          o_recv_std_valid        ,
    output [63:0]   o_recv_return_ts        ,
    output          o_recv_return_valid     ,
    output          o_cur_slot_id          ,
    output          o_syn_start             ,
    /*----axis port----*/
    input           s_ctrl_rx_axis_tvalid   ,
    input  [63:0]   s_ctrl_rx_axis_tdata    ,
    input           s_ctrl_rx_axis_tlast    ,
    input  [7 :0]   s_ctrl_rx_axis_tkeep    ,
    input           s_ctrl_rx_axis_tuser     
);
//*********************************************parameter*************************************************//
localparam      P_TS_PRE        =   64'h00_00_00_00_00_00_66;//102
localparam      P_STD_PRE       =   64'h00_00_00_00_00_00_88;//136
localparam      P_RETURN_PRE    =   64'h00_00_00_00_00_00_55;//85
localparam      P_FRAME_LEN     =   8'd8;
//*********************************************function**************************************************//

//***********************************************FSM*****************************************************//

//***********************************************reg*****************************************************//
reg             ri_rx_axis_tvalid   ;
reg  [63:0]     ri_rx_axis_tdata    ;
reg             ri_rx_axis_tlast    ;
reg  [7 :0]     ri_rx_axis_tkeep    ;
reg             ri_rx_axis_tuser    ;
reg  [63:0]     ro_recv_time_stamp  ;
reg             ro_recv_ts_valid    ;
reg  [63:0]     ro_recv_std_time    ;
reg             ro_recv_std_valid   ;
reg  [63:0]     ro_recv_return_ts   ;
reg             ro_recv_return_valid;

//控制器接口AXIS
reg  [15 :0]                    r_recv_ctrl_cnt     ;
reg                             r_slot_start        ;

reg  [0 : 0]                    r_cur_slot_id       ;
reg  [47: 0]                    r_dest_tor_mac      ;
reg  [63: 0]                    rs_ctrl_rx_axis_tdata = 'd0;
//***********************************************wire****************************************************//

//*********************************************component*************************************************//

//**********************************************assign***************************************************//
assign  o_recv_time_stamp   = ri_rx_axis_tdata      ;
assign  o_recv_ts_valid     = ro_recv_ts_valid      ;
assign  o_recv_std_time     = ri_rx_axis_tdata      ;
assign  o_recv_std_valid    = ro_recv_std_valid     ;
assign  o_recv_return_ts    = ri_rx_axis_tdata      ;
assign  o_recv_return_valid = ro_recv_return_valid  ;
assign  o_cur_slot_id = r_cur_slot_id;
assign  o_syn_start   = r_slot_start  ;
//**********************************************always***************************************************//
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        ri_rx_axis_tvalid <= 'd0;
        ri_rx_axis_tdata  <= 'd0;
        ri_rx_axis_tlast  <= 'd0;
        ri_rx_axis_tkeep  <= 'd0;
        ri_rx_axis_tuser  <= 'd0;
    end
    else begin
        ri_rx_axis_tvalid <= s_ctrl_rx_axis_tvalid;
        ri_rx_axis_tdata  <= s_ctrl_rx_axis_tdata ;
        ri_rx_axis_tlast  <= s_ctrl_rx_axis_tlast ;
        ri_rx_axis_tkeep  <= s_ctrl_rx_axis_tkeep ;
        ri_rx_axis_tuser  <= s_ctrl_rx_axis_tuser ;        
    end
end
 
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_recv_ts_valid   <= 'd0;       
    else if(ri_rx_axis_tvalid && ri_rx_axis_tdata == P_TS_PRE)
        ro_recv_ts_valid   <= 'd1;         
    else 
        ro_recv_ts_valid   <= 'd0;            
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        ro_recv_std_valid <= 'd0;       
    end
    else if(ri_rx_axis_tvalid && ri_rx_axis_tdata == P_STD_PRE)begin
        ro_recv_std_valid <= 'd1;         
    end
    else begin
        ro_recv_std_valid <= 'd0;            
    end
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        ro_recv_return_valid <= 'd0;       
    end
    else if(ri_rx_axis_tvalid && ri_rx_axis_tdata == P_RETURN_PRE)begin
        ro_recv_return_valid <= 'd1;         
    end
    else begin
        ro_recv_return_valid <= 'd0;            
    end
end

//控制器接口，记录时间戳、时隙开始标识以及时隙ID
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_recv_ctrl_cnt <= 'd0;
    else if(s_ctrl_rx_axis_tvalid && s_ctrl_rx_axis_tlast)
        r_recv_ctrl_cnt <= 'd0;
    else if(s_ctrl_rx_axis_tvalid)
        r_recv_ctrl_cnt <= r_recv_ctrl_cnt + 'd1;
    else
        r_recv_ctrl_cnt <= r_recv_ctrl_cnt;
end

always @(posedge i_clk)begin
    rs_ctrl_rx_axis_tdata <= s_ctrl_rx_axis_tdata;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_dest_tor_mac <= 'd0;
    else if(s_ctrl_rx_axis_tvalid && r_recv_ctrl_cnt == 1 && s_ctrl_rx_axis_tdata[31:16] == P_SLOT_ID_TYPE)
        r_dest_tor_mac <= {rs_ctrl_rx_axis_tdata[15:0],s_ctrl_rx_axis_tdata[63:32]};
    else
        r_dest_tor_mac <= r_dest_tor_mac;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_cur_slot_id <= 'd0;
    else if(s_ctrl_rx_axis_tvalid && r_recv_ctrl_cnt == 1 && s_ctrl_rx_axis_tdata[31:16] == P_SLOT_ID_TYPE)
        r_cur_slot_id <= s_ctrl_rx_axis_tdata[1 - 1 : 0];
    else
        r_cur_slot_id <= r_cur_slot_id;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_slot_start <= 'd0;
    else if(s_ctrl_rx_axis_tvalid && r_recv_ctrl_cnt == 1 && s_ctrl_rx_axis_tdata[31:16] == P_SLOT_ID_TYPE)
        r_slot_start <= 'd1;
    else
        r_slot_start <= 'd0;
end


endmodule
