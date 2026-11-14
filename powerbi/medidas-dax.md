🧮 Medidas DAX — Entrega Final
Medidas do modelo de dados do Power BI, documentadas por sprint. Esta é a versão completa, reunindo as quatro entregas. Na última sprint, adicionei a página "Painel Executivo", com medidas de comparação mensal, receita acumulada e um parâmetro de campo para alternar a métrica.
---
Sprint AC1 — Visão Geral
Valor Vendas
```DAX
Valor Vendas = SUMX(Fato\_Vendas, Fato\_Vendas\[Quantidade] \* Fato\_Vendas\[ValorUnitario])
```
Multiplica quantidade por preço unitário em cada linha da tabela de vendas e soma o resultado — receita total do período filtrado.
Quantidade Vendida
```DAX
Quantidade Vendida = SUM(Fato\_Vendas\[Quantidade])
```
Soma total de itens vendidos.
Qtd Notas Fiscais
```DAX
Qtd Notas Fiscais = DISTINCTCOUNT(Fato\_Vendas\[NotaFiscal])
```
Contagem de notas fiscais distintas — usada como proxy do número de vendas realizadas.
Ticket Médio
```DAX
Ticket Médio = DIVIDE(\[Valor Vendas], \[Qtd Notas Fiscais])
```
Valor médio por venda. Optei por `DIVIDE` em vez do operador `/` porque a função já trata o caso de divisão por zero.
---
Sprint AC2 — Vendedores
% Participação Vendedor
```DAX
% Participação Vendedor = DIVIDE(\[Valor Vendas], CALCULATE(\[Valor Vendas], ALL(Dim\_Vendedor)))
```
Calcula a fatia, em porcentagem, que cada vendedor representa do total vendido pela empresa. O `CALCULATE` com `ALL(Dim\_Vendedor)` remove o filtro de vendedor só no denominador, mantendo o total geral como referência.
Ranking Vendedor
```DAX
Ranking Vendedor = RANKX(ALL(Dim\_Vendedor\[Vendedor]), \[Valor Vendas],, DESC)
```
Ordena os vendedores do que mais vendeu para o que menos vendeu. Usei essa medida em conjunto com o gráfico de ranking e a matriz Supervisor → Vendedor da página "Vendedores".
---
Sprint AC3 — Produtos e Margem
Custo Total
```DAX
Custo Total = SUMX(Fato\_Vendas, Fato\_Vendas\[Quantidade] \* RELATED(Dim\_Produto\[CustoUnitario]))
```
Segue a mesma lógica de Valor Vendas, mas usando o custo unitário do produto (`RELATED` busca esse valor na tabela Dim_Produto) em vez do preço de venda — representa quanto a empresa gastou nos produtos vendidos.
Margem
```DAX
Margem = \[Valor Vendas] - \[Custo Total]
```
Lucro bruto: valor vendido menos o custo dos produtos.
% Margem
```DAX
% Margem = DIVIDE(\[Margem], \[Valor Vendas])
```
Percentual do valor vendido que se converteu em lucro. Usei essa medida no TreeMap e nos cartões de KPI da página "Produtos e Margem".
Recursos configurados sem DAX (AC3)
Matriz de rentabilidade: matriz Linha > Grupo de produto com Valor Vendas, Custo Total, Margem e % Margem, com formatação condicional de cor em % Margem.
Drill-through: página "Detalhe do Produto", acessada a partir da tabela dos 10 maiores produtos por Valor Vendas (filtro N Superior).
---
Entrega Final — Painel Executivo
Vendas Mês Anterior
```DAX
Vendas Mês Anterior = CALCULATE(\[Valor Vendas], DATEADD(Dim\_Data\[Data], -1, MONTH))
```
Reaproveita a medida Valor Vendas, deslocando o filtro de data um mês para trás (`DATEADD`). Depende da Dim_Data estar marcada como tabela de datas.
Variação % Mensal
```DAX
Variação % Mensal = DIVIDE(\[Valor Vendas] - \[Vendas Mês Anterior], \[Vendas Mês Anterior])
```
Crescimento (ou queda) percentual em relação ao mês anterior. Janeiro aparece em branco porque a base não tem dezembro de 2018, e o `DIVIDE` evita o erro de divisão por zero.
Receita Acumulada
```DAX
Receita Acumulada = CALCULATE(\[Valor Vendas], DATESYTD(Dim\_Data\[Data]))
```
Soma acumulada do início do ano até a data de cada ponto do gráfico.
Métrica (parâmetro de campo)
Criado em Modelagem > Novo parâmetro > Campos. O Power BI gera a tabela automaticamente, com um código parecido com este:
```DAX
Métrica = {
    ("Valor Vendas", NAMEOF('Fato\_Vendas'\[Valor Vendas]), 0),
    ("Margem", NAMEOF('Fato\_Vendas'\[Margem]), 1),
    ("Ticket Médio", NAMEOF('Fato\_Vendas'\[Ticket Médio]), 2),
    ("Quantidade Vendida", NAMEOF('Fato\_Vendas'\[Quantidade Vendida]), 3)
}
```
Permite ao usuário escolher, por uma segmentação, qual medida o gráfico exibe. O nome da tabela entre aspas depende de onde as medidas foram criadas no modelo.
Recursos configurados sem DAX (Final)
Navegação: navegador de páginas (Inserir > Botões > Navegador) copiado em todas as páginas, mais um indicador (bookmark) com filtro de supervisor acionado por botão.
Identidade visual: tema importado de arquivo JSON, com revisão dos títulos e das dicas de ferramenta.
