module RegisterFile(
input wire[1:0] RS,
input wire[1:0] RT,
input wire[1:0] RD,
input wire[15:0] WriteData,
input wire RegWrite,
input wire Clock,
output wire[15:0] ReadRS,
output wire[15:0] ReadRT
    );
    
reg[15:0] Register[3:0];
wire zero, r1, r2, r3;
assign zero  = Register[2'b00];
assign r1 = Register[2'b01];
assign r2 = Register[2'b10];
assign r3 = Register[2'b11];

//Shkruaj ne regjiter
always @(posedge Clock)
begin
  if(RegWrite)
     begin
     Registers[RD] <= WriteData;
     end
end

//lexo regjistrat ReadData1, ReadData2
assign ReadRS = Registers[RS];
assign ReadRT = Registers[RT];


endmodule