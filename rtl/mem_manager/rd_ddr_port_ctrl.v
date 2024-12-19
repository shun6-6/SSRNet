`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/17 16:14:17
// Design Name: 
// Module Name: rd_ddr_port_ctrl
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


module rd_ddr_port_ctrl#(
    parameter integer   C_M_AXI_ADDR_WIDTH	    = 32,
    parameter integer   P_WRITE_DDR_PORT_NUM    = 1 ,
    parameter integer   P_DDR_LOCAL_QUEUE       = 4 ,
    parameter integer   P_P_WRITE_DDR_PORT      = 0 ,
    parameter           P_MAX_ADDR              = 32'h003F_FFFF,
    parameter           P_LOCAL_PORT_NUM        = 2 ,
    parameter           P_UNLOCAL_PORT_NUM      = 2 ,
    parameter           P_QUEUE_NUM             = 8
)(
    input                                           i_clk                       ,
    input                                           i_rst                       ,

    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_send_local2_pkt_size      ,
    input                                           i_send_local2_valid         ,
    input  [2 : 0]                                  i_send_local2_queue         ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_local_direct_pkt_size     ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_local_direct_pkt_valid    ,
    input  [2 : 0]                                  i_cur_direct_tor            ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_unlocal_direct_pkt_size   ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]               i_unlocal_direct_pkt_valid  ,
    input  [2 : 0]                                  i_unlocal_direct_pkt_queue  ,
    input  [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   i_tx_relay                  ,
    input                                           i_tx_relay_valid            ,
    //dispose direct local\unlocal\my two\relay
    output                                          o_rd_flag                   ,
    output [P_DDR_LOCAL_QUEUE - 1 : 0]              o_rd_queue                  ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]               o_rd_byte                   ,
    output                                          o_rd_byte_valid             ,
    input                                           i_rd_byte_ready             ,
    input                                           i_rd_queue_finish           ,
    //dispose recieved two jump forward pkt
    input                                           i_forward_req               ,
    output                                          o_forward_resp              ,
    input                                           i_forward_finish            
);
/******************************function*****************************/

/******************************parameter****************************/
localparam      P_TX_IDLE           = 'd0,
                P_TX_UNLOCAL_PKT    = 'd1,
                P_TX_MY_TWO_PTK     = 'd2,
                P_TX_RECV_TWO_PTK   = 'd3,
                P_TX_LOCAL_PKT      = 'd4,
                P_TX_RELAY_PKT      = 'd5;
/******************************machine******************************/
reg  [5 : 0]    r_cur_state ;
reg  [5 : 0]    r_nxt_state ;
reg  [15: 0]    r_st_cnt    ;
/******************************reg**********************************/
reg                                         ro_rd_flag          ;
reg  [P_DDR_LOCAL_QUEUE - 1 : 0]            ro_rd_queue         ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]             ro_rd_byte          ;
reg                                         ro_rd_byte_valid    ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]             ri_send_local2_pkt_size     ;      
reg  [2 : 0]                                ri_send_local2_queue        ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]             ri_local_direct_pkt_size    ;
reg  [2 : 0]                                ri_cur_direct_tor           ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]             ri_unlocal_direct_pkt_size  ;
reg  [2 : 0]                                ri_unlocal_direct_pkt_queue ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] ri_tx_relay [P_QUEUE_NUM - 1 : 0]       ;   
reg     r_rd_ddr_lock   ;     
reg     r_forword_wait  ;
reg     ri_tx_relay_valid = 0;
reg  [P_QUEUE_NUM - 1 : 0]  r_relay_finish;
/******************************wire*********************************/
wire  w_rd_byte_en;
/******************************assign*******************************/
assign o_rd_flag       = ro_rd_flag         ;
assign o_rd_queue      = ro_rd_queue        ;
assign o_rd_byte       = ro_rd_byte         ;
assign o_rd_byte_valid = ro_rd_byte_valid   ;
assign w_rd_byte_en = o_rd_byte_valid & i_rd_byte_ready;
/******************************component****************************/

/******************************always*******************************/
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        ri_send_local2_pkt_size <= 'd0;
        ri_send_local2_queue    <= 'd0;
    end else if(r_cur_state == P_TX_IDLE)begin
        ri_send_local2_pkt_size <= 'd0;
        ri_send_local2_queue    <= 'd0;
    end else if(i_send_local2_valid)begin
        ri_send_local2_pkt_size <= i_send_local2_pkt_size;
        ri_send_local2_queue    <= i_send_local2_queue;
    end else begin
        ri_send_local2_pkt_size <= ri_send_local2_pkt_size;
        ri_send_local2_queue    <= ri_send_local2_queue;
    end
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        ri_local_direct_pkt_size <= 'd0;   
        ri_cur_direct_tor        <= 'd0;
    end else if(r_cur_state == P_TX_IDLE)begin
        ri_local_direct_pkt_size <= 'd0;   
        ri_cur_direct_tor        <= 'd0;
    end else if(i_local_direct_pkt_valid)begin
        ri_local_direct_pkt_size <= i_local_direct_pkt_size;   
        ri_cur_direct_tor        <= i_cur_direct_tor       ;
    end else begin
        ri_local_direct_pkt_size <= ri_local_direct_pkt_size;   
        ri_cur_direct_tor        <= ri_cur_direct_tor       ;
    end    
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        ri_unlocal_direct_pkt_size  <= 'd0;
        ri_unlocal_direct_pkt_queue <= 'd0;
    end else if(r_cur_state == P_TX_IDLE)begin
        ri_unlocal_direct_pkt_size  <= 'd0;
        ri_unlocal_direct_pkt_queue <= 'd0;
    end else if(i_unlocal_direct_pkt_valid)begin
        ri_unlocal_direct_pkt_size  <= i_unlocal_direct_pkt_size ;
        ri_unlocal_direct_pkt_queue <= i_unlocal_direct_pkt_queue;
    end else begin
        ri_unlocal_direct_pkt_size  <= ri_unlocal_direct_pkt_size ;
        ri_unlocal_direct_pkt_queue <= ri_unlocal_direct_pkt_queue;
    end
end

always @(posedge i_clk)
    ri_tx_relay_valid <= i_tx_relay_valid;

genvar i;
generate
    for(i = 0; i < P_QUEUE_NUM; i = i + 1)begin

        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                ri_tx_relay[i] <= 'd0;
            else if(r_cur_state == P_TX_IDLE)
                ri_tx_relay[i] <= 'd0;
            else if(i_tx_relay_valid)
                ri_tx_relay[i] <= i_tx_relay[i*C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH];
            else
                ri_tx_relay[i] <= ri_tx_relay[i];
        end

        always @(posedge i_clk or posedge i_rst)begin
            if(i_rst)
                r_relay_finish[i] <= 'd1;
            else if(r_cur_state == P_TX_RELAY_PKT && i_rd_queue_finish && (r_relay_finish[i] == 0) && i == 0)
                r_relay_finish[i] <= 'd1;
            else if(r_cur_state == P_TX_RELAY_PKT && i_rd_queue_finish && (&{{r_relay_finish[i:0] << 1},1'b1}) && i > 0)
                r_relay_finish[i] <= 'd1;
            else if(ri_tx_relay_valid && ri_tx_relay[i] != 0)
                r_relay_finish[i] <= 'd0;
            else
                r_relay_finish[i] <= r_relay_finish[i];
        end

    end
endgenerate


always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_cur_state <= P_TX_IDLE;
    else
        r_cur_state <= r_nxt_state;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_st_cnt <= 'd0;
    else if(r_cur_state != r_nxt_state)
        r_st_cnt <= 'd0;
    else
        r_st_cnt <= r_st_cnt + 'd1;
end


always @(*)begin
    case (r_cur_state)
        P_TX_IDLE        : begin
            if(i_unlocal_direct_pkt_valid)
                r_nxt_state = P_TX_UNLOCAL_PKT;
            else
                r_nxt_state = P_TX_IDLE;
        end
        P_TX_UNLOCAL_PKT : begin
            if(i_rd_queue_finish)
                r_nxt_state = P_TX_LOCAL_PKT;
            else
                r_nxt_state = P_TX_UNLOCAL_PKT;
        end
        P_TX_MY_TWO_PTK   : begin
            if(i_rd_queue_finish && i_forward_req)
                r_nxt_state = P_TX_RECV_TWO_PTK;
            else if(i_rd_queue_finish && !i_forward_req)
                r_nxt_state = P_TX_LOCAL_PKT;
            else
                r_nxt_state = P_TX_MY_TWO_PTK;
        end
        P_TX_RECV_TWO_PTK  : begin
            if(i_forward_finish)
                r_nxt_state = P_TX_LOCAL_PKT;
            else
                r_nxt_state = P_TX_RECV_TWO_PTK;
        end
        P_TX_LOCAL_PKT   : begin
            if(i_forward_finish && r_forword_wait)
                r_nxt_state = P_TX_RECV_TWO_PTK;
            else if(i_forward_finish && !r_forword_wait)
                r_nxt_state = P_TX_RELAY_PKT;
            else
                r_nxt_state = P_TX_LOCAL_PKT;
        end
        P_TX_RELAY_PKT   : begin
            if(&r_relay_finish)
                r_nxt_state = P_TX_IDLE;
            else
                r_nxt_state = P_TX_RELAY_PKT;
        end
        default          : r_nxt_state = P_TX_IDLE;
    endcase
end
       
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        ro_rd_flag  <= 'd0;
        ro_rd_queue <= 'd0;
        ro_rd_byte  <= 'd0;
        ro_rd_byte_valid <= 'd0;
    end
    else if(r_cur_state == P_TX_IDLE)begin
        ro_rd_flag  <= 'd0;
        ro_rd_queue <= 'd0;
        ro_rd_byte  <= 'd0;
        ro_rd_byte_valid <= 'd0;
    end
    else if(r_cur_state == P_TX_UNLOCAL_PKT && !r_rd_ddr_lock)begin
        ro_rd_flag  <= 'd1;
        ro_rd_queue <= ri_unlocal_direct_pkt_queue;
        ro_rd_byte  <= ri_unlocal_direct_pkt_size;
        ro_rd_byte_valid <= 'd1;
    end
    else if(r_cur_state == P_TX_MY_TWO_PTK && !r_rd_ddr_lock)begin
        ro_rd_flag  <= 'd0;
        ro_rd_queue <= ri_send_local2_queue     ;
        ro_rd_byte  <= ri_send_local2_pkt_size  ;
        ro_rd_byte_valid <= 'd1;
    end
    else if(r_cur_state == P_TX_LOCAL_PKT && !r_rd_ddr_lock)begin
        ro_rd_flag  <= 'd0;
        ro_rd_queue <= ri_cur_direct_tor        ;
        ro_rd_byte  <= ri_local_direct_pkt_size ;
        ro_rd_byte_valid <= 'd1;
    end
    else if(r_cur_state == P_TX_RELAY_PKT && !r_rd_ddr_lock)begin
        if(r_relay_finish[0] != 0)begin
            ro_rd_flag  <= 'd0;
            ro_rd_queue <= 0        ;
            ro_rd_byte  <= ri_tx_relay[0] ;
            ro_rd_byte_valid <= 'd1;
        end else if(r_relay_finish[1] != 0)begin
            ro_rd_flag  <= 'd0;
            ro_rd_queue <= 1        ;
            ro_rd_byte  <= ri_tx_relay[1] ;
            ro_rd_byte_valid <= 'd1;
        end else if(r_relay_finish[2] != 0)begin
            ro_rd_flag  <= 'd0;
            ro_rd_queue <= 2        ;
            ro_rd_byte  <= ri_tx_relay[2] ;
            ro_rd_byte_valid <= 'd1;
        end else if(r_relay_finish[3] != 0)begin
            ro_rd_flag  <= 'd0;
            ro_rd_queue <= 3        ;
            ro_rd_byte  <= ri_tx_relay[3] ;
            ro_rd_byte_valid <= 'd1;
        end else if(r_relay_finish[4] != 0)begin
            ro_rd_flag  <= 'd0;
            ro_rd_queue <= 4        ;
            ro_rd_byte  <= ri_tx_relay[4] ;
            ro_rd_byte_valid <= 'd1;
        end else if(r_relay_finish[5] != 0)begin
            ro_rd_flag  <= 'd0;
            ro_rd_queue <= 5        ;
            ro_rd_byte  <= ri_tx_relay[5] ;
            ro_rd_byte_valid <= 'd1;
        end else if(r_relay_finish[6] != 0)begin
            ro_rd_flag  <= 'd0;
            ro_rd_queue <= 6        ;
            ro_rd_byte  <= ri_tx_relay[6] ;
            ro_rd_byte_valid <= 'd1;
        end else if(r_relay_finish[7] != 0)begin
            ro_rd_flag  <= 'd0;
            ro_rd_queue <= 7 ;
            ro_rd_byte  <= ri_tx_relay[7] ;
            ro_rd_byte_valid <= 'd1;
        end
    end
    else begin
        ro_rd_flag  <= 'd0;
        ro_rd_queue <= 'd0;
        ro_rd_byte  <= 'd0;
        ro_rd_byte_valid <= 'd0;
    end 
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_rd_ddr_lock <= 'd0;
    else if(i_rd_queue_finish)
        r_rd_ddr_lock <= 'd0;
    else if(w_rd_byte_en)
        r_rd_ddr_lock <= 'd1;
    else
        r_rd_ddr_lock <= r_rd_ddr_lock;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_forword_wait <= 'd0;
    else if(r_cur_state == P_TX_RECV_TWO_PTK)
        r_forword_wait <= 'd0;
    else if(r_cur_state == P_TX_MY_TWO_PTK && i_rd_queue_finish && !i_forward_req)
        r_forword_wait <= 'd1;
    else
        r_forword_wait <= r_forword_wait;
end

// always @(posedge i_clk or posedge i_rst)begin
//     if(i_rst)

//     else if()

//     else
        
// end

// always @(posedge i_clk or posedge i_rst)begin
//     if(i_rst)

//     else if()

//     else
        
// end

endmodule
