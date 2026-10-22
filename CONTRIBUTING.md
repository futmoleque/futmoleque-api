# Como contribuir

Padrões do FutMoleque. Valem para o `futmoleque-api` e o `futmoleque-app`.

## Regras do projeto

- Projeto paralelo: use só a conta GitHub e a conta Jira do projeto, nunca as da empresa.
- Os repositórios são públicos: nada de senha, chave, token ou arquivo `.env` no código.
- Chave do Jira: `SCRUM`. Todo trabalho começa num card.

## Fluxo de trabalho

1. Atualize a main: `git switch main && git pull`
2. Crie a branch do card: `git switch -c feature/SCRUM-123-descricao-curta`
3. Faça commits pequenos no padrão abaixo.
4. Envie a branch: `git push -u origin HEAD`
5. Abra o PR para a `main`. O template já vem preenchido para completar.
6. Espere o check **Validar PR** ficar verde e a aprovação.
7. Faça **Squash and merge**. A branch é apagada sozinha.

## Nome da branch

`tipo/SCRUM-123-descricao-curta`: tudo minúsculo, palavras separadas por hífen, sem acento.

| Tipo | Quando usar |
|---|---|
| `feature/` | Funcionalidade nova |
| `fix/` | Correção de bug |
| `hotfix/` | Correção urgente em produção |
| `chore/` | Manutenção, configuração |
| `docs/` | Documentação |
| `refactor/` | Mudança de código sem mudar comportamento |
| `test/` | Testes |

## Mensagem de commit e título do PR (Conventional Commits)

`tipo: SCRUM-123 descrição` ou `tipo(escopo): SCRUM-123 descrição`

Tipos: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`, `perf`, `build`, `ci`, `revert`.
Para mudança que quebra compatibilidade, use `!` antes dos dois-pontos: `feat!: SCRUM-80 ...`.

Exemplos:

- `feat: SCRUM-45 cria tela de login`
- `fix(auth): SCRUM-52 corrige expiração do refresh token`
- `docs: SCRUM-1 atualiza o README`

O título do PR vira o único commit na main (squash). Por isso ele precisa ter a mesma chave do nome da branch.

## O que é conferido automaticamente

| Onde | O quê |
|---|---|
| No seu PC (hook `commit-msg`) | A mensagem de cada commit. Ative uma vez por clone: `git config core.hooksPath .githooks` |
| No PR (check **Validar PR**) | O nome da branch, o título do PR e se os dois têm a mesma chave |
| Na main (regras do GitHub) | Só entra por PR, com o check verde, 1 aprovação, conversas resolvidas e squash. Ninguém faz push direto, força push ou apaga a main |
