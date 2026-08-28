# Vendored: ponytail

`SKILL.md` in this directory is copied verbatim from the ponytail project. Only the skill is
vendored; the upstream plugin (three Node lifecycle hooks and a marketplace) is deliberately not
installed. See `DESIGN.md` for that decision.

|        |                                                                    |
| ------ | ------------------------------------------------------------------ |
| Source | https://github.com/DietrichGebert/ponytail                         |
| Path   | `skills/ponytail/SKILL.md`                                         |
| Commit | `2ed6c52c9d7e5e56942508591085fd45dea277d3`                         |
| sha256 | `1316a2f3f95741d2300b116fe0c2d81ce4a9568656ed0a62643f54aaf09957f2` |

`SKILL.md` must stay byte-identical to upstream, which is why it is listed in `.prettierignore` and
keeps its non-ASCII characters against the repo's usual ASCII-only convention. Check for upstream
drift with `just ponytail-diff`; read the diff before copying anything across, then update the
commit and sha256 above. The recipe exits 0 for up to date, 1 for drift, and 2 for a failed fetch,
so a rate-limited or offline run cannot masquerade as drift. Nothing pulls automatically.

The attribution below lives here rather than inside `SKILL.md` so that byte comparison stays
meaningful.

## License

MIT License

Copyright (c) 2026 DietrichGebert

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
