# Changelog

## 0.1.0

Initial release.

- Per-user theme persistence via polymorphic `ThemePreference` model
- 5 preset themes: Ocean, Forest, Twilight, Coral, Arctic
- Configurable default template, accent, and surface colors
- 6 accent colors (blue, emerald, cyan, indigo, violet, rose) and 5 surface colors (zinc, slate, gray, neutral, stone)
- Full shade scale (50-950) matching Tailwind, with custom hex color support via auto-generated shades
- CSS custom property injection (`--color-accent-*`, `--color-surface-*`) via `<style>` tag helper
- Session-based caching with staleness detection
- Settings UI with preset selector and color pickers (requires keystone_ui)
- Stimulus controller for interactive theme selection
- Install and update generators
- Default palette for unauthenticated visitors
