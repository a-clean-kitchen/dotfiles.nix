{ inputs ? { }, lib, pkgs, ... }:

let
  inherit (lib) forEach;
in rec {
  writeIf = cond: msg: if cond then msg else "";
}
