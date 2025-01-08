{
  settings,
  pkgs,
  ...
}:
{

  programs = {
    git = {
      enable = true;
      userName = settings.userName;
      userEmail = "astrick.harren.at.work@gmail.com";
    };
    fish.enable = true;
    kitty.enable = true;
    nixvim.enable = true;
    librewolf.enable = true; # browser
    spotify-player.enable = true;
  };

  # Example to add a new language (python) support (formatter and lsp)
  programs.nixvim.plugins.lsp.servers.pyright.enable = true;
  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = {
    python = [
      "isort"
      "black"
    ];
  };
  home.packages = [
    (pkgs.python3.withPackages (
      py: with py; [
        isort
        black
      ]
    ))
  ];

  # One of "latte", "frappe", "macchiato", "mocha"
  catppuccin.flavor = "frappe";

  home.sessionVariables = {
    EDITOR = "nvim";
    FLAKE = "$HOME/.config/nix"; # where you put your nix config
  };

  nixbox.enable = true;
  nixbox.cursor.theme = "Bibata-Modern-Amber"; # default is `Bibata-Modern-Ice`
  nixbox.lang.rust = {
    enable = true;
    mold.enable = true; # enable mold linker (might not work with things like dioxus)
    nextest.enable = true; # install cargo nextest
    target = {
      musl.enable = true; # enable x86_64-unknown-linux-musl
    };
  };

  wayland.windowManager.hyprland.enable = true;
}
