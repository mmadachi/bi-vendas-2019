# 🧮 Medidas DAX — Sprint AC3

Medidas do modelo de dados do Power BI, documentadas por sprint. Nesta entrega, adicionei a página "Produtos e Margem", com três medidas novas de custo e rentabilidade.

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

## Sprint AC3 — Produtos e Margem

### Custo Total
```DAX
Custo Total = SUMX(Fato_Vendas, Fato_Vendas[Quantidade] * RELATED(Dim_Produto[CustoUnitario]))
```
Segue a mesma lógica de Valor Vendas, mas usando o custo unitário do produto (`RELATED` busca esse valor na tabela Dim_Produto) em vez do preço de venda — representa quanto a empresa gastou nos produtos vendidos.

### Margem
```DAX
Margem = [Valor Vendas] - [Custo Total]
```
Lucro bruto: valor vendido menos o custo dos produtos.

### % Margem
```DAX
% Margem = DIVIDE([Margem], [Valor Vendas])
```
Percentual do valor vendido que se converteu em lucro. Usei essa medida no TreeMap e nos cartões de KPI da página "Produtos e Margem".

### Recursos configurados sem DAX (AC3)
- **Matriz de rentabilidade:** matriz Linha > Grupo de produto com Valor Vendas, Custo Total, Margem e % Margem, com formatação condicional de cor em % Margem.
- **Drill-through:** página "Detalhe do Produto", acessada a partir da tabela dos 10 maiores produtos por Valor Vendas (filtro N Superior).

---
As medidas da entrega final serão documentadas aqui progressivamente.
