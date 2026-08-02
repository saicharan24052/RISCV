
package macros_pkg;

	parameter ALU_OP_WIDTH = 4;

	typedef enum logic [ALU_OP_WIDTH-1:0] {
		ALU_ADD 	= 4'b0000,
		ALU_SUB 	= 4'b0001, 			             
		ALU_SLL 	= 4'b0010,
		ALU_SLT 	= 4'b0011,
		ALU_SLTU	= 4'b0100,
		ALU_XOR 	= 4'b0101,
 		ALU_SRL 	= 4'b0110,
 		ALU_SRA 	= 4'b0111,
 		ALU_OR 		= 4'b1000,
 		ALU_AND 	= 4'b1001,
 		ALU_EQ 		= 4'b1010,
 		ALU_NEQ 	= 4'b1011,
 		ALU_SGEQ 	= 4'b1100, 
 		ALU_SGEQU 	= 4'b1101,
 		ALU_X		= 'x 
 		
	} alu_op_e;
	
	typedef enum logic [6:0] {
		I_TYPE_LOAD		= 7'b0000011,
		I_TYPE			= 7'b0010011, 
		U_TYPE_AUIPC	= 7'b0010111,
		S_TYPE			= 7'b0100011,
		R_TYPE			= 7'b0110011,
		U_TYPE_LUI		= 7'b0110111,
		B_TYPE			= 7'b1100011,
		I_TYPE_JALR		= 7'b1100111,
		J_TYPE			= 7'b1101111
		
	} inst_type_e;


endpackage 