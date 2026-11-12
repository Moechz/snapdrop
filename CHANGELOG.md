# Changelog

All notable user-visible changes to the Snapdrop TOS application package.

## 1.0.0-1 — 2026-11-12

### Added
- First release. Snapdrop (`linuxserver/snapdrop:version-eac78009`, Docker Hub official image, unmodified)
  packaged as a TOS 7 Docker application, published on port 8117 and running
  as a non-root user (1000:1000).
- Persistent data is kept under `/Volume1/DockerAppData/snapdropdocker/`.
