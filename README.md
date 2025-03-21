# 官公需情報検索 LWC コンポーネント

このプロジェクトは、[官公需情報ポータル](https://www.kkj.go.jp/s/) のAPIを利用して、Salesforce Lightning Web Components (LWC) 上で官公需情報を検索および表示するためのコンポーネントです。

## リポジトリ情報
- **リポジトリ名:** gov-kkjsearch-lwc

## 特徴
- 官公需情報ポータルのAPIを利用したデータ取得
- キーワード検索機能
- 取得した情報の一覧表示
- Salesforce環境への簡単な統合

## 環境要件
- Salesforce組織（Developer Edition、Sandbox、Productionなど）
- Lightning Web Components (LWC) に対応したSalesforce環境
- APIアクセスのための適切な認証設定

## インストール
1. **リポジトリのクローン**
   ```sh
   git clone https://github.com/rtoki/gov-kkjsearch-lwc.git
   cd gov-kkjsearch-lwc
   ```

2. **Salesforce CLI (sf) のインストールとログイン**
   ```sh
   sf login org
   ```

3. **コンポーネントのプッシュ（Scratch Orgを使用する場合）**
   ```sh
   sf project deploy start
   ```
   もしくは
   ```sh
   sf force:source:push
   ```

4. **コンポーネントの追加**
   - `官公需情報検索` コンポーネントを対象のLightningページに追加

## 使い方
1. LWCコンポーネントを任意のLightningページに配置
2. 検索バーにキーワードを入力し、検索ボタンをクリック
3. APIを通じて取得した官公需情報が一覧表示される
![image](https://github.com/user-attachments/assets/5334bbb2-540e-4315-8b58-e41332d06721)
4. クリックすると詳細内容がモーダルで表示される
![image](https://github.com/user-attachments/assets/22533071-a2d0-4868-bf9f-1dc6c5afcc98)


## 設定
- API認証キーの設定が必要な場合、適切なカスタムメタデータまたは環境変数に設定してください。
- APIリクエストのパラメータ調整は `官公需情報API.js` 内の `fetchData()` を編集してください。

## 参考情報
- [官公需情報ポータル](https://www.kkj.go.jp/s/)
- [Salesforce Lightning Web Components (LWC) ドキュメント](https://developer.salesforce.com/docs/component-library/overview/components)
- [Salesforce CLI (sf) コマンド](https://developer.salesforce.com/docs/platform/sf-cli/)


