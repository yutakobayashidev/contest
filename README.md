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
The repo-managed `acc-config/` is linked into `acc config-dir` automatically.

## First Login

```bash
acc check-oj
acc login
oj login https://atcoder.jp/
acc templates
```

## Tools

- `python3`
- `uv`
- `ruff`
- `ty`
- `pre-commit`
- `oj`
- `acc`

## Template

`acc new` uses the managed config in [acc-config/config.json](/Users/yuta/ghq/github.com/yutakobayashidev/contest/acc-config/config.json) and the `py` template in [acc-config/py/main.py](/Users/yuta/ghq/github.com/yutakobayashidev/contest/acc-config/py/main.py) and [acc-config/py/template.json](/Users/yuta/ghq/github.com/yutakobayashidev/contest/acc-config/py/template.json).

It configures:

- `default-template = py`
- `default-task-choice = all`
- `default-task-dirname-format = {tasklabel}`
- `default-test-dirname-format = tests`

## Typical Flow

```bash
mkdir -p contests
cd contests
acc new abc123
cd abc123/a
ty check
oj test -c "python3 main.py"
acc submit main.py
```
