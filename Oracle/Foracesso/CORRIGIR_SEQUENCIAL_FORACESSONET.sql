/*
=============================================================================
SISTEMA  : ForacessoNet
BANCO    : Oracle
OBJETIVO : Validar e sincronizar os valores da tabela SEQUENCIAL com os maiores 
           IDs existentes nas tabelas MATRICULADO (23) e PESSOA (37).
           Utilizado para resolver erros de violação de chave primária/duplicidade (ORA-00001).
TIPO     : DML (UPDATE - Modifica dados)
CUIDADOS : No Oracle, transações são implícitas. Sempre conferir os dados 
           antes de efetivar o COMMIT ou desfazer com ROLLBACK.
=============================================================================
*/

-- 1. VALIDAÇÃO DOS VALORES ATUAIS
SELECT 
    'MATRICULADO (Elemento 23)' AS ORIGEM,
    MAX(MATR_ID) AS MAIOR_ID_TABELA 
FROM FORACESSO.MATRICULADO
UNION ALL
SELECT 
    'PESSOA (Elemento 37)' AS ORIGEM,
    MAX(PESS_ID) AS MAIOR_ID_TABELA 
FROM FORACESSO.PESSOA;

-- Consulta valor atual na tabela SEQUENCIAL
SELECT 
    SEQUELEMENTO, 
    SEQUVALOR, 
    SEQUDESCRICAO
FROM FORACESSO.SEQUENCIAL
WHERE SEQUELEMENTO IN (23, 37);


-- 2. CORREÇÃO
UPDATE FORACESSO.SEQUENCIAL
SET SEQUVALOR = CASE 
    WHEN SEQUELEMENTO = 23 THEN (SELECT NVL(MAX(MATR_ID), 0) FROM FORACESSO.MATRICULADO)
    WHEN SEQUELEMENTO = 37 THEN (SELECT NVL(MAX(PESS_ID), 0) FROM FORACESSO.PESSOA)
END
WHERE SEQUELEMENTO IN (23, 37);


-- 3. CONFERÊNCIA PÓS-UPDATE
SELECT 
    SEQUELEMENTO, 
    SEQUVALOR, 
    SEQUDESCRICAO
FROM FORACESSO.SEQUENCIAL
WHERE SEQUELEMENTO IN (23, 37);

-- Se os valores estiverem corretos, efetive a gravação:
-- COMMIT;

-- Se houver divergência, desfaça as alterações:
-- ROLLBACK;
