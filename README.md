# homebrew-liwu

Homebrew tap for [Liwu](https://liwu.app/?utm_source=github&utm_medium=tap) — menu bar battery charge limiter for Apple Silicon Macs.

```sh
brew install --cask urfreespace/liwu/liwu
```

Requires Apple Silicon (M-series), macOS 26.7 or later for Liwu 2.

Uninstall with `brew uninstall --cask liwu`. Homebrew first quits Liwu and asks its signed app to release charging control and unregister its helper and login item. If cleanup fails, removal stops; keep the app installed and resolve the reported problem before retrying. Preferences and licenses are retained.

Homebrew also runs this cleanup during upgrades and reinstalls. Re-enable **Launch at login** in Liwu afterward if you use it.
