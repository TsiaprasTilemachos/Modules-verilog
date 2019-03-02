//This modules translates the binary value of the gray counter
//to the values needed to display the hex representation of the
//counter value

`timescale 1ns / 1ps

module decoder ( gray_counter, disp_out);
	input [3:0] gray_counter;
	output [3:0]  disp_out;
	
	reg [6:0] hex;
	
	assign disp_out = hex;
	
	// Cathode patterns of the 7-segment LED display 
	always @(*)
	begin
		case(gray_counter)
			4'b0000 : hex <= 7'h7E;
            4'b0001 : hex <= 7'h30;
            4'b0010 : hex <= 7'h6D;
            4'b0011 : hex <= 7'h79;
            4'b0100 : hex <= 7'h33;          
            4'b0101 : hex <= 7'h5B;
            4'b0110 : hex <= 7'h5F;
            4'b0111 : hex <= 7'h70;
            4'b1000 : hex <= 7'h7F;
            4'b1001 : hex <= 7'h7B;
            4'b1010 : hex <= 7'h77;
            4'b1011 : hex <= 7'h1F;
            4'b1100 : hex <= 7'h4E;
            4'b1101 : hex <= 7'h3D;
            4'b1110 : hex <= 7'h4F;
            4'b1111 : hex <= 7'h47;
			//default: hex = 7'b
		endcase
	end
endmodule
