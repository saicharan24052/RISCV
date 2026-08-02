module ImmGen(	input	logic [31:0] Instr,
				output	logic [31:0] Imm);
				
always_comb begin
	case(Instr[6:0]) 
	
		7'b0000011,
		7'b0010011,
		7'b1100111:	Imm = {{20{Instr[31]}}, Instr[31:20]};	//I-Type
		
		7'b0100011:	Imm = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};	//S-Type
		
		7'b1100011:	Imm = {{19{Instr[31]}}, {Instr[31]}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};	//B-Type	
	
		7'b0010111,
		7'b0110111:	Imm = {Instr[31:12], {12{1'b0}}};	//U-Type  
		
		7'b1101111:	Imm = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0}; //J-Type
	endcase
end				
endmodule			