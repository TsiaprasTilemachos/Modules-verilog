//This module implements a level to pusle that takes a multiple cycle pulse 
//and returns a single cycle pulse.
//This implementation uses a 3 state FSM to achieve the one cycle pulse
//While the input signal level remains high the pulse friquency increases

`timescale 1ns / 1ps

module GrayCounter_Pulse(input clk, input rst, input level, output reg pulse);

	reg [1:0] state;
	reg [1:0] nextstate;
	parameter S0 = 2'b00;
	parameter S1 = 2'b01;
	parameter S2 = 2'b10;

always @(*)
      begin
			case(state)
				S0:
					begin
						pulse = 0;
						if (level == 1)
						begin
							nextstate = S1;
						end
						else nextstate = S0;
					end
				S1:
					begin
						pulse = 1;
						if(level == 0)
						begin 
							nextstate = S0;
						end
						else
						begin
							nextstate = S2;
						end
					end
				S2:
					begin
						pulse = 0;
						if (level == 0)
						begin
							nextstate = S0;
						end
						else nextstate = S2;
					end
				default:
					begin
						nextstate = S0;
					end
			endcase
      end
	  
	  // Set the new state 
	always @(posedge clk or posedge rst)
	begin
		if(rst == 1'b1)
		begin
			state <= 2'b0;
		end
		else
			state <= nextstate;
	end
endmodule
