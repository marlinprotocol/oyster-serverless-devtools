# oyster-serverless-devtools

This repository contains helper tools for devlopers who wish to develop applications using Oyster Serverless

## Test serverless JS function locally

<b>Create docker image for local test server</b>

Note that, above Dockerfile accepts `TARGETARCH` as build argument which determines the target cpu. Valid values for `TARGETARCH` are `amd64`and `arm64`. Following is the sample command:

```bash
docker image build -t tester:latest --build-arg TARGETARCH=amd64 .
```

<b>Run local test server</b>

```bash
chmod +x mock_serverless.sh
sudo ./mock_serverless.sh 8090 <path-to-js-file>
```

<b> Perform the test call </b>

```bash
curl http://0:8090/ -v -d '{"num": 60000}'
```