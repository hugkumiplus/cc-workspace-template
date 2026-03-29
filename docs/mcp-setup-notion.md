# Notion MCP セットアップガイド

Claude CodeからNotionのページやデータベースを操作できます。

## セットアップ

```bash
claude mcp add-json notion '{"type":"http","url":"https://mcp.notion.com/mcp"}'
```

> HTTP方式（リモートMCP）を使用。npm/Node.js不要、ブラウザ認証のみで接続できます。

## 認証手順

1. Claude Code で `/mcp` を実行
2. Notion の MCP サーバーで「Authenticate」を選択
3. ブラウザが開くので、Notionにログインして認可
4. アクセスを許可するページ/DBを選択
5. 「Authentication successful」と表示されたら完了

## できること

| 機能 | 説明 |
|------|------|
| ページ読み取り | URLを渡してページ内容を取得 |
| ページ更新 | ページの内容を更新（確認あり） |
| DB操作 | データベースのクエリ・ページ作成 |
| コメント取得 | ページのコメントを読み取り |

## 使い方の例

```
「このページの内容を要約して: https://notion.so/xxx」
「タスク.dbに新しいタスクを追加して: https://notion.so/xxx」（確認あり）
「このプロジェクトの進捗をまとめて: https://notion.so/xxx」
```

## セキュリティルール

- **全文検索（search）は使わない** — settings.json で deny 設定済み
- **URLを渡して操作する** — 「Notionの中を全部見て」とは言わない
- **書き込み前に必ず確認** — 変更内容をユーザーに提示してから実行
- **共有DBへの書き込みは特に慎重に** — 他メンバーに影響する

## FAQ

- **npm不要。** HTTP方式なのでNode.jsのインストールは不要
- OAuth認証で許可したページ/DBのみアクセス可能
- 認証トークンはmacOSキーチェーンに安全に保存される
