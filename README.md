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

## Tools

- `python3`
- `uv`
- `ruff`
- `basedpyright`
- `pre-commit`
- `oj`
- `acc`

## Typical Flow

```bash
mkdir -p contests
cd contests
acc new abc123
cd abc123/a
oj d https://atcoder.jp/contests/abc123/tasks/abc123_a
python3 main.py
oj test -c "python3 main.py"
```
