`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/12 11:22:16
// Design Name: 
// Module Name: ddr_queue
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

module ddr_local_queue#(
    parameter           P_BASE_ADDR             = 32'h0000_0000,
    parameter integer   C_M_AXI_ADDR_WIDTH	    = 32,
    parameter integer   P_WRITE_DDR_PORT_NUM    = 1 ,
    parameter integer   P_DDR_LOCAL_QUEUE       = 4 ,
    parameter integer   P_P_WRITE_DDR_PORT      = 0 ,
    parameter           P_MAX_ADDR              = 32'h003F_FFFF
)(
    input                                   i_clk               ,
    input                                   i_rst               ,
    //write DDR
    input                                   i_wr_ddr_valid      ,
    input  [15 :0]                          i_wr_ddr_len        ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]       o_wr_ddr_addr       ,
    output                                  o_wr_ddr_ready      ,
    input                                   i_wr_ddr_cpl_valid  ,
    output                                  o_wr_ddr_cpl_ready  ,
    input  [15 :0]                          i_wr_ddr_cpl_len    ,
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]       i_wr_ddr_cpl_addr   ,
    input  [7 : 0]                          i_wr_ddr_cpl_strb   ,
    //read DDR 
    input  [C_M_AXI_ADDR_WIDTH-1 : 0]       i_rd_local_byte     ,
    input                                   i_rd_local_byte_valid,
    output                                  o_rd_local_byte_ready,
    output                                  o_rd_queue_finish   ,
    output [C_M_AXI_ADDR_WIDTH-1 : 0]       o_rd_ddr_addr       ,
    output [15 :0]                          o_rd_ddr_len        ,
    output [7 : 0]                          o_rd_ddr_strb       ,
    output                                  o_rd_ddr_valid      ,
    input                                   i_rd_ddr_cpl        ,
    input                                   i_rd_ddr_ready      ,
    //get queue size
    output [C_M_AXI_ADDR_WIDTH-1 : 0]       o_queue_size          
);
/******************************function*****************************/

/******************************parameter****************************/

/******************************machine******************************/

/******************************reg**********************************/
reg                                 ro_rd_local_byte_ready;
reg                                 ro_wr_ddr_cpl_ready ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]     ri_rd_local_byte    ;
reg  [31:0]                         r_write_ptr         ;
reg                                 r_fifo_rden         ;
reg                                 ri_wr_ddr_valid     ;
reg  [15 :0]                        ri_wr_ddr_len       ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]     ro_wr_ddr_addr      ;
reg                                 ro_wr_ddr_ready     ;
reg                                 ro_rd_ddr_valid     ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]     r_wr_max_addr       ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]     r_rd_comp_byte      ;
reg                                 r_rd_ddr_complete   ;
reg  [C_M_AXI_ADDR_WIDTH-1 : 0]     ro_queue_size       ;
reg  [2:0]                          ri_rd_local_byte_valid;
// reg  [2:0]                          ri_rd_last_byte     ;
// reg                                 ri_rd_last_byte_valid ;
/******************************wire*********************************/
wire                                w_wr_en             ;
wire                                w_rd_en             ;
wire                                w_reset_ptr         ;//写指针返回0重新开始写
wire                                w_fifo_full         ;
wire [31:0]                         w_fifo_dout_addr    ;
wire [15:0]                         w_fifo_dout_len     ;
wire [7 :0]                         w_fifo_dout_strb    ;
wire [31:0]                         w_max_next_pkt      ;
wire                                w_wr_cpl_en         ;
wire                                w_rd_byte_en        ;
/******************************assign*******************************/
assign o_rd_local_byte_ready = ro_rd_local_byte_ready;
assign w_wr_cpl_en = i_wr_ddr_cpl_valid & o_wr_ddr_cpl_ready;
assign o_wr_ddr_cpl_ready = ro_wr_ddr_cpl_ready;
assign w_wr_en = ri_wr_ddr_valid & ro_wr_ddr_ready  ;
assign w_rd_en = i_rd_ddr_ready & ro_rd_ddr_valid;
assign w_rd_byte_en = o_rd_local_byte_ready && i_rd_local_byte_valid;
assign w_reset_ptr = ((P_MAX_ADDR - r_write_ptr) < (ri_wr_ddr_len << 3)) && w_wr_en;
assign o_wr_ddr_addr  = ro_wr_ddr_addr + P_BASE_ADDR ;
assign o_wr_ddr_ready = ro_wr_ddr_ready ;
assign o_rd_ddr_addr = w_fifo_dout_addr ;
assign o_rd_ddr_len  = w_fifo_dout_len  ;
assign o_rd_ddr_strb = w_fifo_dout_strb ;
assign o_rd_ddr_valid = ro_rd_ddr_valid ;
assign w_max_next_pkt = ri_rd_local_byte - r_rd_comp_byte;
assign o_queue_size        = ro_queue_size       ;
assign o_rd_queue_finish = r_rd_ddr_complete;
/******************************component****************************/
FIFO_32X4096 FIFO_32X4096_ADDR (
  .clk          (i_clk              ), // input wire clk
  .srst         (i_rst              ), // input wire srst
  .din          (i_wr_ddr_cpl_addr  ), // input wire [31 : 0] din
  .wr_en        (w_wr_cpl_en        ), // input wire wr_en
  .rd_en        (r_fifo_rden        ), // input wire rd_en
  .dout         (w_fifo_dout_addr   ), // output wire [31 : 0] dout
  .full         (w_fifo_full        ), // output wire full
  .empty        (                   ), // output wire empty
  .wr_rst_busy  (                   ), // output wire wr_rst_busy
  .rd_rst_busy  (                   )  // output wire rd_rst_busy
);

FIFO_16X4096 FIFO_16X4096_len (
  .clk          (i_clk              ), // input wire clk
  .srst         (i_rst              ), // input wire srst
  .din          (i_wr_ddr_cpl_len   ), // input wire [15 : 0] din
  .wr_en        (w_wr_cpl_en        ), // input wire wr_en
  .rd_en        (r_fifo_rden        ), // input wire rd_en
  .dout         (w_fifo_dout_len    ), // output wire [15 : 0] dout
  .full         (                   ), // output wire full
  .empty        (                   ), // output wire empty
  .wr_rst_busy  (                   ), // output wire wr_rst_busy
  .rd_rst_busy  (                   ) // output wire rd_rst_busy
);

FIFO_8X4096 FIFO_8X4096_strb (
  .clk          (i_clk              ),  // input wire clk
  .srst         (i_rst              ),  // input wire srst
  .din          (i_wr_ddr_cpl_strb  ),  // input wire [7 : 0] din
  .wr_en        (w_wr_cpl_en        ),  // input wire wr_en
  .rd_en        (r_fifo_rden        ),  // input wire rd_en
  .dout         (w_fifo_dout_strb   ),  // output wire [7 : 0] dout
  .full         (                   ),  // output wire full
  .empty        (                   ),  // output wire empty
  .wr_rst_busy  (                   ),  // output wire wr_rst_busy
  .rd_rst_busy  (                   )  // output wire rd_rst_busy
);
/******************************always*******************************/
// always @(posedge i_clk or posedge i_rst)begin
//     if(i_rst)
//         ri_rd_last_byte <= 'd0;
//     else
//         ri_rd_last_byte <= {ri_rd_last_byte[1],ri_rd_last_byte[0],i_rd_last_byte};
// end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        ri_wr_ddr_valid  <= 'd0;
        ri_wr_ddr_len  <= 'd0;
    end
    else if(w_wr_en)begin
        ri_wr_ddr_valid  <= 'd0;
        ri_wr_ddr_len  <= 'd0;
    end
    else if(i_wr_ddr_valid)begin
        ri_wr_ddr_valid  <= i_wr_ddr_valid ;
        ri_wr_ddr_len  <= i_wr_ddr_len ;
    end
    else begin
        ri_wr_ddr_valid  <= ri_wr_ddr_valid ;
        ri_wr_ddr_len  <= ri_wr_ddr_len ;
    end
end


always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_wr_ddr_cpl_ready <= 'd0;
    else if(w_wr_cpl_en)
        ro_wr_ddr_cpl_ready <= 'd0;
    else if(!w_fifo_full && i_wr_ddr_cpl_valid)
        ro_wr_ddr_cpl_ready <= 'd1;
    else
        ro_wr_ddr_cpl_ready <= ro_wr_ddr_cpl_ready;
end

//writer pointer
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_write_ptr <= 'd0;
    else if(w_reset_ptr)
        r_write_ptr <= ri_wr_ddr_len << 3;
    else if(w_wr_en)
        r_write_ptr <= r_write_ptr + (ri_wr_ddr_len << 3);
    else
        r_write_ptr <= r_write_ptr;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_wr_ddr_addr <= 'd0;
    else if(w_wr_en)
        ro_wr_ddr_addr <= r_write_ptr + (ri_wr_ddr_len << 3);
    else
        ro_wr_ddr_addr <= ro_wr_ddr_addr;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_wr_ddr_ready <= 'd0;
    else if(w_wr_en)
        ro_wr_ddr_ready <= 'd0;
    else if(i_wr_ddr_valid && !w_fifo_full)
        ro_wr_ddr_ready <= 'd1;
    else
        ro_wr_ddr_ready <= ro_wr_ddr_ready;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_wr_max_addr <= 'd0;
    else if(w_reset_ptr)
        r_wr_max_addr <= r_write_ptr;
    else
        r_wr_max_addr <= r_wr_max_addr;
end

//read pointer
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_rd_local_byte_ready <= 'd0;
    else if(w_rd_byte_en)
        ro_rd_local_byte_ready <= 'd0;
    else if(i_rd_local_byte_valid)
        ro_rd_local_byte_ready <= 'd1;
    else
        ro_rd_local_byte_ready <= 'd0;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ri_rd_local_byte <= 'd0;
    else if(w_rd_byte_en)
        ri_rd_local_byte <= i_rd_local_byte;
    else
        ri_rd_local_byte <= ri_rd_local_byte;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_fifo_rden <= 'd0;
    else if(w_rd_byte_en)
        r_fifo_rden <= 'd1;
    else if(i_rd_ddr_cpl && i_rd_ddr_ready && !r_rd_ddr_complete)
        r_fifo_rden <= 'd1;
    else
        r_fifo_rden <= 'd0;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_rd_ddr_valid <= 'd0;
    else if(r_fifo_rden)
        ro_rd_ddr_valid <= 'd1;
    else
        ro_rd_ddr_valid <= 'd0;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_rd_comp_byte <= 'd0;
    else if(w_rd_byte_en)
        r_rd_comp_byte <= 'd0;
    else if(w_rd_en)
        r_rd_comp_byte <= r_rd_comp_byte + (o_rd_ddr_len << 3);
    else
        r_rd_comp_byte <= r_rd_comp_byte;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_rd_ddr_complete <= 'd0;
    else if(w_rd_byte_en)
        r_rd_ddr_complete <= 'd0;
    else if(w_max_next_pkt < 1518)
        r_rd_ddr_complete <= 'd1;
    else
        r_rd_ddr_complete <= r_rd_ddr_complete;
end

// always @(posedge i_clk or posedge i_rst)begin
//     if(i_rst)
//         ri_rd_last_byte_valid <= 'd0;
//     else if(w_rd_byte_en)
//         ri_rd_last_byte_valid <= 'd0;
//     else if(ri_rd_last_byte[1] && !ri_rd_last_byte[2] && r_rd_ddr_complete)
//         ri_rd_last_byte_valid <= 'd1;
//     else
//         ri_rd_last_byte_valid <= ri_rd_last_byte_valid;
// end



//VLB check queue size
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_queue_size <= 'd0;
    else if(w_wr_en && !w_rd_en)
        ro_queue_size <= ro_queue_size + (ri_wr_ddr_len << 3);
    else if(!w_wr_en && w_rd_en)
        ro_queue_size <= ro_queue_size - (o_rd_ddr_len << 3);
    else if(w_wr_en && w_rd_en)
        ro_queue_size <= ro_queue_size + (ri_wr_ddr_len << 3) - (o_rd_ddr_len << 3);
    else
        ro_queue_size <= ro_queue_size;
end



endmodule
