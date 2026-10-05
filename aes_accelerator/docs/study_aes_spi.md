# Relatório Técnico de Estudo: AES (FIPS-197) e Protocolo SPI

**Projeto:** Acelerador AES com interface SPI e baixo consumo  
**Módulo:** Documentação de Estudo Inicial (Semana 01)  
**Normas de Referência:** NIST FIPS-197, Motorola SPI Block Guide  

---

## 1. Introdução

Este documento consolida o embasamento teórico necessário para o desenvolvimento do sistema integrado *AES Top-Level System*. São abordados os fundamentos matemáticos e estruturais do padrão de criptografia simétrica **AES (Advanced Encryption Standard - FIPS-197)** e as características elétricas e temporais do protocolo de comunicação serial **SPI (Serial Peripheral Interface)**.

---

## 2. Advanced Encryption Standard (AES - FIPS-197)

### 2.1 Visão Geral
O AES é uma cifra de bloco iterativa simétrica que processa blocos fixos de dados de **128 bits** (16 bytes), utilizando chaves criptográficas de **128, 192 ou 256 bits**. O número de rodadas (*rounds*, $N_r$) varia em função do comprimento da chave ($N_k$ palavras de 32 bits):

| Modo AES | Tamanho da Chave ($N_k$) | Tamanho do Bloco ($N_b$) | Número de Rodadas ($N_r$) |
|:--------:|:------------------------:|:-----------------------:|:-------------------------:|
| AES-128  | 4 palavras (128 bits)    | 4 palavras (128 bits)   | 10 rodadas                |
| AES-192  | 6 palavras (192 bits)    | 4 palavras (128 bits)   | 12 rodadas                |
| AES-256  | 8 palavras (256 bits)    | 4 palavras (128 bits)   | 14 rodadas                |

### 2.2 Estrutura da Matriz de Estado (*State Matrix*)
Os 128 bits de entrada são organizados em uma matriz bidimensional de $4 \times 4$ bytes:

$$
\text{State} = \begin{bmatrix} 
s_{0,0} & s_{0,1} & s_{0,2} & s_{0,3} \\ 
s_{1,0} & s_{1,1} & s_{1,2} & s_{1,3} \\ 
s_{2,0} & s_{2,1} & s_{2,2} & s_{2,3} \\ 
s_{3,0} & s_{3,1} & s_{3,2} & s_{3,3} 
\end{bmatrix}
$$

A indexação dos bytes de entrada $in_0, in_1, \dots, in_{15}$ na matriz de estado segue a ordem orientada por colunas: $s_{r,c} = in_{r + 4c}$.

### 2.3 Transformações de Cada Rodada

A estrutura padrão de encriptação é composta pelas seguintes etapas:
1. **Adição Inicial de Chave (`AddRoundKey`):** XOR bit a bit entre a matriz de estado e a chave de rodada inicial ($w[0..3]$).
2. **Rodadas Intermediárias ($1$ até $N_r - 1$):**
   - **`SubBytes`**: Substituição não-linear byte a byte baseada na S-Box (inversão multiplicativa no corpo de Galois $GF(2^8)$ com polinômio irredutível $m(x) = x^8 + x^4 + x^3 + x + 1$, seguida por uma transformação afim).
   - **`ShiftRows`**: Deslocamento circular para a esquerda das linhas da matriz de estado:
     - Linha 0: desloca 0 posições;
     - Linha 1: desloca 1 posição para a esquerda;
     - Linha 2: desloca 2 posições para a esquerda;
     - Linha 3: desloca 3 posições para a esquerda.
   - **`MixColumns`**: Mistura linear das colunas da matriz de estado, tratando cada coluna como um polinômio de 4 termos sobre $GF(2^8)$ multiplicado módulo $x^4 + 1$ pelo polinômio fixo $c(x) = \{03\}x^3 + \{01\}x^2 + \{01\}x + \{02\}$.
   - **`AddRoundKey`**: XOR entre as colunas do estado e as 4 palavras da chave correspondente à rodada atual.
3. **Rodada Final (Rodada $N_r$):**
   - Executa `SubBytes`, `ShiftRows` e `AddRoundKey` (a etapa `MixColumns` é omitida na última rodada).

### 2.4 Expansão de Chave (*Key Expansion*)
Gera uma sequência total de $N_b(N_r + 1)$ palavras de 32 bits a partir da chave mestre:
- Utiliza a função `RotWord` (deslocamento cíclico de bytes de uma palavra);
- Substituição por S-Box (`SubWord`);
- Constante de rodada (`Rcon[i]`) em potências de $x$ no corpo $GF(2^8)$.

### 2.5 Decriptação (Operações Inversas)
A operação de decriptação reverte as transformações na ordem inversa:
- `InvShiftRows`
- `InvSubBytes` (usando a S-Box inversa)
- `InvAddRoundKey`
- `InvMixColumns` (com polinômio inverso $d(x) = \{0b\}x^3 + \{0d\}x^2 + \{09\}x + \{0e\}$).

---

## 3. Protocolo Serial Peripheral Interface (SPI)

### 3.1 Linhas de Sinal
A interface SPI opera como barramento síncrono full-duplex de 4 fios:
- **`SCLK` (Serial Clock):** relógio gerado pelo mestre que cadencia a transferência de bits.
- **`MOSI` (Master Out Slave In):** linha de dados do mestre para o periférico escravo (configurações, comandos e dados).
- **`MISO` (Master In Slave Out):** linha de dados do escravo para o mestre (status e leitura).
- **`CS_N` / `SS_N` (Chip Select / Slave Select):** ativo em nível baixo, habilita a comunicação com o dispositivo escravo específico.

### 3.2 Modos de Operação (CPOL e CPHA)
A temporização da SPI é definida por dois parâmetros de configuração:
- **`CPOL` (Clock Polarity):** determina o nível lógico de repouso (inativo) da linha de clock.
  - `CPOL = 0`: Clock em nível baixo em repouso.
  - `CPOL = 1`: Clock em nível alto em repouso.
- **`CPHA` (Clock Phase):** define a borda de clock em que os dados são amostrados (*sampled*) ou comutados (*shifted*).
  - `CPHA = 0`: Amostragem na primeira borda do clock, deslocamento na segunda borda.
  - `CPHA = 1`: Deslocamento na primeira borda do clock, amostragem na segunda borda.

| Modo SPI | CPOL | CPHA | Borda de Amostragem (Latch) | Borda de Deslocamento (Shift) |
|:--------:|:----:|:----:|:---------------------------:|:-----------------------------:|
| **Modo 0** | 0    | 0    | Borda de Subida             | Borda de Descida              |
| **Modo 1** | 0    | 1    | Borda de Descida            | Borda de Subida               |
| **Modo 2** | 1    | 0    | Borda de Descida            | Borda de Subida               |
| **Modo 3** | 1    | 1    | Borda de Subida             | Borda de Descida              |

*Observação de Projeto:* No acelerador AES, o periférico SPI escravo suportará primariamente o **Modo 0** (padrão mais comum em microcontroladores e FPGAs), com lógica configurável ou estendível para suporte aos demais modos conforme os requisitos da trilha de verificação.

### 3.3 Integração e Cruzamento de Domínio de Clock (CDC)
Como o sinal `SCLK` é assíncrono em relação ao clock do núcleo do acelerador (`clk_core` gerado pelo PLL), a interface SPI exigirá:
1. Sincronização de 2 ou 3 estágios (*double-flop synchronizers*) para sinais de controle assíncronos (`cs_n`, `sclk`, `mosi`);
2. Buffer de dados e controle de handshake com detecção de borda (*pulse generator*);
3. Proteção contra metastabilidade para garantir transferência íntegra de registradores entre o domínio SPI e o domínio AES.

---

## 4. Referências Bibliográficas
1. National Institute of Standards and Technology (NIST), **FIPS PUB 197: Advanced Encryption Standard (AES)**, Nov. 2001.
2. Freescale / NXP Semiconductors, **SPI Block Guide V04.01**, 2004.
3. Clifford E. Cummings, **Clock Domain Crossing (CDC) Design & Verification Techniques Using SystemVerilog**, SNUG, 2008.
