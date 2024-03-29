
module mux2ne1(
    input Hyrja0,
    input Hyrja1,
    input S,
    output Dalja
    );
    
    assign Dalja = S ? Hyrja1 : Hyrja0;
endmodule

module Mbledhesi(
	input A,
	input B,
	input CarryIn,
	output SUM,
	output CarryOut
);

assign SUM = CarryIn ^ A ^ B;
assign CarryOut = CarryIn & A | CarryIn & B | A & B ;    

endmodule


module mux8ne1(
    input h0,
    input h1,
    input h2,
    input h3,
    input h5,
    input h6,
    input h7,
    input h8,
    input [2:0] S,
    output Dalja
    );
    
//    s 0 000 h0  AND
//    s 0 001 h1  SLTI
//    s 0 010 h2  OR
//    s 0 011 h3  XOR
//    s 1 100 h4  SUB
//    s 0 100 h5  ADD
//    s 0 101 h6  ADDI
//    s 0 111 h7  sra
//    s 0 110 h8  sll

    assign Dalja = S[2] ? (S[1] ? (S[0] ? h7 : h8) : (S[0] ? h6 : h5)) : (S[1] ? (S[0] ? h3 : h2): (S[0] ? h1 : h0));

endmodule


module ALU1(
    input A,
    input B,
    input CIN,
    input Bnegate,
    input Less,
  input [2:0] Op,
    output Result,
    output CarryOut
    );
  
    
   wire JoA, JoB, mB, And, Or, AddnSub, Xor, Addi,Sra, Sll, Slti;//telat edhe per instruksione tjera
    
assign JoB = ~B;
assign JoA = ~A;

mux2ne1 muxB(B, JoB, Bnegate, mB);

assign And = A & mB;

assign Or = A | mB;
 
assign Xor = (JoA & B) | (A & JoB); // Xor = A ^ mB


//assign AddnSub = A + mB;

Mbledhesi m (A, mB, CIN, AddnSub, CarryOut);  

mux8ne1 muxAlu(And, Slti, Or, Xor, AddnSub, Addi, Sra, Sll, Op, Result); //mux8ne1

endmodule


module ALU16(
  input [15:0] A,
  input [15:0] B,
    input BNegate,
  input [2:0] Op,
    output Zero,
  output [15:0] Result,
    output Overflow,
    output CarryOut
    );
    
  wire [14:0] COUT;

    //LIDH 16 ALU 1-biteshe

  ALU1 ALU0(A[0], B[0], BNegate, BNegate, Result[15], Op, Result[0], COUT[0]);
    ALU1 ALU1(A[1], B[1], COUT[0], BNegate, 0, Op, Result[1], COUT[1]);
    ALU1 ALU2(A[2], B[2], COUT[1], BNegate, 0, Op, Result[2], COUT[2]);
	ALU1 ALU3(A[3], B[3], COUT[2], BNegate, 0, Op, Result[3], COUT[3]);
    ALU1 ALU4(A[4], B[4], COUT[3], BNegate, 0, Op, Result[4], COUT[4]);
    ALU1 ALU5(A[5], B[5], COUT[4], BNegate, 0, Op, Result[5], COUT[5]);
    ALU1 ALU6(A[6], B[6], COUT[5], BNegate, 0, Op, Result[6], COUT[6]);
    ALU1 ALU7(A[7], B[7], COUT[6],  BNegate, 0, Op, Result[7], COUT[7]);
    ALU1 ALU8(A[8], B[8], COUT[7], BNegate, 0, Op, Result[8], COUT[8]);
    ALU1 ALU9(A[9], B[9], COUT[8],  BNegate, 0, Op, Result[9], COUT[9]);
    ALU1 ALU10(A[10], B[10], COUT[9], BNegate, 0, Op, Result[10], COUT[10]);
    ALU1 ALU11(A[11], B[11], COUT[10], BNegate, 0, Op, Result[11], COUT[11]);
    ALU1 ALU12(A[12], B[12], COUT[11], BNegate, 0, Op, Result[12], COUT[12]);
    ALU1 ALU13(A[13], B[13], COUT[12], BNegate, 0, Op, Result[13], COUT[13]);
    ALU1 ALU14(A[14], B[14], COUT[13], BNegate, 0, Op, Result[14], COUT[14]);
  ALU1 ALU15(A[15], B[15], COUT[14], BNegate, 0, Op, Result[15], CarryOut);
    
assign Zero = ~(Result[0] | Result[1] | 
                Result[2] | Result[3] | 
                Result[4] | Result[5] | 
                Result[6] | Result[7] | 
                Result[8] | Result[9] | 
                Result[10] | Result[11] | 
                Result[12] | Result[13] | 
                Result[14] | Result[15]); 
                    
  assign Overflow = COUT[14] ^ CarryOut;
    
    
endmodule




module ALUControl(
input [1:0] ALUOp,
input [1:0] Funct,
input [3:0] opcode,
output reg [3:0] ALUCtrl
);

always @(ALUOp)
begin
case(ALUOp) // Pyet per vleren e ALUOp, 00-lw,sw; 01-beq,bne, 10-R-format, 11 - I-format

    2'b00: ALUCtrl = 4'b0100; //LW+SW (mbledhje)
    2'b01: ALUCtrl = 4'b1100; //BEQ+BNE (zbritje)

    2'b10: //sipas FUNCT
        case(Funct)
            2'b00: 
                  case(opcode)
                  4'b0000: ALUCtrl =4'b0000; //AND
                  4'b0001: ALUCtrl = 4'b0100; //ADD
                  endcase

            2'b10: ALUCtrl = 4'b0011; //XOR

            2'b00: ALUCtrl = 4'b0100; //ADD

            2'b01:
                  case(opcode)
                  4'b0001: ALUCtrl = 4'b1100; //SUB
                  4'b0000: ALUCtrl = 4'b0010; //OR
                  endcase
        endcase

    2'b11: //Sipas OPCODE
        case(opcode)
            4'b1001: ALUCtrl = 4'b0101; // ADDI
            4'b1010: ALUCtrl = 4'b1101; //SUBI
            4'b1011: ALUCtrl = 4'b0001; //SLTI
        endcase

endcase
end



endmodule

module DataMemory(
input wire[25:10] Address,
input wire[15:0] WriteData,
input wire MemWrite,
input wire MemRead,
input wire Clock,
output wire[15:0] ReadData
);

reg[7:0] dataMem[0:127];

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


  assign ReadData = {dataMem[Address],dataMem[Address+1]};


endmodule


module InstructionMemory(
input wire[25:10] PCAddress,
output wire[15:0] Instruction);

reg[7:0] instrMem[0:127];

initial
  $readmemb("InstructionMemory.mem", instrMem);

assign Instruction = {instrMem[PCAddress], instrMem[PCAddress+1]};


endmodule


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
     Register[RD] <= WriteData;
     end
end

//lexo regjistrat ReadData1, ReadData2
assign ReadRS = Register[RS];
assign ReadRT = Register[RT];


endmodule


module Datapath(
input Clock, //HYRJE NGA CPU - TELI CPU_IN_1
input RegDst, Branch, MemRead, 
MemWrite, RegWrite, MemToReg, ALUSrc,
input [1:0] ALUOp,
output [3:0] opcode
);


reg[15:0] pc_initial; 
  wire [15:0] pc_next, pc2, pcbeq; 
wire [15:0] instruction; 
wire [1:0] mux_regfile; 
wire[15:0] readData1, readData2, writeData, 
mux_ALU, ALU_Out, Zgjerimi, memToMux,
shifter1beq, branchAdderToMux, beqAddress; 
  wire[3:0] ALUCtrl; 
wire zerof, overflow, carryout; 
wire andMuxBranch; 

initial
begin
    pc_initial = 16'd10; //inicializimi fillestar i PC ne adresen 10
end

always@(posedge Clock)
begin
    pc_initial <= pc_next; //azhurimi i PC ne cdo teh pozitiv me adresen e ardhshme
    
end

//T2 - PC rritet per 2 (ne sistemet 16 biteshe) per te gjitha instruksionet pervec BEQ, BNE
assign pc2 = pc_initial + 2; 

//T6 - Percaktimi nese RD eshte RD (te R-formati) apo RD = RT (te I-formati) - MUX M1 ne foto
assign mux_regfile = (RegDst == 1'b1) ? instruction[7:6] : instruction[9:8]; 

//T14 - pergatitja e adreses per kercim ne BEQ (1 bit shtyrje majtas) 
assign shifter1beq = {{8{instruction[7]}}, instruction[7:0], 1'b0};  

// T12 - Zgjerimi nga 8 ne 16 bit - 8 bit si MSB dhe pjesa e instruction[7:0] - S1 ne foto
assign Zgjerimi = {{8{instruction[7]}}, instruction[7:0]};  

//Instr mem //inicializimi i IM (PC adresa hyrje, teli instruction dajle)
InstructionMemory IM(pc_initial, instruction); 

//REGFILE
//inicializimi i RF(RS, RT, T6 (RD[RD=RD || RD=RT]), T9, CU_OUT_x, CPU_IN_1, T7, T8)
RegisterFile RF(instruction[11:10], instruction[9:8], mux_regfile, writeData, RegWrite, Clock, readData1, readData2 ); 

// T10 - Percaktimi nese hyrja e MUX-it M2 para ALU eshte Regjstri 2 i RF apo vlera imediate e instruksionit 
assign mux_ALU = (ALUSrc == 1'b1) ? Zgjerimi : readData2; 

//inicializimi i ALU Control (CU_OUT_x, Function Code nga R-formati, Opcode, T19)
  ALUControl AC(ALUOp, instruction[1:0], instruction[15:12], ALUCtrl); 

//inicializimi i ALU (T7, T10, T19[3], T19[2], T19[1:0], T20, T11, T21, T22)
  ALU16 ALU(readData1, mux_ALU, ALUCtrl[3], ALUCtrl[2:0], zerof, ALU_Out, overflow, carryout);

//inicializimi i Data Memory (T11, T8, CU_OUT_x, CU_OUT_x, CPU_IN_1, T13) 
DataMemory DM(ALU_Out, readData2, MemWrite, MemRead, Clock, memToMux);

//T9 - Teli qe i dergon te dhenat nga MUX - M3 ne Regfile
assign writeData = (MemToReg == 1'b1) ? memToMux : ALU_Out;

//T23 - Teli qe del nga porta DHE ne pjesen e eperme te fotos (shikon nese plotesohet kushti per BEQ
assign andMuxBranch = zerof & Branch;

//T17, Teli qe mban adresen ne te cilen do te kercej programi kur kushti BEQ plotesohet
assign beqAddress = pc2 + shifter1beq; 

//T3 - Teli qe del nga Mux M4 ne foto qe kontrollon nese kemi BEQ apo PC+2
assign pcbeq = (andMuxBranch == 1'b1) ? beqAddress : pc2;

//Teli D_OUT_1 qe i dergohet CU
assign opcode = instruction[15:12];

endmodule



module CU(
  input [3:0] opcode, //HYRJA NGA D_OUT_1
  input [1:0] Funct,
    output reg RegDst, //DALJET E CU, CU_OUT_x
    output reg Branch,
    output reg MemRead,
    output reg MemToReg,
    output reg[1:0] AluOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
    );
    
    
  always @ (opcode)
begin
  case(opcode)
4'b0000:     //and 
  case(Funct)
    2'b00:
    begin
    RegDst = 1;
    ALUSrc = 0;
    MemToReg = 0;
    RegWrite = 1;
    MemRead = 0;
    MemWrite = 0;
    Branch=0;
    AluOp[1] = 1;
    AluOp[0] = 0;
    end 
    endcase
    
 
   4'b0000:
     case(Funct)  //or 
    2'b01:
    begin
    RegDst = 1;
    ALUSrc = 0;
    MemToReg = 0;
    RegWrite = 1;
    MemRead = 0;
    MemWrite = 0;
    Branch=0;
    AluOp[1] = 1;
    AluOp[0] = 0;
    end 
       endcase
       
   4'b0000:
     case(Funct)  //xor 
    2'b10:
    begin
    RegDst = 1;
    ALUSrc = 0;
    MemToReg = 0;
    RegWrite = 1;
    MemRead = 0;
    MemWrite = 0;
    Branch=0;
    AluOp[1] = 1;
    AluOp[0] = 0;
    end 
       endcase
    
             
     4'b0001:
       case(Funct)  //add
    2'b00:
    begin
    RegDst = 1;
    ALUSrc = 0;
    MemToReg = 0;
    RegWrite = 1;
    MemRead = 0;
    MemWrite = 0;
    Branch=0;
    AluOp[1] = 1;
      AluOp[0] = 0;
    end 
   endcase
         
    4'b0001:
      case(Funct)  //sub
    2'b01:
    begin
    RegDst = 1;
    ALUSrc = 0;
    MemToReg = 0;
    RegWrite = 1;
    MemRead = 0;
    MemWrite = 0;
    Branch=0;
    AluOp[1] = 1;
      AluOp[0] = 0;
    end
      endcase
         
   4'b1001: //i formati addi
    begin
    RegDst = 0;
    ALUSrc = 1;
    MemToReg = 0;
    RegWrite = 1;
    MemRead = 0;
    MemWrite = 0;
    Branch=0;
    AluOp[1] = 1;
    AluOp[0] = 1;
    end 
         
           4'b1010: //i formati subi
    begin
    RegDst = 0;
    ALUSrc = 1;
    MemToReg = 0;
    RegWrite = 1;
    MemRead = 0;
    MemWrite = 0;
    Branch=0;
    AluOp[1] = 1;
    AluOp[0] = 1;
    end 

                   4'b1011: //i formati slti
    begin
    RegDst = 0;
    ALUSrc = 1;
    MemToReg = 0;
    RegWrite = 1;
    MemRead = 0;
    MemWrite = 0;
    Branch=0;
    AluOp[1] = 1;
    AluOp[0] = 1;
    end 
                   4'b1100: //i formati lw
    begin
    RegDst = 0;
    ALUSrc = 1;
    MemToReg = 1;
    RegWrite = 1;
    MemRead = 1;
    MemWrite = 0;
    Branch=0;
      AluOp[1] = 0;
      AluOp[0] = 0;
    end 
         
    4'b1101: //i formati sw
    begin
    RegDst = 0;
    ALUSrc = 1;
    MemToReg = 0;
    RegWrite = 0;
    MemRead = 0;
    MemWrite = 1;
    Branch=0;
      AluOp[1] = 0;
      AluOp[0] = 0;
    end 
         
    4'b1111: //i formati beq
    begin
    RegDst = 0;
    ALUSrc = 0;
    MemToReg = 0;
    RegWrite = 0;
    MemRead = 0;
    MemWrite = 0;
    Branch=1;
      AluOp[1] = 0;
      AluOp[0] = 1;
    end 

              

endcase

end

endmodule


module CPU(input Clock);

//TELAT E BRENDSHEM TE CPU, SHIH CPU.PDF
  wire [3:0] opcode; //D_OUT_1
  wire [1:0] Funct;
//CU_OUT_x
wire RegDst, Branch, MemRead, MemWrite, RegWrite, MemToReg, ALUSrc;
wire [1:0] ALUOp;

//inicializimi i Datapath    
Datapath DP
( Clock, //HYRJE NGA CPU - TELI CPU_IN_1
 RegDst, Branch, MemRead, 
MemWrite, RegWrite, MemToReg, ALUSrc, ALUOp, opcode
);

//Inicializimi i COntrol Unit
  CU ControlUnit( opcode, Funct,
    RegDst, //DALJET E CU, CU_OUT_x
     Branch,
    MemRead,
     MemToReg,
    ALUOp,
    MemWrite,
    ALUSrc,
  RegWrite
);

endmodule