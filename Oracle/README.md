# Consultas SQL - Oracle

Pasta de scripts, consultas e rotinas desenvolvidas especificamente para instâncias **Oracle Database**.

---

## 📁 Estrutura

- **`Banco/`**: Diagnósticos de banco, sessões, bloqueios (locks), tablespaces e manutenção de base.
- **`Foracesso/`**: Consultas, correções de sequenciais e manutenções do Foracesso em Oracle.
- **`Forponto/`**: Consultas de espelho de ponto, colaboradores, horários e apurações em Oracle.

---

## 📑 Scripts Disponíveis

| Subpasta | Script | Tipo | Objetivo |
| :--- | :--- | :--- | :--- |
| `Foracesso/` | [CORRIGIR_SEQUENCIAL_FORACESSONET.sql](Foracesso/CORRIGIR_SEQUENCIAL_FORACESSONET.sql) | DML | Correção e sincronização da tabela `SEQUENCIAL` (elementos 23 e 37). |
| `Forponto/` | [Forponto_Horario.sql](Forponto/Forponto_Horario.sql) | SELECT | Consulta colaboradores, setor e horário vigente com filtros de demissão e matrícula. |

---

## 💡 Dicas e Peculiaridades Oracle

1. **Transações Implícitas**:
   - Comandos `UPDATE`, `INSERT` e `DELETE` **não** são confirmados automaticamente.
   - Sempre finalize com `COMMIT;` para salvar ou `ROLLBACK;` para descartar.
2. **Tratamento de Nulos**:
   - Em Oracle, utilize `NVL(campo, 0)` em vez de `ISNULL`.
3. **Datas**:
   - Sempre utilize `TO_DATE('YYYYMMDD', 'YYYYMMDD')` ou `TO_DATE('DD/MM/YYYY', 'DD/MM/YYYY')` para evitar erros de formato `NLS_DATE_FORMAT`.
