# Vazirharf v34.003 — Font Standard

## Status
Vazirharf v34.003 is the canonical Persian/Arabic UI font standard for YadNegar.

- Upstream: `nadalaba/vazirharf`
- Version: `v34.003`
- Pinned upstream commit: `3cbc943b9fb9107baa77008b3e96b3c3e40e9ed8`
- Integration path: `assets/fonts/vazirharf`
- Integration method: Git submodule

## Standardization policy
All active Persian/RTL UI typography, PDF/export typography, tests, configuration, CI and project documentation must use Vazirharf v34.003 where a project font is required.

The previous application-font standard is superseded by this specification.

## Build and compatibility requirements
1. CI/build must initialize and update Git submodules before build steps that require the font.
2. Flutter font configuration must resolve to Vazirharf and the pinned submodule assets.
3. PDF/export rendering must use Vazirharf assets for Persian text.
4. Tests and contract checks must validate the canonical Vazirharf configuration.
5. Documentation must identify Vazirharf v34.003 as the project standard.
6. Existing RTL, date, storage and product behavior must remain unchanged by typography migration.

Historical Git commits are immutable; this policy applies to the active source tree and current development state.
