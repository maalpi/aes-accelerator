# Backlog do Projeto — Acelerador AES com Interface SPI e Baixo Consumo

**Trilha:** RTL Design Track  
**Especificação de Referência:** Block Guide – MiniSoC AES (v1.0.0)  
**Duração:** 13 Semanas (Cronograma revisado em 27/10/2026 — encerramento em 29/01/2027, recesso de 21/12/2026 a 03/01/2027)  
**Ritmo:** 1 Entregável por Semana com Sabatina e Relatório Semanal (`docs/reports/semana_XX.md`)  

---

## Visão Geral das Fases

| Fase | Semanas | Período | Foco |
|:----:|:-------:|:-------:|:-----|
| **1. Kick-off e ambiente** | 1 | concluída | Estudo, repositório e fluxo mínimo |
| **2. Desenvolvimento do RTL** | 2–7 | 30/10 a 04/12 | Datapath AES, SPI, PLL mock, AES engine, memória e integração (RTL v1.0) |
| **3. Síntese inicial** | 8 | 11/12 | SDC, síntese e baseline de área, timing e potência |
| **4. Verificação formal de equivalência** | 9 | 18/12 | Equivalência RTL × netlist com o Formality |
| **Recesso** | — | 21/12 a 03/01 | Sem entregas |
| **5. Fechamento funcional** | 10 | 08/01 | Modos restantes, correções e RTL v1.1 |
| **6. Intenção de potência e baixo consumo** | 11–12 | 15/01 a 22/01 | Arquitetura de energia, UPF, power gating e clock gating (RTL v2.0) |
| **7. Síntese low power e encerramento** | 13 | 29/01 | Comparação com o baseline e apresentação final |

---

## Detalhamento Semana a Semana

### Fase 1: Kick-off e Ambiente (Semana 1)

#### Semana 1 — Kick-off, Estudo e Ambiente (Concluída)
- [x] Apresentação do projeto e da especificação funcional.
- [x] Estudo do algoritmo AES (FIPS-197) e do protocolo SPI (modos de operação, polaridade e fase de clock).
- [x] Preparação do ambiente inicial: repositório, scripts de execução e configuração das ferramentas (VCS, lint).
- [x] Criação do backlog inicial do projeto.
- **Entregável:** Repositório estruturado, backlog inicial, ambiente executando exemplo mínimo e relatório de estudo sobre AES e SPI (`docs/reports/semana_01/semana_01.md`).
- **Critério de Aceite:** Repositório clonável em ambiente limpo e fluxo mínimo executado com um único comando (`make`).

---

### Fase 2: Desenvolvimento do RTL (Semanas 2–7)

#### Semana 2 — Desafio: SubBytes e ShiftRows (Entrega 30/10)
- [x] Implementar `minisoc_aes_sbox` (entrada 8 bits, saída 8 bits, puramente combinacional, Figura 7 da FIPS-197).
- [x] Implementar `minisoc_aes_sub_bytes` (estado de 128 bits, 16 instâncias de `minisoc_aes_sbox`).
- [x] Implementar `minisoc_aes_shift_rows` (estado de 128 bits, apenas reordenação de fios, convenção do Block Guide `[127:120]` = byte 0).
- [x] Testbench autoverificável (`tb/tb_minisoc_aes_w02.sv`): 256 entradas da S-box e estados do Apêndice B da FIPS-197 (rodadas 1 a 10).
- [x] Leitura das seções 1 a 3 e 8 do Block Guide, registrando dúvidas e ambiguidades.
- **Entregável:** RTL de `minisoc_aes_sbox`, `minisoc_aes_sub_bytes` e `minisoc_aes_shift_rows`, testbench autoverificável e relatório curto (`docs/reports/semana_02.md`).
- **Critério de Aceite:** Testbench executado por um único comando (`make`), com PASS nas 256 entradas da S-box e nos vetores do Apêndice B; lint sem erros.

#### Semana 3 — Microarquitetura v1.0 e Transformações de Rodada (Entrega 06/11)
- [ ] Elaborar documento de microarquitetura v1.0 e apresentar ao verificador parceiro.
- [ ] Implementar transformações de rodada restantes (diretas e inversas: `MixColumns`, `InvSubBytes`, `InvShiftRows`, `InvMixColumns`).
- [ ] Testbench autoverificável validando transformações diretas e inversas.
- **Entregável:** Microarquitetura v1.0 + transformações de rodada + relatório `docs/reports/semana_03.md`.

#### Semana 4 — Expansão de Chave e Datapath AES-128 (Entrega 13/11)
- [ ] Implementar `minisoc_aes_key_exp` (expansão de chave AES-128).
- [ ] Implementar `minisoc_aes_dp` (datapath completo AES-128 em cifragem e decriptação).
- [ ] Testbench com os vetores da FIPS-197 (Apêndice C.1 e Apêndice B) nos dois sentidos.
- **Entregável:** RTL de `minisoc_aes_key_exp` e `minisoc_aes_dp`, testbench com vetores do padrão e relatório `docs/reports/semana_04.md`.
- **Critério de Aceite:** Cifragem e decriptação conferem com os vetores de referência; lint sem erros.

#### Semana 5 — SPI Front-End e PLL Mock (Entrega 20/11)
- [ ] Implementar `minisoc_spi` (seção 5 do Block Guide): SPI Mode 0, MSB-first, frame de 40 bits, sincronização de toggle para domínio `clk` e banco de registradores (seção 6).
- [ ] Implementar `minisoc_pll_mock` (seção 4.1): referência de 2 GHz, enable, `PLL_DIV_SEL` (`/1`, `/2`, `/4`, `/8`) e `locked`.
- [ ] Testbench dirigido: escrita e leitura de todos os registradores via SPI e habilitação do PLL até `PLL_LOCKED = 1`.
- **Entregável:** RTL de `minisoc_spi` e `minisoc_pll_mock`, testbench e relatório de lint (`docs/reports/semana_05.md`).

#### Semana 6 — AES Engine e Memória Compartilhada (Entrega 27/11)
- [ ] Implementar `minisoc_memory` (seção 7): 1024 × 32 bits, single-port síncrona, sem reset, ownership por `MEM_SEL_AES`.
- [ ] Implementar `minisoc_aes_top` (seção 8): modos ECB, CBC e CTR (cifragem e decriptação), detecção de configuração inválida (`ERROR`).
- [ ] Testbench de bloco com a memória (1, 2 e 256 blocos) comparado com modelo de referência em software.
- **Entregável:** RTL de `minisoc_memory` e `minisoc_aes_top`, testbench de bloco, vetores de referência e relatório `docs/reports/semana_06.md`.

#### Semana 7 — Integração do Top-Level e RTL v1.0 (Entrega 04/12)
- [ ] Implementar `minisoc_top`: conexão dos quatro blocos e exposição exata das interfaces CLK, RESET, SPI e MEMORY DATA (seção 3).
- [ ] Sequência de reset (seção 4.2), teste de ponta a ponta (14 passos da seção 9) e análise de CDC.
- [ ] Entrega da tag `rtl-v1.0` ao verificador parceiro.
- **Entregável:** Top-level integrado, teste de ponta a ponta, relatórios de lint e CDC, tag `rtl-v1.0` e relatório `docs/reports/semana_07.md`.

---

### Fase 3: Síntese Inicial (Semana 8)

#### Semana 8 — Síntese Inicial e Baseline (Entrega 11/12)
- [ ] Escrita das restrições de timing (SDC) para `clk`, `sys_clk`, `spi_sclk` e `mem_clk`.
- [ ] Síntese lógica do RTL v1.0 com o PDK fornecido e análise dos relatórios de área, timing e potência.
- **Entregável:** Scripts de síntese, SDC, netlist e relatório de baseline (`docs/reports/semana_08.md`).

---

### Fase 4: Verificação Formal de Equivalência (Semana 9)

#### Semana 9 — Verificação Formal de Equivalência (Entrega 18/12)
- [ ] Fluxo no Formality comparando RTL v1.0 (referência) e netlist sintetizada (implementação) com arquivo SVF.
- [ ] Exercício de diagnóstico com alteração intencional.
- **Entregável:** Scripts do Formality e relatório de equivalência (`docs/reports/semana_09.md`).

---

### Fase 5: Fechamento Funcional (Semana 10)

#### Semana 10 — Fechamento Funcional e RTL v1.1 (Entrega 08/01)
- [ ] Implementação dos modos PCBC, CFB e OFB (seção 8.2).
- [ ] Correção dos defeitos reportados pelo verificador parceiro, nova síntese e nova equivalência formal.
- [ ] Entrega da tag `rtl-v1.1` ao verificador parceiro.
- **Entregável:** Tag `rtl-v1.1`, testes dos seis modos, netlist atualizada e relatório `docs/reports/semana_10.md`.

---

### Fase 6: Intenção de Potência e Baixo Consumo (Semanas 11–12)

#### Semana 11 — Arquitetura de Energia e UPF (Entrega 15/01)
- [ ] Definição dos modos de operação, domínios de potência, tabela de estados (PST), isolamento e retenção.
- [ ] Escrita do arquivo UPF, verificação estática e simulação power-aware.
- **Entregável:** Documento de arquitetura de energia, arquivo UPF, relatórios de verificação estática e simulação power-aware (`docs/reports/semana_11.md`).

#### Semana 12 — Técnicas de Baixo Consumo e RTL v2.0 (Entrega 22/01)
- [ ] Controlador de energia e sequência de power gating integrados ao banco de registradores.
- [ ] Aplicação de clock gating e isolamento de operandos; atualização do testbench.
- [ ] Entrega da tag `rtl-v2.0` ao verificador parceiro.
- **Entregável:** Tag `rtl-v2.0`, testes atualizados e relatórios (`docs/reports/semana_12.md`).

---

### Fase 7: Síntese Low Power e Encerramento (Semana 13)

#### Semana 13 — Síntese Low Power e Encerramento (Entrega 29/01)
- [ ] Síntese do RTL v2.0 com UPF e inserção automática de clock gating.
- [ ] Comparação com o baseline da Semana 8 e verificação de equivalência no Formality com UPF.
- [ ] Consolidação da documentação, release final e apresentação final.
- **Entregável:** Relatório comparativo baseline × low power, relatório de equivalência, release final e apresentação (`docs/reports/semana_13.md`).
