# lanbuf

A simple text buffer for your LAN; a remote copy-paste.

## setup

Run `./setup.sh` to configure the client:

```sh
./setup.sh
```

Add lanbuf to your PATH (add this line to `~/.bashrc` or equivalent):

```sh
# replace this line with your own path:
export LANBUF_PATH=/path/to/lanbuf

export PATH=$PATH:$LANBUF_PATH
```

## usage

Write (from any machine on the LAN):

```sh
$ echo "hello" | lanbuf
```

Read (from any machine on the LAN):

```sh
$ lanbuf
hello
```
