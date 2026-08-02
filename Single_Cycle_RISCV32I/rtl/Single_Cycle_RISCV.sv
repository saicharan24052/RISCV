module Single_Cycle_RISCV(	input	logic clk, rst);

import macros_pkg::*;

logic [31:0] pc_current;
logic [31:0] pc_next;

logic [31:0] jalr_RD1, jalr_or_pc;

logic Branch;
logic [31:0] Imm; 

 
logic [31:0] Instr;

logic Branch_flag; 

logic MemRead;
logic [1:0] ResultSrc;
logic MemWrite, ALUSrc0, ALUSrc1, RegWrite, Jump, jalr_sel;
logic [1:0] ALUOp;	

logic [31:0] WriteData_Reg;
logic [31:0] RD1, RD2;  

logic [3:0] ALUctrl; 

logic [31:0] ALU_result, ALU_B,ALU_A; 

logic [31:0] Data;

logic [31:0] pc_plus4;

assign pc_plus4 = pc_current + 32'd4; 

assign jalr_or_pc = jalr_sel ? RD1 : pc_current;  
assign pc_next = ((Branch && Branch_flag) | Jump) ? (jalr_or_pc + Imm) : pc_plus4; 

pc pc_mod(	.clk(clk),
			.rst(rst),
			.pc_next(pc_next),
			.pc_current(pc_current)
			);	


InstMem InstMem_mod(	.clk(clk),
						.address(pc_current),
						.Inst_out(Instr)
						);
						




					
ControlUnit CU_mod(	.opcode(inst_type_e'(Instr[6:0])),
					.jalr_sel(jalr_sel),
					.Branch(Branch),
					.Jump(Jump),
					.MemRead(MemRead),
					.ResultSrc(ResultSrc),
					.ALUOp(ALUOp),
					.MemWrite(MemWrite),
					.ALUSrc0(ALUSrc0),
					.ALUSrc1(ALUSrc1),
					.RegWrite(RegWrite)
					);	  

RegisterFile RegFile_mod(	.clk(clk),
							.RegWrite(RegWrite),
							.ReadReg1(Instr[19:15]),
							.ReadReg2(Instr[24:20]),
							.WriteReg_Address(Instr[11:7]),
							.WriteData(WriteData_Reg),
							.RD1(RD1),
							.RD2(RD2)
							);
							

ImmGen ImmGen_mod(	.Instr(Instr),
					.Imm(Imm));



ALUControl ALUControl_mod(	.ALUOp(ALUOp),
							.func3(Instr[14:12]),
							.func7(Instr[31:25]),
							.ALUctrl(ALUctrl)
							);


assign ALU_A = ALUSrc0 ? pc_current : RD1;
assign ALU_B = ALUSrc1 ? Imm : RD2;   
 
ALU ALU_mod(	.ALUctrl(alu_op_e'(ALUctrl)),
				.A(ALU_A),
				.B(ALU_B),
				.ALU_result(ALU_result),
				.Branch_flag(Branch_flag)
				);
				


DataMem DataMem_mod(	.clk(clk),
						.address(ALU_result),
						.Write_Data(RD2),
						.MemRead(MemRead),
						.MemWrite(MemWrite),
						.func3(Instr[14:12]),
						.Read_Data(Data)
						);

WriteBack WB_mod(	.ALU_result(ALU_result),
					.Read_Data(Data),
					.pc_plus4(pc_plus4),
					.Imm_out(Imm),
					.ResultSrc(ResultSrc),
					.WB_Result(WriteData_Reg)
					); 
					
					
always @(posedge clk) begin 

//if(!rst) begin
    inst_type_e opcode;
    string inst;  
    
    #1;
    opcode = inst_type_e'(Instr[6:0]);
    
   	
    $display($time, "Instruction = %08h", Instr);
    //$display($time, "opcode = %07h", opcode);
    //$display($time, "Instr[6:0] = %07h\n", Instr[6:0]);

    case (opcode)

    //---------------------------------------------------------
    // LOAD
    //---------------------------------------------------------
    I_TYPE_LOAD: begin
        case (Instr[14:12])
            3'b000: inst = "lb";
            3'b001: inst = "lh";
            3'b010: inst = "lw";
            3'b100: inst = "lbu";
            3'b101: inst = "lhu";
            default: inst = "UNKNOWN";
        endcase

        $display($time, "%s\tx%0d, %0d(x%0d)\tWB=%0d",
                inst, Instr[11:7], Imm, Instr[19:15], WriteData_Reg);
    end

    //---------------------------------------------------------
    // OP-IMM
    //---------------------------------------------------------
    I_TYPE: begin
        case (Instr[14:12])

            3'b000: inst = "addi";
            3'b001: inst = "slli";
            3'b010: inst = "slti";
            3'b011: inst = "sltiu";
            3'b100: inst = "xori";

            3'b101:
                case (Instr[31:25])
                    7'b0000000: inst = "srli";
                    7'b0100000: inst = "srai";
                    default:    inst = "UNKNOWN";
                endcase

            3'b110: inst = "ori";
            3'b111: inst = "andi";

            default: inst = "UNKNOWN";
        endcase

        $display($time, "%s\tx%0d, x%0d, %0d\tWB=%0d",
                inst, Instr[11:7], Instr[19:15], Imm, WriteData_Reg);
    end

    //---------------------------------------------------------
    // AUIPC
    //---------------------------------------------------------
    U_TYPE_AUIPC:
        $display($time, "auipc\tx%0d, %0d\tWB=%0d",
                Instr[11:7], Imm, WriteData_Reg);

    //---------------------------------------------------------
    // LUI
    //---------------------------------------------------------
    U_TYPE_LUI:
        $display($time, "lui\tx%0d, %0d\tWB=%0d",
                Instr[11:7], Imm, WriteData_Reg);

    //---------------------------------------------------------
    // STORE
    //---------------------------------------------------------
    S_TYPE: begin
        case (Instr[14:12])
            3'b000: inst = "sb";
            3'b001: inst = "sh";
            3'b010: inst = "sw";
            default: inst = "UNKNOWN";
        endcase

        $display($time, "%s\tx%0d, %0d(x%0d)",
                inst, Instr[24:20], Imm, Instr[19:15]);
    end

    //---------------------------------------------------------
    // R-TYPE
    //---------------------------------------------------------
    R_TYPE: begin

        case ({Instr[31:25],Instr[14:12]})

            {7'b0000000,3'b000}: inst="add";
            {7'b0100000,3'b000}: inst="sub";

            {7'b0000000,3'b001}: inst="sll";
            {7'b0000000,3'b010}: inst="slt";
            {7'b0000000,3'b011}: inst="sltu";
            {7'b0000000,3'b100}: inst="xor";
            {7'b0000000,3'b101}: inst="srl";
            {7'b0100000,3'b101}: inst="sra";
            {7'b0000000,3'b110}: inst="or";
            {7'b0000000,3'b111}: inst="and";

            default: inst="UNKNOWN";

        endcase

        $display($time, "%s\tx%0d, x%0d, x%0d\tWB=%0d",
                inst,
                Instr[11:7],
                Instr[19:15],
                Instr[24:20],
                WriteData_Reg);
    end

    //---------------------------------------------------------
    // BRANCH
    //---------------------------------------------------------
    B_TYPE: begin

        case (Instr[14:12])
            3'b000: inst="beq";
            3'b001: inst="bne";
            3'b100: inst="blt";
            3'b101: inst="bge";
            3'b110: inst="bltu";
            3'b111: inst="bgeu";
            default: inst="UNKNOWN";
        endcase

        $display($time, "%s\tx%0d, x%0d\tPC=%08h",
                inst,
                Instr[19:15],
                Instr[24:20],
                pc_next);

    end

    //---------------------------------------------------------
    // JALR
    //---------------------------------------------------------
    I_TYPE_JALR:
        $display($time, "jalr\tx%0d, %0d(x%0d)\tPC=%08h\tWB=%0d",
                Instr[11:7],
                Imm,
                Instr[19:15],
                pc_next,
                WriteData_Reg);

    //---------------------------------------------------------
    // JAL
    //---------------------------------------------------------
    J_TYPE:
        $display($time, "jal\tx%0d\tPC=%08h\tWB=%0d",
                Instr[11:7],
                pc_next,
                WriteData_Reg);

    default:
        $display($time,"BAD INSTRUCTION: %b", opcode);

    endcase
        $display(".................................\n");
end					
//end					
					
					
					
					
					
					
endmodule					
/*
always_ff @(posedge clk) begin
if (inst_type_e'(Instr[6:0]) == I_TYPE_LOAD) begin
        string load_type;

        case (Instr[14:12])
            3'b000: load_type = "lb";
            3'b001: load_type = "lh";
            3'b010: load_type = "lw";
            3'b100: load_type = "lbu";
            3'b101: load_type = "lhu";
            default: load_type = "UNKNOWN LOAD";
        endcase

        $display($time, "Instruction = %08h", Instr);
        $display($time, "%s \t x%0d	\t %0d(x%0d) \t WB Data: %0d", load_type, Instr[11:7], Imm, Instr[19:15], WriteData_Reg);
    end
else if(inst_type_e'(Instr[6:0]) == I_TYPE) begin
	string imm_type; 
	
        case (Instr[14:12])
            3'b000: imm_type = "addi";
            3'b001: imm_type = "slli";
            3'b010: imm_type = "slti";
            3'b011: imm_type = "sltiu";
            3'b100: imm_type = "xori";
            3'b101:	
            	begin 
            	if(Instr[31:25] == 7'b0000000)
            		imm_type = "srli";
            	else if(Instr[31:25] == 7'b0100000)
            	 	imm_type = "srai;
            	else
            	 	imm_type = "UNKNOWN INST"; 	
            	end
            3'b110:	imm_type = "ori"; 
            3'b111:	imm_type = "andi";
                       
            default: imm_type = "UNKNOWN INST default"; 
        endcase
        $display($time, "Instruction = %08h", Instr);
        $display($time, "%s \t x%0d	\t x%0d \t %0d \t WB Data: %0d", imm_type, Instr[11:7], Instr[19:15], Imm, WriteData_Reg);
        
end    

else if (inst_type_e'(Instr[6:0]) == U_TYPE_AUIPC) begin

        $display($time, "Instruction = %08h", Instr);
        $display($time, "auipc \t x%0d \t %0d \t WB Data: %0d", Instr[11:7], Imm, WriteData_Reg);
        

    end
else if(inst_type_e'(Instr[6:0]) == S_TYPE) begin
	string store_type; 
	
        case (Instr[14:12])
            3'b000: store_type = "sb";
            3'b001: store_type = "sh";
            3'b010: store_type = "sw";
            default: store_type = "UNKNOWN STORE INST default"; 
        endcase
        
        $display($time, "Instruction = %08h", Instr);
        $display($time, "%s \t x%0d	\t %0d(x%0d) \t WB Data: %0d", store_type, Instr[11:7], Imm, Instr[19:15],  WriteData_Reg);
        

end

else if(inst_type_e'(Instr[6:0]) == R_TYPE) begin
	string r_type; 
	
        case (Instr[14:12])
            3'b000:
            begin
            	if(Instr[31:25] == 7'b0000000)
            		r_type = "add";
            	else if((Instr[31:25] == 7'b0100000))
            		r_type = "sub";
            	else
            		r_type = "ERROR";
            end
            3'b001: r_type = "sll";
            3'b010: r_type = "slt";
            3'b011: r_type = "sltu";
            3'b100: r_type = "xor"; 
            3'b101:
            begin
            	if(Instr[31:25] == 7'b0000000)
            		r_type = "srl";
            	else if((Instr[31:25] == 7'b0100000))
            		r_type = "sra";
            	else
            		r_type = "ERROR";
            end
            3'b110: r_type = "or";
            3'b111: r_type = "and";                       
            default: r_type = "UNKNOWN INST";
        endcase
        
        $display($time, "Instruction = %08h", Instr);
        $display($time, "%s \t x%0d	\t x%0d \t x%0d \t WB Data: %0d", r_type, Instr[11:7], Instr[19:15], Instr[24:20], WriteData_Reg);

end
else if (inst_type_e'(Instr[6:0]) == U_TYPE_LUI) begin

        $display($time, "Instruction = %08h", Instr);
        $display($time, "lui \t x%0d \t %0d \t WB Data: %0d", Instr[11:7], Imm, WriteData_Reg);
end 										

else if(inst_type_e'(Instr[6:0]) == B_TYPE) begin
	string b_type; 
	
        case (Instr[14:12])
            3'b000: b_type = "beq";
            3'b001: b_type = "bne";
            3'b100: b_type = "blt";
            3'b101: b_type = "bge";
            3'b110: b_type = "bltu"; 
            3'b111: b_type = "bgeu";                      
            default: b_type = "UNKNOWN INST";
        endcase
        
        $display($time, "Instruction = %08h", Instr);
        $display($time, "%s	\t x%0d \t x%0d \t PC: %0h \t WB Data: %0d", b_type, Instr[19:15], Instr[24:20],pc_next,  WriteData_Reg);

end
else if (inst_type_e'(Instr[6:0]) == I_TYPE_JALR) begin

        $display($time, "Instruction = %08h", Instr);
        $display($time, "jalr \t x%0d \t x%0d \t %0d \t PC: %0h \t WB Data: %0d", Instr[11:7], Instr[19:15],  pc_next, WriteData_Reg);
end 
else if (inst_type_e'(Instr[6:0]) == J_TYPE) begin

        $display($time, "Instruction = %08h", Instr);
        $display($time, "jal \t x%0d  PC: %0h \t WB Data: %0d", Instr[11:7], pc_next, WriteData_Reg);
end

else 

   $display($time, "BAD INSTRUCTION");	 										
end
*/
