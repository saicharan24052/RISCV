module RegisterFile(	input	logic clk, RegWrite,
						input	logic [4:0] ReadReg1, ReadReg2, WriteReg_Address,
						input	logic [31:0] WriteData,
						output	logic [31:0] RD1, RD2);    
 

logic [31:0] Register [0:31];


always_ff @(posedge clk) begin
	if(RegWrite && (WriteReg_Address != 0)) begin	//WriteReg_Address shouldn't be 0 , becaouse 0 is accupied for constant Zero (0)
		Register[WriteReg_Address] <= WriteData;
	end
end
 
assign RD1 = (ReadReg1 == 0)? 0 : Register[ReadReg1];  
assign RD2 = (ReadReg2 == 0)? 0 : Register[ReadReg2];

endmodule