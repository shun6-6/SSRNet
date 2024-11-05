`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/04 13:14:39
// Design Name: 
// Module Name: crossbar_tb
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


module crossbar_tb();

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


localparam  P_CROSSBAR_N = 4;

reg                         s0_axis_rx_tvalid   ;
reg [63 :0]                 s0_axis_rx_tdata    ;
reg                         s0_axis_rx_tlast    ;
reg [7  :0]                 s0_axis_rx_tkeep    ;
reg                         s0_axis_rx_tuser    ;
reg [2 : 0]                 s0_axis_rx_tdest    ;
wire                        m0_axis_tx_tvalid   ;
wire [63 :0]                m0_axis_tx_tdata    ;
wire                        m0_axis_tx_tlast    ;
wire [7  :0]                m0_axis_tx_tkeep    ;
wire                        m0_axis_tx_tuser    ;
reg                         s1_axis_rx_tvalid   ;
reg  [63 :0]                s1_axis_rx_tdata    ;
reg                         s1_axis_rx_tlast    ;
reg  [7  :0]                s1_axis_rx_tkeep    ;
reg                         s1_axis_rx_tuser    ;
reg  [2 : 0]                s1_axis_rx_tdest    ;
wire                        m1_axis_tx_tvalid   ;
wire [63 :0]                m1_axis_tx_tdata    ;
wire                        m1_axis_tx_tlast    ;
wire [7  :0]                m1_axis_tx_tkeep    ;
wire                        m1_axis_tx_tuser    ;
reg                         s2_axis_rx_tvalid   ;
reg  [63 :0]                s2_axis_rx_tdata    ;
reg                         s2_axis_rx_tlast    ;
reg  [7  :0]                s2_axis_rx_tkeep    ;
reg                         s2_axis_rx_tuser    ;
reg  [2 : 0]                s2_axis_rx_tdest    ;
wire                        m2_axis_tx_tvalid   ;
wire [63 :0]                m2_axis_tx_tdata    ;
wire                        m2_axis_tx_tlast    ;
wire [7  :0]                m2_axis_tx_tkeep    ;
wire                        m2_axis_tx_tuser    ;
reg                         s3_axis_rx_tvalid   ;
reg  [63 :0]                s3_axis_rx_tdata    ;
reg                         s3_axis_rx_tlast    ;
reg  [7  :0]                s3_axis_rx_tkeep    ;
reg                         s3_axis_rx_tuser    ;
reg  [2 : 0]                s3_axis_rx_tdest    ;
wire                        m3_axis_tx_tvalid   ;
wire [63 :0]                m3_axis_tx_tdata    ;
wire                        m3_axis_tx_tlast    ;
wire [7  :0]                m3_axis_tx_tkeep    ;
wire                        m3_axis_tx_tuser    ;

initial begin
    s0_axis_rx_tvalid = 'd0;
    s0_axis_rx_tdata  = 'd0;
    s0_axis_rx_tlast  = 'd0;
    s0_axis_rx_tkeep  = 'd0;
    s0_axis_rx_tuser  = 'd0;
    s0_axis_rx_tdest  = 'd0;
    wait(!rst);
    @(posedge clk);

    fork
        m0_send_pkt(0,8'hf0);
        m1_send_pkt(1,8'hf0);
        m2_send_pkt(2,8'hf0);
        m3_send_pkt(3,8'hf0);
    join

    fork
        m0_send_pkt(0,8'hf0);
        m1_send_pkt(1,8'hf0);
        m2_send_pkt(2,8'hf0);
        m3_send_pkt(3,8'hf0);
    join

    fork
        m0_send_pkt(0,8'hf0);
        m1_send_pkt(1,8'hf0);
        m2_send_pkt(2,8'hf0);
        m3_send_pkt(3,8'hf0);
    join

    fork
        m0_send_pkt(0,8'hf0);
        m1_send_pkt(1,8'hf0);
        m2_send_pkt(2,8'hf0);
        m3_send_pkt(3,8'hf0);
    join

    // fork
    //     m0_send_pkt(0,8'hf0);
    //     m1_send_pkt(0,8'hf0);
    //     m2_send_pkt(0,8'hf0);
    //     m3_send_pkt(0,8'hf0);
    // join

    // fork
    //     m0_send_pkt(1,8'hf0);
    //     m1_send_pkt(1,8'hf0);
    //     m2_send_pkt(1,8'hf0);
    //     m3_send_pkt(1,8'hf0);
    // join

    // fork
    //     m0_send_pkt(2,8'hf0);
    //     m1_send_pkt(2,8'hf0);
    //     m2_send_pkt(2,8'hf0);
    //     m3_send_pkt(2,8'hf0);
    // join

    // fork
    //     m0_send_pkt(3,8'hf0);
    //     m1_send_pkt(3,8'hf0);
    //     m2_send_pkt(3,8'hf0);
    //     m3_send_pkt(3,8'hf0);
    // join

end

crossbar#(
    .P_CROSSBAR_N           (P_CROSSBAR_N)        
)crossbar_u0(
    .i_clk                   (clk             ),
    .i_rst                   (rst             ),

    .s0_axis_rx_tvalid       (s0_axis_rx_tvalid ),
    .s0_axis_rx_tdata        (s0_axis_rx_tdata  ),
    .s0_axis_rx_tlast        (s0_axis_rx_tlast  ),
    .s0_axis_rx_tkeep        (s0_axis_rx_tkeep  ),
    .s0_axis_rx_tuser        (s0_axis_rx_tuser  ),
    .s0_axis_rx_tdest        (s0_axis_rx_tdest  ),
    .m0_axis_tx_tvalid       (m0_axis_tx_tvalid ),
    .m0_axis_tx_tdata        (m0_axis_tx_tdata  ),
    .m0_axis_tx_tlast        (m0_axis_tx_tlast  ),
    .m0_axis_tx_tkeep        (m0_axis_tx_tkeep  ),
    .m0_axis_tx_tuser        (m0_axis_tx_tuser  ),     
    .m0_axis_tx_tready       (1 ),          
    .s1_axis_rx_tvalid       (s1_axis_rx_tvalid ),
    .s1_axis_rx_tdata        (s1_axis_rx_tdata  ),
    .s1_axis_rx_tlast        (s1_axis_rx_tlast  ),
    .s1_axis_rx_tkeep        (s1_axis_rx_tkeep  ),
    .s1_axis_rx_tuser        (s1_axis_rx_tuser  ),
    .s1_axis_rx_tdest        (s1_axis_rx_tdest  ),
    .m1_axis_tx_tvalid       (m1_axis_tx_tvalid ),
    .m1_axis_tx_tdata        (m1_axis_tx_tdata  ),
    .m1_axis_tx_tlast        (m1_axis_tx_tlast  ),
    .m1_axis_tx_tkeep        (m1_axis_tx_tkeep  ),
    .m1_axis_tx_tuser        (m1_axis_tx_tuser  ),
    .m1_axis_tx_tready       (1 ),    
    .s2_axis_rx_tvalid       (s2_axis_rx_tvalid ),
    .s2_axis_rx_tdata        (s2_axis_rx_tdata  ),
    .s2_axis_rx_tlast        (s2_axis_rx_tlast  ),
    .s2_axis_rx_tkeep        (s2_axis_rx_tkeep  ),
    .s2_axis_rx_tuser        (s2_axis_rx_tuser  ),
    .s2_axis_rx_tdest        (s2_axis_rx_tdest  ),
    .m2_axis_tx_tvalid       (m2_axis_tx_tvalid ),
    .m2_axis_tx_tdata        (m2_axis_tx_tdata  ),
    .m2_axis_tx_tlast        (m2_axis_tx_tlast  ),
    .m2_axis_tx_tkeep        (m2_axis_tx_tkeep  ),
    .m2_axis_tx_tuser        (m2_axis_tx_tuser  ),
    .m2_axis_tx_tready       (1 ),    
    .s3_axis_rx_tvalid       (s3_axis_rx_tvalid ),
    .s3_axis_rx_tdata        (s3_axis_rx_tdata  ),
    .s3_axis_rx_tlast        (s3_axis_rx_tlast  ),
    .s3_axis_rx_tkeep        (s3_axis_rx_tkeep  ),
    .s3_axis_rx_tuser        (s3_axis_rx_tuser  ),
    .s3_axis_rx_tdest        (s3_axis_rx_tdest  ),
    .m3_axis_tx_tvalid       (m3_axis_tx_tvalid ),
    .m3_axis_tx_tdata        (m3_axis_tx_tdata  ),
    .m3_axis_tx_tlast        (m3_axis_tx_tlast  ),
    .m3_axis_tx_tkeep        (m3_axis_tx_tkeep  ),
    .m3_axis_tx_tuser        (m3_axis_tx_tuser  ),
    .m3_axis_tx_tready       (1 )
); 


task m0_send_pkt(input [2 : 0] tdest, input[7:0] keep);
begin : m0_send_pkt
    integer i;
    s0_axis_rx_tvalid <= 'd0;
    s0_axis_rx_tdata  <= 'd0;
    s0_axis_rx_tlast  <= 'd0;
    s0_axis_rx_tkeep  <= 'd0;
    s0_axis_rx_tuser  <= 'd0;
    s0_axis_rx_tdest  <= 'd0;
    wait(!rst)
    repeat(10) @(posedge clk);
    for(i = 0; i < 16; i = i + 1)begin
        s0_axis_rx_tvalid <= 'd1;
        if(i == 0)
            s0_axis_rx_tdata  <= 'd1;
        else
            s0_axis_rx_tdata <= i;
        
        if(i == 15)begin
            s0_axis_rx_tlast  <= 'd1;
            s0_axis_rx_tkeep  <= keep;
        end else begin
            s0_axis_rx_tlast  <= 'd0;
            s0_axis_rx_tkeep  <= 8'hff;
        end
        s0_axis_rx_tuser  <= 'd0;
        s0_axis_rx_tdest  <= tdest;
        @(posedge clk);
    end
    s0_axis_rx_tvalid <= 'd0;
    s0_axis_rx_tdata  <= 'd0;
    s0_axis_rx_tlast  <= 'd0;
    s0_axis_rx_tkeep  <= 'd0;
    s0_axis_rx_tuser  <= 'd0;
    s0_axis_rx_tdest  <= 'd0;
    @(posedge clk);
end
endtask

task m1_send_pkt(input [2 : 0] tdest, input[7:0] keep);
begin : m1_send_pkt
    integer i;
    s1_axis_rx_tvalid <= 'd0;
    s1_axis_rx_tdata  <= 'd0;
    s1_axis_rx_tlast  <= 'd0;
    s1_axis_rx_tkeep  <= 'd0;
    s1_axis_rx_tuser  <= 'd0;
    s1_axis_rx_tdest  <= 'd0;
    wait(!rst)
    repeat(10) @(posedge clk);
    for(i = 0; i < 16; i = i + 1)begin
        s1_axis_rx_tvalid <= 'd1;
        if(i == 0)
            s1_axis_rx_tdata  <= 'd2;
        else
            s1_axis_rx_tdata <= i;

        if(i == 15)begin
            s1_axis_rx_tlast  <= 'd1;
            s1_axis_rx_tkeep  <= keep;
        end else begin
            s1_axis_rx_tlast  <= 'd0;
            s1_axis_rx_tkeep  <= 8'hff;
        end
        s1_axis_rx_tuser  <= 'd0;
        s1_axis_rx_tdest  <= tdest;
        @(posedge clk);
    end
    s1_axis_rx_tvalid <= 'd0;
    s1_axis_rx_tdata  <= 'd0;
    s1_axis_rx_tlast  <= 'd0;
    s1_axis_rx_tkeep  <= 'd0;
    s1_axis_rx_tuser  <= 'd0;
    s1_axis_rx_tdest  <= 'd0;
    @(posedge clk);
end
endtask

task m2_send_pkt(input [2 : 0] tdest, input[7:0] keep);
begin : m2_send_pkt
    integer i;
    s2_axis_rx_tvalid <= 'd0;
    s2_axis_rx_tdata  <= 'd0;
    s2_axis_rx_tlast  <= 'd0;
    s2_axis_rx_tkeep  <= 'd0;
    s2_axis_rx_tuser  <= 'd0;
    s2_axis_rx_tdest  <= 'd0;
    wait(!rst)
    repeat(10) @(posedge clk);
    for(i = 0; i < 16; i = i + 1)begin
        s2_axis_rx_tvalid <= 'd1;
        if(i == 0)
            s2_axis_rx_tdata  <= 'd3;
        else
            s2_axis_rx_tdata <= i;

        if(i == 15)begin
            s2_axis_rx_tlast  <= 'd1;
            s2_axis_rx_tkeep  <= keep;
        end else begin
            s2_axis_rx_tlast  <= 'd0;
            s2_axis_rx_tkeep  <= 8'hff;
        end
        s2_axis_rx_tuser  <= 'd0;
        s2_axis_rx_tdest  <= tdest;
        @(posedge clk);
    end
    s2_axis_rx_tvalid <= 'd0;
    s2_axis_rx_tdata  <= 'd0;
    s2_axis_rx_tlast  <= 'd0;
    s2_axis_rx_tkeep  <= 'd0;
    s2_axis_rx_tuser  <= 'd0;
    s2_axis_rx_tdest  <= 'd0;
    @(posedge clk);
end
endtask

task m3_send_pkt(input [2 : 0] tdest, input[7:0] keep);
begin : m3_send_pkt
    integer i;
    s3_axis_rx_tvalid <= 'd0;
    s3_axis_rx_tdata  <= 'd0;
    s3_axis_rx_tlast  <= 'd0;
    s3_axis_rx_tkeep  <= 'd0;
    s3_axis_rx_tuser  <= 'd0;
    s3_axis_rx_tdest  <= 'd0;
    wait(!rst)
    repeat(10) @(posedge clk);
    for(i = 0; i < 16; i = i + 1)begin
        s3_axis_rx_tvalid <= 'd1;
        if(i == 0)
            s3_axis_rx_tdata  <= 'd4;
        else
            s3_axis_rx_tdata <= i;

        if(i == 15)begin
            s3_axis_rx_tlast  <= 'd1;
            s3_axis_rx_tkeep  <= keep;
        end else begin
            s3_axis_rx_tlast  <= 'd0;
            s3_axis_rx_tkeep  <= 8'hff;
        end
        s3_axis_rx_tuser  <= 'd0;
        s3_axis_rx_tdest  <= tdest;
        @(posedge clk);
    end
    s3_axis_rx_tvalid <= 'd0;
    s3_axis_rx_tdata  <= 'd0;
    s3_axis_rx_tlast  <= 'd0;
    s3_axis_rx_tkeep  <= 'd0;
    s3_axis_rx_tuser  <= 'd0;
    s3_axis_rx_tdest  <= 'd0;
    @(posedge clk);
end
endtask

endmodule
