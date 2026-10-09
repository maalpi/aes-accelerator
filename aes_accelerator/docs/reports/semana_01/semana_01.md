# Relatório Semanal — Semana 01

**Projeto:** Acelerador AES com interface SPI e baixo consumo  
**Trilha:** RTL Design Track  
**Aluno:** Mateus Pierre  
**Verificador Parceiro:** A definir  
**Tag/Branch:** `w01-env-v1.0`  
**Data:** 08/10/2026  

---

## 1. Objetivo da Semana
Configuração do ambiente de desenvolvimento, estudo do algoritmo criptográfico AES (FIPS-197) e do protocolo serial SPI, estruturação inicial do repositório Git, elaboração do backlog das 15 semanas de projeto e validação do fluxo mínimo de ferramentas (análise sintática/lint, compilação e simulação) em um único comando (`make`).

## 2. Atividades Realizadas
- **Estudo do Algoritmo AES (FIPS-197) e Protocolo SPI.**
- **Planejamento do Backlog.**
- **Estruturação do Repositório.**
- **Desenvolvimento do RTL e Testbench Mínimos:**
  - `rtl/smoke_top.sv`: Módulo simples de smoke test para validação do ambiente, contendo entradas de clock, reset assíncrono, barramento de dados com handshake e operação combinacional.
  - `tb/tb_smoke_top.sv`: Testbench auto-verificável com geração de clock de 100 MHz, pulso de reset, aplicação de dados e conferência automática, além de geração de ondas FSDB para o Verdi.
- **Automação do Fluxo (`Makefile`):** Script para execução de análise sintática e linting com Synopsys VCS `vlogan`, compilação/elaboração com `vcs` e simulação com `./simv` via comando `make`.

## 3. Resultados Obtidos
O fluxo mínimo foi executado e aprovado com sucesso no servidor com Synopsys VCS (`X-2025.06-SP2`):

- **Status da Compilação/Lint:** **OK** (0 erros, 0 avisos no `vlogan` com `+lint=all`).
- **Status da Simulação:** **Pass** (Simulação concluída aos 60 ns / 60000 ps com auto-verificação de dados aprovada e geração de formas de onda `waves.fsdb`).
- **Métricas Preliminares:** Não aplicável para a Semana 01 (síntese lógica agendada para a Semana 07).
- **Evidência:** Log completo registrado e versionado em [`semana_01_make.log`](semana_01_make.log).

Trecho do log da execução:
```text
Parsing design file 'rtl/smoke_top.sv'
Parsing design file 'tb/tb_smoke_top.sv'
CPU time: .273 seconds to compile
...
=======================================================
 [SUCCESS] Ambiente Synopsys (VCS) configurado com sucesso!
 Lint (vlogan), compilacao (vcs) e simulacao 100% OK.
=======================================================

$finish called from file "tb/tb_smoke_top.sv", line 50.
$finish at simulation time                60000
           V C S   S i m u l a t i o n   R e p o r t 
Time: 60000 ps
CPU Time:      0.390 seconds;       Data structure size:   0.0Mb
```

## 4. Problemas Encontrados e Decisões de Projeto

| Problema / Bloqueio | Causa Raiz | Solução / Decisão Adotada |
|---------------------|------------|---------------------------|
| Avisos de lint `Lint-[NS] Null statement` | Atrasos isolados com ponto e vírgula (`#delay;`) no TB | Delays vinculados diretamente às atribuições no testbench |

## 5. Próximos Passos (Semana 02)
- Especificação detalhada da microarquitetura dos blocos do sistema.
- Definição do mapa de registradores acessíveis via interface SPI.
- Especificação da interface com a memória SRAM e estratégia de sincronização de Clock Domain Crossing (CDC) entre `spi_sclk` e `clk_core`.
