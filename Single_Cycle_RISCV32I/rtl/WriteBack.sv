module WriteBack (
			input	logic	[31:0] ALU_result,
			input	logic	[31:0] Read_Data,
			input	logic	[31:0] pc_plus4,
			input	logic	[31:0] Imm_out,
			input	logic	[1:0] ResultSrc, 
			output	logic	[31:0] WB_Result
			);

	always_comb begin
		case(ResultSrc)
			2'b00:		WB_Result = ALU_result;
			2'b01:		WB_Result = Read_Data;
			2'b10:		WB_Result = pc_plus4;
			2'b11:		WB_Result = Imm_out;
			default:	WB_Result = 'x;		 		
	    endcase
	end

endmodule					   	 