// Testbench da Semana 02 (autoverificável: ele mesmo diz PASS ou FAIL).

module tb_minisoc_aes_w02;

    logic [7:0]   sbox_in;
    logic [7:0]   sbox_out;

    logic [127:0] state_in;        
    logic [127:0] after_sub;       
    logic [127:0] after_shift;    

    int erros = 0;                 

    minisoc_aes_sbox u_sbox (
        .data_i (sbox_in),
        .data_o (sbox_out)
    );

    minisoc_aes_sub_bytes u_sub_bytes (
        .state_i (state_in),
        .state_o (after_sub)
    );

    minisoc_aes_shift_rows u_shift_rows (
        .state_i (after_sub),
        .state_o (after_shift)
    );

    // ---------------- Tabela de referência da S-box ----------------
    localparam logic [7:0] ESPERADO [0:255] = '{
        8'h63, 8'h7c, 8'h77, 8'h7b, 8'hf2, 8'h6b, 8'h6f, 8'hc5, 8'h30, 8'h01, 8'h67, 8'h2b, 8'hfe, 8'hd7, 8'hab, 8'h76,
        8'hca, 8'h82, 8'hc9, 8'h7d, 8'hfa, 8'h59, 8'h47, 8'hf0, 8'had, 8'hd4, 8'ha2, 8'haf, 8'h9c, 8'ha4, 8'h72, 8'hc0,
        8'hb7, 8'hfd, 8'h93, 8'h26, 8'h36, 8'h3f, 8'hf7, 8'hcc, 8'h34, 8'ha5, 8'he5, 8'hf1, 8'h71, 8'hd8, 8'h31, 8'h15,
        8'h04, 8'hc7, 8'h23, 8'hc3, 8'h18, 8'h96, 8'h05, 8'h9a, 8'h07, 8'h12, 8'h80, 8'he2, 8'heb, 8'h27, 8'hb2, 8'h75,
        8'h09, 8'h83, 8'h2c, 8'h1a, 8'h1b, 8'h6e, 8'h5a, 8'ha0, 8'h52, 8'h3b, 8'hd6, 8'hb3, 8'h29, 8'he3, 8'h2f, 8'h84,
        8'h53, 8'hd1, 8'h00, 8'hed, 8'h20, 8'hfc, 8'hb1, 8'h5b, 8'h6a, 8'hcb, 8'hbe, 8'h39, 8'h4a, 8'h4c, 8'h58, 8'hcf,
        8'hd0, 8'hef, 8'haa, 8'hfb, 8'h43, 8'h4d, 8'h33, 8'h85, 8'h45, 8'hf9, 8'h02, 8'h7f, 8'h50, 8'h3c, 8'h9f, 8'ha8,
        8'h51, 8'ha3, 8'h40, 8'h8f, 8'h92, 8'h9d, 8'h38, 8'hf5, 8'hbc, 8'hb6, 8'hda, 8'h21, 8'h10, 8'hff, 8'hf3, 8'hd2,
        8'hcd, 8'h0c, 8'h13, 8'hec, 8'h5f, 8'h97, 8'h44, 8'h17, 8'hc4, 8'ha7, 8'h7e, 8'h3d, 8'h64, 8'h5d, 8'h19, 8'h73,
        8'h60, 8'h81, 8'h4f, 8'hdc, 8'h22, 8'h2a, 8'h90, 8'h88, 8'h46, 8'hee, 8'hb8, 8'h14, 8'hde, 8'h5e, 8'h0b, 8'hdb,
        8'he0, 8'h32, 8'h3a, 8'h0a, 8'h49, 8'h06, 8'h24, 8'h5c, 8'hc2, 8'hd3, 8'hac, 8'h62, 8'h91, 8'h95, 8'he4, 8'h79,
        8'he7, 8'hc8, 8'h37, 8'h6d, 8'h8d, 8'hd5, 8'h4e, 8'ha9, 8'h6c, 8'h56, 8'hf4, 8'hea, 8'h65, 8'h7a, 8'hae, 8'h08,
        8'hba, 8'h78, 8'h25, 8'h2e, 8'h1c, 8'ha6, 8'hb4, 8'hc6, 8'he8, 8'hdd, 8'h74, 8'h1f, 8'h4b, 8'hbd, 8'h8b, 8'h8a,
        8'h70, 8'h3e, 8'hb5, 8'h66, 8'h48, 8'h03, 8'hf6, 8'h0e, 8'h61, 8'h35, 8'h57, 8'hb9, 8'h86, 8'hc1, 8'h1d, 8'h9e,
        8'he1, 8'hf8, 8'h98, 8'h11, 8'h69, 8'hd9, 8'h8e, 8'h94, 8'h9b, 8'h1e, 8'h87, 8'he9, 8'hce, 8'h55, 8'h28, 8'hdf,
        8'h8c, 8'ha1, 8'h89, 8'h0d, 8'hbf, 8'he6, 8'h42, 8'h68, 8'h41, 8'h99, 8'h2d, 8'h0f, 8'hb0, 8'h54, 8'hbb, 8'h16
    };

    task automatic testa_rodada(
        input int           rodada,
        input logic [127:0] start,
        input logic [127:0] esperado_sub,
        input logic [127:0] esperado_shift
    );
        state_in = start;

        #1 if (after_sub !== esperado_sub) begin
            $display("  [FAIL] Rodada %0d SubBytes: obtido=%h esperado=%h", rodada, after_sub, esperado_sub);
            erros++;
        end
        if (after_shift !== esperado_shift) begin
            $display("  [FAIL] Rodada %0d ShiftRows: obtido=%h esperado=%h", rodada, after_shift, esperado_shift);
            erros++;
        end
        if (after_sub === esperado_sub && after_shift === esperado_shift)
            $display("  [PASS] Rodada %0d OK", rodada);
    endtask

    initial begin
        $display("\n[TESTE 1] S-box: 256 entradas");
        for (int i = 0; i < 256; i++) begin
            sbox_in = i[7:0];
            #1 if (sbox_out !== ESPERADO[i]) begin
                $display("  [FAIL] sbox(%h) = %h, esperado %h", i[7:0], sbox_out, ESPERADO[i]);
                erros++;
            end
        end
        if (erros == 0) $display("  [PASS] As 256 entradas conferem");

        $display("\n[TESTE 2] SubBytes e ShiftRows (FIPS-197 Apendice B)");

        testa_rodada(1,  128'h193de3bea0f4e22b9ac68d2ae9f84808, 128'hd42711aee0bf98f1b8b45de51e415230, 128'hd4bf5d30e0b452aeb84111f11e2798e5);
        testa_rodada(10, 128'heb40f21e592e38848ba113e71bc342d2, 128'he9098972cb31075f3d327d94af2e2cb5, 128'he9317db5cb322c723d2e895faf090794);

        if (erros == 0) $display("\n=== PASS: todos os testes passaram ===\n");
        else            $display("\n=== FAIL: %0d erro(s) ===\n", erros);

        $finish;
    end

    initial begin
        $fsdbDumpfile("waves.fsdb");
        $fsdbDumpvars(0, tb_minisoc_aes_w02);
    end

endmodule : tb_minisoc_aes_w02
