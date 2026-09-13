// Consulta: Fato_Vendas
// Fonte: BaseVendas_ModeloPowerBI.xlsx (aba "Fato_Vendas")
//
// Nesta sprint (AC1), parti da planilha já consolidada — as 11 abas mensais
// originais (BaseVendasCompleta.xlsx) foram empilhadas e a coluna de data
// unificada previamente. Deixei comentado, abaixo, o caminho alternativo
// para quem for reproduzir o processo a partir do arquivo bruto.

let
    Origem = Excel.Workbook(File.Contents("BaseVendas_ModeloPowerBI.xlsx"), null, true),
    Fato_Vendas_Tabela = Origem{[Item="Fato_Vendas", Kind="Table"]}[Data],

    TiposAlterados = Table.TransformColumnTypes(Fato_Vendas_Tabela, {
        {"IDLinha", Int64.Type},
        {"Data", type date},
        {"NotaFiscal", Int64.Type},
        {"cdProduto", Int64.Type},
        {"cdVendedor", Int64.Type},
        {"Quantidade", Int64.Type},
        {"ValorUnitario", type number}
    })
in
    TiposAlterados


// -----------------------------------------------------------------
// Alternativa: construir a partir da planilha ORIGINAL com 11 abas mensais
// (BaseVendasCompleta.xlsx), usando "Anexar Consultas" + conversão de data:
// -----------------------------------------------------------------
//
// let
//     Origem = Excel.Workbook(File.Contents("BaseVendasCompleta.xlsx"), null, true),
//     // Filtra só as abas de mês (ignora eventuais abas auxiliares)
//     AbasMensais = Table.SelectRows(Origem, each List.Contains(
//         {"janeiro","fevereiro","março","abril","maio","junho","julho",
//          "agosto","setembro","outubro","novembro","dezembro"}, [Name])),
//     // Expande e empilha todas as abas em uma única tabela
//     Empilhado = Table.Combine(List.Transform(AbasMensais[Data], each _)),
//
//     // Mapeia nome do mês (texto) para número
//     MesParaNumero = (mes as text) as number =>
//         let
//             mapa = [janeiro=1, fevereiro=2, março=3, abril=4, maio=5, junho=6,
//                     julho=7, agosto=8, setembro=9, outubro=10, novembro=11, dezembro=12]
//         in
//             Record.Field(mapa, mes),
//
//     ColunaMesNum = Table.AddColumn(Empilhado, "MesNum", each MesParaNumero([Mês]), Int64.Type),
//     ColunaData   = Table.AddColumn(ColunaMesNum, "Data",
//                        each #date([Ano], [MesNum], [Dia]), type date)
// in
//     ColunaData
