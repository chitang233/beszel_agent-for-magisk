#!/usr/bin/env bash

rm beszel_agent-for-magisk.zip 2>/dev/null
# rm -rf beszel
git clone --depth=1 https://github.com/henrygd/beszel.git
pushd beszel/beszel
go mod tidy
mkdir -p output
GOOS=linux GOARCH=arm64 go build -v -o output/arm64 -ldflags "-w -s" beszel/cmd/agent
GOOS=linux GOARCH=arm go build -v -o output/arm -ldflags "-w -s" beszel/cmd/agent
GOOS=linux GOARCH=amd64 go build -v -o output/x64 -ldflags "-w -s" beszel/cmd/agent
popd

mkdir -p module/beszel/bin
mv beszel/beszel/output/* module/beszel/bin/

beszel_version=$(module/beszel/bin/x64 version | sed 's/beszel-agent //')
sed -i "s/AGENT_VERSION/${beszel_version}/g" module/module.prop

versionCode=$(git rev-list --count --all)
sed -i "s/VERSION_CODE/${versionCode}/g" module/module.prop

pushd module
zip -r ../beszel_agent-for-magisk.zip .
popd

sed -i "s/${beszel_version}/AGENT_VERSION/g" module/module.prop