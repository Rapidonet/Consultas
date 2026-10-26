/*
=============================================================================
SISTEMA  : Forponto
BANCO    : Oracle
OBJETIVO : Consultar colaboradores com seus respectivos horários vigentes e setores.
           Permite filtrar por status (ativos/demitidos) e matrícula.
TIPO     : SELECT (Leitura)
CUIDADOS : Nenhum (consulta apenas leitura). Para bases grandes com muitos 
           demitidos, utilizar filtros por matrícula ou empresa se necessário.
=============================================================================
*/

SELECT 
    F.DFFUNCRACHA AS "MATRICULA",
    F.DFFUNNOME   AS "NOME",
    F.DFORGCODIGO || ' - ' || O.DFORGDESCRICAO AS "SETOR",
    FH.DFHORCODIGO || ' - ' || H.DFHORDESCRICAO AS "HORARIO"
FROM PFUNFPTO F
INNER JOIN PFUHFPTO FH 
    ON F.DFFUNCRACHA = FH.DFFUNCRACHA 
   AND F.DFEPSCODIGO = FH.DFEPSCODIGO 
   AND FH.DFFUHTERMINO = TO_DATE('29991231', 'YYYYMMDD')
INNER JOIN PORGFPTO O 
    ON F.DFORGCODIGO = O.DFORGCODIGO 
   AND F.DFEPSCODIGO = O.DFEPSCODIGO 
INNER JOIN PHORFPTO H 
    ON FH.DFHORCODIGO = H.DFHORCODIGO 
   AND FH.DFEPSCODIGO = H.DFEPSCODIGO
-- DESCOMENTAR A LINHA ABAIXO PARA USAR O FILTRO:
-- WHERE F.DFFUNDATADEMISSAO = TO_DATE('18991230', 'YYYYMMDD') -- Apenas Ativos
-- WHERE F.DFFUNDATADEMISSAO > TO_DATE('18991230', 'YYYYMMDD') -- Apenas Demitidos
-- WHERE TRUNC(F.DFFUNCRACHA) = 58456                         -- Matrícula específica
;