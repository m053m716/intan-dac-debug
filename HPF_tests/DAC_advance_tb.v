`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:32:54 01/22/2019
// Design Name:   DAC_advance
// Module Name:   C:/Users/BuccelliLab/Documents/GitHub/intan-dac-debug/HPF_tests/DAC_advance_tb.v
// Project Name:  HPF_tests
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DAC_advance
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DAC_advance_tb;

	// Inputs
	reg reset;
	reg dataclk;
	reg [1:0] DAC_edge_type;
	reg [1:0] DAC_en;
	reg [31:0] DAC_fsm_state_counter_in;
	reg [31:0] DAC_fsm_start_win_in_1;
	reg [31:0] DAC_fsm_stop_win_in_1;
	reg DAC_thrsh_pol_1;
	reg [31:0] DAC_fsm_start_win_in_2;
	reg [31:0] DAC_fsm_stop_win_in_2;
	reg DAC_thrsh_pol_2;
	reg [15:0] DAC_input_offset;
	reg [15:0] DAC_thrsh_1;
	reg [15:0] DAC_thrsh_2;

	// Outputs
	wire DAC_check_states;
	wire DAC_any_enabled;
	wire [1:0] DAC_in_window;
	wire [1:0] DAC_thresh_int;
	wire [1:0] DAC_in_en;
	wire DAC_advance;
	wire [1:0] DAC_state_status;
	wire [1:0] DAC_thresh_out;

	integer fsm_window_state=0;
	reg [31:0] DAC_stop_max;
	localparam
			  fsm_idle   = 0,
			  fsm_track  = 1,
			  fsm_stim   = 2;
			  
	// Instantiate the Unit Under Test (UUT)
	DAC_advance uut (
		.reset(reset), 
		.dataclk(dataclk), 
		.DAC_edge_type(DAC_edge_type), 
		.DAC_en(DAC_en), 
		.DAC_fsm_state_counter_in(DAC_fsm_state_counter_in), 
		.DAC_fsm_start_win_in_1(DAC_fsm_start_win_in_1), 
		.DAC_fsm_stop_win_in_1(DAC_fsm_stop_win_in_1), 
		.DAC_thrsh_pol_1(DAC_thrsh_pol_1), 
		.DAC_fsm_start_win_in_2(DAC_fsm_start_win_in_2), 
		.DAC_fsm_stop_win_in_2(DAC_fsm_stop_win_in_2), 
		.DAC_thrsh_pol_2(DAC_thrsh_pol_2), 
		.DAC_input_offset(DAC_input_offset), 
		.DAC_thrsh_1(DAC_thrsh_1), 
		.DAC_thrsh_2(DAC_thrsh_2), 
		.DAC_check_states(DAC_check_states), 
		.DAC_any_enabled(DAC_any_enabled), 
		.DAC_in_window(DAC_in_window), 
		.DAC_thresh_int(DAC_thresh_int), 
		.DAC_in_en(DAC_in_en), 
		.DAC_advance(DAC_advance), 
		.DAC_state_status(DAC_state_status), 
		.DAC_thresh_out(DAC_thresh_out)
	);

	initial begin
		// Initialize Inputs
		reset = 0;
		dataclk = 0;
		DAC_edge_type = 2'b10; // 0== inclusion, 1 == exclusion
		DAC_en = 2'b11;
		DAC_fsm_state_counter_in = 0;
		
		DAC_fsm_start_win_in_1 = 0;
		DAC_fsm_stop_win_in_1 = 2;
		
		DAC_thrsh_pol_1 = 1; // if polarity==1, threshold_out == (DAC_input_offset >= DAC_thrsh_1)
		DAC_thrsh_pol_2 = 1;
		
		DAC_fsm_start_win_in_2 = 3;
		DAC_fsm_stop_win_in_2 = 5;
		DAC_stop_max=5;

		DAC_input_offset = 30975;
		DAC_thrsh_1 = 30973;
		DAC_thrsh_2 = 32255;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
		
	always
	#2 
	dataclk =  ! dataclk;
	
	always @(posedge dataclk) begin
		if (reset) begin
			fsm_window_state <= fsm_idle;
			DAC_fsm_state_counter_in <= 16'b0;
		end else begin					
				case (fsm_window_state)
					
					fsm_idle: begin

						if (DAC_advance) begin
							fsm_window_state <= fsm_track;
							DAC_fsm_state_counter_in <= DAC_fsm_state_counter_in + 1;
						end
					end
					
					fsm_track: begin

						if (DAC_advance) begin
							if (DAC_fsm_state_counter_in==DAC_stop_max) begin
								fsm_window_state <= fsm_stim;
								DAC_fsm_state_counter_in <= 16'b0;
							end else begin
								fsm_window_state <= fsm_track;
								DAC_fsm_state_counter_in <= DAC_fsm_state_counter_in + 1;
							end
						end else begin
							fsm_window_state <= fsm_idle;
							DAC_fsm_state_counter_in <= 16'b0;
						end
					end 
						  
					fsm_stim: begin

						fsm_window_state <= fsm_idle;
					end
					
					default: begin

						fsm_window_state <= fsm_idle;
						DAC_fsm_state_counter_in <= 16'b0;
					end
				endcase
		end	
	end
      
endmodule




