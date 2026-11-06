// AddRoundKey do AES (FIPS-197, seção 5.1.4).
// Ideia: é apenas um XOR (^) bit a bit entre o estado de 128 bits e a chave da rodada de 128 bits.
// Serve tanto para a cifragem quanto para a decriptação (pois o inverso do XOR é o próprio XOR).

module minisoc_aes_add_round_key (
    input  logic [127:0] state_i,      
    input  logic [127:0] round_key_i,   
    output logic [127:0] state_o        
);

    assign state_o = state_i ^ round_key_i;

endmodule : minisoc_aes_add_round_key

