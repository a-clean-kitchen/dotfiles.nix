inputs: _final: prev: {
  swww = inputs.swww.packages.${prev.system}.swww;
}
