#!/usr/bin/env bash
# One-command deploy: push to team repo (source of truth) + Lovaber mirror (triggers Netlify)
# Usage: ./deploy.sh "commit message"
#
# Auth: uses $GITHUB_TOKEN if set, otherwise falls back to your configured git credentials
# (credential helper / SSH). Generate a token at github.com/settings/tokens/new (scope: repo).
set -e

TEAM_REPO="github.com/hariharansamgenai-web/c35-personal-health-manager.git"
MIRROR_REPO="github.com/Lovaber/Personal-Health-Manager.git"

git add -A
[ -n "$1" ] && git commit -m "$1" || echo "(no commit message — pushing existing commits)"

if [ -n "$GITHUB_TOKEN" ]; then
  echo "→ using GITHUB_TOKEN"
  git push "https://${GITHUB_TOKEN}@${TEAM_REPO}" HEAD:BranchBabu
  git push "https://${GITHUB_TOKEN}@${MIRROR_REPO}" HEAD:main
else
  echo "→ using your configured git credentials"
  git push "https://${TEAM_REPO}" HEAD:BranchBabu
  git push "https://${MIRROR_REPO}" HEAD:main
fi

echo ""
echo "✓ Pushed both remotes. Netlify rebuild: ~25s"
echo "✓ Deploys: https://app.netlify.com/projects/pulsepath-aiap/deploys"
echo "✓ Live:    https://pulsepath-aiap.netlify.app"
