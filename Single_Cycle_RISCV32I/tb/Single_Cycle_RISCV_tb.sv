module Single_Cycle_RISCV_tb;

bit clk,rst;

Single_Cycle_RISCV riscv(clk, rst);

always #0.5 clk = ~clk;


initial begin 
rst = 1;
#2.5;
rst  =0;
#26;
$stop;

end


endmodule