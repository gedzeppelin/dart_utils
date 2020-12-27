# Dart utils

 A collection of dart/flutter util libraries and widgets.

## Commit convention

Commit messages __MUST__ use [Conventional Commits](https://www.conventionalcommits.org/en/) format. It provides guidelines to create a better commit history log, making easier to have automated tasks around it (e.g. automated changelogs). Commits would follow the format `<type>[(optional scope)]: <description>`, where `<type>` might be `feat`/`fix`/`docs` etc. Breaking changes are indicated on the beginning of the optional body or footer section. 

Example:
```
git commit -m "feat(survey): add survey view"

BREAKING CHANGE:  `survey` objects have been re-used in the global configurations.
```

Types other than `fix` and `feat` are allowed. Some examples are `build` / `core` / `ci` / `docs` / `style` / `refactor` / `perf` / `test`, and any other descriptive enough type.

Please refer to the current Conventional Commits [docs](https://www.conventionalcommits.org/en/v1.0.0/#specification) for more details.


