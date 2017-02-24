module TopLeveltest11(out,Done,R1,R2,sel,clk,busy);
  output[15:0] out;
  output Done;
  input[7:0] R1,R2;
  input[2:0] sel;
  input clk;
  output busy;
  wire[15:0] outAdd,outSub,outR1,outcomp,outand,outOr,outXor,prod;
  assign outAdd[15:9]=0;
  copyR1 R11(outR1[15:0],Done,R1[7:0],clk);
  complement comR1(outcomp[15:0],Done,R1[7:0],clk);
  AndR1R2 R12(outand[15:0],R1[7:0],R2[7:0]);
  OrR1R2 R13(outOr[15:0],R1[7:0],R2[7:0]);
  XorR1R2 R14(outXor[15:0],R1[7:0],R2[7:0]);
  cla_8Bit Add_CLA(outAdd[7:0],outAdd[8],R1,R2,1'b0);
  cla_8Bit Sub_CLA(outSub[15:0], ,R1,R2,1'b1);
  multiplier MR1R2(prod[15:0], busy, R1[7:0], R2[7:0], clk);
  mux mainMux(outR1,outcomp,outand,outOr,outXor,outAdd,outSub,prod,sel,out);

endmodule

module mux (a,b,c,d,e,f,g,h,sel,y1); 
  input[15:0] a, b, c, d, e, f, g, h; 
   input [2:0] sel; 
   output[15:0] y1;
   reg[15:0] y1;
   always @ (a or b or c or d or e or f or g or h or sel)
     case (sel) 
       0 : y1 = a; 
       1 : y1 = b; 
       2 : y1 = c; 
       3 : y1 = d; 
       4 : y1 = e;
       5 : y1 = f;
       6 : y1 = g;
       7 : y1 = h;
       default : $display("hii"); 
     endcase
//assign y=y1;
endmodule

module copyR1(outR1,Done,R1,clk);
input clk;
output Done;
reg Done=0;
input [7:0]R1;
output outR1;
reg [15:0]outR1;
always @(posedge clk)
begin
    outR1=R1;
    Done=1'b1;
end
endmodule

module complement(outcomp,Done,R1,clk);
  input [7:0] R1;
  input clk;
  output outcomp;
  reg [15:0] outcomp;
  output Done;
  reg Done = 0;
  always @(posedge clk)
    begin
      outcomp[0]= ~R1[0];
      outcomp[1]= ~R1[2];
      outcomp[2]= ~R1[2];
      outcomp[3]= ~R1[3];
      outcomp[4]= ~R1[4];
      outcomp[5]= ~R1[5];
      outcomp[6]= ~R1[6];
      outcomp[7]= ~R1[7];
      outcomp[15:8]= 0;
      Done= 1;
    end
endmodule

module AndR1R2(outand,R1,R2);
input [7:0]R1,R2;
output [15:0]outand;
assign outand=R1&R2;
endmodule


module OrR1R2(outOr,R1,R2);
input [7:0]R1,R2;
output [15:0]outOr;
assign outOr=R1|R2;
endmodule

module XorR1R2(outXor,R1,R2);
input [7:0]R1,R2;
output [15:0]outXor;
assign outXor=R1^R2;
endmodule

module cla_8Bit(Sum, Cout, A, B, Cin);
  input [7:0] A,B;
  input Cin;
  output [15:0] Sum;
  assign Sum[15:8]=0;
  output Cout;
  wire[7:0] B_test;
  assign B_test = B ^ {8{Cin}};
  wire [15:0] Sum;
  wire carry;
  CLA_4bit CLA0(.S(Sum[3:0]),.Cout(carry),.A(A[3:0]),.B(B_test[3:0]),.Cin(Cin));
  CLA_4bit CLA1 (.S(Sum[7:4]),.Cout(Cout),.A(A[7:4]),.B(B_test[7:4]),.Cin(carry));
endmodule

module CLA_4bit(output [3:0] S,output Cout, input [3:0] A,B, input Cin);
    wire [3:0] G,P,C;
    assign G = A & B;
    assign P = A ^ B;
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) |(P[3] & P[2] & P[1] & P[0] & C[0]);
    assign S = P ^ C;
endmodule

module multiplier(prod, busy, mc, mp, clk);
  output [15:0] prod;
  output busy;
  input [7:0] mc, mp;
  input clk;
  reg start=1;
  reg [7:0] A, Q, M;
  reg Q_1;
  reg [3:0] count;
  wire [7:0] sum, difference;
  always @(posedge clk)
    begin
      if (start) 
        begin
          A <= 8'b0;      
          M <= mc;
          Q <= mp;
          Q_1 <= 1'b0;      
          count <= 4'b0;
start<=0;
        end
      else 
        begin
          case ({Q[0], Q_1})
            2'b0_1 : {A, Q, Q_1} <= {sum[7], sum, Q};
            2'b1_0 : {A, Q, Q_1} <= {difference[7], difference, Q};
            default: {A, Q, Q_1} <= {A[7], A, Q};
          endcase
          count <= count + 1'b1;
        end
    end
  alu adder (sum, A, M, 1'b0);
  alu subtracter (difference, A, ~M, 1'b1);
  assign prod = {A,Q};
  assign busy = (count < 8);
endmodule

module alu(out, a, b, cin);
  output [7:0] out;
  input [7:0] a;
  input [7:0] b;
  input cin;
  assign out = a + b + cin;
endmodule