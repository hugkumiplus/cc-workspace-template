#!/bin/bash
# 機密ファイルへのアクセスをブロックするhookスクリプト
# PreToolUse(Read|Edit|Write) で実行される
# exit 0: 許可 / exit 2: ブロック

INPUT=$(cat /dev/stdin)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')

# ツールに応じてファイルパスを取得
case "$TOOL_NAME" in
  Read)
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path')
    ;;
  Edit)
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path')
    ;;
  Write)
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path')
    ;;
  *)
    exit 0
    ;;
esac

# パスが空ならスキップ
if [ -z "$FILE_PATH" ] || [ "$FILE_PATH" = "null" ]; then
  exit 0
fi

# 機密ファイルパターン
BLOCKED_PATTERNS=(
  '\.env$'
  '\.env\.'
  '/secrets/'
  '\.pem$'
  '\.key$'
  'credentials\.'
  '\.ssh/'
  '\.aws/'
  '\.config/gh/'
  '\.gnupg/'
  '\.kube/'
  '\.docker/config\.json'
  '\.npmrc$'
  '\.pypirc$'
  '\.gem/credentials'
  '\.git-credentials'
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$FILE_PATH" | grep -qE "$pattern"; then
    echo "セキュリティ: 機密ファイルへのアクセスはできません: $FILE_PATH" >&2
    echo "このファイルにはパスワードやAPIキーが含まれている可能性があります。" >&2
    exit 2
  fi
done

exit 0
