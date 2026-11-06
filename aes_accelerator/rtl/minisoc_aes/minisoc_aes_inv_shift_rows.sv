// Desfaz o ShiftRows: em vez de girar as linhas para a esquerda, gira para a DIREITA!

module minisoc_aes_inv_shift_rows (
    input  logic [127:0] state_i,
    output logic [127:0] state_o
);

    logic [7:0] b0, b1, b2,  b3,  b4,  b5,  b6,  b7;
    logic [7:0] b8, b9, b10, b11, b12, b13, b14, b15;

    assign {b0, b1, b2,  b3,  b4,  b5,  b6,  b7,
            b8, b9, b10, b11, b12, b13, b14, b15} = state_i;

    assign state_o = {b0,  b13, b10, b7,
                      b4,  b1,  b14, b11,
                      b8,  b5,  b2,  b15,
                      b12, b9,  b6,  b3};

endmodule : minisoc_aes_inv_shift_rows

