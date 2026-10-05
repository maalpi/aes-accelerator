// ==============================================================================
// Pacote: aes_pkg
// Descrição: Definições de parâmetros globais, tipos de dados, opcodes de comando
// e estados do Acelerador AES com interface SPI.
//
// NOTA DE DESENVOLVIMENTO:
// Arquivo base inicial da Semana 01. Novos tipos e constantes serão adicionados
// ao longo das semanas de desenvolvimento do RTL.
// ==============================================================================

package aes_pkg;

    // --------------------------------------------------------------------------
    // Parâmetros Globais do Algoritmo AES (FIPS-197)
    // --------------------------------------------------------------------------
    localparam int AES_BLOCK_BITS = 128;
    localparam int AES_KEY_128    = 128;
    localparam int AES_KEY_192    = 192;
    localparam int AES_KEY_256    = 256;
    localparam int AES_ROUNDS_128 = 10;
    localparam int AES_ROUNDS_192 = 12;
    localparam int AES_ROUNDS_256 = 14;

    // --------------------------------------------------------------------------
    // Tipos de Modo de Chave e Operação
    // --------------------------------------------------------------------------
    typedef enum logic [1:0] {
        AES_KEY_SIZE_128 = 2'b00,
        AES_KEY_SIZE_192 = 2'b01,
        AES_KEY_SIZE_256 = 2'b10
    } aes_key_size_t;

    typedef enum logic {
        AES_ENCRYPT = 1'b0,
        AES_DECRYPT = 1'b1
    } aes_op_mode_t;

    // --------------------------------------------------------------------------
    // Opcodes da Interface SPI (Exemplo Base)
    // --------------------------------------------------------------------------
    typedef enum logic [7:0] {
        SPI_CMD_NOP       = 8'h00,
        SPI_CMD_WRITE_KEY = 8'h10,
        SPI_CMD_WRITE_CFG = 8'h11,
        SPI_CMD_START_OP  = 8'h20,
        SPI_CMD_READ_STAT = 8'h30,
        SPI_CMD_READ_DATA = 8'h31
    } spi_opcode_t;

    // --------------------------------------------------------------------------
    // Estruturas de Status e Controle
    // --------------------------------------------------------------------------
    typedef struct packed {
        logic       busy;
        logic       done;
        logic       error;
        logic [4:0] current_round;
    } aes_status_t;

endpackage : aes_pkg
