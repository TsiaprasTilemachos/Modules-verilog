//This module is used in order to cancel the noisy of a signal 
//created by a button on the ZEDboard so that a single pulse is prodused

`timescale 1ns / 1ps

module debounce #(parameter DELAY=10)   // .01 sec with a 100 Mhz clock 1500000
	             (input rst, input clk, input noisy, output reg clean);
	reg [20:0] count;
	
	always @ (posedge clk or posedge rst) begin
		if(rst == 1) begin
			count <= 19'b0;
			clean <= 0;
		end
		else begin
			if (noisy == 1'b1) begin
				if (count >= DELAY) begin
					clean <= 1;
				end
				else 
				begin
					clean <= 0;
					count <= count + 21'b1;
				end

			end
			else begin
				count <= 0;
				clean <= 0;
			end
		end
	end
endmodule
