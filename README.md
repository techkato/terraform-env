# terraform構築

作成日時: 2022年2月5日 午後 6:32
更新日時: 2022年2月5日 午後 8:12

# Terraform on AWS

## AWS CLI v2 インストール (macOS)

以下のリンクの手順に沿ってインストールする。

[https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2-mac.html](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2-mac.html)

AWS CLI にてIAMユーザーの認証情報を登録しておく。

```bash
$ aws configure --profile example_user
AWS Access Key ID [None]: アクセスキー
AWS Secret Access Key [None]: シークレットキー
Default region name [None]: ap-northeast-1
Default output format [None]: json
```

## tfstateをクラウドに保存できるようにする

terraformでインフラを作成した場合、インフラの状態が保存されたtfstateファイルが生成される。

このファイルはデフォルトでローカルに保存されるため、複数人で開発する場合にはクラウド上に保存することで常に同じ状態を共有することができる。

---

Git管理はだめなのか？

- Terraformを実行した際にtfstateをGitにプッシュし忘れたり、古い状態ファイルを実行してしまう可能性がある。
- 同じ状態ファイルで同時に実行しないようにするロック機能がない。
- 状態ファイルには機密データも含まれるため、無闇に保存するべきでない。

---

## 実装方法

### S3バケット・DynamoDB作成

- variable.tf
- provider.tf
- backend.tf

を作成（各ファイル参照）し、以下のコマンドを実行する。

```bash
$ terraform plan
...
$ terraform apply
...
Enter a value: yes
...
```

## 使用方法

### tfstateをS3バケットに保存する設定

backend.configを作成（名前は何でも良い）

```bash
# s3バケット名
bucket         = "techkato-s3"
# S3 tfstate保存先
key            = "state/terraform.tfstate"
region         = "ap-northeast-1"

# dynamoDB テーブル名
dynamodb_table = "tfstate-lock"
encrypt        = true
```

main.tf（作成したtfファイル）のterraformに以下を追加し、backendにS3を使用することを記述

```bash
terraform {
	backend "s3" {}
}
```

以下のコマンドを実行

```bash
$ terraform init -backend-config=backend.config
```

---

### 参考

[https://takelg.com/terraform-tfstate_manage/](https://takelg.com/terraform-tfstate_manage/)