Makes using redshift less of a pain.

## install

- place the contents of this repo inside, wherever you want;
- make `tempcolor` executable: `chmod +x ./tempcolor`;
- feel free to create a symbolic link for `tempcolor`.
  - be it in `/usr/bin`;
  - or be it in `$HOME/.local/bin`.

### usage

**incrementally change color temperature**
`tempcolor -inc <percent_value>`
`tempcolor -dec <percent_value>`

**reset color temperature (turn off)**
`tempcolor -x`

**set value using one shot mode (-O)**
`tempcolor <value>`
