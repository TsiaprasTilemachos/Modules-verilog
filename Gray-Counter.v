//This module implements a syncronus gray counter enebled by a pulse

`timescale 1ns / 1ps

module gray_Nbits #(parameter N=4)(clk, clk_en, rst, gray_out, rstled);
    input clk, clk_en, rst;
    output [N-1:0]gray_out;
    output rstled;
    reg [N-1:-1] state;

	//localy used
	reg temp;
    reg no_ones_below [N-1:-1];
    integer i, j, k;
    reg q_msb;

    always @ (posedge clk or posedge rst)
    begin
        if (rst == 1'b1)
        begin
            // Resetting involves setting the imaginary bit to 1
            temp <=1;
            state[-1] <= 1;
            for (i = 0; i <= N-1; i = i + 1)
                state[i] <= 0;    
            
        end
        else if (clk_en)
        begin
            state[-1] <= ~state[-1];
            
            for (i = 0; i < N-1; i = i + 1)
            begin    
            
                state[i] <= state[i] ^ (state[i-1] & no_ones_below[i-1]);    
            end    
            
            state[N-1] <= state[N-1] ^ (q_msb & no_ones_below[N-2]);
        end
        else temp <=0;
    end

    always @(*)
    begin
        no_ones_below[-1] = 1;
        
        for (j = 0; j < N-1; j = j + 1)
            no_ones_below[j] = no_ones_below[j-1] & ~state[j-1];    

        q_msb = state[N-1] | state[N-2];    
        
    end

    assign gray_out = state[N-1:0];
  //  assign rstled = temp;
        
endmodule

