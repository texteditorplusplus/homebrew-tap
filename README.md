# TextEditor++ Homebrew tap

[TextEditor++](https://texteditorplusplus.com/) is a free text editor for Mac for code, very large files, live server logs and text extraction.

## Install

```sh
brew install texteditorplusplus/tap/texteditorplusplus
```

Requires an Apple Silicon Mac running macOS 14 (Sonoma) or later.

## Update

TextEditor++ updates itself. `brew upgrade texteditorplusplus` works too.

## Uninstall

```sh
brew uninstall texteditorplusplus
```

Add `--zap` to also remove settings, caches and session recovery data.

## Maintenance

`.github/workflows/bump.yml` reads the app's update feed every three hours. When a new version is published, it updates the version and checksum in `Casks/texteditorplusplus.rb` on its own.
