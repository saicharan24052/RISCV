//Lets make a Instruction Memory Readable/Writable
module InstMem(	input	logic clk,
			   //	input	logic we,	//we = 1 for writing instructions to the memory and we = 0 it will reads
				input	logic [31:0] address, //Inst_in,
				output	logic [31:0] Inst_out);
				
logic [31:0] RAM [0:12];	//Depth can varies 
/*				
always_ff @(posedge clk)begin		//write is always sequentional
	if(we) begin	
		mem[address] <= Inst_in; 
	end
end
*/
initial
	$readmemh("Instructions.txt", RAM);
			 

always_comb begin					//Read is always combinational
  //	if(!we) begin	
			Inst_out = RAM[address[31:2]];
   //	end
end
endmodule