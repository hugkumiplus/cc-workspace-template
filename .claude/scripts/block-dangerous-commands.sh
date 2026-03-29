#!/bin/bash
# 危険なコマンドパターンをブロックするhookスクリプト
# PreToolUse(Bash) で実行される
# exit 0: 許可 / exit 2: ブロック

COMMAND=$(jq -r '.tool_input.command' < /dev/stdin)

BLOCKED_PATTERNS=(
  # === 第1層: 破壊的操作の防止 ===
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

  # === 第2層: コマンド実行前ガード（プロンプトインジェクション対策） ===
  # 動的コード実行
  "eval "
  "exec "
  "source /dev/stdin"
  "bash -c "
  "sh -c "
  "zsh -c "

  # パイプ経由のリモートコード実行
  "curl.*\|.*sh"
  "curl.*\|.*bash"
  "curl.*\|.*python"
  "curl.*\|.*perl"
  "curl.*\|.*ruby"
  "curl.*\|.*node"
  "wget.*\|.*sh"
  "wget.*\|.*bash"
  "wget.*\|.*python"

  # Base64エンコードによる難読化攻撃
  "base64.*-d.*\|.*sh"
  "base64.*--decode.*\|.*sh"
  "base64.*-d.*\|.*bash"
  "base64.*--decode.*\|.*bash"
  "base64.*-d.*\|.*python"
  "echo.*\|.*base64.*-d"

  # Python/Node経由の攻撃
  "python.*-c.*import os"
  "python.*-c.*import subprocess"
  "python.*-c.*import socket"
  "python.*-c.*__import__"
  "python.*-c.*exec("
  "python.*-c.*eval("
  "node.*-e.*require.*child_process"
  "node.*-e.*require.*fs.*writeFile"

  # === 第3層: 情報漏洩の防止 ===
  # システムプロンプト窃取
  "cat.*CLAUDE\.md.*\|.*curl"
  "cat.*CLAUDE\.md.*\|.*nc"
  "cat.*\.claude/.*\|.*curl"

  # 環境変数・機密情報の外部送信
  "env\b.*\|.*curl"
  "printenv.*\|.*curl"
  "echo.*\\\$.*TOKEN.*\|.*curl"
  "echo.*\\\$.*KEY.*\|.*curl"
  "echo.*\\\$.*SECRET.*\|.*curl"
  "echo.*\\\$.*PASSWORD.*\|.*curl"
  "set \|.*curl"

  # リバースシェル
  "bash.*-i.*>&.*/dev/tcp"
  "nc.*-e.*/bin"
  "ncat.*-e"
  "python.*socket.*connect"

  # 外部への機密データ送信
  "curl.*-d.*@.*\.env"
  "curl.*--data.*@.*\.env"
  "curl.*-F.*@.*\.pem"
  "curl.*-F.*@.*\.key"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qiE "$pattern"; then
    echo "セキュリティ: 危険なコマンドパターンを検出しました: $pattern" >&2
    echo "このコマンドは実行できません。安全な代替手段を使ってください。" >&2
    exit 2
  fi
done

exit 0
