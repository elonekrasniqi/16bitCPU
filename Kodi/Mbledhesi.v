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