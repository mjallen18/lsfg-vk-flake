{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.lsfg-vk;
  lsfg-vk = pkgs.callPackage ./lsfg-vk.nix { };
  lsfg-vk-ui = pkgs.callPackage ./lsfg-vk-ui.nix { };
in
{
  options = {
    services.lsfg-vk = {
      enable = lib.mkEnableOption "Lossless Scaling Frame Generation Vulkan layer";

      ui.enable = lib.mkEnableOption "Enables a GUI for configuring lsfg-vk";

      package = lib.mkOption {
        type = lib.types.package;
        description = "The lsfg-vk package to use";
        default = lsfg-vk;
      };

      losslessDLLFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        example = "/home/user/games/Lossless Scaling/Lossless.dll";
        description = ''
          Sets the LSFG_DLL_PATH environment variable.
          Required if Lossless Scaling isn't installed in a standard location
        '';
      };

      configFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        example = "/home/user/.config/lsfg-vk/conf.toml";
        description = ''
          Sets the LSFG_CONFIG environment variable.
          Required if the lsfg-vk configuration file isn't stored at the standard location
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ cfg.package ];

        # Installs the Vulkan implicit layer system-wide
        environment.etc."vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json".source =
          "${cfg.package}/share/vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json";
      }
      (lib.mkIf cfg.ui.enable {
        environment.systemPackages = [ lsfg-vk-ui ];
      })
      (lib.mkIf (cfg.losslessDLLFile != null) {
        environment.sessionVariables.LSFG_DLL_PATH =
          lib.warn "losslessDLLFile is deprecated and will only be used by lsfg-vk if LSFG_LEGACY is set."
          cfg.losslessDLLFile;
      })
      (lib.mkIf (cfg.configFile != null) {
        environment.sessionVariables.LSFG_CONFIG = cfg.configFile;
      })
    ]
  );
}
