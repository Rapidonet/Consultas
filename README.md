# Consultas SQL - Repositório de Suporte e Análise de Software

Repositório centralizado de scripts e consultas SQL para analistas de software, suporte e sustentação de sistemas.

O repositório é categorizado pela arquitetura **Banco de Dados / Sistema**, facilitando a localização rápida durante atendimentos e manutenções.

---

## 📁 Estrutura de Pastas

```text
├── Oracle/
│   ├── Banco/                   # Scripts de manutenção, diagnóstico e utilitários Oracle
│   ├── Foracesso/               # Consultas, correções e rotinas do Foracesso (Oracle)
│   └── Forponto/                # Consultas, horários e rotinas do Forponto (Oracle)
│
├── SqlServer/
│   ├── Banco/                   # Fragmentação de índices, manutenção, tuning e DMVs
│   ├── Foracesso/               # Consultas, correções e rotinas do Foracesso (SQL Server)
│   └── Forponto/                # Consultas e rotinas do Forponto (SQL Server)
│
└── README.md                    # Catálogo centralizado e guia de contribuição
```

---

## 📑 Catálogo de Consultas Disponíveis

### 🟠 Oracle

| Sistema | Script | Tipo | Descrição |
| :--- | :--- | :--- | :--- |
| **Foracesso** | [CORRIGIR_SEQUENCIAL_FORACESSONET.sql](Oracle/Foracesso/CORRIGIR_SEQUENCIAL_FORACESSONET.sql) | DML (`UPDATE`) | Sincroniza a tabela `SEQUENCIAL` com os IDs máximos de `MATRICULADO` (23) e `PESSOA` (37). |
| **Forponto** | [Forponto_Horario.sql](Oracle/Forponto/Forponto_Horario.sql) | `SELECT` | Consulta funcionários, setor e horário vigente, com filtros opcionais para ativos/demitidos. |

Consulte o [README do Oracle](Oracle/README.md) para detalhes específicos.

---

### 🔵 SQL Server

| Sistema | Script | Tipo | Descrição |
| :--- | :--- | :--- | :--- |
| **Banco** | [CONSULTA_FRAGMENTACAO.sql](SqlServer/Banco/CONSULTA_FRAGMENTACAO.sql) | `SELECT` | Retorna percentual de fragmentação e páginas dos índices via DMV `sys.dm_db_index_physical_stats`. |
| **Foracesso** | [CONSULTA_IDENTIFICACAO_FORACESSO.SQL](SqlServer/Foracesso/CONSULTA_IDENTIFICACAO_FORACESSO.SQL) | `SELECT` | Consultas de identificações/crachás ativos, filtros por padrão, auditorias e duplicidades. |
| **Foracesso** | [CORRIGIR_SEQUENCIAL_FORACESSONET.sql](SqlServer/Foracesso/CORRIGIR_SEQUENCIAL_FORACESSONET.sql) | DML (`UPDATE`) | Sincroniza a tabela `SEQUENCIAL` com os IDs máximos de `MATRICULADO` (23) e `PESSOA` (37). |

Consulte o [README do SQL Server](SqlServer/README.md) para detalhes específicos.

---

## 📝 Padrão de Cabeçalho para Novos Scripts

Todo script novo adicionado ao repositório deve conter o seguinte cabeçalho preenchido no início do arquivo:

```sql
/*
=============================================================================
SISTEMA  : [Foracesso / Forponto / Banco / etc.]
BANCO    : [Oracle / SQL Server]
OBJETIVO : [Descrição clara do que o script faz e qual problema resolve]
TIPO     : [SELECT (Leitura) / DML (UPDATE/DELETE - Modifica Dados) / DDL]
CUIDADOS : [Ex: Executar em horário de baixo movimento / Exige COMMIT / Rodar em transação]
PARÂMETROS:
    -- Liste variáveis ou filtros configuráveis, se houver
=============================================================================
*/
```

---

## ⚠️ Boas Práticas para os Analistas

1. **Scripts DML (UPDATE / DELETE)**:
   - **SQL Server**: Sempre encapsular em `BEGIN TRANSACTION; ... COMMIT / ROLLBACK`.
   - **Oracle**: Lembrar que transações são implícitas, sendo necessário executar `COMMIT;` para persistir ou `ROLLBACK;` para cancelar.
2. **Consultas em Produção**:
   - Evitar `SELECT *` desnecessários em tabelas com milhões de registros.
   - Em Oracle, utilizar paginação (`ROWNUM` ou `FETCH FIRST`) ou filtros por empresa/período.
   - Em SQL Server, evitar bloquear tabelas críticas em consultas pesadas (avaliar `WITH (NOLOCK)` apenas em cenários onde leitura suja é tolerada).
