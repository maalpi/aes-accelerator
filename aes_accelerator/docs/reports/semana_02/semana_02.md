# Relatório Semanal — Semana 02

**Projeto:** Acelerador AES com interface SPI e baixo consumo  
**Trilha:** RTL Design Track  
**Aluno:** Mateus Pierre  
**Verificador Parceiro:** A definir  
**Tag/Branch:** `w02-sbox-shiftrows`  
**Data:** 30/10/2026  

---

## 1. Objetivo da Semana
Implementar e verificar em RTL sintetizável as transformações combinacionais `minisoc_aes_sbox`, `minisoc_aes_sub_bytes` e `minisoc_aes_shift_rows` segundo o padrão NIST FIPS-197 e a convenção de estado do Block Guide do MiniSoC AES (v1.0.0), além de realizar a leitura crítica das seções 1 a 3 e 8 do Block Guide para levantamento de dúvidas e possíveis ambiguidades.

---

## 2. Atividades Realizadas
- **Replanejamento do Backlog (`docs/backlog.md`):** Atualização do cronograma do projeto para 13 semanas (encerramento em 29/01/2027, com recesso de 21/12/2026 a 03/01/2027), alinhado à especificação funcional oficial *Block Guide – MiniSoC AES (v1.0.0)*.
- **Implementação de `minisoc_aes_sbox` (`rtl/minisoc_aes/minisoc_aes_sbox.sv`):**
  - Módulo puramente combinacional (tabela `localparam` de 256 posições com `assign data_o = SBOX[data_i]`) de 8 bits de entrada (`data_i`) e 8 bits de saída (`data_o`), mapeando a Figura 7 da FIPS-197.
- **Implementação de `minisoc_aes_sub_bytes` (`rtl/minisoc_aes/minisoc_aes_sub_bytes.sv`):**
  - Módulo combinacional operando sobre o estado de 128 bits (`state_i` → `state_o`), instanciando 16 unidades paralelas de `minisoc_aes_sbox` via laço `for (genvar i = 0; i < 16; i++)`.
- **Implementação de `minisoc_aes_shift_rows` (`rtl/minisoc_aes/minisoc_aes_shift_rows.sv`):**
  - Módulo puramente combinacional que realiza a permutação cíclica das linhas da matriz de estado apenas por reordenação de fios, respeitando a convenção do Block Guide: byte 0 em `[127:120]` e byte 15 em `[7:0]`, onde o byte $n$ corresponde a $s[r][c]$ com $r = n \bmod 4$ e $c = \lfloor n / 4 \rfloor$.
  - Mapeamento dos bytes de saída: `{b0, b5, b10, b15, b4, b9, b14, b3, b8, b13, b2, b7, b12, b1, b6, b11}`.
- **Desenvolvimento do Testbench Autoverificável (`tb/tb_minisoc_aes_w02.sv`):**
  - **(a) Teste exaustivo da S-box:** Verificação automática das 256 entradas (`8'h00` a `8'hFF`) contra a tabela de referência da FIPS-197 (`sbox(8'h00) = 8'h63`, `sbox(8'h53) = 8'hed`).
  - **(b) Teste das transformações `SubBytes` e `ShiftRows`:** Aplicação dos estados intermediários das rodadas **1 e 10** do exemplo oficial de cifragem do Apêndice B da FIPS-197, validando a cadeia `"Start of Round"` → `"After SubBytes"` → `"After ShiftRows"`.
- **Atualização do `Makefile`:** Configuração do alvo padrão (`make`) para executar lint (`vlogan +lint=all`), compilação (`vcs`) e simulação (`./simv`) do testbench da Semana 02 com um único comando.
- **Leitura das Seções 1 a 3 e 8 do Block Guide:** Levantamento de dúvidas e pontos de alinhamento registrados na Seção 4 deste relatório.

---

## 3. Resultados Obtidos
O fluxo da Semana 02 foi executado e validado no servidor com Synopsys VCS (`X-2025.06-SP2`):

- **Status da Compilação/Lint:** **OK** (0 erros e 0 avisos no `vlogan -full64 -sverilog -kdb +lint=all`).
- **Status da Simulação:** **PASS** (Simulação concluída aos 258 ns / 258000 ps com 0 erros e geração de formas de onda `waves.fsdb`).
  - **S-box:** 256/256 entradas aprovadas (`sbox(8'h00) = 8'h63`, `sbox(8'h53) = 8'hed`).
  - **Apêndice B (Rodadas 1 e 10):** Aprovadas nas saídas de `SubBytes` e `ShiftRows`:
    - Rodada 1: `193de3bea0f4e22b9ac68d2ae9f84808` → `d42711aee0bf98f1b8b45de51e415230` (`SubBytes`) → `d4bf5d30e0b452aeb84111f11e2798e5` (`ShiftRows`).
    - Rodada 10: `eb40f21e592e38848ba113e71bc342d2` → `e9098972cb31075f3d327d94af2e2cb5` (`SubBytes`) → `e9317db5cb322c723d2e895faf090794` (`ShiftRows`).
- **Métricas Preliminares:** Não aplicável nesta semana (síntese lógica prevista para a Semana 08).
- **Evidência:** Log completo registrado em [`semana_02_make.log`](semana_02_make.log).

Trecho do log da execução:
```text
Parsing design file 'rtl/minisoc_aes/minisoc_aes_sbox.sv'
Parsing design file 'rtl/minisoc_aes/minisoc_aes_sub_bytes.sv'
Parsing design file 'rtl/minisoc_aes/minisoc_aes_shift_rows.sv'
Parsing design file 'tb/tb_minisoc_aes_w02.sv'
CPU time: .297 seconds to compile
...
[TESTE 1] S-box: 256 entradas
  [PASS] As 256 entradas conferem

[TESTE 2] SubBytes e ShiftRows (FIPS-197 Apendice B)
  [PASS] Rodada 1 OK
  [PASS] Rodada 10 OK

=== PASS: todos os testes passaram ===

$finish called from file "tb/tb_minisoc_aes_w02.sv", line 102.
$finish at simulation time               258000
```

---

## 4. Problemas Encontrados, Decisões de Projeto e Dúvidas sobre o Block Guide

### 4.1 Problemas e Decisões de Projeto
| Problema / Questão | Causa Raiz | Solução / Decisão Adotada |
|--------------------|------------|---------------------------|
| Avisos `Lint-[NS] Null statement` no testbench | Uso de `#1;` isolado com ponto e vírgula antes do `if` de verificação no `tb_minisoc_aes_w02.sv` | Atraso `#1` associado diretamente ao comando condicional (`#1 if (...)`), eliminando 100% dos avisos do `vlogan +lint=all`. |
| Escolha entre tabela (LUT) e cálculo algébrico em $GF(2^8)$ para a `minisoc_aes_sbox` | A especificação permite implementar via tabela de 256 entradas (Figura 7 da FIPS-197) ou inversão em $GF(2^8)$ + transformação afim | Adotada a tabela explícita de 256 entradas (`SBOX[data_i]`) pela simplicidade de leitura, verificação direta e menor atraso lógico combinacional na síntese inicial. |
| Padronização dos nomes das portas dos submódulos combinacionais | A seção 3 do Block Guide fixa os sinais de topo do MiniSoC, enquanto os submódulos internos do datapath (`minisoc_aes_*`) conectam-se a `minisoc_aes_dp` | Adotados nomes limpos e autoexplicativos (`data_i`/`data_o` em `minisoc_aes_sbox` e `state_i`/`state_o` em `minisoc_aes_sub_bytes` e `minisoc_aes_shift_rows`), que serão documentados na microarquitetura da Semana 03. |

### 4.2 Lista de Dúvidas e Ambiguidades (Leitura das Seções 1 a 3 e 8 do Block Guide)
Durante a leitura das seções **1 (Visão Geral)**, **2 (Arquitetura)**, **3 (Interfaces de Topo)** e **8 (AES Engine e Modos de Operação)** do *Block Guide – MiniSoC AES (v1.0.0)*, foram registrados os seguintes pontos para confirmação com o instrutor e alinhamento com o verificador parceiro:

1. **Ordenação de Palavras (Endianness) na Memória Compartilhada vs. Estado de 128 bits (Seções 3 e 8):**
   - Cada bloco de 128 bits ocupa 4 palavras de 32 bits consecutivas na memória (`4*b + 0` a `4*b + 3`). Gostaríamos de confirmar se o endereço base do bloco (`4*b + 0`) corresponde sempre à **Word 0 (`state[127:96]`)** e `4*b + 3` à **Word 3 (`state[31:0]`)**, tanto na leitura do texto-claro quanto na escrita *in-place* do texto-cifrado.
2. **Incremento do Contador no Modo CTR (Seção 8.2):**
   - Na concatenação de `COUNTER_HI` e `COUNTER_LO` para formar o bloco de contador de 128 bits (ou 64 bits de nonce + 64 bits de contador), em casos de múltiplos blocos com `COUNTER_LO = 32'hFFFF_FFFF`, o carry do incremento aritmético de +1 por bloco deve propagar para `COUNTER_HI` (incremento de 64/128 bits completo) ou é restrito aos 32 bits inferiores (`COUNTER_LO`)?
3. **Comportamento dos Sinais `DONE`, `ERROR` e `BLOCKS_DONE` em Caso de Configuração Inválida (Seção 8):**
   - Quando um `START` é disparado com configuração inválida (`NUM_BLOCKS` fora do intervalo `1..256` ou `MODE` reservado), o bloco sinaliza `ERROR = 1` e encerra sem processar blocos (`BLOCKS_DONE = 0`). Nesse cenário de erro imediato, o bit `DONE` também deve ir a `1` (indicando término da tentativa de operação) ou deve permanecer em `0` enquanto apenas `ERROR = 1` fica ativo? Além disso, `ERROR` também é *sticky* até o próximo `START` válido, assim como `DONE`?
4. **Latência da Memória `minisoc_memory` na Leitura pelo AES Engine (Seções 3, 7 e 8):**
   - Sendo a memória single-port síncrona, o dado de leitura (`rdata`) está disponível no ciclo seguinte à apresentação do endereço (`addr`) com `we = 0`. Existe alguma restrição de número máximo de ciclos por bloco na interface do `minisoc_aes_top` esperada pelos VIPs da trilha de verificação, ou a verificação aguarda o sinal `DONE` independentemente da latência interna da FSM?
5. **Comportamento de `spi_miso` quando `spi_cs_n = 1` (Seção 3):**
   - Na interface de topo, quando o escravo SPI não está selecionado (`spi_cs_n = 1`), o pino `spi_miso` deve ser dirigido com valor constante (`1'b0`) ou colocado em alta impedância (`1'bz`)? (Em fluxos ASIC síncronos internos e Formality costuma-se preferir `1'b0` para evitar nós tri-state).

---

## 5. Próximos Passos (Semana 03)
- Elaboração do documento de microarquitetura v1.0 (`docs/architecture/`) e alinhamento das decisões e dúvidas do Block Guide com o instrutor e o verificador parceiro.
- Implementação das demais transformações de rodada diretas e inversas: `minisoc_aes_mix_columns`, `minisoc_aes_inv_sbox`, `minisoc_aes_inv_sub_bytes`, `minisoc_aes_inv_shift_rows` e `minisoc_aes_inv_mix_columns`.
- Validação em testbench autoverificável das transformações diretas e inversas (incluindo propriedade de inversão $T^{-1}(T(x)) = x$ e vetores da FIPS-197).
