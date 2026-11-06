// Igualzinho ao SubBytes normal, mas passa cada um dos 16 bytes pela S-box Inversa (minisoc_aes_inv_sbox).

module minisoc_aes_inv_sub_bytes (
    input  logic [127:0] state_i,  
    output logic [127:0] state_o    
);

    for (genvar i = 0; i < 16; i++) begin : g_inv_sbox
        localparam int TOPO = 127 - 8*i;

        minisoc_aes_inv_sbox u_inv_sbox (
            .data_i (state_i[TOPO -: 8]),
            .data_o (state_o[TOPO -: 8])
        );
    end

endmodule : minisoc_aes_inv_sub_bytes

