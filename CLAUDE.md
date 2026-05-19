## Project Overview

ONLYOFFICE document-server-package — build and packaging system for ONLYOFFICE Docs across multiple platforms: DEB (Debian/Ubuntu), RPM (RHEL/CentOS/Fedora), APT-RPM, Windows EXE (Inno Setup), and TAR archives.

## Tech Stack

GNU Make, M4 macro processor, Bash, Inno Setup (Windows), dpkg/rpmbuild, systemd

## Project Structure

```
Makefile            — Main build system (602 lines)
variables.m4        — M4 build variable definitions
common/documentserver/
  bin/              — Shell/batch/PS1 scripts (M4 templates)
  nginx/            — Nginx config templates (M4)
  systemd/          — systemd service files (M4)
  logrotate/        — Log rotation config
  home/             — Document server home directory
  license/          — License file placeholders
  sudoers/          — Sudoers configuration
common/documentserver-example/  — Example app packaging
deb/template/       — Debian package templates (control, postinst, prerm, etc.)
rpm/                — RPM spec files and templates
apt-rpm/            — APT-RPM spec files
exe/                — Windows installer (Inno Setup scripts, data, nginx configs)
  InnoDependencyInstaller/  — Git submodule for Windows deps
  winsw/            — WinSW XML service configs (AdminPanel, Converter, DocService, Example, Proxy)
  scripts/          — Python helper scripts (e.g. connectionRabbit.py)
```

## Build

```bash
# Build all Linux packages
make all PRODUCT_VERSION=9.2.0 BUILD_NUMBER=1

# Platform-specific builds
make deb PRODUCT_VERSION=9.2.0 BUILD_NUMBER=1        # Debian
make rpm PRODUCT_VERSION=9.2.0 BUILD_NUMBER=1        # RPM
make rpm_aarch64 PRODUCT_VERSION=9.2.0 BUILD_NUMBER=1 # ARM64 RPM
make exe PRODUCT_VERSION=9.2.0 BUILD_NUMBER=1        # Windows
make tar PRODUCT_VERSION=9.2.0 BUILD_NUMBER=1        # TAR archive

# Clean
make clean
```

## Key Patterns

- M4 macro processor generates platform-specific files from `.m4` templates
- Expects binaries in `../build_tools/out/` — does NOT contain DocumentServer source code
- Four editions: Community, Enterprise (-EE), Integration (-IE), Developer (-DE)
- Multi-arch: x86_64, aarch64
- Windows installer uses Inno Setup with InnoDependencyInstaller submodule
- systemd services: ds-converter, ds-docservice, ds-metrics, ds-adminpanel

## Review Focus

**M4 Templates**: Correct macro expansion, variable substitution
**Makefile**: Target dependencies, platform detection, clean builds
**Shell**: postinst/prerm scripts — error handling, idempotency, service management
**Inno Setup**: Windows installer logic, dependency handling, registry operations
**Security**: Package permissions, sudoers config, service user setup
**Dependencies**: Version pinning in control/spec files

## Git Workflow

- **Main branch**: `master`
- **Integration branch**: `develop`
- **Branch naming**: `feature/*`, `bugfix/*`, `hotfix/*`, `release/*`
- **Submodules**: `exe/InnoDependencyInstaller/` — run `git submodule update --init` after clone
