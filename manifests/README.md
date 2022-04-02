# manifests

dreamkast-cluster 及び dreamkast-dev-cluster に適用するためのマニフェスト置き場

### About directories

```
.
├── app ... Dreamkast 関連のマニフェストを管理するディレクトリ
│   ├── argocd-apps
│   │   ├── development ... dreamkast-dev-cluster にデプロイするマニフェストを管理する Argo CD Application 置き場
│   │   └── production  ... dreamkast-cluster にデプロイするマニフェストを管理する Argo CD Application 置き場
│   ├── dreamkast
│   │   ├── base
│   │   └── overlays
│   │       ├── development
│   │       │   ├── template-dk ... cloudnativedaysjp/dreamkast の PR から作成される Review Apps 環境を構築するためのマニフェストのテンプレート
│   │       │   ├── template-ui ...  cloudnativedaysjp/dreamkast-ui の PR から作成される Review Apps 環境を構築するためのマニフェストのテンプレート
│   │       │   └── * ... reviewapp-operator より PR ごとにマニフェストディレクトリが生成される
│   │       ├── production
│   │       │   └── main ... production 環境の各種マニフェスト
│   │       └── staging
│   │           └── main ... staging 環境の各種マニフェスト
│   ├── dreamkast-api-mock
│   ├── dreamkast-releasebot
│   └── maintenance
├── application-dev.yaml ... dreamkast-dev-cluster における Argo CD Application の起点
├── application-prd.yaml ... dreamkast-cluster における Argo CD Application の起点
├── argocd ... Argo CD 自体をデプロイするためのマニフェストを管理するディレクトリ
├── argocd-apps
│   ├── dev ... dreamkast-dev-cluster にデプロイされる各種 Application を管理
│   └── prd ... dreamkast-cluster にデプロイされる各種 Application を管理
├── infra ... 各種ミドルウェアをデプロイするためのマニフェストを管理
└── reviewapps ... reviewapp-operator より立ち上げられる Review Apps についての設定を管理
    ├── argocd-apps
    ├── dreamkast ... cloudnativedaysjp/dreamkast に対する Review Apps の設定
    │   ├── .mt-candidate -> ../../app/dreamkast/overlays/development/template-dk
    │   ├── .mt-stable -> ../../app/dreamkast/overlays/development/template-dk
    │   ├── applicationtemplate.yaml
    │   └── reviewappmanager.yaml
    └── dreamkast-ui ... cloudnativedaysjp/dreamkast-ui に対する Review Apps の設定
        ├── .mt-candidate -> ../../app/dreamkast/overlays/development/template-ui
        ├── .mt-stable -> ../../app/dreamkast/overlays/development/template-ui
        ├── applicationtemplate.yaml
        └── reviewappmanager.yaml
```

### Review Apps

[reviewapp-operator](https://github.com/cloudnativedaysjp/reviewapp-operator) を用いて以下のように Review Apps 環境を動的に作成している。

* [argocd/overlays/dev/argocd-cm.yaml](https://github.com/cloudnativedaysjp/dreamkast-infra/blob/main/manifests/argocd/overlays/dev/argocd-cm.yaml) にて `reviewappctl` Plugin を定義
* [reviewapps/argocd-apps/dreamkast.yaml](https://github.com/cloudnativedaysjp/dreamkast-infra/blob/main/manifests/reviewapps/argocd-apps/dreamkast.yaml) にて source に [reviewapps/dreamkast](https://github.com/cloudnativedaysjp/dreamkast-infra/blob/main/manifests/reviewapps/dreamkast) を, Plugin に `reviewappctl` を指定した `reviewapps-dreamkast` Application リソースを宣言
* `reviewapps-dreamkast` Application が sync されると、 `reviewappctl` Plugin により [app/dreamkast/overlays/development/template-dk](https://github.com/cloudnativedaysjp/dreamkast-infra/tree/main/manifests/app/dreamkast/overlays/development/template-dk) (reviewapps/dreamkast/.mt-stable の symlink 先) を元に ManifestsTemplate リソースが生成され、その ManifestsTemplate を含めた [reviewapps/dreamkast](https://github.com/cloudnativedaysjp/dreamkast-infra/blob/main/manifests/reviewapps/dreamkast) 以下のマニフェストが Kubernetes に適用される
* ReviewAppManager, ApplicationTemplate, ManifestsTemplate がそれぞれ Kubernetes に適用されたことにより reviewapp-operator が [dreamkast](https://github.com/cloudnativedaysjp/dreamkast) リポジトリの監視を開始し、 PR ごとに以下のマニフェストが dreamkast-infra リポジトリに push される
    * ApplicationTemplate オブジェクトを元にした Application リソースのマニフェストが [app/argocd-apps/development](https://github.com/cloudnativedaysjp/dreamkast-infra/tree/main/manifests/app/argocd-apps/development) 以下に配置される
    * ManifestsTemplate オブジェクトを元にした各種マニフェストが [app/dreamkast/overlays/development/](https://github.com/cloudnativedaysjp/dreamkast-infra/tree/main/manifests/app/dreamkast/overlays/development/) 以下に配置される

