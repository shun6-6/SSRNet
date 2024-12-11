`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/12 10:04:33
// Design Name: 
// Module Name: mem_manager
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


module mem_manager#(
    parameter integer   C_M_AXI_ADDR_WIDTH	    = 32,
    parameter integer   P_WRITE_DDR_PORT_NUM    = 1 ,
    parameter integer   P_DDR_LOCAL_QUEUE       = 4 ,
    parameter integer   P_P_WRITE_DDR_PORT      = 0 ,
    parameter           P_MAX_ADDR              = 32'h003F_FFFF,
    parameter           P_LOCAL_PORT_NUM        = 2 ,
    parameter           P_UNLOCAL_PORT_NUM      = 2 ,
    parameter           P_QUEUE_NUM             = 8
)(
    input                                   i_clk                           ,
    input                                   i_rst                           ,
    //local port 0 write DDR    
    input                                   i_wr_local_port0_valid          ,
    input  [15 :0]                          i_wr_local_port0_len            ,
    input  [P_DDR_LOCAL_QUEUE - 1 : 0]      i_wr_local_port0_queue          ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]       o_wr_local_port0_addr           ,
    output                                  o_wr_local_port0_ready          ,
    input                                   i_wr_local_port0_cpl_valid      ,
    output                                  o_wr_local_port0_cpl_ready      ,
    input  [P_DDR_LOCAL_QUEUE - 1 : 0]      i_wr_local_port0_cpl_queue      ,
    input  [15 :0]                          i_wr_local_port0_cpl_len        ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]       i_wr_local_port0_cpl_addr       ,
    input  [7 : 0]                          i_wr_local_port0_cpl_strb       ,
    //local port 1 write DDR
    input                                   i_wr_local_port1_valid          ,
    input  [15 :0]                          i_wr_local_port1_len            ,
    input  [P_DDR_LOCAL_QUEUE - 1 : 0]      i_wr_local_port1_queue          ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]       o_wr_local_port1_addr           ,
    output                                  o_wr_local_port1_ready          ,
    input                                   i_wr_local_port1_cpl_valid      ,
    output                                  o_wr_local_port1_cpl_ready      ,
    input  [P_DDR_LOCAL_QUEUE - 1 : 0]      i_wr_local_port1_cpl_queue      ,
    input  [15 :0]                          i_wr_local_port1_cpl_len        ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]       i_wr_local_port1_cpl_addr       ,
    input  [7 : 0]                          i_wr_local_port1_cpl_strb       ,
    //unlocal port 0 write or read DDR  
    input                                   i_wr_unlocal_port0_valid        ,
    input  [15 :0]                          i_wr_unlocal_port0_len          ,
    input  [P_DDR_LOCAL_QUEUE - 1 : 0]      i_wr_unlocal_port0_queue        ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]       o_wr_unlocal_port0_addr         ,
    output                                  o_wr_unlocal_port0_ready        ,
    input                                   i_wr_unlocal_port0_cpl_valid    ,
    output                                  o_wr_unlocal_port0_cpl_ready    ,
    input  [P_DDR_LOCAL_QUEUE - 1 : 0]      i_wr_unlocal_port0_cpl_queue    ,
    input  [15 :0]                          i_wr_unlocal_port0_cpl_len      ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]       i_wr_unlocal_port0_cpl_addr     ,
    input  [7 : 0]                          i_wr_unlocal_port0_cpl_strb     ,

    input  [P_DDR_LOCAL_QUEUE - 1 : 0]      i_rd_unlocal_port0_queue        ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]       i_rd_unlocal_port0_byte         ,
    input                                   i_rd_unlocal_port0_byte_valid   ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]       o_rd_unlocal_port0_addr         ,
    output [15 :0]                          o_rd_unlocal_port0_len          ,
    output [7 : 0]                          o_rd_unlocal_port0_strb         ,
    output                                  o_rd_unlocal_port0_valid        ,
    input                                   i_rd_unlocal_port0_cpl          ,
    input                                   i_rd_unlocal_port0_ready        ,

    //unlocal port 1 write or read DDR
    input                                   i_wr_unlocal_port1_valid        ,
    input  [15 :0]                          i_wr_unlocal_port1_len          ,
    input  [P_DDR_LOCAL_QUEUE - 1 : 0]      i_wr_unlocal_port1_queue        ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]       o_wr_unlocal_port1_addr         ,
    output                                  o_wr_unlocal_port1_ready        ,
    input                                   i_wr_unlocal_port1_cpl_valid    ,
    output                                  o_wr_unlocal_port1_cpl_ready    ,
    input  [P_DDR_LOCAL_QUEUE - 1 : 0]      i_wr_unlocal_port1_cpl_queue    ,
    input  [15 :0]                          i_wr_unlocal_port1_cpl_len      ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]       i_wr_unlocal_port1_cpl_addr     ,
    input  [7 : 0]                          i_wr_unlocal_port1_cpl_strb     ,

    input  [P_DDR_LOCAL_QUEUE - 1 : 0]      i_rd_unlocal_port1_queue        ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]       i_rd_unlocal_port1_byte         ,
    input                                   i_rd_unlocal_port1_byte_valid   ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]       o_rd_unlocal_port1_addr         ,
    output [15 :0]                          o_rd_unlocal_port1_len          ,
    output [7 : 0]                          o_rd_unlocal_port1_strb         ,
    output                                  o_rd_unlocal_port1_valid        ,
    input                                   i_rd_unlocal_port1_cpl          ,
    input                                   i_rd_unlocal_port1_ready        ,

    output [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   o_local_queue_size      ,
    output [P_QUEUE_NUM*C_M_AXI_ADDR_WIDTH-1 : 0]   o_unlocal_queue_size          

);
//每个本地队列的写描述符信息
reg  [P_QUEUE_NUM - 1 : 0]          r_wr_local_queue_valid      ;
reg  [15 :0]                        r_wr_local_queue_len [P_QUEUE_NUM - 1 : 0]  ;
reg  [2 : 0]                        r_wr_port_ready_id [P_QUEUE_NUM - 1 : 0]    ;

reg  [C_M_AXI_ADDR_WIDTH-1 : 0]     ro_wr_local_port_addr  [P_LOCAL_PORT_NUM - 1 : 0];
reg  [P_LOCAL_PORT_NUM - 1 : 0]     ro_wr_local_port_ready ;

wire [P_LOCAL_PORT_NUM - 1 : 0]     w_wr_local_port_valid   ;
wire [P_DDR_LOCAL_QUEUE - 1 : 0]    w_wr_local_port_queue [P_LOCAL_PORT_NUM - 1 : 0]  ;
wire [P_QUEUE_NUM - 1 : 0]          w_wr_local_queue_ready  ;
wire [C_M_AXI_ADDR_WIDTH-1 : 0]     w_wr_local_queue_addr [P_QUEUE_NUM - 1 : 0]  ;
wire [P_LOCAL_PORT_NUM - 1 : 0]     w_wr_local_port_cpl_valid   ;

//每个本地队列的写完成描述符信息
reg  [P_QUEUE_NUM-1 : 0]            r_wr_local_queue_cpl_valid  ;
reg  [15 :0]                        r_wr_local_queue_cpl_len  [P_QUEUE_NUM - 1 : 0]  ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]     r_wr_local_queue_cpl_addr [P_QUEUE_NUM - 1 : 0]  ;
reg  [7 : 0]                        r_wr_local_queue_cpl_strb [P_QUEUE_NUM - 1 : 0]  ;
reg  [2 : 0]                        r_wr_local_port_cpl_ready_id [P_QUEUE_NUM - 1 : 0]    ;
reg  [P_LOCAL_PORT_NUM - 1 : 0]     ro_wr_local_port_cpl_ready;

wire [P_QUEUE_NUM - 1 : 0]          w_wr_local_queue_cpl_ready;

//队列长度信息
wire [C_M_AXI_ADDR_WIDTH-1 : 0]     w_local_queue_size[P_QUEUE_NUM-1 : 0]  ;
wire [C_M_AXI_ADDR_WIDTH-1 : 0]     w_unlocal_queue_size[P_QUEUE_NUM-1 : 0];

//读队列数据
reg  [P_QUEUE_NUM-1 : 0]        r_rd_local_byte_valid;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_rd_local_byte         [P_QUEUE_NUM-1 : 0];
reg  [2 : 0]                    r_rd_local_port_id [P_QUEUE_NUM-1 : 0];
reg  [P_QUEUE_NUM-1 : 0]    r_rd_local_queue_cpl  ;
reg  [P_QUEUE_NUM-1 : 0]    r_rd_local_queue_ready;

wire [C_M_AXI_ADDR_WIDTH-1 : 0] w_rd_local_queue_addr  [P_QUEUE_NUM-1 : 0] ;
wire [15:0]                     w_rd_local_queue_len   [P_QUEUE_NUM-1 : 0] ;
wire [7:0]                      w_rd_local_queue_strb  [P_QUEUE_NUM-1 : 0] ;
wire [P_QUEUE_NUM-1 : 0]        w_rd_local_queue_valid ;

reg  [C_M_AXI_ADDR_WIDTH-1 : 0] r_rd_unlocal_port_addr  [P_UNLOCAL_PORT_NUM-1 : 0] ;
reg  [15:0]                     r_rd_unlocal_port_len   [P_UNLOCAL_PORT_NUM-1 : 0] ;
reg  [7:0]                      r_rd_unlocal_port_strb  [P_UNLOCAL_PORT_NUM-1 : 0] ;
reg  [P_UNLOCAL_PORT_NUM-1 : 0] r_rd_unlocal_port_valid ;

wire [P_QUEUE_NUM-1 : 0]        w_rd_unlocal_port_queue[P_UNLOCAL_PORT_NUM-1 : 0];
// assign w_rd_unlocal_port_queue[0] = 

assign w_wr_local_port_valid[0] = i_wr_local_port0_valid;
assign w_wr_local_port_valid[1] = i_wr_local_port1_valid;
assign w_wr_local_port_queue[0] = i_wr_local_port0_queue;
assign w_wr_local_port_queue[1] = i_wr_local_port1_queue;

assign w_wr_local_port_cpl_valid[0] = i_wr_local_port0_cpl_valid;
assign w_wr_local_port_cpl_valid[1] = i_wr_local_port1_cpl_valid;

assign o_wr_local_port0_addr  = ro_wr_local_port_addr [0];
assign o_wr_local_port0_ready = ro_wr_local_port_ready[0];
assign o_wr_local_port1_addr  = ro_wr_local_port_addr [1];
assign o_wr_local_port1_ready = ro_wr_local_port_ready[1];

assign o_wr_local_port0_cpl_ready = ro_wr_local_port_cpl_ready[0];
assign o_wr_local_port1_cpl_ready = ro_wr_local_port_cpl_ready[1];

assign w_rd_unlocal_port_queue[0] = i_rd_unlocal_port0_queue;
assign w_rd_unlocal_port_queue[1] = i_rd_unlocal_port1_queue;

assign o_rd_unlocal_port0_addr  = r_rd_unlocal_port_addr [0];
assign o_rd_unlocal_port0_len   = r_rd_unlocal_port_len  [0];
assign o_rd_unlocal_port0_strb  = r_rd_unlocal_port_strb [0];
assign o_rd_unlocal_port0_valid = r_rd_unlocal_port_valid[0];
assign o_rd_unlocal_port1_addr  = r_rd_unlocal_port_addr [1];
assign o_rd_unlocal_port1_len   = r_rd_unlocal_port_len  [1];
assign o_rd_unlocal_port1_strb  = r_rd_unlocal_port_strb [1];
assign o_rd_unlocal_port1_valid = r_rd_unlocal_port_valid[1];


genvar gen_local_i;
generate
    for(gen_local_i = 0; gen_local_i < P_QUEUE_NUM; gen_local_i = gen_local_i + 1)begin : local_queue_i
        
        assign o_local_queue_size[gen_local_i*C_M_AXI_ADDR_WIDTH +: C_M_AXI_ADDR_WIDTH] = w_local_queue_size [gen_local_i];
        
        //写DDR描述符
        always @(posedge i_clk or posedge i_rst) begin
            if(i_rst)begin
                r_wr_local_queue_valid[gen_local_i] <= 'd0;
                r_wr_local_queue_len[gen_local_i]   <= 'd0;
                r_wr_port_ready_id[gen_local_i]     <= 'd0;
            end
            else if(r_wr_local_queue_valid[gen_local_i] && w_wr_local_queue_ready[gen_local_i])begin
                r_wr_local_queue_valid[gen_local_i] <= 'd0;
                r_wr_local_queue_len[gen_local_i]   <= 'd0;
                r_wr_port_ready_id[gen_local_i]     <= 'd0;
            end
            else if(i_wr_local_port0_valid && i_wr_local_port0_queue == gen_local_i && !o_wr_local_port0_ready)begin
                r_wr_local_queue_valid[gen_local_i] <= 'd1;
                r_wr_local_queue_len[gen_local_i]   <= i_wr_local_port0_len;
                r_wr_port_ready_id[gen_local_i]     <= 'd0;
            end
            else if(i_wr_local_port1_valid && i_wr_local_port1_queue == gen_local_i && !o_wr_local_port1_ready)begin
                r_wr_local_queue_valid[gen_local_i] <= 'd1;
                r_wr_local_queue_len[gen_local_i]   <= i_wr_local_port1_len;
                r_wr_port_ready_id[gen_local_i]     <= 'd1;
            end
            else begin
                r_wr_local_queue_valid[gen_local_i] <= 'd0;
                r_wr_local_queue_len[gen_local_i]   <= 'd0;
                r_wr_port_ready_id[gen_local_i]     <= r_wr_port_ready_id[gen_local_i];
            end
        end
        //完成写DDR描述符
        always @(posedge i_clk or posedge i_rst) begin
            if(i_rst)begin
                r_wr_local_queue_cpl_valid[gen_local_i] <= 'd0;
                r_wr_local_queue_cpl_len  [gen_local_i] <= 'd0;
                r_wr_local_queue_cpl_addr [gen_local_i] <= 'd0;
                r_wr_local_queue_cpl_strb [gen_local_i] <= 'd0;
                r_wr_local_port_cpl_ready_id [gen_local_i] <= 'd0;
            end
            else if(r_wr_local_queue_cpl_valid[gen_local_i] && w_wr_local_queue_cpl_ready[gen_local_i])begin
                r_wr_local_queue_cpl_valid[gen_local_i] <= 'd0;
                r_wr_local_queue_cpl_len  [gen_local_i] <= 'd0;
                r_wr_local_queue_cpl_addr [gen_local_i] <= 'd0;
                r_wr_local_queue_cpl_strb [gen_local_i] <= 'd0;
                r_wr_local_port_cpl_ready_id [gen_local_i] <= 'd0;
            end
            else if(i_wr_local_port0_cpl_valid && i_wr_local_port0_cpl_queue == gen_local_i && !o_wr_local_port0_cpl_ready)begin
                r_wr_local_queue_cpl_valid[gen_local_i] <= 'd1;
                r_wr_local_queue_cpl_len  [gen_local_i] <= i_wr_local_port0_cpl_len ;
                r_wr_local_queue_cpl_addr [gen_local_i] <= i_wr_local_port0_cpl_addr;
                r_wr_local_queue_cpl_strb [gen_local_i] <= i_wr_local_port0_cpl_strb;
                r_wr_local_port_cpl_ready_id [gen_local_i] <= 'd0;
            end
            else if(i_wr_local_port1_cpl_valid && i_wr_local_port1_cpl_queue == gen_local_i && !o_wr_local_port1_cpl_ready)begin
                r_wr_local_queue_cpl_valid[gen_local_i] <= 'd1;
                r_wr_local_queue_cpl_len  [gen_local_i] <= i_wr_local_port1_cpl_len ;
                r_wr_local_queue_cpl_addr [gen_local_i] <= i_wr_local_port1_cpl_addr;
                r_wr_local_queue_cpl_strb [gen_local_i] <= i_wr_local_port1_cpl_strb;
                r_wr_local_port_cpl_ready_id [gen_local_i] <= 'd1;
            end
            else begin
                r_wr_local_queue_cpl_valid[gen_local_i] <= r_wr_local_queue_cpl_valid[gen_local_i];
                r_wr_local_queue_cpl_len  [gen_local_i] <= r_wr_local_queue_cpl_len  [gen_local_i];
                r_wr_local_queue_cpl_addr [gen_local_i] <= r_wr_local_queue_cpl_addr [gen_local_i];
                r_wr_local_queue_cpl_strb [gen_local_i] <= r_wr_local_queue_cpl_strb [gen_local_i];
                r_wr_local_port_cpl_ready_id [gen_local_i] <= r_wr_local_port_cpl_ready_id [gen_local_i];
            end
        end    
        //读DDR描述符
        always @(posedge i_clk or posedge i_rst) begin
            if(i_rst)begin
                r_rd_local_byte_valid [gen_local_i] <= 'd0;
                r_rd_local_byte       [gen_local_i] <= 'd0;
                r_rd_local_port_id          [gen_local_i] <= 'd0;  
            end
            else if(i_rd_unlocal_port0_byte_valid && i_rd_unlocal_port0_queue == gen_local_i)begin
                r_rd_local_byte_valid [gen_local_i] <= 'd1;
                r_rd_local_byte       [gen_local_i] <= i_rd_unlocal_port0_byte;
                r_rd_local_port_id          [gen_local_i] <= 'd0;  
            end
            else if(i_rd_unlocal_port1_byte_valid && i_rd_unlocal_port1_queue == gen_local_i)begin
                r_rd_local_byte_valid [gen_local_i] <= 'd1;
                r_rd_local_byte       [gen_local_i] <= i_rd_unlocal_port1_byte;
                r_rd_local_port_id          [gen_local_i] <= 'd1;  
            end
            else begin
                r_rd_local_byte_valid [gen_local_i] <= 'd0;
                r_rd_local_byte       [gen_local_i] <= 'd0;
                r_rd_local_port_id          [gen_local_i] <= r_rd_local_port_id[gen_local_i];  
            end
        end
        
        always @(posedge i_clk or posedge i_rst) begin
            if(i_rst)begin 
                r_rd_local_queue_cpl  [gen_local_i] <= 'd0;
                r_rd_local_queue_ready[gen_local_i] <= 'd0;
            end
            else if(r_rd_local_port_id[gen_local_i] == 0 && i_rd_unlocal_port0_queue == gen_local_i)begin
                r_rd_local_queue_cpl  [gen_local_i] <= i_rd_unlocal_port0_cpl;
                r_rd_local_queue_ready[gen_local_i] <= i_rd_unlocal_port0_ready;
            end
            else if(r_rd_local_port_id[gen_local_i] == 1 && i_rd_unlocal_port1_queue == gen_local_i)begin  
                r_rd_local_queue_cpl  [gen_local_i] <= i_rd_unlocal_port1_cpl;
                r_rd_local_queue_ready[gen_local_i] <= i_rd_unlocal_port1_ready;
            end
            else begin 
                r_rd_local_queue_cpl  [gen_local_i] <= 'd0;
                r_rd_local_queue_ready[gen_local_i] <= 'd0;
            end
        end

        ddr_local_queue#(
            .P_BASE_ADDR            (32'h0000_0000          ),
            .C_M_AXI_ADDR_WIDTH	    (C_M_AXI_ADDR_WIDTH	    ),
            .P_WRITE_DDR_PORT_NUM   (P_WRITE_DDR_PORT_NUM   ),
            .P_DDR_LOCAL_QUEUE      (P_DDR_LOCAL_QUEUE      ),
            .P_P_WRITE_DDR_PORT     (P_P_WRITE_DDR_PORT     ),
            .P_MAX_ADDR             (P_MAX_ADDR             )
        )ddr_local_queue_u(
            .i_clk                  (i_clk                          ),
            .i_rst                  (i_rst                          ),
    
            .i_wr_ddr_valid         (r_wr_local_queue_valid[gen_local_i]    ),
            .i_wr_ddr_len           (r_wr_local_queue_len[gen_local_i]      ),
            .o_wr_ddr_addr          (w_wr_local_queue_addr[gen_local_i]     ),
            .o_wr_ddr_ready         (w_wr_local_queue_ready[gen_local_i]    ),
            .i_wr_ddr_cpl_valid     (r_wr_local_queue_cpl_valid[gen_local_i]),
            .o_wr_ddr_cpl_ready     (w_wr_local_queue_cpl_ready[gen_local_i]),
            .i_wr_ddr_cpl_len       (r_wr_local_queue_cpl_len  [gen_local_i]),
            .i_wr_ddr_cpl_addr      (r_wr_local_queue_cpl_addr [gen_local_i]),
            .i_wr_ddr_cpl_strb      (r_wr_local_queue_cpl_strb [gen_local_i]),
    
            .i_rd_local_byte        (r_rd_local_byte[gen_local_i]       ),
            .i_rd_local_byte_valid  (r_rd_local_byte_valid[gen_local_i] ),
            .o_rd_ddr_addr          (w_rd_local_queue_addr [gen_local_i]),
            .o_rd_ddr_len           (w_rd_local_queue_len  [gen_local_i]),
            .o_rd_ddr_strb          (w_rd_local_queue_strb [gen_local_i]),
            .o_rd_ddr_valid         (w_rd_local_queue_valid[gen_local_i]),
            .i_rd_ddr_cpl           (r_rd_local_queue_cpl  [gen_local_i]),
            .i_rd_ddr_ready         (r_rd_local_queue_ready[gen_local_i]),
    
            .o_queue_size           (w_local_queue_size [gen_local_i])

        );
    end
endgenerate

genvar gen_local_o;
generate
    for(gen_local_o = 0; gen_local_o < P_LOCAL_PORT_NUM; gen_local_o = gen_local_o + 1)begin : local_queue_o

        always @(posedge i_clk or posedge i_rst) begin
            if(i_rst)begin
                ro_wr_local_port_ready[gen_local_o] <= 'd0;
                ro_wr_local_port_addr[gen_local_o]  <= 'd0;
            end
            else if(w_wr_local_port_valid[gen_local_o])begin
                case(w_wr_local_port_queue[gen_local_o])
                0 : begin
                    if(r_wr_port_ready_id[0] == gen_local_o && w_wr_local_queue_ready[0])begin
                        ro_wr_local_port_ready[gen_local_o] <= w_wr_local_queue_ready[0];
                        ro_wr_local_port_addr[gen_local_o]  <= w_wr_local_queue_addr[0];
                    end else begin
                        ro_wr_local_port_ready[gen_local_o] <= 'd0;
                        ro_wr_local_port_addr[gen_local_o]  <= 'd0;
                    end
                end
                1 : begin
                    if(r_wr_port_ready_id[1] == gen_local_o && w_wr_local_queue_ready[1])begin
                        ro_wr_local_port_ready[gen_local_o] <= w_wr_local_queue_ready[1];
                        ro_wr_local_port_addr[gen_local_o]  <= w_wr_local_queue_addr[1];
                    end else begin
                        ro_wr_local_port_ready[gen_local_o] <= 'd0;
                        ro_wr_local_port_addr[gen_local_o]  <= 'd0;
                    end
                end
                2 : begin
                    if(r_wr_port_ready_id[2] == gen_local_o && w_wr_local_queue_ready[2])begin
                        ro_wr_local_port_ready[gen_local_o] <= w_wr_local_queue_ready[3];
                        ro_wr_local_port_addr[gen_local_o]  <= w_wr_local_queue_addr[3];
                    end else begin
                        ro_wr_local_port_ready[gen_local_o] <= 'd0;
                        ro_wr_local_port_addr[gen_local_o]  <= 'd0;
                    end
                end
                3 : begin
                    if(r_wr_port_ready_id[3] == gen_local_o && w_wr_local_queue_ready[3])begin
                        ro_wr_local_port_ready[gen_local_o] <= w_wr_local_queue_ready[3];
                        ro_wr_local_port_addr[gen_local_o]  <= w_wr_local_queue_addr[3];
                    end else begin
                        ro_wr_local_port_ready[gen_local_o] <= 'd0;
                        ro_wr_local_port_addr[gen_local_o]  <= 'd0;
                    end
                end
                4 : begin
                    if(r_wr_port_ready_id[4] == gen_local_o && w_wr_local_queue_ready[4])begin
                        ro_wr_local_port_ready[gen_local_o] <= w_wr_local_queue_ready[4];
                        ro_wr_local_port_addr[gen_local_o]  <= w_wr_local_queue_addr[4];
                    end else begin
                        ro_wr_local_port_ready[gen_local_o] <= 'd0;
                        ro_wr_local_port_addr[gen_local_o]  <= 'd0;
                    end
                end
                5 : begin
                    if(r_wr_port_ready_id[5] == gen_local_o && w_wr_local_queue_ready[5])begin
                        ro_wr_local_port_ready[gen_local_o] <= w_wr_local_queue_ready[5];
                        ro_wr_local_port_addr[gen_local_o]  <= w_wr_local_queue_addr[5];
                    end else begin
                        ro_wr_local_port_ready[gen_local_o] <= 'd0;
                        ro_wr_local_port_addr[gen_local_o]  <= 'd0;
                    end
                end
                6 : begin
                    if(r_wr_port_ready_id[6] == gen_local_o && w_wr_local_queue_ready[6])begin
                        ro_wr_local_port_ready[gen_local_o] <= w_wr_local_queue_ready[6];
                        ro_wr_local_port_addr[gen_local_o]  <= w_wr_local_queue_addr[6];
                    end else begin
                        ro_wr_local_port_ready[gen_local_o] <= 'd0;
                        ro_wr_local_port_addr[gen_local_o]  <= 'd0;
                    end
                end
                7 : begin
                    if(r_wr_port_ready_id[7] == gen_local_o && w_wr_local_queue_ready[7])begin
                        ro_wr_local_port_ready[gen_local_o] <= w_wr_local_queue_ready[7];
                        ro_wr_local_port_addr[gen_local_o]  <= w_wr_local_queue_addr[7];
                    end else begin
                        ro_wr_local_port_ready[gen_local_o] <= 'd0;
                        ro_wr_local_port_addr[gen_local_o]  <= 'd0;
                    end
                end
                default : begin
                        ro_wr_local_port_ready[gen_local_o] <= 'd0;
                        ro_wr_local_port_addr[gen_local_o]  <= 'd0;
                end
                endcase
            end
        end

        always @(posedge i_clk or posedge i_rst) begin
            if(i_rst)begin
                ro_wr_local_port_cpl_ready[gen_local_o] <= 'd0;
            end
            else if(w_wr_local_port_cpl_valid[gen_local_o])begin
                case(w_wr_local_port_queue[gen_local_o])
                0 : begin
                    if(r_wr_local_port_cpl_ready_id[0] == gen_local_o && w_wr_local_queue_cpl_ready[0])begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= w_wr_local_queue_cpl_ready[0];
                    end else begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= 'd0;
                    end
                end
                1 : begin
                    if(r_wr_local_port_cpl_ready_id[1] == gen_local_o && w_wr_local_queue_cpl_ready[1])begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= w_wr_local_queue_cpl_ready[1];
                    end else begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= 'd0;
                    end
                end
                2 : begin
                    if(r_wr_local_port_cpl_ready_id[2] == gen_local_o && w_wr_local_queue_cpl_ready[2])begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= w_wr_local_queue_cpl_ready[2];
                    end else begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= 'd0;
                    end
                end
                3 : begin
                    if(r_wr_local_port_cpl_ready_id[3] == gen_local_o && w_wr_local_queue_cpl_ready[3])begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= w_wr_local_queue_cpl_ready[3];
                    end else begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= 'd0;
                    end
                end
                4 : begin
                    if(r_wr_local_port_cpl_ready_id[4] == gen_local_o && w_wr_local_queue_cpl_ready[4])begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= w_wr_local_queue_cpl_ready[4];
                    end else begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= 'd0;
                    end
                end
                5 : begin
                    if(r_wr_local_port_cpl_ready_id[5] == gen_local_o && w_wr_local_queue_cpl_ready[5])begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= w_wr_local_queue_cpl_ready[5];
                    end else begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= 'd0;
                    end
                end
                6 : begin
                    if(r_wr_local_port_cpl_ready_id[6] == gen_local_o && w_wr_local_queue_cpl_ready[6])begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= w_wr_local_queue_cpl_ready[6];
                    end else begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= 'd0;
                    end
                end
                7 : begin
                    if(r_wr_local_port_cpl_ready_id[7] == gen_local_o && w_wr_local_queue_cpl_ready[7])begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= w_wr_local_queue_cpl_ready[7];
                    end else begin
                        ro_wr_local_port_cpl_ready[gen_local_o] <= 'd0;
                    end
                end
                default : begin
                    ro_wr_local_port_cpl_ready[gen_local_o] <= 'd0;
                end
                endcase
            end
        end

        //read DDR
        always @(posedge i_clk or posedge i_rst) begin
            if(i_rst)begin
                r_rd_unlocal_port_addr [gen_local_o] <= 'd0;
                r_rd_unlocal_port_len  [gen_local_o] <= 'd0;
                r_rd_unlocal_port_strb [gen_local_o] <= 'd0;
                r_rd_unlocal_port_valid[gen_local_o] <= 'd0;
            end
            else begin
                case(w_rd_unlocal_port_queue[gen_local_o])
                0 : begin
                    if(r_rd_local_port_id[0] == gen_local_o && w_rd_local_queue_valid[0])begin
                        r_rd_unlocal_port_addr [gen_local_o] <= w_rd_local_queue_addr [0];
                        r_rd_unlocal_port_len  [gen_local_o] <= w_rd_local_queue_len  [0];
                        r_rd_unlocal_port_strb [gen_local_o] <= w_rd_local_queue_strb [0];
                        r_rd_unlocal_port_valid[gen_local_o] <= w_rd_local_queue_valid[0];
                    end else begin
                        r_rd_unlocal_port_addr [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_len  [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_strb [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_valid[gen_local_o] <= 'd0;
                    end
                end
                1 : begin
                    if(r_rd_local_port_id[1] == gen_local_o && w_rd_local_queue_valid[1])begin
                        r_rd_unlocal_port_addr [gen_local_o] <= w_rd_local_queue_addr [1];
                        r_rd_unlocal_port_len  [gen_local_o] <= w_rd_local_queue_len  [1];
                        r_rd_unlocal_port_strb [gen_local_o] <= w_rd_local_queue_strb [1];
                        r_rd_unlocal_port_valid[gen_local_o] <= w_rd_local_queue_valid[1];
                    end else begin
                        r_rd_unlocal_port_addr [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_len  [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_strb [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_valid[gen_local_o] <= 'd0;
                    end
                end
                2 : begin
                    if(r_rd_local_port_id[2] == gen_local_o && w_rd_local_queue_valid[2])begin
                        r_rd_unlocal_port_addr [gen_local_o] <= w_rd_local_queue_addr [2];
                        r_rd_unlocal_port_len  [gen_local_o] <= w_rd_local_queue_len  [2];
                        r_rd_unlocal_port_strb [gen_local_o] <= w_rd_local_queue_strb [2];
                        r_rd_unlocal_port_valid[gen_local_o] <= w_rd_local_queue_valid[2];
                    end else begin
                        r_rd_unlocal_port_addr [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_len  [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_strb [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_valid[gen_local_o] <= 'd0;
                    end
                end
                3 : begin
                    if(r_rd_local_port_id[3] == gen_local_o && w_rd_local_queue_valid[3])begin
                        r_rd_unlocal_port_addr [gen_local_o] <= w_rd_local_queue_addr [3];
                        r_rd_unlocal_port_len  [gen_local_o] <= w_rd_local_queue_len  [3];
                        r_rd_unlocal_port_strb [gen_local_o] <= w_rd_local_queue_strb [3];
                        r_rd_unlocal_port_valid[gen_local_o] <= w_rd_local_queue_valid[3];
                    end else begin
                        r_rd_unlocal_port_addr [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_len  [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_strb [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_valid[gen_local_o] <= 'd0;
                    end
                end
                4 : begin
                    if(r_rd_local_port_id[4] == gen_local_o && w_rd_local_queue_valid[4])begin
                        r_rd_unlocal_port_addr [gen_local_o] <= w_rd_local_queue_addr [4];
                        r_rd_unlocal_port_len  [gen_local_o] <= w_rd_local_queue_len  [4];
                        r_rd_unlocal_port_strb [gen_local_o] <= w_rd_local_queue_strb [4];
                        r_rd_unlocal_port_valid[gen_local_o] <= w_rd_local_queue_valid[4];
                    end else begin
                        r_rd_unlocal_port_addr [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_len  [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_strb [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_valid[gen_local_o] <= 'd0;
                    end
                end
                5 : begin
                    if(r_rd_local_port_id[5] == gen_local_o && w_rd_local_queue_valid[5])begin
                        r_rd_unlocal_port_addr [gen_local_o] <= w_rd_local_queue_addr [5];
                        r_rd_unlocal_port_len  [gen_local_o] <= w_rd_local_queue_len  [5];
                        r_rd_unlocal_port_strb [gen_local_o] <= w_rd_local_queue_strb [5];
                        r_rd_unlocal_port_valid[gen_local_o] <= w_rd_local_queue_valid[5];
                    end else begin
                        r_rd_unlocal_port_addr [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_len  [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_strb [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_valid[gen_local_o] <= 'd0;
                    end
                end
                6 : begin
                    if(r_rd_local_port_id[6] == gen_local_o && w_rd_local_queue_valid[6])begin
                        r_rd_unlocal_port_addr [gen_local_o] <= w_rd_local_queue_addr [6];
                        r_rd_unlocal_port_len  [gen_local_o] <= w_rd_local_queue_len  [6];
                        r_rd_unlocal_port_strb [gen_local_o] <= w_rd_local_queue_strb [6];
                        r_rd_unlocal_port_valid[gen_local_o] <= w_rd_local_queue_valid[6];
                    end else begin
                        r_rd_unlocal_port_addr [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_len  [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_strb [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_valid[gen_local_o] <= 'd0;
                    end
                end
                7 : begin
                    if(r_rd_local_port_id[7] == gen_local_o && w_rd_local_queue_valid[7])begin
                        r_rd_unlocal_port_addr [gen_local_o] <= w_rd_local_queue_addr [7];
                        r_rd_unlocal_port_len  [gen_local_o] <= w_rd_local_queue_len  [7];
                        r_rd_unlocal_port_strb [gen_local_o] <= w_rd_local_queue_strb [7];
                        r_rd_unlocal_port_valid[gen_local_o] <= w_rd_local_queue_valid[7];
                    end else begin
                        r_rd_unlocal_port_addr [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_len  [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_strb [gen_local_o] <= 'd0;
                        r_rd_unlocal_port_valid[gen_local_o] <= 'd0;
                    end
                end
                default : begin
                    ro_wr_local_port_cpl_ready[gen_local_o] <= 'd0;
                end
                endcase
            end
        end

    end
endgenerate





endmodule