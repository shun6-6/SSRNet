`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/22 16:37:00
// Design Name: 
// Module Name: hash_tb
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


module hash_tb();

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

wire  [47:0]                     o_update_dest_mac  ;
wire  [4 - 1:0]                  o_update_outport   ;
wire                             o_update_flag      ;
wire                             o_update_valid     ;

reg                             r_seek_valid        ;
reg [47:0]                      r_seek_dest_mac     ;
reg [2 :0]                      r_seek_id           ;

mac_table_init#(
    .P_OUTPORT_WIDTH (4                    )  ,
    .P_TABLE_DEPTH   (16                   )  ,
    .P_MYTOR_ADDR    (0                    )  ,
    .P_MY_MAC1       (48'h00_00_00_00_00_01)  ,
    .P_MY_MAC2       (48'h00_00_00_00_00_02)  
)mac_table_init_u0(
    .i_clk               (clk   ),
    .i_rst               (rst   ),
    .o_update_dest_mac   (o_update_dest_mac),
    .o_update_outport    (o_update_outport ),
    .o_update_flag       (o_update_flag    ),
    .o_update_valid      (o_update_valid   )
);

Hash_locating#(
    .P_OUTPORT_WIDTH    (4 )    ,
    .P_TABLE_DEPTH      (16)    ,
    .P_MYTOR_ADDR       (0 )    
)Hash_locating_u0(
    .i_clk               (clk   ),
    .i_rst               (rst   ),

    .i_update_dest_mac   (o_update_dest_mac),
    .i_update_outport    (o_update_outport ),
    .i_update_flag       (o_update_flag    ),
    .i_update_valid      (o_update_valid   ),

    .i_seek_valid        (r_seek_valid   ),
    .i_seek_dest_mac     (r_seek_dest_mac),
    .i_seek_id           (r_seek_id      ),
    .o_seek_outport      (),
    .o_seek_id           (),
    .o_seek_flag         (),
    .o_seek_valid        () 
);

initial begin
    r_seek_valid    = 'd0;
    r_seek_dest_mac = 'd0;
    r_seek_id       = 'd0;
    wait(!rst);
    seek_mac();
end

task seek_mac();
begin:seek_mac
    integer i;
    r_seek_valid    <= 'd0;
    r_seek_dest_mac <= 'd0;
    r_seek_id       <= 'd0;
    wait(!rst);
    repeat(50)@(posedge clk);
    for(i = 0; i < 16; i = i + 1)begin
        r_seek_valid    <= 'd1;
        r_seek_dest_mac <= {16'd0,i+1};
        r_seek_id       <= 'd0;
        @(posedge clk);
        r_seek_valid    <= 'd0;
        r_seek_dest_mac <= 'd0;
        r_seek_id       <= 'd0;
        @(posedge clk);
    end
end
endtask

endmodule
