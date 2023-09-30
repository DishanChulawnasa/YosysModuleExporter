/* Generated by Yosys 0.33+6 (git sha1 31ee566ec, x86_64-w64-mingw32-g++ 9.2.1 -Os) */

(* src = "counter.v:1.1-12.10" *)
module counter(clk, rst, en, count);
  wire _00_;
  wire _01_;
  wire _02_;
  wire _03_;
  wire _04_;
  wire _05_;
  wire _06_;
  wire _07_;
  wire _08_;
  wire _09_;
  wire _10_;
  wire _11_;
  wire _12_;
  wire _13_;
  wire _14_;
  wire _15_;
  wire _16_;
  (* src = "counter.v:3.10-3.13" *)
  input clk;
  wire clk;
  (* src = "counter.v:4.21-4.26" *)
  output [2:0] count;
  wire [2:0] count;
  (* src = "counter.v:3.20-3.22" *)
  input en;
  wire en;
  (* src = "counter.v:3.15-3.18" *)
  input rst;
  wire rst;
  NOT _17_ (
    .A(count[2]),
    .Y(_16_)
  );
  NOT _18_ (
    .A(count[1]),
    .Y(_03_)
  );
  NAND _19_ (
    .A(en),
    .B(count[0]),
    .Y(_04_)
  );
  NOT _20_ (
    .A(_04_),
    .Y(_05_)
  );
  NOR _21_ (
    .A(en),
    .B(count[0]),
    .Y(_06_)
  );
  NOT _22_ (
    .A(_06_),
    .Y(_07_)
  );
  NAND _23_ (
    .A(_04_),
    .B(_07_),
    .Y(_08_)
  );
  NOR _24_ (
    .A(rst),
    .B(_08_),
    .Y(_00_)
  );
  NOR _25_ (
    .A(_03_),
    .B(_04_),
    .Y(_09_)
  );
  NAND _26_ (
    .A(count[1]),
    .B(_05_),
    .Y(_10_)
  );
  NAND _27_ (
    .A(_03_),
    .B(_04_),
    .Y(_11_)
  );
  NAND _28_ (
    .A(_10_),
    .B(_11_),
    .Y(_12_)
  );
  NOR _29_ (
    .A(rst),
    .B(_12_),
    .Y(_01_)
  );
  NOR _30_ (
    .A(_16_),
    .B(_09_),
    .Y(_13_)
  );
  NOR _31_ (
    .A(count[2]),
    .B(_10_),
    .Y(_14_)
  );
  NOR _32_ (
    .A(_13_),
    .B(_14_),
    .Y(_15_)
  );
  NOR _33_ (
    .A(rst),
    .B(_15_),
    .Y(_02_)
  );
  (* src = "counter.v:6.4-10.32" *)
  DFF _34_ (
    .C(clk),
    .D(_00_),
    .Q(count[0])
  );
  (* src = "counter.v:6.4-10.32" *)
  DFF _35_ (
    .C(clk),
    .D(_01_),
    .Q(count[1])
  );
  (* src = "counter.v:6.4-10.32" *)
  DFF _36_ (
    .C(clk),
    .D(_02_),
    .Q(count[2])
  );
endmodule
