#!/usr/bin/env bash

# 编译成js,生成的js在lib文件夹里
coffee --compile --output lib/ src/

coffee --compile --output example/ src/
