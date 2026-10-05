# Relatório Semanal — Semana 01

**Projeto:** Acelerador AES com interface SPI e baixo consumo (RTL Design Track)  
**Tag/Branch:** `w01-env-kickoff`  
**Data:** 05/10/2026

## 1. O que foi feito
- Estudo de AES (FIPS-197) e SPI (CPOL/CPHA): [`../study_aes_spi.md`](../study_aes_spi.md).
- Estudo da arquitetura do AES Top-Level System: [`../architecture.md`](../architecture.md).
- Estrutura do repositório, `.gitignore` e `Makefile` com fluxo de um comando.
- Esqueletos RTL (apenas portas) e smoke test com modelo de memória.
- Backlog inicial das 15 semanas: [`../backlog.md`](../backlog.md).

## 2. Resultados obtidos
> Preencher após rodar `make` no ambiente com VCS.

- Sintaxe/lint (`make syntax`): _pendente_
- Compilação (`make compile`): _pendente_
- Simulação (`make run`): _pendente_

## 3. Problemas encontrados
_Registrar aqui após a primeira execução._

## 4. Próximos passos (Semana 02)
- Microarquitetura de cada bloco e mapa de registradores SPI.
- Interface de dados com memória e estratégia de CDC (`spi_sclk` × `clk_core`).
