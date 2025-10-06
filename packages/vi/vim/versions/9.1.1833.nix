import ../generic.nix rec {
  version = "9.1.1833";
  url = "https://github.com/vim/vim/archive/refs/tags/v${version}.tar.gz";
  hash = "sha256-763OWJVKXRh1pad+U81K0j8kP9snzc00tIhONdd82bc=";
  dir = "vim-${version}";
}
