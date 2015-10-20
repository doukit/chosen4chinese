#!/usr/bin/env bash

# 编译成js,生成的js在lib文件夹里
coffee --compile --output lib/ src/

# 下面的仅用于测试(添加--bare编译参数)
coffee --compile --bare --output example/ src/
