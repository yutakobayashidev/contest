# contest

Competitive programming contest workspace for Python.

## Setup

```bash
nix develop
nix fmt
nix flake check
```

`acc` is configured to use `oj` automatically from the dev shell.
`pre-commit` hooks are installed automatically when you enter the dev shell.

## First Login

```bash
acc check-oj
acc login
oj login https://atcoder.jp/
```

## Tools

- `python3`
- `uv`
- `ruff`
- `ty`
- `pre-commit`
- `oj`
- `acc`

## Typical Flow

```bash
mkdir -p contests
cd contests
acc new abc123
cd abc123/a
touch main.py
ty check
oj test -c "python3 main.py"
acc submit main.py
```
