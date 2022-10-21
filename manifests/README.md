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
│   │       ├── production
│   │       │   └── main ... production 環境の各種マニフェスト
│   │       └── staging
│   │           └── main ... staging 環境の各種マニフェスト
│  <snip>
├── application-dev.yaml ... dreamkast-dev-cluster における Argo CD Application の起点
├── application-prd.yaml ... dreamkast-cluster における Argo CD Application の起点
├── argocd ... Argo CD 自体をデプロイするためのマニフェストを管理するディレクトリ
├── argocd-apps
│   ├── dev ... dreamkast-dev-cluster にデプロイされる各種 Application を管理
│   └── prd ... dreamkast-cluster にデプロイされる各種 Application を管理
├── infra ... 各種ミドルウェアをデプロイするためのマニフェストを管理
└── reviewapps ... ArgoCD ApplicationSet より立ち上げられる Review Apps についての設定を管理
```

### Review Apps

[zenn.dev - Argo CD ApplicationSet で実現する Review Apps](https://zenn.dev/kanatakita/articles/reviewapp-with-argocdappset) を参照してください。
