# Minesweeper Desktop (Catalina)

macOS Minesweeper that runs on **Catalina 10.15+**.

Forked from [cameron-goddard/Minesweeper-Desktop](https://github.com/cameron-goddard/Minesweeper-Desktop) with deployment and API changes for older macOS.

## Install

Needs a Mac with **Xcode 16.x**:

```bash
git clone https://github.com/9Mirrors-Lab/Minesweeper-Desktop-Catalina.git
cd Minesweeper-Desktop-Catalina
./install.sh
```

This builds a universal app (`arm64` + `x86_64`), installs it to `/Applications/Minesweeper.app`, and opens it.

## Use on a Catalina Mac

1. Run `./install.sh` on the Xcode 16 Mac.
2. Copy `/Applications/Minesweeper.app` to the Catalina Mac.
3. Open the app there.

Do not build on the Catalina Mac. Catalina only supports up to Xcode 12, which cannot compile this project. Xcode 27+ also cannot target macOS 10.15.

## License

GPL-3.0. See [LICENSE](LICENSE).
