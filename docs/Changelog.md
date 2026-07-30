# 🌱 MadScienceLa Changelog

This format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses a convention inspired by [Semantic Versioning](https://semver.org/spec/v2.0.0.html) but tracks Ceedling’s version with a letter appendix for Docker image changes.

---

# [1.2.0] Prerelease

ℹ️ Docker images still contain Ceedling 1.1.0.

## 🌟 Added

- Added [BullseyeCoverage](https://www.bullseye.com) tooling to the plugins variants (requires license to activate). This supports the Ceedling Bullseye plugin.

---

# [1.1.2] — 2026-07-27

## 🌟 Added

- Updated Ceedling to 1.1.2 gem

## ⚠️ Changed

- Refactored Github workflows to more smartly create, validate, and publish Docker images.

---

# [1.1.1] — 2026-07-23

## 🌟 Added

- Updated Ceedling to 1.1.1 gem

---

# [1.1.0] — 2026-07-23

## 🌟 Added

- Updated Ceedling to 1.1.0 gem
- Added Valgrind to the plugins variants manifest (previoulsy added but unadvertised)
- Added Cppcheck

## 💪 Fixed

- Fixed container path handling to make all tools available to any user (including `root` user if the container is run with root access).

## ⚠️ Changed

- Updated base image to latest stable `minideb:trixie`
- Changed Ceedling gem installation:
   1. Prefers gems bundled with Ruby rather than getting latest dependencies if version constraints are met.
   1. Disabled RDoc documentation generation that can break builds because of RDoc’s custom Ruby parser failures.