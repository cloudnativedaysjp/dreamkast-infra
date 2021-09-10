# Dreamkast インフラ構築のために知っておくべき話

※構築手順をすぐ見たい場合はこのセクションは飛ばしても構いません。一度は目を通すことを推奨しますが・・・

Dreamkastは主に以下のコンポーネントで構成されています

- AWS(CloudFormation)
    - VPC
        - EKSやRDSを構築するために前提として必要
    - RDS
        - DreamkastではMySQLを使っているため、RDS for MySQLを採用
    - S3
        - 画像などのユーザーコンテンツ保存・配信に利用
    - EKS
        - クラウドネイティブおじさん
    - SQS
        - メール配信に必要

構築の順番に関してはImmutableであるため基本的には順不同ですが、VPCに関してはRDSやEKSが依存するので最初に構築する必要があります。

ただし、EKSについてはVPCのアドレス範囲やサブネットの設定などにいろいろ細かい考慮事項があります。構築にあたっては簡単にでもよいので以下の公式ドキュメントを一度は目を通しておいてください。

Ref. [クラスター VPC に関する考慮事項](https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/network_reqs.html), [Amazon EKS セキュリティグループの考慮事項](https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/sec-group-reqs.html)

EKSが他のKubernetsディストリビューションと違うのはVPCのネットワークがワーカーノードや上で動くワークロード(Pod)にも紐づくという点です。そのため、VPCのアドレス設計、インスタンスタイプによるアタッチ可能なIPアドレスの範囲なども合わせて考慮する必要があります。以下に参考資料をいくつかおいておきます。

Ref. [ポッドネットワーキング (CNI)](https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/pod-networking.html), https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt

# 構築手順

基本的にはCloudFormationをひたすら適用していくだけです。簡単ですね。

RDSについては特に以下の考慮が必要です

1. DBNameのパラメーターはDreamkastのワークロードに環境変数で指定する
2. 適用するMySQLのバージョンはDreamkastのローカル開発でも揃える
3. 本番の接続情報はSecrets Managerで管理されていて、Kubernetes上ではexternal secrets経由で取得する

## CloudFormationのパラメーターについて

基本的に全体で共通で使うパラメーターは`PJPrefix`だけです。ここには`dreamkast-(prd|stg)`といった環境情報が入ります（リソースの生成時に名前の衝突を防ぐため）

## CloudFormationの適用について

新規スタックの場合は迷うことがないと思いますが、インスタンスタイプや数などについてはある程度柔軟に変更できるようにしたほうが良さそうです。細かいパラメーターについてはSlackで相談して決めています。

更新の場合は基本的に変更セットの作成を行っています。自動化までやるモチベがなかったので手動でやってます。CI/CDまでやれる元気がある人は手伝ってください！

## 本番・ステージングで別れているリソースと共通のリソース

### 本番とステージングで別のStackを作っているもの

- VPC
- S3
- EKS(クラスター、ノード両方)
- SQS

### 本番とステージングで同じリソースを共有しているもの

- RDS(クラスターは同じで、DBだけ分けている)
