// SubBytes do AES.

module minisoc_aes_sub_bytes (
    input  logic [127:0] state_i,   // estado de entrada
    output logic [127:0] state_o    // estado de saída (cada byte trocado pela S-box)
);

    // Repete 16 vezes (i = 0 até 15), criando uma S-box para cada byte.
    for (genvar i = 0; i < 16; i++) begin : g_sbox
        // Posição do byte i: o byte 0 fica no topo, então contamos de cima para baixo.
        localparam int TOPO = 127 - 8*i;

        minisoc_aes_sbox u_sbox (
            .data_i (state_i[TOPO -: 8]),   // pega 8 bits a partir de TOPO
            .data_o (state_o[TOPO -: 8])
        );
    end

endmodule : minisoc_aes_sub_bytes
