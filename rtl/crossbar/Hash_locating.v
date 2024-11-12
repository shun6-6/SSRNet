`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/17 15:08:04
// Design Name: 
// Module Name: Hash_locating
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


module Hash_locating#(
    parameter       P_OUTPORT_WIDTH = 4     ,
    parameter       P_TABLE_DEPTH   = 16    ,
    parameter       P_MYTOR_ADDR    = 0     
)(
    input                           i_clk               ,
    input                           i_rst               ,
    /*更新MAC地址表*/
    input  [47:0]                   i_update_dest_mac   ,
    input  [P_OUTPORT_WIDTH - 1:0]  i_update_outport    ,
    input                           i_update_flag       ,
    input                           i_update_valid      ,
    /*查找MAC地址表*/
    input                           i_seek_valid        ,
    input  [47:0]                   i_seek_dest_mac     ,
    input  [2 :0]                   i_seek_id           ,
    output [P_OUTPORT_WIDTH - 1:0]  o_seek_outport      ,
    output [2 + 1 :0]               o_seek_id           ,
    output                          o_seek_flag         ,
    output                          o_seek_valid        
);
/******************************function*****************************/

/******************************parameter****************************/

/******************************machine******************************/

/******************************reg**********************************/
reg                             ri_seek_valid    = 'd0   ;
reg  [47:0]                     ri_seek_dest_mac = 'd0   ;
reg  [2 :0]                     ri_seek_id       = 'd0   ;

reg  [P_OUTPORT_WIDTH - 1:0]    ro_seek_outport = 'd0 ;
reg  [2 :0]                     ro_seek_id      = 'd0 ;
reg                             ro_seek_flag    = 'd0 ;
reg                             ro_seek_valid   = 'd0 ;

//48位mac addr + 1位判断该MAC地址是否为本地MAC + 
//4位输出端口（本地MAC）或者目的ToR地址（非本地MAC）
reg  [4*(48 + 1 + P_OUTPORT_WIDTH) - 1 : 0] mac_addr_table  [P_TABLE_DEPTH - 1 : 0];
reg  [2 : 0] mac_addr_num  [P_TABLE_DEPTH - 1 : 0];
//initial table
integer i;
initial begin
    for(i = 0; i < P_TABLE_DEPTH; i = i + 1)begin
        mac_addr_table[i] = 'd0;
        mac_addr_num [i] = 'd0;
    end
end

reg  [47:0]                     ri_update_dest_mac = 'd0 ;
reg  [P_OUTPORT_WIDTH - 1:0]    ri_update_outport  = 'd0 ;
reg                             ri_update_valid    = 'd0 ;
reg                             ri_update_flag     = 'd0; 
/******************************wire*********************************/
wire [31:0]     w_crc32_result  ;
wire [3 :0]     w_hash_addr     ;
wire [47:0]     w_crc_mac       ;
/******************************assign*******************************/
assign w_hash_addr = w_crc32_result[3 :0]   ;
assign w_crc_mac =  i_update_valid ? i_update_dest_mac : 
                    i_seek_valid ? i_seek_dest_mac : 'd0;

assign o_seek_outport  = ro_seek_outport ;
assign o_seek_id       = {ro_seek_id,ro_seek_flag};
assign o_seek_flag     = ro_seek_flag    ;
assign o_seek_valid    = ro_seek_valid   ;
/******************************component****************************/
CRC32_64bKEEP CRC32_64bKEEP_u0(
  .i_clk            (i_clk              ),
  .i_rst            (i_rst              ),
  .i_en             (i_update_valid || i_seek_valid),
  .i_data           (w_crc_mac[47:40]   ),
  .i_data_1         (w_crc_mac[39:32]   ),
  .i_data_2         (w_crc_mac[31:24]   ),
  .i_data_3         (w_crc_mac[23:16]   ),
  .i_data_4         (w_crc_mac[15: 8]   ),
  .i_data_5         (w_crc_mac[7 : 0]   ),
  .i_data_6         (8'd0),
  .i_data_7         (8'd0),
  .o_crc_8          (),//8个byte全部参与校验的结果
  .o_crc_1          (),//1个byte全部参与校验的结果
  .o_crc_2          (),//2个byte全部参与校验的结果
  .o_crc_3          (),//3个byte全部参与校验的结果
  .o_crc_4          (),//4个byte全部参与校验的结果
  .o_crc_5          (),//5个byte全部参与校验的结果
  .o_crc_6          (w_crc32_result             ),//6个byte全部参与校验的结果
  .o_crc_7          () //7个byte全部参与校验的结果
);

// BRAM_MAC_Hash_table BRAM_MAC_Hash_table_u0 (
//   .clka     (i_clk              ),  
//   .ena      (ri_update_valid    ),    
//   .wea      (ri_update_valid    ),    
//   .addra    (w_hash_addr        ),  
//   .dina     (),     
//   .clkb     (i_clk          ),      
//   .enb      (),
//   .addrb    (),
//   .doutb    () 
// );

/******************************always*******************************/
always @(posedge i_clk) begin
    if(i_update_valid)begin
        ri_update_dest_mac <= i_update_dest_mac     ;
        ri_update_outport  <= i_update_outport      ;
        ri_update_valid    <= i_update_valid        ;
        ri_update_flag     <= i_update_flag         ;
    end
    else begin
        ri_update_dest_mac <= ri_update_dest_mac    ;
        ri_update_outport  <= ri_update_outport     ;
        ri_update_valid    <= 0       ;
        ri_update_flag     <= ri_update_flag        ;
    end
end
//写入表项
always @(posedge i_clk) begin
    if(ri_update_valid)
        mac_addr_num[w_hash_addr] <= mac_addr_num[w_hash_addr] + 1'd1;
    else
        mac_addr_num[w_hash_addr] <= mac_addr_num[w_hash_addr];
end

always @(posedge i_clk) begin
    if(ri_update_valid)begin
        case(mac_addr_num[w_hash_addr])
            0 : mac_addr_table[w_hash_addr][0 +: (48 + 1 + P_OUTPORT_WIDTH)] <= {ri_update_outport,ri_update_flag,ri_update_dest_mac};
            1 : mac_addr_table[w_hash_addr][1*(48 + 1 + P_OUTPORT_WIDTH) +: (48 + 1 + P_OUTPORT_WIDTH)] <= {ri_update_outport,ri_update_flag,ri_update_dest_mac};
            2 : mac_addr_table[w_hash_addr][2*(48 + 1 + P_OUTPORT_WIDTH) +: (48 + 1 + P_OUTPORT_WIDTH)] <= {ri_update_outport,ri_update_flag,ri_update_dest_mac};
            3 : mac_addr_table[w_hash_addr][3*(48 + 1 + P_OUTPORT_WIDTH) +: (48 + 1 + P_OUTPORT_WIDTH)] <= {ri_update_outport,ri_update_flag,ri_update_dest_mac};
            default : mac_addr_table[w_hash_addr] <=  mac_addr_table[w_hash_addr];
        endcase
    end
    else
        mac_addr_table[w_hash_addr] <= mac_addr_table[w_hash_addr];
end

//输出表项
always @(posedge i_clk) begin
    if(i_seek_valid)begin
        ri_seek_valid    <= i_seek_valid   ;
        ri_seek_dest_mac <= i_seek_dest_mac;
        ri_seek_id       <= i_seek_id      ;        
    end
    else begin
        ri_seek_valid    <= 0               ;
        ri_seek_dest_mac <= ri_seek_dest_mac;
        ri_seek_id       <= ri_seek_id      ;   
    end
end

always @(posedge i_clk) begin
    if(ri_seek_valid)begin
        if(mac_addr_table[w_hash_addr][0 +: 48] == ri_seek_dest_mac)begin
            ro_seek_flag    <= mac_addr_table[w_hash_addr][48 +: 1];
            ro_seek_outport <= mac_addr_table[w_hash_addr][48 + 1 +: P_OUTPORT_WIDTH];
            ro_seek_id      <= ri_seek_id;
            ro_seek_valid   <= 'd1;
        end
        else if(mac_addr_table[w_hash_addr][1 * (48 + 1 + P_OUTPORT_WIDTH)  +: 48] == ri_seek_dest_mac)begin
            ro_seek_flag    <= mac_addr_table[w_hash_addr][1 * (48 + 1 + P_OUTPORT_WIDTH) + 48 +: 1];
            ro_seek_outport <= mac_addr_table[w_hash_addr][1 * (48 + 1 + P_OUTPORT_WIDTH) + 48 + 1 +: P_OUTPORT_WIDTH];
            ro_seek_id      <= ri_seek_id;
            ro_seek_valid   <= 'd1;
        end
        else if(mac_addr_table[w_hash_addr][2 * (48 + 1 + P_OUTPORT_WIDTH)  +: 48] == ri_seek_dest_mac)begin
            ro_seek_flag    <= mac_addr_table[w_hash_addr][2 * (48 + 1 + P_OUTPORT_WIDTH) + 48 +: 1];
            ro_seek_outport <= mac_addr_table[w_hash_addr][2 * (48 + 1 + P_OUTPORT_WIDTH) + 48 + 1 +: P_OUTPORT_WIDTH];
            ro_seek_id      <= ri_seek_id;
            ro_seek_valid   <= 'd1;
        end
        else if(mac_addr_table[w_hash_addr][3 * (48 + 1 + P_OUTPORT_WIDTH)  +: 48] == ri_seek_dest_mac)begin
            ro_seek_flag    <= mac_addr_table[w_hash_addr][3 * (48 + 1 + P_OUTPORT_WIDTH) + 48 +: 1];
            ro_seek_outport <= mac_addr_table[w_hash_addr][3 * (48 + 1 + P_OUTPORT_WIDTH) + 48 + 1 +: P_OUTPORT_WIDTH];
            ro_seek_id      <= ri_seek_id;
            ro_seek_valid   <= 'd1;
        end
        else begin
            ro_seek_flag    <= 'd0;
            ro_seek_outport <= 'd0;
            ro_seek_id      <= 'd0;
            ro_seek_valid   <= 'd0;
        end
    end
    else begin
        ro_seek_flag    <= 'd0;
        ro_seek_outport <= 'd0;
        ro_seek_id      <= 'd0;
        ro_seek_valid   <= 'd0;
    end
end



endmodule
