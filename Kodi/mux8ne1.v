`timescale 1ns / 1ps

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