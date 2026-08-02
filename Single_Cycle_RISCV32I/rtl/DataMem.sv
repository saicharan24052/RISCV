module DataMem(	input	logic clk,
				input	logic [31:0]address,
				input	logic [31:0] Write_Data,
				input	logic MemRead, MemWrite,	//why 2 signals instead of 1 signal (enable pin)? maybe becoz of data mem idle at branch inst
				input	logic [2:0] func3,
				output	logic [31:0] Read_Data);

logic [31:0] RAM [0:31];
logic [7:0] byte_data;
logic [15:0] halfword_data;
/*			
always_ff @(posedge clk) begin
	if(MemWrite) 
		RAM[address[31:2]] <= Write_Data;	//byte alignment
end

always_comb begin
	if(MemRead)	
		Read_Data = RAM[address[31:2]];		//byte alignment			
end
*/ 


always_ff @(posedge clk) begin
	if(MemWrite)
		case(func3) 
			3'b000:	begin
				    	case(address[1:0])
				        	2'b00:		RAM[address[31:2]][7:0]		<= Write_Data[7:0];	
							2'b01: 		RAM[address[31:2]][15:8] 	<= Write_Data[7:0];	
							2'b10:		RAM[address[31:2]][23:16] 	<= Write_Data[7:0];
							2'b11:		RAM[address[31:2]][31:24] 	<= Write_Data[7:0];	 
							default:	RAM[address[31:2]][7:0] 	<= Write_Data[7:0];	
						endcase		
					end
			3'b001:begin
				    	case(address[1])
				        	1'b0:		RAM[address[31:2]][15:0] 	<= Write_Data[15:0];	
							1'b1:		RAM[address[31:2]][31:16] 	<= Write_Data[15:0];	 
							default:	RAM[address[31:2]][15:0] 	<= Write_Data[15:0];	
						endcase		
					end		
			3'b010:						RAM[address[31:2]] 	<= Write_Data[31:0];					
		endcase
end



always_comb begin
	case(address[1:0])
    	2'b00:	byte_data		= RAM[address[31:2]][7:0];
    	2'b01:	byte_data 		= RAM[address[31:2]][15:8];      
    	2'b10:	byte_data 		= RAM[address[31:2]][23:16];
    	2'b11:	byte_data 		= RAM[address[31:2]][31:24];
    endcase     
end

always_comb begin
	case(address[1])
    	2'b00:	halfword_data 	= RAM[address[31:2]][15:0];
    	2'b01:	halfword_data 	= RAM[address[31:2]][31:16];      
    endcase     
end
always_comb begin
	if(MemRead)
		case(func3)
			3'b000:		Read_Data = {{24{byte_data[7]}}, byte_data};			//load byte sign extnd	 
			3'b001:		Read_Data = {{16{halfword_data[15]}}, halfword_data};	//load half-word sign extnd		
			3'b010:		Read_Data = RAM[address[31:2]];	   					//load word sign extnd	
			3'b100:		Read_Data = {{24{1'b0}}, byte_data};					//load byte zero extnd		
			3'b101:		Read_Data = {{16{1'b0}}, halfword_data};				//load half-word zero extnd
		endcase
end
endmodule			
	