inputs: _final: prev: {
  zen-browser = inputs.zen-browser.packages.${prev.system}.default;
}
