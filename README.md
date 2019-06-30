# Grim Gamers

## Development Environment

### VS Code Extensions

- [Love2D Support](https://marketplace.visualstudio.com/items?itemName=pixelbyte-studios.pixelbyte-love2d) - Love API autocomplete. Run Love2D in vscode
- [Luacheck](https://marketplace.visualstudio.com/items?itemName=rog2.luacheck) - Validate and lints lua code
- [vscode-lua](https://marketplace.visualstudio.com/items?itemName=trixnz.vscode-lua) - Intellisense / error checking / autocomplete for lua

### Running unit tests

The bash script `tests/run.sh` can be invoked via a terminal to run all unit tests. In windows this is typically done like so (from project root): `./tests/run-unit-tests.sh`.

---

## Brainstorming

- 2D Side-scrolling platformer / metroidvania / roguelite
- Two worlds: Alive/Real vs Decayed world
  - The player could switch between worlds intermittently?
  - Make one world a main world
- Light is a core mechanic
  - The world is dark by default, you are the light source?
  - Beam vs Radial lights sources being a core decision the player constantly must make?
  - The player could have a companion that IS the light source (easier to animate by separating player vs moving light source)?
  - Throwable light source?
- Tile-based world
