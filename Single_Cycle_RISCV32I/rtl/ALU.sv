module ALU
	import macros_pkg::*;
		(	input	alu_op_e	ALUctrl,
			input	logic 		[31:0] A, B,
			output	logic 		[31:0] ALU_result,
			output	logic 		Branch_flag);
			
 			             
always_comb begin
	case (ALUctrl)
		ALU_ADD:	ALU_result	= A + B;		//add
		ALU_SUB:	ALU_result	= A - B;		//sub
		ALU_SLL:	ALU_result 	= A << B[4:0];	//shift left logical
		ALU_SLT:	ALU_result 	= $signed(A) < $signed(B);	//set less than
		ALU_SLTU:	ALU_result 	= A < B;		//set less than unsigned
		ALU_XOR:	ALU_result 	= A ^ B;		//XOR
		ALU_SRL:	ALU_result 	= A >> B[4:0];	//shift right logical 
		ALU_SRA:	ALU_result 	= $signed(A) >>> B[4:0];
		ALU_OR:		ALU_result 	= A | B;		//OR
		ALU_AND:	ALU_result 	= A & B;		//AND
		ALU_EQ:		ALU_result 	= (A == B);		//EQ
		ALU_NEQ:	ALU_result 	= !(A == B);	//NEQ
		ALU_SGEQ:	ALU_result 	= $signed(A) >= $signed(B);	//
		ALU_SGEQU:	ALU_result	= A >= B;
		 
		default:	ALU_result = 'bx;
     endcase
end 

assign Branch_flag = ALU_result[0];     

endmodule			