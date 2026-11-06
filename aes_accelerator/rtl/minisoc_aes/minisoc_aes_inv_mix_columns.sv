// faz o inverso do MixColumns.
// Em vez de multiplicar cada coluna por 2 e 3, multiplica por 9, 11, 13 e 14.

module minisoc_aes_inv_mix_columns (
    input  logic [127:0] state_i,
    output logic [127:0] state_o
);

    logic [7:0] b0, b1, b2,  b3,  b4,  b5,  b6,  b7;
    logic [7:0] b8, b9, b10, b11, b12, b13, b14, b15;

    assign {b0, b1, b2,  b3,  b4,  b5,  b6,  b7,
            b8, b9, b10, b11, b12, b13, b14, b15} = state_i;

    logic [7:0] m0, m1, m2,  m3,  m4,  m5,  m6,  m7;
    logic [7:0] m8, m9, m10, m11, m12, m13, m14, m15;

    function automatic logic [7:0] mult2(input logic [7:0] x);
        if (x[7] == 1'b1)
            return (x << 1) ^ 8'h1b;
        else
            return (x << 1);
    endfunction

    function automatic logic [7:0] mult4(input logic [7:0] x);
        return mult2(mult2(x));
    endfunction

    function automatic logic [7:0] mult8(input logic [7:0] x);
        return mult2(mult4(x));
    endfunction

    function automatic logic [7:0] mult9(input logic [7:0] x);
        return mult8(x) ^ x;
    endfunction

    function automatic logic [7:0] mult11(input logic [7:0] x);
        return mult8(x) ^ mult2(x) ^ x;
    endfunction

    function automatic logic [7:0] mult13(input logic [7:0] x);
        return mult8(x) ^ mult4(x) ^ x;
    endfunction

    function automatic logic [7:0] mult14(input logic [7:0] x);
        return mult8(x) ^ mult4(x) ^ mult2(x);
    endfunction

    always_comb begin
        m0  = mult14(b0) ^ mult11(b1) ^ mult13(b2) ^ mult9(b3);
        m1  = mult9(b0)  ^ mult14(b1) ^ mult11(b2) ^ mult13(b3);
        m2  = mult13(b0) ^ mult9(b1)  ^ mult14(b2) ^ mult11(b3);
        m3  = mult11(b0) ^ mult13(b1) ^ mult9(b2)  ^ mult14(b3);

        m4  = mult14(b4) ^ mult11(b5) ^ mult13(b6) ^ mult9(b7);
        m5  = mult9(b4)  ^ mult14(b5) ^ mult11(b6) ^ mult13(b7);
        m6  = mult13(b4) ^ mult9(b5)  ^ mult14(b6) ^ mult11(b7);
        m7  = mult11(b4) ^ mult13(b5) ^ mult9(b6)  ^ mult14(b7);

        m8  = mult14(b8) ^ mult11(b9) ^ mult13(b10) ^ mult9(b11);
        m9  = mult9(b8)  ^ mult14(b9) ^ mult11(b10) ^ mult13(b11);
        m10 = mult13(b8) ^ mult9(b9)  ^ mult14(b10) ^ mult11(b11);
        m11 = mult11(b8) ^ mult13(b9) ^ mult9(b10)  ^ mult14(b11);

        m12 = mult14(b12) ^ mult11(b13) ^ mult13(b14) ^ mult9(b15);
        m13 = mult9(b12)  ^ mult14(b13) ^ mult11(b14) ^ mult13(b15);
        m14 = mult13(b12) ^ mult9(b13)  ^ mult14(b14) ^ mult11(b15);
        m15 = mult11(b12) ^ mult13(b13) ^ mult9(b14)  ^ mult14(b15);
    end

    assign state_o = {m0, m1, m2,  m3,  m4,  m5,  m6,  m7,
                      m8, m9, m10, m11, m12, m13, m14, m15};

endmodule : minisoc_aes_inv_mix_columns
