# Controle de Faltas da Escola

Código-fonte do sistema de controle de faltas, abonadas e substituições.

## Arquivos

- `index.html`: aplicação web.
- `supabase-update.sql`: atualização do banco para FOM e padronização de nomes.

## Fluxo recomendado

1. Manter este repositório como **privado** no GitHub.
2. Fazer alterações no código pelo GitHub.
3. Conectar o repositório à Vercel para publicar automaticamente a branch `main`.
4. Executar alterações de banco separadamente no SQL Editor do Supabase.
5. Antes de mudanças maiores, manter uma cópia/exportação do banco e uma versão estável do código.

## Atualização incluída nesta versão

- Sigla `FOM — Formação`.
- Ordenação dos registros por data: mais recente primeiro ou mais antiga primeiro.
- Padronização automática dos nomes de professores, por exemplo:
  - `JOÃO CARLOS DE SOUZA` → `João Carlos de Souza`
  - `maria da silva` → `Maria da Silva`
- Edição de professores.
- Exclusão segura de professores: o cadastro fica inativo para novos lançamentos, preservando o histórico antigo.
- Edição e exclusão de registros de faltas.
- Impressão e exportação respeitando os filtros aplicados.

## Segurança

A chave presente no HTML é a chave **publishable** do Supabase, própria para uso no navegador. Não coloque neste repositório chaves `service_role`, senhas de usuários ou outros segredos administrativos.
