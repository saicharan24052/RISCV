module pc(	input logic clk, rst,
			input logic [31:0] pc_next,
			output logic [31:0] pc_current);

always_ff @(posedge clk) begin
	if(rst)
		pc_current <= 'b0;
		
	else
		pc_current <= pc_next;


end				
endmodule			