`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:05:36 01/15/2019 
// Design Name: 
// Module Name:    main_reduced 
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
module main_reduced(
	input wire			reset,
	input wire			dataclk,
	input reg [15:0]  ampl_to_DAC
    );

integer 			fsm_window_state;
integer			main_state;
reg  				sample_CLK_out;
reg  				DAC_fsm_mode;
reg [15:0]		DAC_fsm_counter;
reg [15:0]		DAC_start_win_1;
reg [15:0]		DAC_stop_win_1;
reg [15:0]		DAC_stop_max;
reg  [7:0]		DAC_edge_type;
wire [7:0]		DAC_in_window;
wire [7:0]	   DAC_state_status;
reg  [7:0]		DAC_fsm_out;
wire [7:0]		DAC_thresh_int;
wire [7:0]		DAC_in_en;
wire 				DAC_advance;
wire 				DAC_check_states;
wire 				DAC_any_enabled;
wire  [7:0]		DAC_en;
wire  [7:0]		DAC_thresh_out;
reg   [5:0]		channel;  // varies from 0-19 (amplfier channels 0-15, plus 4 auxiliary commands)
reg  [15:0]		DAC_register_1;
wire [15:0] 	DAC_sequencer_1;
wire 				DAC_sequencer_en_1;
wire [2:0]		DAC_gain;
wire [6:0]     DAC_noise_suppress;
wire				DAC_SYNC;
wire				DAC_SCLK;
wire				DAC_DIN_1;
reg [15:0]		DAC_thresh_1;
reg				DAC_thresh_pol_1;
wire [7:0]		DAC_thresh_out;
reg [15:0]		HPF_coefficient;
reg				HPF_en;
wire				DAC_reref_mode;
wire				DAC_1_input_is_ref;
reg [15:0]		DAC_reref_register;
wire [15:0]		DAC_output_register_1; 
wire 				SPI_start;

	localparam
			  fsm_idle   = 0,
			  fsm_track  = 1,
			  fsm_stim   = 2,
				ms_wait    = 99,
				ms_clk1_a  = 100,
				ms_clk1_b  = 101,
				ms_clk1_c  = 102,
				ms_clk1_d  = 103,
				ms_clk2_a  = 104,
				ms_clk2_b  = 105,
				ms_clk2_c  = 106,
				ms_clk2_d  = 107,
				ms_clk3_a  = 108,
				ms_clk3_b  = 109,
				ms_clk3_c  = 110,
				ms_clk3_d  = 111,
				ms_clk4_a  = 112,
				ms_clk4_b  = 113,
				ms_clk4_c  = 114,
				ms_clk4_d  = 115,
				ms_clk5_a  = 116,
				ms_clk5_b  = 117,
				ms_clk5_c  = 118,
				ms_clk5_d  = 119,
				ms_clk6_a  = 120,
				ms_clk6_b  = 121,
				ms_clk6_c  = 122,
				ms_clk6_d  = 123,
				ms_clk7_a  = 124,
				ms_clk7_b  = 125,
				ms_clk7_c  = 126,
				ms_clk7_d  = 127,
				ms_clk8_a  = 128,
				ms_clk8_b  = 129,
				ms_clk8_c  = 130,
				ms_clk8_d  = 131,
				ms_clk9_a  = 132,
				ms_clk9_b  = 133,
				ms_clk9_c  = 134,
				ms_clk9_d  = 135,
				ms_clk10_a = 136,
				ms_clk10_b = 137,
				ms_clk10_c = 138,
				ms_clk10_d = 139,
				ms_clk11_a = 140,
				ms_clk11_b = 141,
				ms_clk11_c = 142,
				ms_clk11_d = 143,
				ms_clk12_a = 144,
				ms_clk12_b = 145,
				ms_clk12_c = 146,
				ms_clk12_d = 147,
				ms_clk13_a = 148,
				ms_clk13_b = 149,
				ms_clk13_c = 150,
				ms_clk13_d = 151,
				ms_clk14_a = 152,
				ms_clk14_b = 153,
				ms_clk14_c = 154,
				ms_clk14_d = 155,
				ms_clk15_a = 156,
				ms_clk15_b = 157,
				ms_clk15_c = 158,
				ms_clk15_d = 159,
				ms_clk16_a = 160,
				ms_clk16_b = 161,
				ms_clk16_c = 162,
				ms_clk16_d = 163,
				ms_clk17_a = 164,
				ms_clk17_b = 165,
				ms_clk17_c = 166,
				ms_clk17_d = 167,
				ms_clk18_a = 168,
				ms_clk18_b = 169,
				ms_clk18_c = 170,
				ms_clk18_d = 171,
				ms_clk19_a = 172,
				ms_clk19_b = 173,
				ms_clk19_c = 174,
				ms_clk19_d = 175,
				ms_clk20_a = 176,
				ms_clk20_b = 177,
				ms_clk20_c = 178,
				ms_clk20_d = 179,
				ms_clk21_a = 180,
				ms_clk21_b = 181,
				ms_clk21_c = 182,
				ms_clk21_d = 183,
				ms_clk22_a = 184,
				ms_clk22_b = 185,
				ms_clk22_c = 186,
				ms_clk22_d = 187,
				ms_clk23_a = 188,
				ms_clk23_b = 189,
				ms_clk23_c = 190,
				ms_clk23_d = 191,
				ms_clk24_a = 192,
				ms_clk24_b = 193,
				ms_clk24_c = 194,
				ms_clk24_d = 195,
				ms_clk25_a = 196,
				ms_clk25_b = 197,
				ms_clk25_c = 198,
				ms_clk25_d = 199,
				ms_clk26_a = 200,
				ms_clk26_b = 201,
				ms_clk26_c = 202,
				ms_clk26_d = 203,
				ms_clk27_a = 204,
				ms_clk27_b = 205,
				ms_clk27_c = 206,
				ms_clk27_d = 207,
				ms_clk28_a = 208,
				ms_clk28_b = 209,
				ms_clk28_c = 210,
				ms_clk28_d = 211,
				ms_clk29_a = 212,
				ms_clk29_b = 213,
				ms_clk29_c = 214,
				ms_clk29_d = 215,
				ms_clk30_a = 216,
				ms_clk30_b = 217,
				ms_clk30_c = 218,
				ms_clk30_d = 219,
				ms_clk31_a = 220,
				ms_clk31_b = 221,
				ms_clk31_c = 222,
				ms_clk31_d = 223,
				ms_clk32_a = 224,
				ms_clk32_b = 225,
				ms_clk32_c = 226,
				ms_clk32_d = 227,

				ms_clk33_a = 228,
				ms_clk33_b = 229,

				ms_cs_a    = 230,
				ms_cs_b    = 231,
				ms_cs_c    = 232,
				ms_cs_d    = 233,
				ms_cs_e    = 234,
				ms_cs_f    = 235,
				ms_cs_g    = 236,
				ms_cs_h    = 237,
				ms_cs_i    = 238,
				ms_cs_j    = 239;

	assign DAC_in_en = (~DAC_in_window) | (~DAC_en); // Tracks "In window" or "Enabled"; if a DAC channel is not one or the other, it will not interrupt state machine
	assign DAC_thresh_int = DAC_thresh_out ^ DAC_edge_type; // Intermediate threshold to X-OR the threshold level with the threshold type. If threshold is HIGH, but edge is also HIGH, interrupts machine.
	assign DAC_state_status = DAC_thresh_int | DAC_in_en; // The thresholding does not matter outside the window, or if DAC is disabled.
	assign DAC_check_states = &DAC_state_status; // Reduce the state status to a logical value (all conditions must be met)
	assign DAC_any_enabled = |DAC_en; 				// At least one DAC must be enabled to run the machine (otherwise it will constantly stim.)
	assign DAC_advance = DAC_check_states && DAC_any_enabled; // If all state criteria are met, advances to next clock cycle iteration.

	always @(posedge sample_CLK_out) begin
		if (reset) begin
			// MM 1/16/18 - FSM DISCRIMINATOR - START
			fsm_window_state <= fsm_idle;
			DAC_fsm_out <= 8'b0100_0000;
			DAC_fsm_counter <= 16'b0;
			// END
		end else begin					
			if (DAC_fsm_mode) begin
				case (fsm_window_state)
					
					fsm_idle: begin
						DAC_fsm_out <= 8'b0100_0000;
						if (DAC_advance) begin
							fsm_window_state <= fsm_track;
							DAC_fsm_counter <= DAC_fsm_counter + 1;
						end
					end
					
					fsm_track: begin
						DAC_fsm_out <= 8'b0010_0000;
						if (DAC_advance) begin
							if (DAC_fsm_counter==DAC_stop_max) begin
								fsm_window_state <= fsm_stim;
								DAC_fsm_counter <= 16'b0;
							end else begin
								fsm_window_state <= fsm_track;
								DAC_fsm_counter <= DAC_fsm_counter + 1;
							end
						end else begin
							fsm_window_state <= fsm_idle;
							DAC_fsm_counter <= 16'b0;
						end
					end 
						  
					fsm_stim: begin
						DAC_fsm_out <= 8'b0001_0000;
						fsm_window_state <= fsm_idle;
					end
					
					default: begin
						DAC_fsm_out <= 8'b0100_0000;
						fsm_window_state <= fsm_idle;
						DAC_fsm_counter <= 16'b0;
					end
				endcase
			end else begin
				fsm_window_state <= fsm_idle;
				DAC_fsm_counter <= 16'b0;
				DAC_fsm_out <= 8'b0000_0000;
			end
		end
	end
		
	// MM 1/22/2018 - FSM DISCRIMINATOR - END

				 	
	// reduced MAIN FSM to be placed here
	
					 	
	always @(posedge dataclk) begin
		if (reset) begin
			main_state <= ms_wait;
			sample_CLK_out <= 0;
			channel <= 0;
			SPI_start<=0;
			
		end else begin

			case (main_state)
			
				ms_wait: begin
					sample_CLK_out <= 0;
					channel <= 0;
					if (SPI_start) begin
						main_state <= ms_cs_j;
					end
				end

				ms_cs_j: begin
						main_state <= ms_clk1_a;
				end

				ms_clk1_a: begin
					if (channel == 0) begin	// sample clock goes high during channel 0 SPI command
						sample_CLK_out <= 1'b1;
					end else begin
						sample_CLK_out <= 1'b0;
					end


					if (channel == 0) begin		// update  DAC registers with the amplifier data
						DAC_register_1 <= ampl_to_DAC;
					end
					main_state <= ms_cs_i;
				end
				
				ms_cs_i: begin
					if (channel == 19) begin
						channel <= 0;
					end else begin
						channel <= channel + 1;
					end
					main_state <= ms_cs_j;
				end
				
				default: begin
					main_state <= ms_wait;
				end
				
			endcase
		end
	end

DAC_modified uut (
		.reset(reset), 
		.dataclk(dataclk), 
		.main_state(main_state), 
		.channel(channel), 
		.DAC_input(DAC_register_1), 
		.DAC_sequencer_in(DAC_sequencer_1), 
		.use_sequencer(DAC_sequencer_en_1), 
		.DAC_en(DAC_en), 
		.gain(DAC_gain), 
		.noise_suppress(DAC_noise_suppress), 
		.DAC_SYNC(DAC_SYNC), 
		.DAC_SCLK(DAC_SCLK), 
		.DAC_DIN(DAC_DIN_1), 
		.DAC_thrsh(DAC_thresh_1), 
		.DAC_thrsh_pol(DAC_thresh_pol_1), 
		.DAC_thrsh_out(DAC_thresh_out), 
		.DAC_fsm_start_win_in(DAC_start_win_1), //
		.DAC_fsm_stop_win_in(DAC_stop_win_1), 
		.DAC_fsm_state_counter_in(DAC_fsm_counter), 
		.DAC_fsm_inwin_out(DAC_in_window[0]), //
		.HPF_coefficient(HPF_coefficient), 
		.HPF_en(HPF_en), 
		.software_reference_mode(DAC_reref_mode & ~DAC_1_input_is_ref), 
		.software_reference(DAC_reref_register), 
		.DAC_register(DAC_output_register_1)
	);
						
					
endmodule
