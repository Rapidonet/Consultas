/*
=============================================================================
SISTEMA  : ForacessoNet
BANCO    : SQL Server
OBJETIVO : Validar e sincronizar os valores da tabela SEQUENCIAL com os maiores 
           IDs existentes nas tabelas MATRICULADO (23) e PESSOA (37).
           Utilizado para resolver erros de violação de chave primária/duplicidade.
TIPO     : DML (UPDATE - Modifica dados)
CUIDADOS : Sempre executar dentro de uma transação explícita (BEGIN TRAN) 
           e conferir os valores antes do COMMIT.
=============================================================================
*/

-- 1. VALIDAÇÃO DOS VALORES ATUAIS
SELECT 
    'MATRICULADO (Elemento 23)' AS Origem,
    MAX(MATR_ID) AS Maior_ID_Tabela 
FROM FORACESSO.MATRICULADO
UNION ALL
SELECT 
    'PESSOA (Elemento 37)' AS Origem,
    MAX(PESS_ID) AS Maior_ID_Tabela 
FROM FORACESSO.PESSOA;

-- Consulta valor atual na tabela SEQUENCIAL
SELECT 
    SEQUELEMENTO, 
    SEQUVALOR, 
    SEQUDESCRICAO
FROM FORACESSO.SEQUENCIAL
WHERE SEQUELEMENTO IN (23, 37);


-- 2. CORREÇÃO COM TRANSAÇÃO SEGURA
BEGIN TRANSACTION;

UPDATE FORACESSO.SEQUENCIAL
SET SEQUVALOR = CASE 
    WHEN SEQUELEMENTO = 23 THEN (SELECT ISNULL(MAX(MATR_ID), 0) FROM FORACESSO.MATRICULADO)
    WHEN SEQUELEMENTO = 37 THEN (SELECT ISNULL(MAX(PESS_ID), 0) FROM FORACESSO.PESSOA)
END
WHERE SEQUELEMENTO IN (23, 37);

-- 3. CONFERÊNCIA PÓS-UPDATE
SELECT 
    SEQUELEMENTO, 
    SEQUVALOR, 
    SEQUDESCRICAO
FROM FORACESSO.SEQUENCIAL
WHERE SEQUELEMENTO IN (23, 37);

-- Se os valores estiverem corretos, execute o COMMIT:
-- COMMIT TRANSACTION;

-- Se houver divergência, execute o ROLLBACK:
-- ROLLBACK TRANSACTION;
