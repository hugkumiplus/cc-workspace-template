# CC Workspace Template

Claude Code を活用するための汎用ワークスペーステンプレートです。
チームでの業務効率化を目的とし、セキュリティガイドライン・汎用スキル・スキル共有の仕組みを含みます。

## このリポジトリでできること

- Claude Code のセキュリティ設定が最初から適用される
- 議事録作成・報告書作成・データ分析などの汎用スキルがすぐ使える
- 自分だけのスキルを作って、チームと共有できる

---

## セットアップ手順（初めての方向け）

### 前提条件

- Claude Code がインストール済みであること
- ターミナル（コマンドプロンプト）が使えること

### Step 1: Git のインストール確認

ターミナルを開いて、以下を実行してください：

```bash
git --version
```

バージョン番号が表示されればOKです。
表示されない場合は [Git公式サイト](https://git-scm.com/) からインストールしてください。

### Step 2: リポジトリのクローン（コピー）

「クローン」とは、GitHub上のファイル一式を自分のPCにコピーすることです。

```bash
# 作業フォルダに移動（例: デスクトップ）
cd ~/Desktop

# リポジトリをクローン
git clone https://github.com/YOUR_USERNAME/cc-workspace-template.git

# クローンしたフォルダに移動
cd cc-workspace-template
```

> **補足**: `git clone` は「ダウンロード」と似ていますが、変更履歴も一緒にコピーされます。
> これにより、後から最新版に更新したり、自分の変更を共有したりできます。

### Step 3: Claude Code で開く

```bash
claude
```

これだけで、セキュリティ設定とスキルが適用された状態で Claude Code が起動します。

### Step 4: スキルを使ってみる

```
> /meeting-notes
> /report
> /data-analysis
> /review
> /task
```

---

## 最新版への更新（フェッチ & プル）

テンプレートが更新されたら、以下で最新版を取得できます：

```bash
# 最新の変更情報を確認（まだ適用しない）
git fetch origin

# 変更を適用
git pull origin main
```

> **補足**:
> - `git fetch` = 「新しい郵便が届いてるか郵便受けを見に行く」（中身はまだ開けない）
> - `git pull` = 「届いた郵便を開けて中身を取り出す」（実際にファイルが更新される）

---

## フォルダ構成

```
cc-workspace-template/
├── README.md              ← このファイル
├── CLAUDE.md              ← Claude Code への指示・セキュリティルール
├── .claude/
│   └── settings.json      ← セキュリティ技術設定
├── skills/                ← 汎用スキル
│   ├── meeting-notes/     ← 議事録作成スキル
│   ├── report-writer/     ← 報告書作成スキル
│   ├── data-analysis/     ← データ分析スキル
│   ├── document-review/   ← 文書校正スキル
│   └── task-manager/      ← タスク管理スキル
├── templates/
│   └── skill-template/    ← スキル作成用テンプレート
├── community-skills/      ← コミュニティ共有スキルのインデックス
└── docs/
    ├── SETUP_GUIDE.md     ← 詳細セットアップガイド
    ├── SECURITY_POLICY.md ← セキュリティポリシー詳細
    └── SKILL_SHARING_GUIDE.md ← スキル共有ガイド
```

---

## スキルの共有について

自分で作ったスキルをチームと共有する方法は [docs/SKILL_SHARING_GUIDE.md](docs/SKILL_SHARING_GUIDE.md) を参照してください。

## セキュリティについて

このテンプレートには業務利用に適したセキュリティ設定が含まれています。
詳細は [docs/SECURITY_POLICY.md](docs/SECURITY_POLICY.md) を参照してください。

---

## ライセンス

MIT License