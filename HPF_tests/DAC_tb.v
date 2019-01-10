`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:51:57 01/10/2019
// Design Name:   DAC_output_scalable_HPF
// Module Name:   C:/Users/BuccelliLab/Desktop/Prova_intan/HPF_tests/DAC_tb.v
// Project Name:  HPF_tests
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DAC_output_scalable_HPF
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DAC_tb;

	// Inputs
	reg reset;
	reg dataclk;
	reg [31:0] main_state;
	reg [5:0] channel;
	reg [15:0] DAC_input;
	reg [15:0] DAC_sequencer_in;
	reg use_sequencer;
	reg DAC_en;
	reg [2:0] gain;
	reg [6:0] noise_suppress;
	reg [15:0] DAC_thrsh;
	reg DAC_thrsh_pol;
	reg [15:0] HPF_coefficient;
	reg HPF_en;
	reg software_reference_mode;
	reg [15:0] software_reference;
	integer f;
	parameter WIDTH = 6001;
	reg [15:0] data_stored [0:WIDTH-1]; //200001 16-bits words is the length of raw_data.txt
	

	// Outputs
	wire DAC_SYNC;
	wire DAC_SCLK;
	wire DAC_DIN;
	wire DAC_thrsh_out;
	wire [15:0] DAC_register;

	// Instantiate the Unit Under Test (UUT)
	DAC_output_scalable_HPF uut (
		.reset(reset), 
		.dataclk(dataclk), 
		.main_state(main_state), 
		.channel(channel), 
		.DAC_input(DAC_input), 
		.DAC_sequencer_in(DAC_sequencer_in), 
		.use_sequencer(use_sequencer), 
		.DAC_en(DAC_en), 
		.gain(gain), 
		.noise_suppress(noise_suppress), 
		.DAC_SYNC(DAC_SYNC), 
		.DAC_SCLK(DAC_SCLK), 
		.DAC_DIN(DAC_DIN), 
		.DAC_thrsh(DAC_thrsh), 
		.DAC_thrsh_pol(DAC_thrsh_pol), 
		.DAC_thrsh_out(DAC_thrsh_out), 
		.HPF_coefficient(HPF_coefficient), 
		.HPF_en(HPF_en), 
		.software_reference_mode(software_reference_mode), 
		.software_reference(software_reference), 
		.DAC_register(DAC_register)
	);

	initial begin
		// Initialize Inputs
		reset = 0;
		dataclk = 0;
		main_state = 0;
		channel = 0;
		DAC_input = 10;
		DAC_sequencer_in = 150;
		use_sequencer = 0;
		DAC_en = 1;
		gain = 2;
		noise_suppress = 0;
		DAC_thrsh = 0;
		DAC_thrsh_pol = 0;
		HPF_coefficient = 30;
		HPF_en = 1;
		software_reference_mode = 0;
		software_reference = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end

	initial begin
		$readmemb("ampl_data_bin.txt", data_stored); // read data from txt in binary format
		f = $fopen("output.txt","w");
	end
	
	
   
	always
		#5 dataclk =  ! dataclk;
	always @(posedge dataclk) begin
		DAC_en = ! DAC_en;
		
		$fwrite(f,"%b\n",   DAC_input); // write to output_file
		
		#3 $display ("Current value of DAC_register is %d", DAC_register);
		end
endmodule

