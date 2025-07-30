{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  glib,
  pango,
  gdk-pixbuf,
  gtk4,
  libadwaita
}:

rustPlatform.buildRustPackage {
  pname = "lsfg-vk-ui";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "PancakeTAS";
    repo = "lsfg-vk";
    rev = "v0.9.0";
    hash = "sha256-88baJynBxJ0M4Ia0GVngvDs91bbxnK2U3fPSGR3KIk4=";
  };
  
  cargoHash = "sha256-1/3CTCXTqSfb/xtx/Q1whaHPeQ0fxu0Zg2sVJPxdcK0=";

  sourceRoot = "source/ui";

  nativeBuildInputs = [
    pkg-config
    glib
  ];

  buildInputs = [
    pango
    gdk-pixbuf
    gtk4
    libadwaita
  ];

  meta = with lib; {
    description = "Graphical interface for lsfg-vk";
    homepage = "https://github.com/PancakeTAS/lsfg-vk/";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "lsfg-vk-ui";
  };
}