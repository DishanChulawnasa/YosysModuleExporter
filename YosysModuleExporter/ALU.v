module ALU(
  input [31:0] data1_i,
  input [31:0] data2_i,
  input [2:0] ALUCtrl_i,
  output reg [31:0] data_o,
  output reg Zero_o
);

  parameter SUM = 3'b001;
  parameter SUB = 3'b010;
  parameter AND = 3'b011;
  parameter OR  = 3'b100;
  parameter XOR = 3'b101;
  parameter MUL = 3'b110;

  /* implement here */
  always @* begin
    Zero_o = (data1_i == data2_i) ? 1 : 0;
    case (ALUCtrl_i)
      SUM: begin
        FullAdder32bit adder(.A(data1_i), .B(data2_i), .Cin(0), .Sum(data_o), .Cout());
      end
      SUB: begin
        data_o = data1_i - data2_i;
      end
      AND: begin
        data_o = data1_i & data2_i;
      end
      OR: begin
        data_o = data1_i | data2_i;
      end
      XOR: begin
        data_o = data1_i ^ data2_i;
      end
      MUL: begin
        data_o = data1_i * data2_i;
      end
      default: begin
        data_o = data1_i;
      end
    endcase
  end

endmodule

module FullAdder32bit(
  input [31:0] A,
  input [31:0] B,
  input Cin,
  output [31:0] Sum,
  output Cout
);
  
  wire [31:0] XOR_out, AND1_out, AND2_out;
  wire [31:0] Carry_out;

  // Generate XOR gates for each bit
  assign XOR_out = A ^ B;

  // Generate AND gates for each bit
  assign AND1_out = A & B;
  assign AND2_out[0] = XOR_out & Cin;

  // Generate carry chain
  assign Carry_out[0] = Cin;
  genvar i;
  generate
    for (i = 1; i < 32; i = i + 1) begin
      assign Carry_out[i] = AND1_out[i-1] | AND2_out[i-1];
      assign AND2_out[i] = XOR_out[i] & Carry_out[i];
    end
  endgenerate

  // Generate sum output
  assign Sum = XOR_out ^ Carry_out;

  // Generate Cout output
  assign Cout = AND1_out[31] | AND2_out[31];

endmodule