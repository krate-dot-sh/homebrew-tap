# Homebrew Tap for krate

Micro-VM engine for developer workload isolation.

## Install

```sh
brew install krate-dot-sh/tap/krate
```

## Usage

```sh
krate run alpine:latest
```

## Manage the daemon

```sh
brew services start krate    # start anvild
brew services stop krate     # stop anvild
brew services restart krate  # restart after upgrade
```
