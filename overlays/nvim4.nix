inputs: _final: prev: {
  nvim4 = inputs.nvim4.packages.${prev.system}.default;
}
