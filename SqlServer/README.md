# Consultas SQL - SQL Server

Pasta de scripts, consultas e rotinas desenvolvidas especificamente para instâncias **Microsoft SQL Server**.

---

## 📁 Estrutura

- **`Banco/`**: Diagnósticos de banco, DMVs de desempenho, fragmentação de índices, reindexação e tarefas administrativas.
- **`Foracesso/`**: Consultas, correções de sequenciais e manutenções do Foracesso em SQL Server.
- **`Forponto/`**: Consultas de espelho de ponto, colaboradores, horários e apurações em SQL Server.

---

## 📑 Scripts Disponíveis

| Subpasta | Script | Tipo | Objetivo |
| :--- | :--- | :--- | :--- |
| `Banco/` | [CONSULTA_FRAGMENTACAO.sql](Banco/CONSULTA_FRAGMENTACAO.sql) | SELECT | Consulta percentual de fragmentação e páginas dos índices via DMV. |
| `Foracesso/` | [CONSULTA_IDENTIFICACAO_FORACESSO.SQL](Foracesso/CONSULTA_IDENTIFICACAO_FORACESSO.SQL) | SELECT | Consultas de identificações/crachás ativos, filtros por padrão, auditorias e duplicidades. |
| `Foracesso/` | [CORRIGIR_SEQUENCIAL_FORACESSONET.sql](Foracesso/CORRIGIR_SEQUENCIAL_FORACESSONET.sql) | DML | Correção e sincronização da tabela `SEQUENCIAL` (elementos 23 e 37). |

---

## 💡 Dicas e Peculiaridades SQL Server

1. **Transações Seguras**:
   - Para scripts de alteração de dados, sempre utilize o bloco:
     ```sql
     BEGIN TRANSACTION;
     -- seus comandos aqui
     -- COMMIT TRANSACTION;
     -- ROLLBACK TRANSACTION;
     ```
2. **Tratamento de Nulos**:
   - Utilize `ISNULL(campo, valor_se_nulo)` ou o padrão ANSI `COALESCE(campo, valor_se_nulo)`.
3. **DMVs e Diagnóstico**:
   - As consultas da pasta `Banco/` utilizam DMVs dinâmicas do SQL Server para apoiar no diagnóstico de lentidão e saúde dos bancos dos clientes.
