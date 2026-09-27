# 🧮 Medidas DAX — Sprint AC2

Medidas do modelo de dados do Power BI, documentadas por sprint. Nesta entrega, adicionei a página "Vendedores", com duas medidas novas de participação e ranking.

---

## Sprint AC1 — Visão Geral

### Valor Vendas
```DAX
Valor Vendas = SUMX(Fato_Vendas, Fato_Vendas[Quantidade] * Fato_Vendas[ValorUnitario])
```
Multiplica quantidade por preço unitário em cada linha da tabela de vendas e soma o resultado — receita total do período filtrado.

### Quantidade Vendida
```DAX
Quantidade Vendida = SUM(Fato_Vendas[Quantidade])
```
Soma total de itens vendidos.

### Qtd Notas Fiscais
```DAX
Qtd Notas Fiscais = DISTINCTCOUNT(Fato_Vendas[NotaFiscal])
```
Contagem de notas fiscais distintas — usada como proxy do número de vendas realizadas.

### Ticket Médio
```DAX
Ticket Médio = DIVIDE([Valor Vendas], [Qtd Notas Fiscais])
```
Valor médio por venda. Optei por `DIVIDE` em vez do operador `/` porque a função já trata o caso de divisão por zero.

---

## Sprint AC2 — Vendedores

### % Participação Vendedor
```DAX
% Participação Vendedor = DIVIDE([Valor Vendas], CALCULATE([Valor Vendas], ALL(Dim_Vendedor)))
```
Calcula a fatia, em porcentagem, que cada vendedor representa do total vendido pela empresa. O `CALCULATE` com `ALL(Dim_Vendedor)` remove o filtro de vendedor só no denominador, mantendo o total geral como referência.

### Ranking Vendedor
```DAX
Ranking Vendedor = RANKX(ALL(Dim_Vendedor[Vendedor]), [Valor Vendas],, DESC)
```
Ordena os vendedores do que mais vendeu para o que menos vendeu. Usei essa medida em conjunto com o gráfico de ranking e a matriz Supervisor → Vendedor da página "Vendedores".

---
As medidas das próximas sprints (AC3 e Final) serão documentadas aqui progressivamente.
