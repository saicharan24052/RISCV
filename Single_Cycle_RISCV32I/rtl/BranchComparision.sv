module BranchComparision(	input	logic [6:0] opcode,
							input	logic [2:0] func3,
							input	logic [31:0] RD1, RD2,
			   				output	logic BranchTaken);

				
always_comb begin 
	if(opcode == 7'b1100011) begin
		case(func3) 

		3'b000:	BranchTaken = (RD1 == RD2);
		3'b001:	BranchTaken = (RD1 != RD2);
		3'b100: BranchTaken = ($signed(RD1) < $signed(RD2));
		3'b101: BranchTaken = ($signed(RD1) >= $signed(RD2));
		3'b110:	BranchTaken = (RD1 < RD2);
		3'b111:	BranchTaken = (RD1 >= RD2);
		endcase
	end
	
	else BranchTaken = 1'b0; 
	
end				
endmodule			