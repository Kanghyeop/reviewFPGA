`timescale 1ns / 1ps

module fsm_counter
#(
	parameter CNT_BIT = 31
)
(
    input 			clk,
    input 			reset_n,
	input 			i_run,
	input  [CNT_BIT-1:0]	i_num_cnt, 
	output   		o_idle,
	output   		o_running,
	output reg		o_done
    );
    
/////////////////////

localparam S_IDLE	= 2'b00;
localparam S_RUN	= 2'b01;
localparam S_DONE  	= 2'b10;

reg [1:0] c_state;
reg [1:0] n_state;
wire	  is_done;

/////////////////////

assign o_idle 		= (c_state == S_IDLE); // o_IDLE
assign o_running 	= (c_state == S_RUN); // o_RUN
assign is_done = o_running && (cnt_always == num_cnt-1); // o_DONE + cnt logic

/////////////////////

// c_state ctrl
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
		c_state <= S_IDLE;
    end else begin
		c_state <= n_state;
    end
end

// n_state ctrl
always @(*) 
begin
	n_state = S_IDLE; // To prevent Latch.
	case(c_state)
	S_IDLE: if(i_run)
				n_state = S_RUN;
	S_RUN : if(is_done)
				n_state = S_DONE;
			else 
				n_state = S_RUN;
	S_DONE: n_state = S_IDLE;
	endcase
end 

/////////////////////

// num_cnt ctrl
reg [CNT_BIT-1:0] num_cnt;  
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        num_cnt <= 0;  
    end else if (i_run) begin
        num_cnt <= i_num_cnt;
	end else if (o_done) begin
		num_cnt <= 0;
	end
end

// counter logic
reg [CNT_BIT-1:0] cnt_always;

always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        cnt_always <= 0;  
    end else if (is_done) begin
        cnt_always <= 0; 
    end else if (o_running) begin
        cnt_always <= cnt_always + 1;
	end
end

/////////////////////

always @(*) // prevent latch (???)
begin
	o_done = 0;
	case(c_state)
	S_DONE: o_done = 1;
	endcase
end

endmodule