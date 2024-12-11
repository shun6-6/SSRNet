`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/18 16:47:26
// Design Name: 
// Module Name: mac_table_init
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


module mac_table_init#(
    parameter       P_OUTPORT_WIDTH = 4     ,
    parameter       P_TABLE_DEPTH   = 16    ,
    parameter       P_MYTOR_ADDR    = 0     ,
    parameter       P_MY_MAC1       = 48'h8D_BC_5C_4A_00_01,
    parameter       P_MY_MAC2       = 48'h8D_BC_5C_4A_00_02
)(
    input                           i_clk               ,
    input                           i_rst               ,
    /*更新MAC地址表*/
    output [47:0]                   o_update_dest_mac   ,
    output [P_OUTPORT_WIDTH - 1:0]  o_update_outport    ,
    output                          o_update_flag       ,
    output                          o_update_valid      
);

reg  [47:0]                     ro_update_dest_mac  ;
reg  [P_OUTPORT_WIDTH - 1:0]    ro_update_outport   ;
reg                             ro_update_flag      ;
reg                             ro_update_valid     ;

reg                             r_init              ;
reg                             r_init_1d           ;
reg  [7 :0]                     r_init_cnt          ;

assign o_update_dest_mac = ro_update_dest_mac   ;
assign o_update_outport  = ro_update_outport    ;
assign o_update_flag     = ro_update_flag       ;
assign o_update_valid    = ro_update_valid      ;

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_init <= 'd0;
    else
        r_init <= r_init + 1'b1;
end
always @(posedge i_clk)
    r_init_1d <= r_init;

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
        r_init_cnt <= 'd0;
    else if(r_init_cnt == 'd17)
        r_init_cnt <= r_init_cnt;
    else if(r_init)
        r_init_cnt <= r_init_cnt + 1'b1;
    else
        r_init_cnt <= r_init_cnt;
end

always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)begin 
        ro_update_dest_mac <= 'd0;
        ro_update_outport  <= 'd0;
        ro_update_flag     <= 'd0;
        ro_update_valid    <= 'd0;
    end
    else if(r_init_cnt == P_MY_MAC1[7:0] && (!r_init && r_init_1d))begin
        ro_update_dest_mac <= {40'd0,r_init_cnt};
        ro_update_outport  <= 'd0;
        ro_update_flag     <= 'd0;//0:local 1:unlocal
        ro_update_valid    <= 'd1;
    end
    else if(r_init_cnt == P_MY_MAC2[7:0] && (!r_init && r_init_1d))begin
        ro_update_dest_mac <= {40'd0,r_init_cnt};
        ro_update_outport  <= 'd1;
        ro_update_flag     <= 'd0;//0:local 1:unlocal
        ro_update_valid    <= 'd1;
    end
    else if(!r_init && r_init_1d && r_init_cnt < 'd17)begin
        ro_update_dest_mac <= {40'd0,r_init_cnt};
        ro_update_outport  <= (r_init_cnt - 1) >> 1;
        ro_update_flag     <= 'd1;//0:local 1:unlocal
        ro_update_valid    <= 'd1;
    end
    else begin
        ro_update_dest_mac <= 'd0;
        ro_update_outport  <= 'd0;
        ro_update_flag     <= 'd0;
        ro_update_valid    <= 'd0;
    end
end



endmodule
