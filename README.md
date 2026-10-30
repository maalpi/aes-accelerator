# Acelerador AES com interface SPI e baixo consumo — RTL Design Track

Projeto hands-on de 13 semanas (um entregável por semana), seguindo a especificação funcional **Block Guide – MiniSoC AES (v1.0.0)**. Este repositório encontra-se na **Semana 2**: implementação das transformações combinacionais `minisoc_aes_sbox`, `minisoc_aes_sub_bytes` e `minisoc_aes_shift_rows` e verificação com vetores da FIPS-197.

## Estrutura

```
aes_accelerator/
├── Makefile                  # make = sintaxe/lint + compilação + simulação (Semana 2)
├── .gitignore
├── docs/
│   ├── architecture.md       # AES Top-Level System (blocos e interfaces)
│   ├── backlog.md            # Backlog atualizado (13 semanas)
│   ├── study_aes_spi.md      # Estudo AES (FIPS-197) e SPI
│   └── reports/
│       ├── template_semanal.md
│       ├── semana_01/
│       │   ├── semana_01.md
│       │   └── semana_01_make.log
│       ├── semana_02.md      # Relatório da Semana 2 + dúvidas do Block Guide
│       └── semana_02/
│           └── semana_02.md
├── rtl/
│   ├── minisoc_aes/          # Submódulos do datapath AES
│   │   ├── minisoc_aes_sbox.sv
│   │   ├── minisoc_aes_sub_bytes.sv
│   │   └── minisoc_aes_shift_rows.sv
│   └── smoke_top.sv          # Módulo de smoke test (Semana 1)
├── tb/
│   ├── tb_minisoc_aes_w02.sv # Testbench autoverificável (S-box 256 entradas + FIPS-197 Apêndice B)
│   └── tb_smoke_top.sv       # Testbench da Semana 1
├── synth/                    # Síntese lógica (Design Compiler) — semana 8
├── formal/                   # Equivalência formal (Formality) — semana 9
├── upf/                      # Intenção de potência (UPF) — semanas 11–12
└── scripts/                  # Scripts auxiliares (Tcl, shell)
```

## Uso

```bash
make          # fluxo completo da Semana 2 (lint + compilação + simulação autoverificável)
make lint     # apenas lint do RTL (vlogan +lint=all)
make wave     # abre waveform no Verdi
make clean
```

Requer Synopsys VCS (`vlogan`, `vcs`) e, opcionalmente, Verdi.
