// Testbench da Semana 03

module tb_minisoc_aes_w03;

    // ---------------- Fios do teste de CIFRAGEM ----------------
    logic [127:0] enc_in;
    logic [127:0] enc_key;
    logic [127:0] after_sub;
    logic [127:0] after_shift;
    logic [127:0] after_mix;
    logic [127:0] after_add;

    // ---------------- Fios do teste de DECRIPTAÇÃO ----------------
    logic [127:0] dec_in;
    logic [127:0] dec_key;
    logic [127:0] after_inv_shift;
    logic [127:0] after_inv_sub;
    logic [127:0] after_inv_add;
    logic [127:0] after_inv_mix;

    int erros = 0;

    // ---------------- Módulos de CIFRAGEM (um ligado no outro) ----------------
    minisoc_aes_sub_bytes u_sub_bytes (
        .state_i (enc_in),
        .state_o (after_sub)
    );

    minisoc_aes_shift_rows u_shift_rows (
        .state_i (after_sub),
        .state_o (after_shift)
    );

    minisoc_aes_mix_columns u_mix_columns (
        .state_i (after_shift),
        .state_o (after_mix)
    );

    minisoc_aes_add_round_key u_add_round_key (
        .state_i     (after_mix),
        .round_key_i (enc_key),
        .state_o     (after_add)
    );

    // ---------------- Módulos de DECRIPTAÇÃO (um ligado no outro) ----------------
    minisoc_aes_inv_shift_rows u_inv_shift_rows (
        .state_i (dec_in),
        .state_o (after_inv_shift)
    );

    minisoc_aes_inv_sub_bytes u_inv_sub_bytes (
        .state_i (after_inv_shift),
        .state_o (after_inv_sub)
    );

    minisoc_aes_add_round_key u_inv_add_round_key (
        .state_i     (after_inv_sub),
        .round_key_i (dec_key),
        .state_o     (after_inv_add)
    );

    minisoc_aes_inv_mix_columns u_inv_mix_columns (
        .state_i (after_inv_add),
        .state_o (after_inv_mix)
    );

    // ---------------- Início dos Testes ----------------
    initial begin
        $display("\n[TESTE 1] Cifragem - FIPS-197 Apendice B (Rodada 1)");

        enc_in  = 128'h193de3bea0f4e22b9ac68d2ae9f84808; 
        enc_key = 128'ha0fafe1788542cb123a339392a6c7605; 

        #10 if (after_sub === 128'hd42711aee0bf98f1b8b45de51e415230)
            $display("  [PASS] SubBytes OK");
        else begin
            $display("  [FAIL] SubBytes: saiu %h", after_sub);
            erros++;
        end

        if (after_shift === 128'hd4bf5d30e0b452aeb84111f11e2798e5)
            $display("  [PASS] ShiftRows OK");
        else begin
            $display("  [FAIL] ShiftRows: saiu %h", after_shift);
            erros++;
        end

        if (after_mix === 128'h046681e5e0cb199a48f8d37a2806264c)
            $display("  [PASS] MixColumns OK");
        else begin
            $display("  [FAIL] MixColumns: saiu %h", after_mix);
            erros++;
        end

        if (after_add === 128'ha49c7ff2689f352b6b5bea43026a5049)
            $display("  [PASS] AddRoundKey OK");
        else begin
            $display("  [FAIL] AddRoundKey: saiu %h", after_add);
            erros++;
        end

        $display("\n[TESTE 2] Decriptacao - FIPS-197 Apendice C.1 (Rodada Inversa 1)");

        dec_in  = 128'h7ad5fda789ef4e272bca100b3d9ff59f; 
        dec_key = 128'h549932d1f08557681093ed9cbe2c974e;

        #10 if (after_inv_shift === 128'h7a9f102789d5f50b2beffd9f3dca4ea7)
            $display("  [PASS] InvShiftRows OK");
        else begin
            $display("  [FAIL] InvShiftRows: saiu %h", after_inv_shift);
            erros++;
        end

        if (after_inv_sub === 128'hbd6e7c3df2b5779e0b61216e8b10b689)
            $display("  [PASS] InvSubBytes OK");
        else begin
            $display("  [FAIL] InvSubBytes: saiu %h", after_inv_sub);
            erros++;
        end

        if (after_inv_add === 128'he9f74eec023020f61bf2ccf2353c21c7)
            $display("  [PASS] AddRoundKey (Inversa) OK");
        else begin
            $display("  [FAIL] AddRoundKey (Inversa): saiu %h", after_inv_add);
            erros++;
        end

        if (after_inv_mix === 128'h54d990a16ba09ab596bbf40ea111702f)
            $display("  [PASS] InvMixColumns OK");
        else begin
            $display("  [FAIL] InvMixColumns: saiu %h", after_inv_mix);
            erros++;
        end

        if (erros == 0)
            $display("\n=== PASS: todos os testes da Semana 03 passaram ===\n");
        else
            $display("\n=== FAIL: %0d erro(s) ===\n", erros);

        $finish;
    end

    initial begin
        $fsdbDumpfile("waves.fsdb");
        $fsdbDumpvars(0, tb_minisoc_aes_w03);
    end

endmodule : tb_minisoc_aes_w03
