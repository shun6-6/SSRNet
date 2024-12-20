`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/20 20:37:58
// Design Name: 
// Module Name: OCS0_module
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


module OCS0_module(
    input           i_slot_id   ,

    input  [7 : 0]  i_tor_txp   ,
    input  [7 : 0]  i_tor_txn   ,
    output [7 : 0]  o_tor_rxp   ,
    output [7 : 0]  o_tor_rxn   
);

assign o_tor_rxp[0] = i_slot_id == 0 ? i_tor_txp[7] : i_tor_txp[5];
assign o_tor_rxn[0] = i_slot_id == 0 ? i_tor_txn[7] : i_tor_txn[5];

assign o_tor_rxp[1] = i_slot_id == 0 ? i_tor_txp[0] : i_tor_txp[6];
assign o_tor_rxn[1] = i_slot_id == 0 ? i_tor_txn[0] : i_tor_txn[6];

assign o_tor_rxp[2] = i_slot_id == 0 ? i_tor_txp[1] : i_tor_txp[7];
assign o_tor_rxn[2] = i_slot_id == 0 ? i_tor_txn[1] : i_tor_txn[7];

assign o_tor_rxp[3] = i_slot_id == 0 ? i_tor_txp[2] : i_tor_txp[0];
assign o_tor_rxn[3] = i_slot_id == 0 ? i_tor_txn[2] : i_tor_txn[0];

assign o_tor_rxp[4] = i_slot_id == 0 ? i_tor_txp[3] : i_tor_txp[1];
assign o_tor_rxn[4] = i_slot_id == 0 ? i_tor_txn[3] : i_tor_txn[1];

assign o_tor_rxp[5] = i_slot_id == 0 ? i_tor_txp[4] : i_tor_txp[2];
assign o_tor_rxn[5] = i_slot_id == 0 ? i_tor_txn[4] : i_tor_txn[2];

assign o_tor_rxp[6] = i_slot_id == 0 ? i_tor_txp[5] : i_tor_txp[3];
assign o_tor_rxn[6] = i_slot_id == 0 ? i_tor_txn[5] : i_tor_txn[3];

assign o_tor_rxp[7] = i_slot_id == 0 ? i_tor_txp[6] : i_tor_txp[4];
assign o_tor_rxn[7] = i_slot_id == 0 ? i_tor_txn[6] : i_tor_txn[4];

endmodule
