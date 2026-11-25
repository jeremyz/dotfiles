---
description: Split a large AGENTS.md into a lean root + area/topic files, then tighten the wording
argument-hint: "[split|tighten] [notes]"
---
Optimize this project's agent instructions (`AGENTS.md`, or `CLAUDE.md`). Phase: ${1:-split}.
Extra notes from the user: ${@:2}

Goal: the root file is loaded on every turn, so it must be small. The detailed rules move to
files the agent reads only before touching their area. No rule may be lost.

## Rules for both phases

- Read the current file in full and keep a pristine copy (`git show HEAD:AGENTS.md` if tracked,
  else copy it to `/tmp/agents-old.md` before any edit).
- Obey the project's own rules (commit policy, docs rules, formatting). Never commit.
- Each rule is written once, in the file that owns it; other files point to it ("see
  `backend.md` *Row locks*"), never copy it.
- Keep the code references (classes, methods, tests, files, keys, error codes): they are how an
  agent finds the code and the test that enforces a rule. Keep the short "rejected: …" notes:
  they stop an agent from "fixing" what is deliberate.
- When done, run a mechanical check and fix what it reports (a code span broken across a line
  wrap shows up as missing):
  ```bash
  cat AGENTS.md agents/*.md > /tmp/new.md
  grep -o '`[^`]*`' /tmp/agents-old.md | sort -u > /tmp/old.t
  grep -o '`[^`]*`' /tmp/new.md | sort -u > /tmp/new.t
  comm -23 /tmp/old.t /tmp/new.t          # spans gone: each must be a deliberate cut
  ```
  plus the same for class-like names (`grep -oE '\b[A-Z][a-zA-Z0-9]+(Test|Service|…)\b'`, the
  suffixes this project uses). Report sizes before / after (`wc -c`).
- Run the project's doc build if it has one (a strict MkDocs build, …) to prove nothing broke.
- End with a summary: the file map with sizes, the choices to check (what moved where, what was
  split across files), every deliberate cut, and the docs updated or not needing anything.

## Phase `split`

1. **Check how the harness loads context files** (for pi: the agent dir, the cwd and its
   parents only; nested `AGENTS.md` files in subdirectories are NOT loaded automatically). So
   the root must route explicitly: a table "Before touching… → Read `agents/x.md`".
2. **Measure** the sections (bytes per top-level bullet / heading) to see where the weight is.
3. **Plan the split by area + topic**, not by layer alone:
   - area files following the code layout (backend, UI, SQL / schema, tests, build /
     dependencies / docs toolchain / troubleshooting, …);
   - topic files for big feature-specific rule sets that span layers (auth, config, blobs, …);
   - a rule spanning layers goes to the file that owns its core, with a one-line pointer from
     the other (ex: the UI side of locking under the UI's *Edit cycle*, pointing to the backend's
     *Row locks*).
4. **Root file** keeps: a one-paragraph intro, the routing table, commands, a short architecture
   map, and only the rules that hold everywhere (git policy, files needing the user's OK,
   formatting, logging, the docs-update rule, …). Update the docs rule so it covers the new
   files, and says a new `agents/` file gets a row in the table.
5. **Location**: one folder (`agents/` at the repo root by default). Never inside a doc site's
   source dir whose build fails on pages missing from its navigation (MkDocs
   `validation.omitted_files: warn` + `--strict`); check its config first.
6. In this phase, **keep the original wording**: move text, add headings and pointers only. The
   user reviews the split before any rewording.
7. Update every reference to the old file's sections elsewhere (README's documentation list,
   the backlog, the doc site's index, …): `grep -rn AGENTS`.

## Phase `tighten`

Rewrite every file (root included) for density, without dropping a rule:
- remove repeated explanations, filler, and statements already made elsewhere (ex: in the
  commands table);
- shorten example lists to one or two plus "…";
- merge rules that say the same thing in different cases;
- combine related command rows.
Expect ~15–20% fewer bytes, not more: beyond that you are deleting rules. Say so in the summary
instead of forcing it.
