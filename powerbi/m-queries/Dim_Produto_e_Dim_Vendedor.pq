// Consulta: Dim_Produto
// Fonte: BaseVendas_ModeloPowerBI.xlsx (aba "Dim_Produto")

let
    Origem = Excel.Workbook(File.Contents("BaseVendas_ModeloPowerBI.xlsx"), null, true),
    Dim_Produto_Tabela = Origem{[Item="Dim_Produto", Kind="Table"]}[Data],
    TiposAlterados = Table.TransformColumnTypes(Dim_Produto_Tabela, {
        {"cdProduto", Int64.Type},
        {"GrupoProduto", type text},
        {"LinhaProduto", type text},
        {"Fornecedor", type text},
        {"CustoUnitario", type number}
    })
in
    TiposAlterados


// -----------------------------------------------------------------
// Consulta: Dim_Vendedor
// Fonte: BaseVendas_ModeloPowerBI.xlsx (aba "Dim_Vendedor")
// -----------------------------------------------------------------

let
    Origem2 = Excel.Workbook(File.Contents("BaseVendas_ModeloPowerBI.xlsx"), null, true),
    Dim_Vendedor_Tabela = Origem2{[Item="Dim_Vendedor", Kind="Table"]}[Data],
    TiposAlterados2 = Table.TransformColumnTypes(Dim_Vendedor_Tabela, {
        {"cdVendedor", Int64.Type},
        {"Vendedor", type text},
        {"Supervisor", type text}
    })
in
    TiposAlterados2
