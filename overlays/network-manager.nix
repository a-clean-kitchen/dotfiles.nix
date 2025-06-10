inputs: _final: prev: {
  network-manager-tui = inputs.network-manager.packages.${prev.system}.default;
}