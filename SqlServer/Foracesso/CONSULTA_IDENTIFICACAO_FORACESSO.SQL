/*
=============================================================================
SISTEMA  : Foracesso
BANCO    : SQL Server
OBJETIVO : Consultas de credenciais e identificações (crachás, tags, cartões)
           vinculadas a matriculados e pessoas no Foracesso.
           Contém consultas operacionais, auditoria de duplicidade, pessoas sem
           crachá, credenciais ativas em inativos e buscas rápidas por leitora.
TIPO     : SELECT (Leitura)
CUIDADOS : Consultas seguras de leitura. Podem ser executadas em produção.
PARÂMETROS:
    -- @IDTF_CODIGO : Código do crachá/credencial para busca pontual
    -- Padrão LIKE   : Ajustar prefixo para faixas específicas de crachá
=============================================================================
*/

-- =============================================================================
-- 1. IDENTIFICAÇÕES ATIVAS VINCULADAS (GERAL)
--    Retorna todas as pessoas ativas com identificações vigentes.
-- =============================================================================
SELECT
    MAT.MATR_MATRICULA       AS "MATRICULA",
    PES.PESS_NOME            AS "NOME",
    IDM.IDTF_CODIGO          AS "IDENTIFICACAO",
    IDM.IDMT_VALIDADE        AS "VALIDADE"
FROM MATRICULADO MAT
INNER JOIN PESSOA PES ON 
    MAT.PESS_ID = PES.PESS_ID
INNER JOIN IDENTIFICACAO_MATRICULADO IDM ON 
    MAT.MATR_ID = IDM.MATR_ID
WHERE MAT.MATR_ATIVO = 1
  AND (IDM.IDMT_VALIDADE IS NULL OR IDM.IDMT_VALIDADE > GETDATE())
ORDER BY PES.PESS_NOME;


-- =============================================================================
-- 2. IDENTIFICAÇÕES ATIVAS INICIADAS POR PADRÃO ESPECÍFICO (EX: INICIADAS EM '9')
--    Útil para filtrar faixas de visitantes, prestadores ou lotes específicos.
-- =============================================================================
SELECT
    MAT.MATR_MATRICULA       AS "MATRICULA",
    PES.PESS_NOME            AS "NOME",
    IDM.IDTF_CODIGO          AS "IDENTIFICACAO",
    IDM.IDMT_VALIDADE        AS "VALIDADE"
FROM MATRICULADO MAT
INNER JOIN PESSOA PES ON 
    MAT.PESS_ID = PES.PESS_ID
INNER JOIN IDENTIFICACAO_MATRICULADO IDM ON 
    MAT.MATR_ID = IDM.MATR_ID
WHERE MAT.MATR_ATIVO = 1
  AND (IDM.IDMT_VALIDADE IS NULL OR IDM.IDMT_VALIDADE > GETDATE())
  AND IDM.IDTF_CODIGO LIKE '9%' -- Altere o padrão conforme necessidade (ex: '999999%', etc.)
ORDER BY MAT.MATR_MATRICULA;


-- =============================================================================
-- 3. BUSCA RÁPIDA POR CÓDIGO DA LEITORA / CRACHÁ
--    Útil no atendimento quando o equipamento/catraca lê um código desconhecido.
-- =============================================================================
SELECT
    MAT.MATR_MATRICULA       AS "MATRICULA",
    PES.PESS_NOME            AS "NOME",
    IDM.IDTF_CODIGO          AS "IDENTIFICACAO",
    IDM.IDMT_VALIDADE        AS "VALIDADE",
    CASE 
        WHEN MAT.MATR_ATIVO = 1 THEN 'Ativo' 
        ELSE 'Inativo' 
    END                      AS "STATUS_MATRICULA",
    CASE 
        WHEN IDM.IDMT_VALIDADE IS NOT NULL AND IDM.IDMT_VALIDADE <= GETDATE() THEN 'Vencida'
        ELSE 'Válida'
    END                      AS "STATUS_IDENTIFICACAO"
FROM MATRICULADO MAT
INNER JOIN PESSOA PES ON 
    MAT.PESS_ID = PES.PESS_ID
INNER JOIN IDENTIFICACAO_MATRICULADO IDM ON 
    MAT.MATR_ID = IDM.MATR_ID
WHERE IDM.IDTF_CODIGO = 'DIGITE_O_CODIGO_AQUI';


-- =============================================================================
-- 4. MATRICULADOS ATIVOS SEM NENHUMA IDENTIFICAÇÃO VÁLIDA
--    Identifica colaboradores/alunos ativos que estão sem crachá ou com tudo vencido.
-- =============================================================================
SELECT
    MAT.MATR_MATRICULA       AS "MATRICULA",
    PES.PESS_NOME            AS "NOME"
FROM MATRICULADO MAT
INNER JOIN PESSOA PES ON 
    MAT.PESS_ID = PES.PESS_ID
WHERE MAT.MATR_ATIVO = 1
  AND NOT EXISTS (
      SELECT 1 
      FROM IDENTIFICACAO_MATRICULADO IDM
      WHERE IDM.MATR_ID = MAT.MATR_ID
        AND (IDM.IDMT_VALIDADE IS NULL OR IDM.IDMT_VALIDADE > GETDATE())
  )
ORDER BY PES.PESS_NOME;


-- =============================================================================
-- 5. AUDITORIA: IDENTIFICAÇÕES DUPLICADAS (MESMO CÓDIGO VINCULADO A > 1 MATRÍCULA)
--    Gera conflito nas catracas e falha de identificação de evento.
-- =============================================================================
SELECT
    IDM.IDTF_CODIGO                                        AS "IDENTIFICACAO_DUPLICADA",
    COUNT(DISTINCT MAT.MATR_ID)                            AS "QTD_MATRICULAS",
    STRING_AGG(CONVERT(VARCHAR, MAT.MATR_MATRICULA), ', ') AS "MATRICULAS_VINCULADAS"
FROM IDENTIFICACAO_MATRICULADO IDM
INNER JOIN MATRICULADO MAT ON 
    IDM.MATR_ID = MAT.MATR_ID
WHERE (IDM.IDMT_VALIDADE IS NULL OR IDM.IDMT_VALIDADE > GETDATE())
GROUP BY IDM.IDTF_CODIGO
HAVING COUNT(DISTINCT MAT.MATR_ID) > 1;

-- =============================================================================
-- 6. MATRICULADOS COM MÚLTIPLAS IDENTIFICAÇÕES ATIVAS
--    Localiza usuários com mais de um crachá/tag simultaneamente ativos.
-- =============================================================================
SELECT
    MAT.MATR_MATRICULA       AS "MATRICULA",
    PES.PESS_NOME            AS "NOME",
    COUNT(IDM.IDTF_CODIGO)   AS "QTD_IDENTIFICACOES_ATIVAS"
FROM MATRICULADO MAT
INNER JOIN PESSOA PES ON 
    MAT.PESS_ID = PES.PESS_ID
INNER JOIN IDENTIFICACAO_MATRICULADO IDM ON 
    MAT.MATR_ID = IDM.MATR_ID
WHERE MAT.MATR_ATIVO = 1
  AND (IDM.IDMT_VALIDADE IS NULL OR IDM.IDMT_VALIDADE > GETDATE())
GROUP BY MAT.MATR_MATRICULA, PES.PESS_NOME
HAVING COUNT(IDM.IDTF_CODIGO) > 1
ORDER BY COUNT(IDM.IDTF_CODIGO) DESC;