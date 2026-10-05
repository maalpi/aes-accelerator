// ==============================================================================
// Módulo: aes_core
// Descrição: Datapath de processamento criptográfico AES (FIPS-197).
// Responsável por executar as transformações (SubBytes, ShiftRows, MixColumns,
// AddRoundKey) e a expansão de chaves para AES-128/192/256.
//
// NOTA DE DESENVOLVIMENTO:
// Módulo esqueleto da Semana 01. O algoritmo completo será desenvolvido na
// Semana 05. Apenas a casca de portas e registradores básicos estão definidos.
// ==============================================================================

module aes_core (
    input  logic                  clk,
    input  logic                  rst_n,

    // Controle de Operação
    input  logic                  start,
    input  aes_pkg::aes_key_size_t key_size,
    input  aes_pkg::aes_op_mode_t  op_mode,

    // Chave e Dados
    input  logic [255:0]          key_in,
    input  logic [127:0]          block_in,
    output logic [127:0]          block_out,

    // Handshake e Status
    output logic                  busy,
    output logic                  done,
    output aes_pkg::aes_status_t  status
);

    import aes_pkg::*;

    // TODO (Semana 05): FSM de rodadas, S-Box, ShiftRows, MixColumns, AddRoundKey
    assign block_out = '0;
    assign busy      = 1'b0;
    assign done      = 1'b0;
    assign status    = '0;

endmodule : aes_core
