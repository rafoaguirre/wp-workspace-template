# wospace CLI - Design & Development Guide

Date: 2026-02-01

## Goals
- Scaffold new WordPress workspaces from the template quickly (`wospace new <name>`).
- Manage lifecycle commands (`build`, `run`, `stop`, `down`, `doctor`, `update`).
- Keep template and CLI decoupled: template versioned in its own repo; CLI fetches a release archive.
- Minimal dependencies for users; predictable, repeatable setup.

## Scope (MVP)
- Commands: new, build, run, stop, down, doctor.
- Template fetch: download tagged release archive (zip/tar.gz) from template repo.
- Post-scaffold customization: rename containers, adjust ports, copy .env.example -> .env.
- Port handling: defaults or auto-offset if conflicts detected.
- Environment checks: Docker, docker-compose, port availability, .env presence.

## Out of Scope (MVP)
- Applying diffs to existing projects (beyond re-fetch/update).
- GUI; package managers beyond basic installers.
- Multi-template catalog.

## Language & Packaging Recommendation
- Primary: Go (single static binary; easy install via GitHub Releases or `go install`).
- Alternates: Node.js (npm global), Python (pipx). Keep design language-agnostic but examples assume Go + Cobra.

## High-Level Architecture
- cmd/cli: Cobra commands (new, build, run, stop, down, doctor, update).
- internal/template:
  - Fetcher: download archive by version.
  - Extractor: unzip/untar into target dir.
  - Customizer: rename container names, set project slug, adjust .env ports.
- internal/check:
  - Docker/compose availability; port checks; .env existence.
- internal/ports:
  - Assign defaults or auto-offset; persist in .env.
- internal/logging:
  - Structured but simple console logs.
- internal/config:
  - CLI config dir (XDG: ~/.config/wospace) storing defaults and latest template version.

## Command Specs (MVP)
- wospace new <project> [--version vX.Y.Z] [--ports 8080,8081,8025,3306]
  - Steps: verify empty dir; fetch template archive; extract; rename containers to <project>-*; copy .env.example->.env; set ports; print next steps.
- wospace build
  - Run `docker-compose build` in CWD; pre-check Docker/compose.
- wospace run
  - Run `docker-compose up -d`; ensure .env exists; optional `--logs` to tail.
- wospace stop
  - Run `docker-compose stop`.
- wospace down [--volumes]
  - Run `docker-compose down` (add -v if requested).
- wospace doctor
  - Checks: Docker running; compose present; required ports free; .env exists; template version in README matches fetched version.
- wospace update [--version vX.Y.Z]
  - Download newer template archive; (MVP) offer to write to new folder to avoid overwriting; future: patching.

## Template Distribution
- Template repo: versioned releases with tar.gz/zip assets.
- CLI default version: latest release; override via flag or config.
- Checksum: publish SHA256 alongside release; verify after download.

## Project Naming & Container Naming
- Project slug = folder name (kebab-case).
- Container names: <slug>-wordpress, -db, -nginx, -phpmyadmin, -wpcli, -mailhog.
- .env ports updated per project; defaults: 8080/8081/8025/3306; auto-offset if conflicts.

## Port Conflict Strategy
- Detect listeners on requested ports.
- If conflict: increment by +2 (8080->8082, 8081->8083, 8025->8027, 3306->3308) until free.
- Persist chosen ports into .env and echo to user.

## UX Notes
- Fail fast with clear remediation steps.
- Dry-run flag for `new` to show what would happen.
- Verbose flag for troubleshooting.
- Colorized output (optional) with plain-text fallback.

## Testing Plan
- Unit tests: port allocator, slug validation, env file writer, downloader checksum.
- Integration (local):
  - wospace new tmp-site (assert structure, container names, .env ports).
  - wospace build/run/stop in a temp dir (requires Docker available in CI or gated).
- Lint/format: gofmt/golangci-lint (if Go); npm lint/tsc (if Node); black/ruff (if Python).

## Release Plan (CLI)
- Tag versions (v1.0.0, etc.).
- Build binaries for macOS (arm64/x86_64), Linux (amd64/arm64), Windows (amd64).
- Upload to GitHub Releases with checksums and install instructions.

## Future Enhancements
- wospace update with in-place patching/merge assistance.
- Plugin system for additional stacks (Redis, Elasticsearch).
- Multi-template support (different WordPress stacks).
- Telemetry (opt-in) for basic usage metrics.
- Self-upgrade command (`wospace self-update`).

## Next Steps
1) Create new repo for wospace CLI.
2) Choose language (Go+Cobra recommended) and scaffold.
3) Implement `new` (fetch/extract/customize) + `doctor` first.
4) Add `build/run/stop/down` thin wrappers with checks.
5) Wire port allocator and container renaming.
6) Add tests for allocator, env writer, downloader.
7) Publish first CLI release; attach template archive to template repo release.
