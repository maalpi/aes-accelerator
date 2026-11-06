// MixColumns do AES (FIPS-197, seção 5.1.3).
// Ideia: pega os 16 bytes (4 colunas de 4 bytes) e mistura cada coluna.

module minisoc_aes_mix_columns (
    input  logic [127:0] state_i,
    output logic [127:0] state_o
);

    // 1. Separa a entrada nos 16 bytes
    logic [7:0] b0, b1, b2,  b3,  b4,  b5,  b6,  b7;
    logic [7:0] b8, b9, b10, b11, b12, b13, b14, b15;

    assign {b0, b1, b2,  b3,  b4,  b5,  b6,  b7,
            b8, b9, b10, b11, b12, b13, b14, b15} = state_i;

    // 2. Bytes de saída depois da mistura
    logic [7:0] m0, m1, m2,  m3,  m4,  m5,  m6,  m7;
    logic [7:0] m8, m9, m10, m11, m12, m13, m14, m15;

    function automatic logic [7:0] mult2(input logic [7:0] x);
        if (x[7] == 1'b1)
            return (x << 1) ^ 8'h1b;
        else
            return (x << 1);
    endfunction

    function automatic logic [7:0] mult3(input logic [7:0] x);
        return mult2(x) ^ x;
    endfunction

    always_comb begin
        m0  = mult2(b0) ^ mult3(b1) ^ b2        ^ b3;
        m1  = b0        ^ mult2(b1) ^ mult3(b2) ^ b3;
        m2  = b0        ^ b1        ^ mult2(b2) ^ mult3(b3);
        m3  = mult3(b0) ^ b1        ^ b2        ^ mult2(b3);

        m4  = mult2(b4) ^ mult3(b5) ^ b6        ^ b7;
        m5  = b4        ^ mult2(b5) ^ mult3(b6) ^ b7;
        m6  = b4        ^ b5        ^ mult2(b6) ^ mult3(b7);
        m7  = mult3(b4) ^ b5        ^ b6        ^ mult2(b7);

        m8  = mult2(b8) ^ mult3(b9) ^ b10        ^ b11;
        m9  = b8        ^ mult2(b9) ^ mult3(b10) ^ b11;
        m10 = b8        ^ b9        ^ mult2(b10) ^ mult3(b11);
        m11 = mult3(b8) ^ b9        ^ b10        ^ mult2(b11);

        m12 = mult2(b12) ^ mult3(b13) ^ b14        ^ b15;
        m13 = b12        ^ mult2(b13) ^ mult3(b14) ^ b15;
        m14 = b12        ^ b13        ^ mult2(b14) ^ mult3(b15);
        m15 = mult3(b12) ^ b13        ^ b14        ^ mult2(b15);
    end

    assign state_o = {m0, m1, m2,  m3,  m4,  m5,  m6,  m7,
                      m8, m9, m10, m11, m12, m13, m14, m15};

endmodule : minisoc_aes_mix_columns
