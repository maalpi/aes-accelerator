// ShiftRows do AES.
// Não calcula nada: só troca os bytes de lugar (são só fios).

module minisoc_aes_shift_rows (
    input  logic [127:0] state_i,
    output logic [127:0] state_o
);

    logic [7:0] b0, b1, b2,  b3,  b4,  b5,  b6,  b7;
    logic [7:0] b8, b9, b10, b11, b12, b13, b14, b15;

    assign {b0, b1, b2,  b3,  b4,  b5,  b6,  b7,
            b8, b9, b10, b11, b12, b13, b14, b15} = state_i;

    assign state_o = {b0,  b5,  b10, b15,
                      b4,  b9,  b14, b3,
                      b8,  b13, b2,  b7,
                      b12, b1,  b6,  b11};

endmodule : minisoc_aes_shift_rows
