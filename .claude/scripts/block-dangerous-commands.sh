#!/bin/bash
# 危険なコマンドパターンをブロックするhookスクリプト
# PreToolUse(Bash) で実行される
# exit 0: 許可 / exit 2: ブロック

COMMAND=$(jq -r '.tool_input.command' < /dev/stdin)

BLOCKED_PATTERNS=(
  "rm -rf"
  "rm -r -f"
  "rm --recursive --force"
  "rm --force --recursive"
  "dd if=/dev/zero"
  "dd if=/dev/random"
  "dd if=/dev/urandom"
  "mkfs\."
  "chmod 777"
  "chmod -R 777"
  ":(){:|:&};"
  "> /dev/sda"
  "eval "
  "exec "
  "curl.*\|.*sh"
  "curl.*\|.*bash"
  "wget.*\|.*sh"
  "wget.*\|.*bash"
  "base64.*-d.*\|.*sh"
  "base64.*--decode.*\|.*sh"
  "python.*-c.*import os"
  "python.*-c.*import subprocess"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qiE "$pattern"; then
    echo "セキュリティ: 危険なコマンドパターンを検出しました: $pattern" >&2
    echo "このコマンドは実行できません。安全な代替手段を使ってください。" >&2
    exit 2
  fi
done

exit 0
