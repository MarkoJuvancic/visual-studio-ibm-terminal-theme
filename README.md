# IBM Terminal Theme for Visual Studio 2026

A Visual Studio 2026 theme inspired by IBM 3270 terminals and ISPF-style interfaces, using hard-edged terminal colors instead of a modern pastel palette.

> IBM is a trademark of International Business Machines Corporation. This project is an independent, unofficial theme and is not affiliated with or endorsed by IBM.

## Screenshots

> Screenshots coming soon.

## Design

IBM Terminal uses a deliberately small, high-contrast set of terminal colors. Categories are distinguished by a few discrete colors rather than by soft gradients between similar shades.

| Role | Color |
| --- | --- |
| Background | `#000000` |
| Green | `#01D900` |
| Cyan | `#01E5E6` |
| Blue | `#0000FF` |
| White | `#E6E5E6` |
| Dim green | `#008A00` |

In the editor:

- ordinary code, locals, parameters, operators and punctuation use terminal white;
- keywords, strings, properties and fields use terminal green;
- methods, types, constants and numbers use cyan;
- namespaces and preprocessor directives use blue;
- comments and line numbers use dim green.

Yellow is reserved for warnings and red for errors instead of being used as decorative syntax colors.

v0.2 is intentionally less "soft" than v0.1: the green-tinted, pastel look was replaced with a pure black background and harder, saturated colors that are closer to the IBM terminal / ISPF aesthetic.

## Requirements

- Visual Studio 2026

## Installation

1. Download the latest `.vsix` from [GitHub Releases](../../releases).
2. Close Visual Studio.
3. Run the VSIX installer (double-click the `.vsix` file).
4. Start Visual Studio.
5. Open **Tools → Options → Environment → Visual Experience**.
6. Under **Color theme**, select **IBM Terminal**.

## Building from source

Requirements:

- Visual Studio 2026 with the **Visual Studio extension development** workload (VSSDK)

Run:

```text
build-release.cmd
```

The script locates MSBuild via `vswhere`, restores NuGet packages, rebuilds the project in Release mode, verifies the theme registration in the generated VSIX (`verify-vsix.ps1`) and exports:

```text
IBMTerminalTheme-VS2026-v0.2.0.vsix
```

## Font

The theme does not include, install or change any font.

For a more terminal-like appearance, users may optionally use a 3270-style monospaced font installed separately.

## Version history

**v0.2.0**
- Reworked palette around harder IBM 3270 / ISPF-inspired colors.
- Pure black editor background.
- Higher-saturation green, cyan and blue terminal accents.
- Reduced pastel/soft styling from v0.1.

**v0.1.0**
- Initial IBM Terminal theme.

## License

Released under the [MIT License](LICENSE).
