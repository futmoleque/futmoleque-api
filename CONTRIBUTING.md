# Como contribuir

Padrões do FutMoleque. Valem para o `futmoleque-api` e o `futmoleque-app`.

## Regras do projeto

- Projeto paralelo: use só a conta GitHub e a conta Jira do projeto, nunca as da empresa.
- Os repositórios são públicos: nada de senha, chave, token ou arquivo `.env` no código.
- Chave do Jira: `SCRUM`. Todo commit cita o card.

## Fluxo atual: 1 dev, direto na main

Enquanto só uma pessoa desenvolve, não usamos branch. Cada entrega vai direto na `main` com a rotina `git salvar`.

```bash
git switch main
git pull
# ... trabalhar ...
git salvar "feat: SCRUM-123 descrição"
```

O `git salvar` confere a branch, a conta, o hook e segredos, faz `git add -A`, cria o commit (o hook confere a mensagem), junta com o GitHub (`git pull --rebase`) e envia (`git push`).

Ative uma vez em cada clone:

```bash
git config core.hooksPath .githooks
git config alias.salvar '!sh scripts/salvar.sh'
git config pull.rebase true
```

Ao enviar, o GitHub mostra `remote: Bypassed rule violations for refs/heads/main`. É normal: o admin tem exceção na regra `main-pr`.

## Mensagem de commit (Conventional Commits)

`tipo: SCRUM-123 descrição` ou `tipo(escopo): SCRUM-123 descrição`

Tipos: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`, `perf`, `build`, `ci`, `revert`.
Para mudança que quebra compatibilidade, use `!` antes dos dois-pontos: `feat!: SCRUM-80 ...`.

Exemplos:

- `feat: SCRUM-45 cria tela de login`
- `fix(auth): SCRUM-52 corrige expiração do refresh token`
- `docs: SCRUM-1 atualiza o README`

## O que é conferido automaticamente

| Onde | O quê |
|---|---|
| No PC (`git salvar`) | Está na main, e-mail noreply, endereço com o login da conta paralela, hook ligado, sem arquivo ou chave com cara de segredo |
| No PC (hook `commit-msg`) | A mensagem de cada commit |
| No GitHub (job **Validar commits**) | A mensagem de cada commit que chega na main |
| Na main (regra `main-basico`, vale para todos) | Ninguém apaga a main, ninguém faz force push, histórico linear |
| Na main (regra `main-pr`) | PR com 1 aprovação e check **Validar PR**. Repository admin tem exceção (pode enviar direto) |

## Integração com o Jira

Os dois repositórios estão ligados ao Jira (futmoleque.atlassian.net) pelo app **GitHub for Atlassian**, instalado na organização `futmoleque`.

- Todo commit com a chave do card (`SCRUM-123`, em maiúsculas, como o hook já exige) aparece na aba **Desenvolvimento** desse card logo depois do `git salvar`.
- Branches e PRs também aparecem quando a chave estiver no nome da branch ou no título do PR (fluxo do 2º dev).
- Commits enviados para a main antes da integração não aparecem: o histórico importado pelo app não inclui a branch principal.
- Smart commits (`#comment`, `#time`, `#done`) estão ligados no Jira, mas não fazem efeito aqui: os commits usam o e-mail noreply do GitHub, e o Jira só executa o comando quando o e-mail do commit é o mesmo do login no Jira. Mova o card e lance horas no próprio Jira.

## Quando o 2º dev entrar: fluxo com PR

1. Nos dois repositórios, em Settings › Rules › Rulesets › `main-pr`, troque a exceção do Repository admin de **Always allow** para **For pull requests only** (ou remova). O 2º dev entra com papel **Write**, nunca Admin.
2. A partir daí, todo trabalho vai em branch e PR:
   - Branch: `tipo/SCRUM-123-descricao-curta` (`feature/`, `fix/`, `hotfix/`, `chore/`, `docs/`, `refactor/`, `test/`), minúsculo, com hífens, sem acento.
   - Título do PR: `tipo: SCRUM-123 descrição`, com a mesma chave da branch. Ele vira o commit na main (squash).
   - O check **Validar PR** confere branch e título; o PR precisa de 1 aprovação; merge só por **Squash and merge**.
   - Com a chave na branch e no título, a branch e o PR aparecem sozinhos na aba **Desenvolvimento** do card.
3. O `git salvar` passa a recusar quem não estiver na main; troque-o pelo fluxo de branch.
