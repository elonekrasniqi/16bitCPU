
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
  
    
   wire JoA, JoB, mB, And, Or, AddnSub, Xor, Addi, Slti;//telat edhe per instruksione tjera
    
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

