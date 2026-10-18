# Global agent instructions

These instructions apply across projects. Follow repository-specific `AGENTS.md` guidance as well; use the project’s conventions where they are more specific.

## Branches

- Name every new branch `tcrawford/sc-{shortcut-id}/{terse-branch-name}`. Use the numeric Shortcut story ID and a short kebab-case change slug (for example, `tcrawford/sc-552035/pl-email-branding`; not `fix/pl-email-branding`, `tcrawford/pl-email-branding`, or `tcrawford/552035/pl-email-branding`).
- Attribute each new branch to a Shortcut story. Use the ID from the task context, a story link, an `sc-` reference, or the existing branch/PR context. If the story is unclear, ask before creating the branch; never invent an ID.
- Preserve existing branches, including branches checked out for an existing PR.

## Commits and pull requests

- Use Conventional Commits for commit messages and PR titles: `type(scope): description` or `type: description`.
- Allowed types: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`, `build`, `ci`, `perf`, `revert`.
- When writing a PR title or body, follow the `pr-figure` skill (`~/.agents/skills/pr-figure/SKILL.md`) first. Use the `pr` skill only for anything `pr-figure` does not cover.

## Response style after edits

- After successful edits, reply with one short line naming the updated file(s). Let the diff speak for itself; omit summaries, edit lists, introductions, and pleasantries.
- Give a fuller response only when a command fails, tests break, or essential clarification is needed.

## Kotlin and Java

Apply these principles when writing, modifying, or reviewing Kotlin or Java code:

### Design and APIs

- Prefer immutability: Kotlin `val` over `var`, Java `final` fields, and unmodifiable collections in public APIs.
- Enforce invariants at construction with factories, builders, or validated constructors rather than exposing partially initialized objects.
- Favor composition over inheritance; use inheritance for genuine “is-a” relationships.
- Program to interfaces and keep concrete types as implementation details.
- Minimize visibility: prefer `private` or `internal` until wider access is needed.
- Design for extension without over-engineering; add abstractions when a second use case appears.

### Types and collections

- Override `equals` and `hashCode` together and preserve the equality contract.
- Prefer enums over integer or string constants for fixed sets of values.
- Use generics to preserve type safety; avoid raw types and unchecked casts.
- Prefer standard-library collections and utilities over ad hoc data structures.
- Return empty collections rather than `null`. In Java, use `Optional` only for return types, not fields or parameters.

### Nullability, errors, and control flow

- In Kotlin, avoid `!!`; express absence in types and handle it explicitly with safe calls, `?:`, `requireNotNull`, or early returns.
- Use `require`, `check`, and `error` for preconditions, state checks, and impossible states.
- Prefer sealed classes or interfaces for closed hierarchies that need exhaustive `when` handling.
- Keep functions focused; extract logic when branching or nesting obscures intent.
- Prefer expression-oriented Kotlin when it improves clarity, and use `when` as an expression where appropriate.
- Use scope functions (`let`, `apply`, `run`, `also`, `with`) when they reduce noise, not by default.
- Keep local-variable scope small and declare variables close to first use.

### Resources, performance, and readability

- Avoid unnecessary allocations in hot paths.
- Use try-with-resources in Java and `use` in Kotlin for closeable resources.
- Handle exceptions, wrap them with context, or deliberately rethrow them; do not ignore them.
- Name types, methods, and variables for intent rather than implementation.
- Write idiomatic Kotlin in `.kt` files and idiomatic Java in `.java` files; avoid Java-style Kotlin and Kotlin-style Java.

## Kotlin tests with Kotest

When writing, editing, or reviewing Kotlin tests:

- Use Kotest `FunSpec`.
- Name tests in the “should … when …” format.
- Inside each test, include exactly one bare `// Given`, one bare `// When`, and one bare `// Then` comment, each directly above its respective section. Do not add descriptions to those comments (`// Given`, not `// Given a borrower with no identities`).

## Secrets

- A Gradle/Artifact Registry 401 or 403 means my gcloud login expired: ask me to run `glogin`; don't look for credentials. Ask me for any secret you need; don't search for one.
- If a secret value ever appears in output, stop and tell me which one; don't repeat it.

## Tooling

- Edit files with your native edit tool, never with Python, `sed`, or shell heredocs. Read files with the native read tool, not `sed -n`, `cat -n`, or `nl`.
- `ah` is the harness CLI for recurring workflows: worktree inventory and pruning across home clones, Gradle tests, PR review threads, CI status, and long-running local services. Run `ah --help` (or `ah schema`) before writing a script, and prefer it over raw `./gradlew … | rg`, hand-written `gh api graphql` queries, or `launchctl` / `sleep; curl` loops.
- `ah` prints one JSON envelope on stdout: branch on `.ok`, `.error.kind`, and the exit code, and follow `.error.hint`.
- Keep improving `ah`. Fix or extend it in `~/dev/github/ah` (following its `AGENTS.md`) instead of working around it with a throwaway script when:
  - a command fails or returns wrong or unhelpful output
  - a command lacks a flag or behavior the task needs
  - you'd write the same helper twice
- Prove an `ah` change works before shipping it: `bun test`, `bunx tsc --noEmit`, and a live run of the affected command against the real system.
- Once it's proven, commit directly on `main` and push. This repo needs no branch, Shortcut ID, or PR. Run `git pull --rebase` before pushing, since other agents may have pushed. Mention the change in your reply.
