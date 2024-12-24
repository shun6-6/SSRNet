`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/20 20:15:21
// Design Name: 
// Module Name: ocs_slot_ctrl
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


module ocs_slot_ctrl#(
    parameter       P_CONFIG_DELAY  = 32'h0000_0960,
    parameter       P_SLOT_LEN      = 32'h0000_5CD0 
)(
    input           i_clk           ,
    input           i_rst           ,

    input           i_chnl_ready    ,
    output          o_slot_id       ,
    output          o_slot_start    
);

reg             ro_slot_id      ;
reg             ro_slot_start   ;
reg             r_config_flag   ;
reg             ri_chnl_ready = 0 ;

reg  [15: 0]    r_slot_cnt  ;

assign o_slot_id    = ro_slot_id   ;
assign o_slot_start = ro_slot_start;

always @(posedge i_clk)
    ri_chnl_ready <= i_chnl_ready;

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_slot_cnt <= 'd0;
    else if(r_slot_cnt == P_SLOT_LEN && !r_config_flag)
        r_slot_cnt <= 'd0;
    else if(r_slot_cnt == P_CONFIG_DELAY && r_config_flag)
        r_slot_cnt <= 'd0;
    else if(ri_chnl_ready)
        r_slot_cnt <= r_slot_cnt + 1'b1;
    else
        r_slot_cnt <= r_slot_cnt;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_config_flag <= 'd0;
    else if(r_slot_cnt == P_CONFIG_DELAY && r_config_flag)
        r_config_flag <= 'd0;
    else if(r_slot_cnt == P_SLOT_LEN && !r_config_flag)
        r_config_flag <= 'd1;
    else
        r_config_flag <= r_config_flag;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ro_slot_start <= 'd0;
    else if(r_slot_cnt == P_CONFIG_DELAY && r_config_flag)
        ro_slot_start <= 'd1;
    else
        ro_slot_start <= 'd0;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        ro_slot_id <= 'd0;
    else if(r_slot_cnt == P_CONFIG_DELAY && r_config_flag)
        ro_slot_id <= ro_slot_id + 'd1;
    else
        ro_slot_id <= ro_slot_id;
end

// always @(posedge i_clk or posedge i_rst) begin
//     if(i_rst)
//         
//     else if()

//     else
        
// end


endmodule
