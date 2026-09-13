# 🧮 Medidas DAX — Sprint AC1

Medidas criadas no Power BI para a primeira entrega do projeto (página "Visão Geral"). DAX é a linguagem de fórmulas do modelo de dados do Power BI — equivalente, em espírito, a criar fórmulas no Excel, mas aplicada diretamente sobre as tabelas do modelo.

As medidas das próximas sprints (AC2, AC3 e Final) serão documentadas aqui progressivamente, conforme forem desenvolvidas.

---

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
Valor médio por venda. Optei por `DIVIDE` em vez do operador `/` porque a função já trata o caso de divisão por zero, evitando erro quando o filtro atual não retorna nenhuma nota fiscal.
