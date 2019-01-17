`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:15:05 01/15/2019
// Design Name:   main_reduced
// Module Name:   C:/Users/BuccelliLab/Documents/GitHub/intan-dac-debug/HPF_tests/main_reduced_tb.v
// Project Name:  HPF_tests
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: main_reduced
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module main_reduced_tb;

	// Inputs
	reg reset;
	reg dataclk;
	reg [15:0] ampl_to_DAC;
	reg SPI_start;
	reg [15:0] DAC_start_win_1;
	reg [15:0] DAC_stop_win_1;
	reg [15:0] DAC_stop_max;
	reg DAC_edge_type;
	reg [15:0] HPF_coefficient;
	reg HPF_en;
	reg [15:0] DAC_sequencer_1;
	reg DAC_sequencer_en_1;
	reg DAC_en;
	reg [2:0] DAC_gain;
	reg [6:0] DAC_noise_suppress;
	reg [15:0] DAC_thrsh_1;
	reg DAC_thrsh_pol_1;
	reg DAC_reref_mode;
	reg DAC_1_input_is_ref;
	reg [15:0] DAC_reref_register;
	reg DAC_fsm_mode;

	// Outputs
	wire DAC_thrsh_out;
	wire DAC_SYNC;
	wire DAC_SCLK;
	wire DAC_DIN;
	wire[31:0] fsm_window_state;
	wire [15:0] DAC_output_register_1;
	wire  [31:0] main_state;
	wire sample_CLK_out;
	wire [5:0]channel;
	wire [15:0]DAC_register_1;
	
	// Additional
	integer f, count;
	parameter WIDTH = 6001;
	reg [15:0] data_stored [0:WIDTH-1]; //200001 16-bits words is the length of raw_data.txt
	
	// Instantiate the Unit Under Test (UUT)
	main_reduced uut (
		.reset(reset), 
		.dataclk(dataclk), 
		.ampl_to_DAC(ampl_to_DAC), 
		.SPI_start(SPI_start), 
		.DAC_start_win_1(DAC_start_win_1), 
		.DAC_stop_win_1(DAC_stop_win_1), 
		.DAC_stop_max(DAC_stop_max), 
		.DAC_edge_type(DAC_edge_type), 
		.DAC_thresh_out(DAC_thrsh_out), 
		.HPF_coefficient(HPF_coefficient), 
		.HPF_en(HPF_en), 
		.DAC_sequencer_1(DAC_sequencer_1), 
		.DAC_sequencer_en_1(DAC_sequencer_en_1), 
		.DAC_en(DAC_en), 
		.DAC_gain(DAC_gain), 
		.DAC_noise_suppress(DAC_noise_suppress), 
		.DAC_SYNC(DAC_SYNC), 
		.DAC_SCLK(DAC_SCLK), 
		.DAC_DIN(DAC_DIN), 
		.DAC_thrsh_1(DAC_thrsh_1), 
		.DAC_thrsh_pol_1(DAC_thrsh_pol_1), 
		.DAC_reref_mode(DAC_reref_mode), 
		.DAC_1_input_is_ref(DAC_1_input_is_ref), 
		.DAC_reref_register(DAC_reref_register), 
		.DAC_fsm_mode(DAC_fsm_mode),
		.fsm_window_state(fsm_window_state), 
		.DAC_output_register_1(DAC_output_register_1), 
		.main_state(main_state), 
		.sample_CLK_out(sample_CLK_out),
		.channel(channel),
		.DAC_register_1(DAC_register_1)
	);


initial begin
		// Initialize Inputs
		reset = 1;
		dataclk = 0;
		ampl_to_DAC = 0;
		SPI_start = 1;
		DAC_start_win_1 = 0;
		DAC_stop_win_1 = 3;
		DAC_stop_max = 3;
		DAC_edge_type = 0;
		HPF_coefficient = 3343; // 250Hz/30000kS
		HPF_en = 1;
		DAC_sequencer_1 = 0;
		DAC_sequencer_en_1 = 0;
		DAC_en = 1;
		DAC_gain = 0;
		DAC_noise_suppress = 0;
		DAC_thrsh_1 = 105;
		DAC_thrsh_pol_1 = 1;
		DAC_reref_mode = 0;
		DAC_1_input_is_ref = 0;
		DAC_reref_register = 0;
		count=0;
		DAC_fsm_mode=1;

		// Wait 100 ns for global reset to finish
		#100;
      reset = 0;
		// Add stimulus here

	end
	
	initial begin
		$readmemb("ampl_data_bin.txt", data_stored); // read data from txt in binary format
		f = $fopen("output_main_reduced_2.txt","w");
	end
	
	always
		#2 
		dataclk =  ! dataclk;

	always @(posedge dataclk) begin
		if (channel==0 & main_state==100) begin
			ampl_to_DAC<=data_stored[count];
			count=count+1;
			end
		if (channel==0 & main_state==170) begin //maybe it is correct @ 170 (to check)
			$fwrite(f,"%b\n",   DAC_output_register_1); // write to output_file
			$display ("Current value of DAC_register is %d", DAC_output_register_1);
			end
	end

endmodule


