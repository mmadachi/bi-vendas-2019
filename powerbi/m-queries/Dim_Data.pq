// Consulta: Dim_Data
// Calendário completo cobrindo o período de Fato_Vendas (jan a nov/2019)

let
    DataInicial = #date(2019, 1, 1),
    DataFinal   = #date(2019, 11, 30),
    NumDias     = Duration.Days(DataFinal - DataInicial) + 1,
    ListaDatas  = List.Dates(DataInicial, NumDias, #duration(1,0,0,0)),
    TabelaBase  = Table.FromList(ListaDatas, Splitter.SplitByNothing(), {"Data"}),
    TiposData   = Table.TransformColumnTypes(TabelaBase, {{"Data", type date}}),

    ColAno      = Table.AddColumn(TiposData, "Ano", each Date.Year([Data]), Int64.Type),
    ColMesNum   = Table.AddColumn(ColAno, "MesNum", each Date.Month([Data]), Int64.Type),
    ColNomeMes  = Table.AddColumn(ColMesNum, "NomeMes", each Date.MonthName([Data], "pt-BR"), type text),
    ColTrimestre= Table.AddColumn(ColNomeMes, "Trimestre", each "T" & Text.From(Date.QuarterOfYear([Data])), type text),
    ColDiaMes   = Table.AddColumn(ColTrimestre, "DiaDoMes", each Date.Day([Data]), Int64.Type),
    ColDiaSemNum= Table.AddColumn(ColDiaMes, "DiaSemanaNum", each Date.DayOfWeek([Data], Day.Monday), Int64.Type),
    ColNomeDiaSem = Table.AddColumn(ColDiaSemNum, "NomeDiaSemana", each Date.DayOfWeekName([Data], "pt-BR"), type text),
    ColAnoMes   = Table.AddColumn(ColNomeDiaSem, "AnoMes", each Date.ToText([Data], "yyyy-MM"), type text)
in
    ColAnoMes

// Após carregar: Modelagem > Marcar como Tabela de Datas > coluna [Data].
// Esse passo habilita funções de inteligência de tempo (DATEADD, SAMEPERIODLASTYEAR
// etc.), que pretendo usar nas próximas sprints.
