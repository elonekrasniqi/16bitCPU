module DataMemory(
input wire[25:10] Address,
input wire[15:0] WriteData,
input wire MemWrite,
input wire MemRead,
input wire Clock,
output wire[15:0] ReadData
);

reg[7:0] dataMem[127:0];

initial
$readmemb("DataMemory.mem", dataMem);

always@(posedge Clock)
begin
    if(MemWrite) 
        begin
            //bigEndian
            dataMem[Address] <= WriteData[15:8];
            dataMem[Address+1] <= WriteData[7:0];
           end
end

always@(negedge Clock)
begin
$writememb("DataMemory.mem", dataMem);
end


assign ReadData = {dMem[Address],dMem[Address+1]};


endmodule