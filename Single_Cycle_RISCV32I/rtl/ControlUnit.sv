module ControlUnit
		import macros_pkg::*;
				(	input	inst_type_e		opcode,
					output	logic 			jalr_sel, ALUSrc0, ALUSrc1,
					output	logic			[1:0] ResultSrc,
					output	logic			RegWrite, MemRead, MemWrite,
					output	logic			Jump, Branch,
					output	logic			[1:0] ALUOp);

					
//ALUOp tells what kind of operation is used without seeing func3, func7	 
//ALUOp 00: ADD for all Load, Store, auipc, lui(dont care about ALU) and jalr
//		01: unclear for B-Type
//		10:	Unclear for R-type
//		11: reserved				
always_comb begin
	case(opcode)
		I_TYPE_LOAD:	begin	//Load 
			jalr_sel		= 1'b0;
			ALUSrc0			= 1'b0;
			ALUSrc1			= 1'b1;
			ResultSrc		= 2'b01;
			RegWrite 		= 1'b1;
			MemRead 		= 1'b1;
			MemWrite 		= 1'b0;
			Jump			= 1'b0;
			Branch 			= 1'b0;
			ALUOp 			= 2'b00;
		end

		I_TYPE:	begin	//I-Type
			jalr_sel		= 1'b0;
			ALUSrc0			= 1'b0;
			ALUSrc1			= 1'b1;
			ResultSrc		= 2'b00;
			RegWrite 		= 1'b1;
			MemRead 		= 1'b0;
			MemWrite 		= 1'b0;
			Jump			= 1'b0;
			Branch 			= 1'b0;
			ALUOp 			= 2'b10;
		end
		
		U_TYPE_AUIPC:	begin	//auipc
			jalr_sel		= 1'b0;
			ALUSrc0			= 1'b1;
			ALUSrc1			= 1'b1;
			ResultSrc		= 2'b00;
			RegWrite 		= 1'b1;
			MemRead 		= 1'b0;
			MemWrite 		= 1'b0;
			Jump			= 1'b0;
			Branch 			= 1'b0;
			ALUOp 			= 2'b00;
		end		

		S_TYPE:	begin	//Store
			jalr_sel		= 1'b0;
			ALUSrc0			= 1'b0;
			ALUSrc1			= 1'b1;
			ResultSrc		= 2'b00;
			RegWrite 		= 1'b0;
			MemRead 		= 1'b0;
			MemWrite 		= 1'b1;
			Jump			= 1'b0;
			Branch 			= 1'b0;
			ALUOp 			= 2'b00;
		end	

		R_TYPE:	begin	//R-Type
			jalr_sel		= 1'b0;
			ALUSrc0			= 1'b0;
			ALUSrc1			= 1'b0;
			ResultSrc		= 2'b00;
			RegWrite 		= 1'b1;
			MemRead 		= 1'b0;
			MemWrite 		= 1'b0;
			Jump			= 1'b0;
			Branch 			= 1'b0;
			ALUOp 			= 2'b10;
		end
		
		U_TYPE_LUI:	begin	//lui
			jalr_sel		= 1'b0;
			ALUSrc0			= 1'b0;
			ALUSrc1			= 1'b0;
			ResultSrc		= 2'b11;
			RegWrite 		= 1'b1;
			MemRead 		= 1'b0;
			MemWrite 		= 1'b0;
			Jump			= 1'b0;
			Branch 			= 1'b0;
			ALUOp 			= 2'b00;
		end		

		B_TYPE:	begin	//Branch
			jalr_sel		= 1'b0;
			ALUSrc0			= 1'b0;
			ALUSrc1			= 1'b0;
			ResultSrc		= 2'b00;
			RegWrite 		= 1'b0;
			MemRead 		= 1'b0;
			MemWrite 		= 1'b0;
			Jump			= 1'b0;
			Branch 			= 1'b1;
			ALUOp 			= 2'b01;
		end
		
		I_TYPE_JALR:	begin	//jalr
			jalr_sel		= 1'b1;
			ALUSrc0			= 1'b0;
			ALUSrc1			= 1'b0;
			ResultSrc		= 2'b10;
			RegWrite 		= 1'b1;
			MemRead 		= 1'b0;
			MemWrite 		= 1'b0;
			Jump			= 1'b1;
			Branch 			= 1'b0;
			ALUOp 			= 2'b00;
		end			  

		J_TYPE:	begin	//jal
			jalr_sel		= 1'b0;
			ALUSrc0			= 1'b0;
			ALUSrc1			= 1'b0;
			ResultSrc		= 2'b10;
			RegWrite 		= 1'b1;
			MemRead 		= 1'b0;
			MemWrite 		= 1'b0;
			Jump			= 1'b1;
			Branch 			= 1'b0;
			ALUOp 			= 2'b00;
		end	
		
		default:	begin	
			jalr_sel		= 1'b0;
			ALUSrc0			= 1'b0;
			ALUSrc1			= 1'b0;
			ResultSrc		= 2'b00;
			RegWrite 		= 1'b0;
			MemRead 		= 1'b0;
			MemWrite 		= 1'b0;
			Jump			= 1'b0;
			Branch 			= 1'b0;
			ALUOp 			= 2'b00;
		end	
	endcase			

end									
endmodule					