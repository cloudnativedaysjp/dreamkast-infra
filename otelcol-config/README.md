# ver. の上げ方

- 以下を確認してリリースされている ver. を把握する
  - https://github.com/open-telemetry/opentelemetry-collector/releases
  - https://github.com/open-telemetry/opentelemetry-collector-contrib/releases
- `Dockerfile` の `OCB_VERSION` を上げる
- `builder-config.yaml` の各モジュールの ver. を上げる
- `make generate-code` で collector のコードを生成する
- git commit し、pull request を作る
