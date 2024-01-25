
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
            4'b1010: ALUCtrl = 4'1101; //SUBI
            4'b1011: ALUCtrl = 4'0001; //SLTI
        endcase

endcase
end



endmodule
