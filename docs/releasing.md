# Releasing lingtree

The source repository and the Typst Universe submission are separate. Prepare
and commit the source first; submit the generated snapshot only when its
documentation and implementation are ready for public review.

## Prerequisites

- Install `typst` and GitHub CLI (`gh`).
- Authenticate GitHub CLI with `gh auth login`.
- Keep `../typst-publish` checked out next to this repository.
- Start from a clean `main` branch synchronized with GitHub.

## Prepare a snapshot

Choose a SemVer version and run:

```sh
./scripts/make-release.sh 0.1.0
```

The script performs four operations:

1. It updates `typst.toml` and every package import in `README.md`.
2. It compiles the API, smoke, and alignment tests and the complete feature
   tour.
3. It assembles only the public package files under
   `release/preview/lingtree/0.1.0`.
4. It resolves an `@preview/lingtree:0.1.0` import against that snapshot and
   compiles a small tree.

The `release` directory is ignored by Git because the snapshot belongs in the
`typst/packages` repository, not in this source repository.

Review the source changes, rerun the project tests if needed, and commit and
push the versioned source. Do not tag the source manually: the publishing tool
offers to create and push the version tag after it pushes the submission
branch.

## Submit to Typst Universe

From the repository root, run:

```sh
../typst-publish/typst-publish.sh
```

Confirm the selected package and version. The tool updates a sparse checkout of
`typst/packages` in `/tmp/packages`, creates a submission branch in the GitHub
fork, pushes the snapshot, and offers to tag this repository. It then prints the
link used to open the package pull request.

If automated checks or review require package changes, update the source,
rebuild the same versioned snapshot, and run:

```sh
../typst-publish/typst-publish.sh --update-pr
```

This amends the existing submission commit and updates its pull request. Use
`--branch NAME` as well if the submission branch does not have the default name
`lingtree-VERSION`.
