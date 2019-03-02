//author: Tilemachos Tsiapras
//module name: GrayCounter_Pulse
//file : Level-to-accelerated-pulse.v
//description : This module implements a level to pusle that takes a multiple cycle pulse 
//              and returns a single cycle pulse.
//              This implementation uses a 3 state FSM to achieve the one cycle pulse
//              While the input signal level remains high the pulse friquency increases
//              max Wall : max distance between pulses
//              min Wall : min distance between pulses

`timescale 1ns / 1ps

module GrayCounter_Pulse(input clk, input rst, input level, output reg pulse);

	reg [1:0] state;
	reg [1:0] nextstate;
	parameter S0 = 2'b00;
	parameter S1 = 2'b01;
	parameter S2 = 2'b10;
	parameter MaxWall = 27'b101111101011110000100000000; //100000000 cycles for 1 sec of delay  
	parameter MinWall = 27'b11110100001001000000; //1000000 cycles  
	reg flag;
	reg [26:0] wall;
	reg [26:0] counter;
	
	
	always @(*) begin
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
						if (level == 0 || flag ==1)
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
				wall <= MaxWall; 
				counter <= 27'b0;
				flag = 0;
			end
			else begin
				state <= nextstate;
				if (state == S0) begin
					counter <=0;
					if (flag == 0) wall = MaxWall;
					flag <=0;
				end
				else if (state == S2) begin
					counter <= counter + 27'b1;
					if (counter >= wall)
					begin
						//step for acceleration 3000000 cycles
						if(wall > MinWall) wall<= wall - 27'b1011011100011011000000;
						else if(wall < MinWall) wall <= MinWall;
						flag <= 1;
						counter<= 27'b0;
					end
				end
			end
	end
endmodule
