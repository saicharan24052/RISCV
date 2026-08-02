module ALUControl
	import macros_pkg::*;
		(	input	logic [1:0]	ALUOp,
			input	logic [2:0]	func3,
			input	logic [6:0]	func7,
			output	alu_op_e	ALUctrl);
					
					
always_comb begin
    casez ({ALUOp, func7, func3})

        // R-type
        12'b10_0000000_000: ALUctrl = ALU_ADD;	// add
        12'b10_0100000_000: ALUctrl = ALU_SUB;	// sub
        12'b10_0000000_001:	ALUctrl = ALU_SLL;	//shift left logical
        12'b10_0000000_010:	ALUctrl = ALU_SLT;	//set less than
        12'b10_0000000_011:	ALUctrl = ALU_SLTU;	//set less than unsigned
        
        12'b10_0000000_100:	ALUctrl = ALU_XOR;	//XOR
        12'b10_0000000_101:	ALUctrl = ALU_SRL;	//shift right logical	
        12'b10_0100000_101:	ALUctrl = ALU_SRA;	//shift right arithmetic
        
        12'b10_0000000_110: ALUctrl = ALU_OR;	// or
        12'b10_0000000_111: ALUctrl = ALU_AND;	// and 
        
        12'b01_???????_000:	ALUctrl = ALU_EQ;
        12'b01_???????_001:	ALUctrl = ALU_NEQ; 
        12'b01_???????_100:	ALUctrl = ALU_SLT;
        12'b01_???????_101:	ALUctrl = ALU_SGEQ;
        
        12'b01_???????_110:	ALUctrl = ALU_SLTU;
        12'b01_???????_111:	ALUctrl = ALU_SGEQU;

        // load, stor, auipc, jalr, lui
        12'b00_???????_???: ALUctrl = ALU_ADD;	//ADD

        // U-Type
        
        
        
        
        default:            ALUctrl = ALU_X;
    endcase
end				
endmodule					