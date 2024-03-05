module InstructionMemory(
input wire[25:10] PCAddress,
output wire[15:0] Instruction);

reg[7:0] instrMem[127:0];

initial
$readmemb("InstructionMemory.mem", instrMem);

assign Instruction = {instrMem[PCAddress], instrMem[PCAddress+1]};


endmodule
