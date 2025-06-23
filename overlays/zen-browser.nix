inputs: final: prev: {
  zen-browser = inputs.zen-browser.packages.${prev.system}.default;

  # The Backup Route
  # zen-browser-unwrapped = prev.callPackage ../pkgs/zen-browser.nix { };
  # zen-browser = prev.wrapFirefox final.zen-browser-unwrapped {
  #   pname = "zen-browser";
  # };
}

