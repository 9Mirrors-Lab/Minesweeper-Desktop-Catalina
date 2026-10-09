#  Minesweeper Desktop (Catalina)

[![macOS](https://img.shields.io/badge/macOS-10.15+-blue.svg)](https://apps.apple.com/us/app/macos-catalina/id1466841314?mt=12)
[![Swift](https://img.shields.io/badge/Swift-5-orange.svg)](https://www.swift.org)
[![License](https://img.shields.io/badge/license-GPL--3.0-green)](LICENSE)

Fork of [cameron-goddard/Minesweeper-Desktop](https://github.com/cameron-goddard/Minesweeper-Desktop) adjusted to run on **macOS Catalina 10.15+**.

A modern Minesweeper clone for the Mac. Classic Minesweeper look, native macOS feel, themes, stats, and custom boards.

## Install (one command)

On a Mac with **Xcode 16.x** installed:

```bash
git clone https://github.com/9Mirrors-Lab/Minesweeper-Desktop-Catalina.git
cd Minesweeper-Desktop-Catalina
chmod +x install.sh
./install.sh
```

That builds a universal app (`arm64` + `x86_64`), copies it to `/Applications/Minesweeper.app`, and launches it.

To run on a **Catalina** machine: build with the script on an Xcode 16 Mac, then copy `/Applications/Minesweeper.app` to the Catalina Mac. Do not try to build on Catalina itself (Xcode 12 is too old for this project). 


<p align="left">
  <img width="300" alt="Beginner Covered" src="https://github.com/user-attachments/assets/bc9e6aef-65cd-4436-b438-3f5d031bc3e6" />
  <img width="398" alt="Intermediate in Progress with Stats" src="https://github.com/user-attachments/assets/29eb5823-8876-43db-b932-5865852b0fc0" />
</p>

## Themes
Themes are fully compatible with [Minesweeper X](https://www.curtisbright.com/msx/) themes. You can download 24 custom themes [here](https://minesweepergame.com/download/minesweeper-x-skins.zip), or browse some more [here](https://mzrg.com/mines/msx/index.html).


<p align="left">
<img width="300" alt="Theme Preview" src="https://github.com/user-attachments/assets/3bbd95f1-4f8d-40c9-8520-de2f398d433d" />
<img width="324" alt="Theme Preview with Settings" src="https://github.com/user-attachments/assets/c0bb703d-d086-4407-a507-d521ce588b3d" />
</p>

## Roadmap
- [x] Full classic gameplay
- [x] Standard board sizes, custom sizes
- [x] Customizable theme system
- [x] [Standard](https://minesweepergame.com/statistics.php) game statistics
- [x] Saving and loading custom boards using the [Minesweeper Board File (mbf) format](https://mzrg.com/js/mine/make_board.html)
- [x] Track high scores
- [ ] Customizable key bindings
- [ ] "Competition mode" for [official rankings](https://minesweepergame.com/ranking-rules.php)

## Catalina (macOS 10.15) build notes

This tree targets **macOS 10.15+** and builds a **universal** (`arm64` + `x86_64`) app so Intel Catalina machines can run it.

**Do not build on the Catalina Mac itself.** Catalina only runs up to Xcode 12, which cannot compile this project. Build on a newer Mac, then copy the `.app` over.

### Build machine
- Use **Xcode 16.x** (supports deployment targets down to macOS 10.13; 10.15 is fine).
- Xcode 27+ on this M4 Mini cannot set `MACOSX_DEPLOYMENT_TARGET` below **12.0**, so it cannot produce a Catalina binary.

### Build command
```bash
xcodebuild build \
  -project Minesweeper.xcodeproj \
  -scheme Minesweeper \
  -configuration Release \
  -destination 'platform=macOS' \
  ARCHS='arm64 x86_64' \
  ONLY_ACTIVE_ARCH=NO \
  MACOSX_DEPLOYMENT_TARGET=10.15 \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO
```

Then copy the built `Minesweeper.app` from DerivedData `Build/Products/Release/` to the Catalina machine (AirDrop, USB, shared folder, etc.) and open it there.

### Dependencies pinned for 10.15
- [Defaults](https://github.com/sindresorhus/Defaults) `7.3.1` (macOS 10.15+)
- [Sparkle](https://github.com/sparkle-project/Sparkle) `2.9.0` (macOS 10.13+)
