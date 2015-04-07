加法器模块：

module AdderAndSubber64(
    input [63:0] A,
    input [63:0] B,
    input mode,
    output [63:0] result,
    output SF,
    output CF,
    output OF,
    output PF,
    output ZF
    );

mode给1进行减法，给0进行加法
