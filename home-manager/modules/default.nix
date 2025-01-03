{
  pkgs,
  lib,
  config,
  ...
}@input:
let
  mkDefaultModule =
    mod:
    let
      module =
        let
          module = import mod;
        in
        if lib.isFunction module then module input else module;
      config = module.config or module;
      isNotMergable = value: (lib.isBool value || lib.isInt value || lib.isFloat value);
    in
    {
      imports = lib.map mkDefaultModule (module.imports or [ ]);
      options = module.options or { };
      config = lib.mapAttrsRecursive (
        _: value: if isNotMergable value then lib.mkDefault value else value
      ) config;
    };

  mkCondModule =
    enableAll: mod:
    let
      cond = if lib.isAttrs mod then (lib.or mod.enable enableAll) else enableAll;
      module = mkDefaultModule (if lib.isAttrs mod then mod.module else mod);
    in
    module;
in
{
  options = {
    minix.enable = lib.mkEnableOption "Enabel minix integrations by default";
    minix.nixvim.enable = lib.mkEnableOption "Enable minix's Neovim Config";
    minix.hyprlock.enable = lib.mkEnableOption "Enable hyprlock";
    minix.lang.rust.enable = lib.mkEnableOption "Enable rust";
  };

  imports = lib.map (mkCondModule config.minix.enable) [
    ./cursor.nix
    ./fish.nix
    ./git.nix
    ./librewolf
    ./hyprland.nix
    {
      enable = config.minix.hyprlock.enable;
      module = ./hyprlock.nix;
    }
    ./kitty.nix
    {
      enable = config.minix.nixvim.enable;
      module = ./nixvim;
    }
    ./utils.nix
    {
      enable = config.minix.lang.rust.enable;
      module = ./lang/rust.nix;
    }
  ];
}
