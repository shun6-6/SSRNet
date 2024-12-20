`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/20 11:08:31
// Design Name: 
// Module Name: ctrl_tx
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


module ctrl_tx#(
    parameter       P_SLOT_ID_TYPE  = 16'hff03              ,
    parameter       P_SIM_START     = 16'hff0a              ,
    parameter       P_MY_MAC        = 48'h8D_BC_5C_4A_1A_1F ,
    parameter       P_DEST_TOR_MAC  = 48'h8D_BC_5C_4A_00_00 
)(
    input           i_clk               ,
    input           i_rst               ,

    input  [7 : 0]  i_chnl_ready        ,
    input           i_new_slot_start    ,
    input           i_slot_id           ,
    input  [63: 0]  i_time_stamp        ,

    output          o_tx_axis_tvalid    ,
    output [63 :0]  o_tx_axis_tdata     ,
    output          o_tx_axis_tlast     ,
    output [7  :0]  o_tx_axis_tkeep     ,
    output          o_tx_axis_tuser     ,
    input           i_tx_axis_tready    
);

localparam      P_PKT_LEN = 8;

reg             ri_chnl_ready = 0;
reg             r_slot_id;
reg             ro_tx_axis_tvalid   ;
reg  [63 :0]    ro_tx_axis_tdata    ;
reg             ro_tx_axis_tlast    ;
reg  [7  :0]    ro_tx_axis_tkeep    ;
reg             ro_tx_axis_tuser    ;
reg  [4:0]      r_tx_cnt;
reg             r_sim_flag          ;

wire w_tx_en;
wire w_sim_start;

assign w_tx_en = ro_tx_axis_tvalid & i_tx_axis_tready;
assign o_tx_axis_tvalid = ro_tx_axis_tvalid ;
assign o_tx_axis_tdata  = ro_tx_axis_tdata  ;
assign o_tx_axis_tlast  = ro_tx_axis_tlast  ;
assign o_tx_axis_tkeep  = 8'hff  ;
assign o_tx_axis_tuser  = 'd0  ;
assign w_sim_start = i_chnl_ready && !ri_chnl_ready;

always @(posedge i_clk)
    ri_chnl_ready <= i_chnl_ready;


always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_slot_id <= 'd0;
    else if(i_new_slot_start)
        r_slot_id <= i_slot_id;
    else
        r_slot_id <= r_slot_id;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_tx_cnt <= 'd0;
    else if(r_tx_cnt == P_PKT_LEN - 1 && w_tx_en)
        r_tx_cnt <= 'd0;
    else if(w_tx_en)
        r_tx_cnt <= r_tx_cnt + 1;
    else
        r_tx_cnt <= r_tx_cnt;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_tx_axis_tvalid <= 'd0;
    else if(r_tx_cnt == P_PKT_LEN - 1 && w_tx_en)
        ro_tx_axis_tvalid <= 'd0;
    else if(w_sim_start)
        ro_tx_axis_tvalid <= 'd1;
    else if(i_new_slot_start)
        ro_tx_axis_tvalid <= 'd1;
    else
        ro_tx_axis_tvalid <= ro_tx_axis_tvalid;
end


always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_sim_flag <= 'd0;
    else if(w_tx_en && ro_tx_axis_tlast)
        r_sim_flag <= 'd0;
    else if(w_sim_start)
        r_sim_flag <= 'd1;
    else
        r_sim_flag <= r_sim_flag;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_tx_axis_tlast <= 'd0;
    else if(r_tx_cnt == P_PKT_LEN - 1 && w_tx_en)
        ro_tx_axis_tlast <= 'd0;
    else if(r_tx_cnt == P_PKT_LEN - 2 && w_tx_en)
        ro_tx_axis_tlast <= 'd1;
    else
        ro_tx_axis_tlast <= ro_tx_axis_tlast;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_tx_axis_tdata <= 'd0;
    else if(i_new_slot_start)
        ro_tx_axis_tdata <= {P_MY_MAC,P_DEST_TOR_MAC[47:32]};
    else if(w_tx_en && r_sim_flag)
        case (r_tx_cnt)
            0       : ro_tx_axis_tdata <= {P_DEST_TOR_MAC[31:0],P_SIM_START,{15'd0,r_slot_id}};
            1       : ro_tx_axis_tdata <= i_time_stamp;
            default : ro_tx_axis_tdata <= i_time_stamp;
        endcase
    else if(w_tx_en && !r_sim_flag)
        case (r_tx_cnt)
            0       : ro_tx_axis_tdata <= {P_DEST_TOR_MAC[31:0],P_SLOT_ID_TYPE,{15'd0,r_slot_id}};
            1       : ro_tx_axis_tdata <= i_time_stamp;
            default : ro_tx_axis_tdata <= i_time_stamp;
        endcase
    else
        ro_tx_axis_tdata <= 'd0;
end

// always @(posedge i_clk or posedge i_rst)begin
//     if(i_rst)

//     else if()

//     else
        
// end


endmodule
