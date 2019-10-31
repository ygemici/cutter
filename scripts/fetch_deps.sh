#!/bin/bash

cd $(dirname "${BASH_SOURCE[0]}")/..
mkdir -p cutter-deps && cd cutter-deps

LINUX_FILE="cutter-deps-linux.tar.gz"
LINUX_MD5=563f5573e8ea2c35c5e293888afe8f15
LINUX_URL=https://github.com/radareorg/cutter-deps/releases/download/v11/cutter-deps-linux.tar.gz

MACOS_FILE="cutter-deps-macos.tar.gz"
MACOS_MD5=c08f7f741454c2fd009668a2ccec560b
MACOS_URL=https://github.com/radareorg/cutter-deps/releases/download/v11/cutter-deps-macos.tar.gz

WIN_FILE="cutter-deps-win.tar.gz"
WIN_MD5=460f234d208e62ad6eb46e53f7878301
WIN_URL=https://github.com/radareorg/cutter-deps/releases/download/v11/cutter-deps-win.tar.gz

if [ "$OS" == "Windows_NT" ]; then
	FILE="${WIN_FILE}"
	MD5="${WIN_MD5}"
	URL="${WIN_URL}"
else
	UNAME_S="$(uname -s)"
	if [ "$UNAME_S" == "Linux" ]; then
		FILE="${LINUX_FILE}"
		MD5="${LINUX_MD5}"
		URL="${LINUX_URL}"
	elif [ "$UNAME_S" == "Darwin" ]; then
		FILE="${MACOS_FILE}"
		MD5="${MACOS_MD5}"
		URL="${MACOS_URL}"
	else
		echo "Unsupported Platform: uname -s => $UNAME_S, \$OS => $OS"
		exit 1
	fi
fi

curl -L "$URL" -o "$FILE" || exit 1

if [ "$UNAME_S" == "Darwin" ]; then
	if [ "$(md5 -r "$FILE")" != "$MD5 $FILE" ]; then \
		echo "MD5 mismatch for file $FILE"; \
		exit 1; \
	else \
	        echo "$FILE OK"; \
	fi
else
	echo "$MD5 $FILE" | md5sum -c - || exit 1
fi

tar -xf "$FILE" || exit 1

if [ -f relocate.sh ]; then
	./relocate.sh || exit 1
fi

