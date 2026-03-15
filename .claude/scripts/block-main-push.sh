#!/bin/bash
# main/masterブランチへの直接pushをブロックするhookスクリプト
# PreToolUse(Bash) で実行される
# exit 0: 許可 / exit 2: ブロック

COMMAND=$(jq -r '.tool_input.command' < /dev/stdin)

# 管理者チェック: 環境変数 CC_ADMIN=true ならスキップ
if [ "$CC_ADMIN" = "true" ]; then
  exit 0
fi

# git push コマンドでなければスキップ
if ! echo "$COMMAND" | grep -qE "git push"; then
  exit 0
fi

# main/master への直接 push を検出
if echo "$COMMAND" | grep -qE "git push.*(main|master)"; then
  echo "セキュリティ: main/masterブランチへの直接pushはできません。" >&2
  echo "ブランチを切って作業してください: git checkout -b feature/your-branch" >&2
  exit 2
fi

# ブランチ指定なしの git push（現在のブランチがmain/masterの可能性）
if echo "$COMMAND" | grep -qE "^git push$"; then
  CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)
  if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
    echo "セキュリティ: 現在のブランチ($CURRENT_BRANCH)への直接pushはできません。" >&2
    echo "ブランチを切って作業してください: git checkout -b feature/your-branch" >&2
    exit 2
  fi
fi

exit 0
