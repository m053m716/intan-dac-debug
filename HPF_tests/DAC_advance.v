`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:35:31 01/21/2019 
// Design Name: 
// Module Name:    DAC_advance 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DAC_advance(
		input wire			reset,
		input wire			dataclk,
		input wire [1:0]	DAC_edge_type,	
		input wire [1:0]	DAC_en, 			//this was 8bits in the original main
		input wire [31:0] DAC_fsm_state_counter_in,
		input wire [31:0] DAC_fsm_start_win_in_1,
		input wire [31:0] DAC_fsm_stop_win_in_1,
		input wire 			DAC_thrsh_pol_1,
		input wire [31:0] DAC_fsm_start_win_in_2,
		input wire [31:0] DAC_fsm_stop_win_in_2,
		input wire 			DAC_thrsh_pol_2,
		input wire [15:0]	DAC_input_offset,
		input wire [15:0] DAC_thrsh_1,
		input wire [15:0] DAC_thrsh_2,
		output wire 		DAC_check_states,
		output wire 		DAC_any_enabled,
		output wire [1:0] DAC_in_window,		 // needs to be an output
		output wire [1:0]	DAC_thresh_int,
		output wire [1:0]	DAC_in_en,
		output wire 		DAC_advance,
		output wire [1:0] DAC_state_status,
		output wire[1:0]	DAC_thresh_out //this was 8bits in the original main
    );
	 
	// this is usually in DAC_modified 
	assign DAC_in_window[0] = (DAC_fsm_state_counter_in >= DAC_fsm_start_win_in_1) && (DAC_fsm_stop_win_in_1 > DAC_fsm_state_counter_in);
	assign DAC_thresh_out[0] = DAC_en[0] ? (DAC_thrsh_pol_1 ? (DAC_input_offset >= DAC_thrsh_1) : (DAC_input_offset <= DAC_thrsh_1)) : 1'b0;
	assign DAC_in_window[1] = (DAC_fsm_state_counter_in >= DAC_fsm_start_win_in_2) && (DAC_fsm_stop_win_in_2 > DAC_fsm_state_counter_in);
	assign DAC_thresh_out[1] = DAC_en[1] ? (DAC_thrsh_pol_2 ? (DAC_input_offset >= DAC_thrsh_2) : (DAC_input_offset <= DAC_thrsh_2)) : 1'b0;
	//
	
	assign DAC_in_en = (~DAC_in_window) | (~DAC_en); // Tracks "In window" or "Enabled"; if a DAC channel is not one or the other, it will not interrupt state machine
	assign DAC_thresh_int = DAC_thresh_out ^ DAC_edge_type; // Intermediate threshold to X-OR the threshold level with the threshold type. If threshold is HIGH, but edge is also HIGH, interrupts machine.
	assign DAC_state_status = DAC_thresh_int | DAC_in_en; // The thresholding does not matter outside the window, or if DAC is disabled.
	assign DAC_check_states = &DAC_state_status; // Reduce the state status to a logical value (all conditions must be met)
	assign DAC_any_enabled = |DAC_en; 				// At least one DAC must be enabled to run the machine (otherwise it will constantly stim.)
	assign DAC_advance = DAC_check_states && DAC_any_enabled; 
	
endmodule
