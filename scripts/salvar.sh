#!/bin/sh
# git salvar "tipo: SCRUM-123 descrição"
#
# Rotina de commit do FutMoleque enquanto só 1 dev trabalha: tudo direto na main.
# Ordem: confere branch, conta, hook e segredos -> git add -> git commit
#        (o hook confere a mensagem) -> git pull --rebase -> git push.
#
# Ativar uma vez em cada clone:
#   git config alias.salvar '!sh scripts/salvar.sh'
#   git config pull.rebase true

ORG="futmoleque"
MSG="$1"

falha() {
  printf '\n  %s\n' "$1" >&2
  [ -n "$2" ] && printf '  %s\n' "$2" >&2
  printf '\n' >&2
  exit 1
}

[ -n "$MSG" ] || falha 'Faltou a mensagem do commit.' 'Use: git salvar "feat: SCRUM-123 descrição"'

ramo=$(git rev-parse --abbrev-ref HEAD) || exit 1
[ "$ramo" = "main" ] || falha "Você está na branch $ramo. Por enquanto tudo vai direto na main." 'Volte com: git switch main'

email=$(git config user.email)
case "$email" in
  *@users.noreply.github.com) ;;
  *) falha "O e-mail deste repositório é \"$email\" (precisa ser o noreply da conta paralela)." 'Corrija com: git config user.email "NUMERO+USUARIO@users.noreply.github.com"' ;;
esac

origem=$(git config --get remote.origin.url)
case "$origem" in
  https://*@github.com/$ORG/*) ;;
  *) falha "O endereço do repositório não tem o login da conta paralela: $origem" "Corrija com: git remote set-url origin https://USUARIO@github.com/$ORG/NOME-DO-REPOSITORIO.git" ;;
esac

[ "$(git config core.hooksPath)" = ".githooks" ] || falha 'O hook que confere a mensagem está desligado.' 'Ligue com: git config core.hooksPath .githooks'

git add -A

if git diff --cached --quiet; then
  printf '\n  Nada para salvar: nenhum arquivo mudou.\n\n'
  exit 0
fi

# Segredos: o repositório é público
suspeitos=$(git diff --cached --name-only \
  | grep -Ei '(^|/)\.env(\..+)?$|\.(pem|key|pfx|p12|p8|jks|keystore)$|(^|/)secrets\.json$' \
  | grep -v '\.env\.example$')
if [ -n "$suspeitos" ]; then
  git reset -q
  falha "Arquivo com cara de segredo: $suspeitos" 'O repositório é público. Tire o arquivo ou coloque no .gitignore.'
fi
if git diff --cached -U0 | grep -Eq 'BEGIN [A-Z ]*PRIVATE KEY|ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}'; then
  git reset -q
  falha 'Encontrei algo parecido com chave ou token no código.' 'Tire o segredo antes de salvar (o repositório é público).'
fi

printf '\n  Arquivos deste commit:\n'
git diff --cached --name-status | sed 's/^/    /'
printf '\n'

if ! git commit -q -m "$MSG"; then
  git reset -q
  exit 1
fi

if ! git pull --rebase -q origin main; then
  falha 'Não deu para juntar com o que já estava no GitHub (conflito).' 'Resolva os arquivos marcados, rode git add <arquivo> e git rebase --continue. Depois: git push origin main'
fi

if ! git push origin main; then
  falha 'O GitHub recusou o envio. Veja a mensagem acima.' 'A tabela de erros está no PDF da rotina de commit e no doc claude/git-github-regras.md.'
fi

repo=$(printf '%s' "$origem" | sed -E 's#^https://[^@]+@github\.com/##; s#\.git$##')
printf '\n  Salvo na main: %s\n  https://github.com/%s/commit/%s\n\n' \
  "$(git log -1 --format='%h %s')" "$repo" "$(git rev-parse HEAD)"
