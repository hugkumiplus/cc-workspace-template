#!/bin/bash
# 大きなファイルやデータファイルの読み込み時に警告するhookスクリプト
# PreToolUse(Read) で実行される
# exit 0: 許可 / exit 2: 警告（ブロック）

# サイズ閾値の定義
MAX_FILE_SIZE=1048576    # 1MB（バイト）
DATA_FILE_SIZE=512000    # 500KB（バイト）

# データファイルの拡張子パターン
DATA_EXTENSIONS="csv|xlsx|xls|tsv|json"

# 標準入力からJSON入力を読み取る
INPUT=$(cat /dev/stdin)

# ツール名を取得
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')

# Readツール以外はスキップ
if [ "$TOOL_NAME" != "Read" ]; then
  exit 0
fi

# ファイルパスを取得
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path')

# パスが空またはnullならスキップ
if [ -z "$FILE_PATH" ] || [ "$FILE_PATH" = "null" ]; then
  exit 0
fi

# ファイルが存在しない場合はスキップ（Readツール側でエラーになるため）
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# ファイルサイズを取得（バイト単位）
if [[ "$(uname)" == "Darwin" ]]; then
  # macOS
  FILE_SIZE=$(stat -f%z "$FILE_PATH" 2>/dev/null)
else
  # Linux
  FILE_SIZE=$(stat -c%s "$FILE_PATH" 2>/dev/null)
fi

# サイズ取得に失敗した場合はスキップ
if [ -z "$FILE_SIZE" ]; then
  exit 0
fi

# ファイル拡張子を取得（小文字に変換）
FILE_EXT=$(echo "${FILE_PATH##*.}" | tr '[:upper:]' '[:lower:]')

# 1MB超のファイルに対する警告
if [ "$FILE_SIZE" -gt "$MAX_FILE_SIZE" ]; then
  # サイズをMB単位で計算（小数点1桁）
  SIZE_MB=$(awk "BEGIN {printf \"%.1f\", $FILE_SIZE / 1048576}")
  echo "警告: 大きなファイル（${SIZE_MB}MB）を読み込もうとしています: ${FILE_PATH}" >&2
  echo "生データをそのままAIに投げることは推奨されません。" >&2
  echo "必要な部分だけを抽出するか、要約してから処理してください。" >&2
  exit 2
fi

# データファイル（500KB超）に対する警告
if echo "$FILE_EXT" | grep -qE "^(${DATA_EXTENSIONS})$"; then
  if [ "$FILE_SIZE" -gt "$DATA_FILE_SIZE" ]; then
    echo "警告: データファイル（.${FILE_EXT}）の直接読み込みは注意が必要です。" >&2
    echo "個人情報が含まれていないか確認してください。" >&2
    exit 2
  fi
fi

# 問題なし：読み込みを許可
exit 0
