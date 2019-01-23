`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:23:52 01/10/2019
// Design Name:   basic_and
// Module Name:   C:/Users/BuccelliLab/Desktop/Prova_intan/HPF_tests/basic_and_tb.v
// Project Name:  HPF_tests
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: basic_and
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module basic_and_tb();
 
  reg [1:0] a, b;
  wire [1:0] out;
 
  basic_and #(.WIDTH(2)) DUT (
    .a(a),
    .b(b),
    .out(out)
  );
 
  initial begin
    a = 2'b00;
    b = 2'b00;
    #20
    a = 2'b11;
    b = 2'b01;
    #20
    a = 2'b11;
    b = 2'b11;
    #20
    a = 2'b11;
    b = 2'b00;
    #20
    a = 2'b11;
    b = 2'b10;
    #20
    $finish;
  end
 
endmodule

