# suBinder
このリポジトリはsuBinderのバックエンドです。  
[フロントエンドのリポジトリはこちら](https://github.com/Pankun-coder/suBinder_frontend "フロントエンドのリポジトリ")
## 概要

[https://www.sub-binder.com](https://www.sub-binder.com "サイトURL")  

![ランディングページ](https://github.com/Pankun-coder/github-images/blob/main/suBinder/screenshots/pc_landing-page.png)
趣味の教室運営向けに作った、生徒の予約、進捗状況を管理できるアプリです。  
教室登録・ユーザー登録をすると、

- 教室への生徒の追加
- 予約可能枠の追加
- 講座の追加
- 予約可能枠への生徒の追加(予約)
- 生徒への講座の追加(受講登録)
- 生徒の講座の進捗状況の登録
  <br>
  <br>

ができます。  
[スクリーンショット一覧](https://github.com/Pankun-coder/github-images/tree/main/suBinder/screenshots "スクリーンショット一覧")
<br>
<br>


## ポイント
- 生徒の予約情報・進捗情報を同一のページにまとめ、擬似的なタブによって切り替える方式にしました。  
  - 別々のページに配置するよりも直感的なUIになったと思います。
- 入力情報はフロントエンド/バックエンド両方でバリデーションするようにしました。
  - 不必要な通信を減らすことができました。
- 教室(グループ)を作成した後のユーザー登録の際、直前に作成したグループのIDを自動入力するようにしました。
  - セットアップの際教室とユーザーの両方を作成する必要があるため、少しでも手間を減らす必要があると考えました。
- useSWRを使い、フォーカスされるたびにログイン状態をチェックするようにしました。
  - データを入力した後にログイン状態が切れていたことに気づいて全て入力し直し、という状況を避けることができます。
<br>
<br>


## インフラ構成
![インフラ構成図](https://github.com/Pankun-coder/github-images/blob/main/suBinder/infrastructures.png)
Github Actionsを用いて、mainブランチへ更新があるとFargateに自動的にデプロイされるようにしました。
<br>
<br>

## 使用技術
- インフラ
  - docker 20.10.12
- フロントエンド
  - Next 12.1.6
  - React 18.1.0
  - tailwindcss 3.1.4
  - react-hook-form 7.34.2
  - swr 1.3.0
  - eslint 8.17.0
  - prettier 2.7.1
  - jest 28.1.3
- バックエンド
  - rails 7.0.3
  - puma 5.6.4
  - bcrypt 3.1.18
  - rack-cors 1.1.1
  - rubocop 1.32.0
  - rubocop-rails 2.15.2
- データベース
  - mysql 8.0.28
<br>
<br>

## 機能・非機能
### 機能
- 教室登録
- ユーザー登録・ログイン
- 生徒登録
- 予約可能枠登録
  - 生徒の予約登録
  - 予約キャンセル
- 講座登録
  - 生徒の受講登録
  - 生徒の進捗登録
### 非機能
- フロントエンド
  - Jest
    - ユーザー登録ページ・教室登録ページ・ログインページに対する単体テスト
- バックエンド
  - minitest
    - 各モデルへのバリデーションテスト
