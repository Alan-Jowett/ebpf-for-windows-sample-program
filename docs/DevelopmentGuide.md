# Development Guide

This guide provides information for contributors to the eBPF for Windows Sample Program project.

## Table of Contents

- [Coding Conventions](#coding-conventions)
- [Header Files](#header-files)
- [Style Guide](#style-guide)
- [Naming Conventions](#naming-conventions)
- [Documentation Standards](#documentation-standards)

## Coding Conventions

### General Guidelines

* **DO** use fixed length types defined in `stdint.h` instead of language keywords determined by the compiler (e.g., `int64_t, uint8_t`, not `long, unsigned char`).

* **DO** use `const` and `static` and visibility modifiers to scope exposure of variables and methods as much as possible.

* **DO** use doxygen comments, with `[in,out]` [direction annotation](http://www.doxygen.nl/manual/commands.html#cmdparam) in all public API headers. This is also encouraged, but not strictly required, for internal API headers as well.

* **DON'T** use global variables where possible.

* **DON'T** use abbreviations unless they are already well-known terms known by users (e.g., "app", "info"), or are already required for use by developers (e.g., "min", "max", "args"). Examples of bad use would be `num_widgets` instead of `widget_count`, and `opt_widgets` instead of `option_widgets` or `optional_widgets`.

* **DON'T** use hard-coded magic numbers for things that have to be consistent between different files. Instead use a `#define` or an enum or const value, as appropriate.

* **DON'T** use the same C function name with two different prototypes across the project where possible.

* **DON'T** use commented-out code, or code in an `#if 0` or equivalent. Make sure all code is actually built.

### Sample Program Specific Guidelines

* **DO** follow eBPF for Windows conventions and patterns demonstrated in the main repository.

* **DO** include clear documentation explaining the purpose and behavior of each sample program.

* **DO** use meaningful variable and function names that clearly indicate their purpose in the sample.

* **DO** include error handling that demonstrates best practices for eBPF program development.

* **DON'T** include production-sensitive code or credentials in sample programs.

## Header Files

* **DO** make sure any header file can be included directly, without requiring other headers to be included first. That is, any dependencies should be included within the header file itself.

* **DO** include local headers (with `""`) before system headers (with `<>`). This helps ensure that local headers don't have dependencies on other things being included first, and is also consistent with the use of a local header for precompiled headers.

* **DO** list headers in alphabetical order where possible. This helps ensure there are not duplicate includes, and also helps ensure that headers are usable directly.

* **DO** use `#pragma once` in all header files, rather than using ifdefs to test for duplicate inclusion.

## Style Guide

### Automated Formatting with `clang-format`

For all C/C++ files (`*.c`, `*.cpp` and `*.h`), we use `clang-format` (specifically version `18.1.8` or later) to apply our code formatting rules. After modifying C/C++ files and before merging, be sure to run:

```powershell
.\scripts\format-code.bat
```

### Formatting Notes

Our coding conventions follow the [LLVM coding standards](https://llvm.org/docs/CodingStandards.html) with the following overrides:

* Source lines **MUST NOT** exceed 120 columns.
* Single-line if/else/loop blocks **MUST** be enclosed in braces.

Please stage the formatting changes with your commit, instead of making an extra "Format Code" commit. Your editor can likely be set up to automatically run `clang-format` across the file or region you're editing. See:

- [clang-format.el](https://github.com/llvm-mirror/clang/blob/master/tools/clang-format/clang-format.el) for Emacs
- [vim-clang-format](https://github.com/rhysd/vim-clang-format) for Vim
- [vscode-cpptools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) for Visual Studio Code

The [.clang-format](.clang-format) file describes the style that is enforced by the script, which is based off the LLVM style with modifications closer to the default Visual Studio style. See [clang-format style options](http://releases.llvm.org/3.6.0/tools/clang/docs/ClangFormatStyleOptions.html) for details.

### License Header

The following license header **must** be included at the top of every code file:

```c
// Copyright (c) eBPF for Windows contributors
// SPDX-License-Identifier: MIT
```

It should be prefixed with the file's comment marker. If there is a compelling reason to not include this header, the file can be added to `scripts/.check-license.ignore`.

All files are checked for this header with the script:

```powershell
.\scripts\check-license.bat
```

## Naming Conventions

Naming conventions we use that are not automated include:

1. Use `lower_snake_case` for variable, member/field, and function names.
2. Use `UPPER_SNAKE_CASE` for macro names and constants.
3. Prefer `lower_snake_case` file names for headers and sources.
4. Prefer full words for names over contractions (i.e., `memory_context`, not `mem_ctx`).
5. Prefix names with `_` to indicate internal and private fields or methods (e.g., `_internal_field, _internal_method()`).
6. The single underscore (`_`) is reserved for local definitions (static, file-scope definitions). e.g., `static ebpf_result_t _do_something(..)`.
7. Prefix `struct` definitions with `_` (this is an exception to point 6), and always create a `typedef` with the suffix `_t`. For example:

```c
typedef struct _sample_context
{
    uint64_t packet_count;
    uint32_t bytes_processed;
} sample_context_t;
```

8. Prefix eBPF specific names in the global namespace with `ebpf_` (e.g., `ebpf_result_t`).

Above all, if a file happens to differ in style from these guidelines (e.g., private members are named `m_member` rather than `_member`), the existing style in that file takes precedence.

## Documentation Standards

### Sample Program Documentation

Each sample program should include:

1. **README.md** - Overview, purpose, and basic usage instructions.
2. **Build instructions** - How to compile and prepare the sample.
3. **Usage examples** - Command-line examples and expected outputs.
4. **Code comments** - Inline explanations of key eBPF concepts demonstrated.
5. **Troubleshooting** - Common issues and solutions.

### Code Documentation

* Use doxygen-style comments for all public APIs.
* Include parameter descriptions with `@param` tags.
* Document return values with `@return` tags.
* Add `@brief` descriptions for functions and structures.
* Include usage examples in comments where helpful.

### Markdown Documentation

* Use consistent heading levels and structure.
* Include code blocks with appropriate language highlighting.
* Add links to relevant eBPF for Windows documentation.
* Keep line lengths reasonable for readability.

## Build System

### Project Structure

Sample programs should follow a consistent structure:

```
sample-name/
├── README.md
├── src/
│   ├── sample.c          # eBPF program source
│   └── user_app.c        # User-space application
├── include/
│   └── sample.h          # Header files
├── tests/
│   └── test_sample.c     # Test files
└── scripts/
    └── run_sample.ps1    # Helper scripts
```

### Build Configuration

* Use MSBuild project files (`.vcxproj`) for C/C++ projects.
* Include appropriate Windows SDK and eBPF for Windows dependencies.
* Configure builds for both Debug and Release configurations.
* Ensure compatibility with the supported Visual Studio versions.

## Performance Considerations

* **DO** optimize for clarity and educational value in sample programs.
* **DO** include performance notes in documentation where relevant.
* **DON'T** prioritize performance over code readability in samples.
* **DO** mention performance implications of different eBPF patterns.

## Security Considerations

* **DO** follow secure coding practices.
* **DON'T** include hardcoded credentials or sensitive information.
* **DO** validate inputs in user-space applications.
* **DO** demonstrate proper error handling and resource cleanup.
* **DO** include security considerations in sample documentation.

## Contributing Improvements

If you find areas where this development guide could be improved:

1. Create an issue describing the improvement.
2. Submit a pull request with proposed changes.
3. Include rationale for the changes in the PR description.

For questions about these guidelines, please create an issue or start a discussion in the main eBPF for Windows repository.