{
  description = "Dotfiles personales para NixOS + Sway + Hyprland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      mkDotfiles =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          cfg = config.modulos.home.core.dotfiles;

          resolveSource =
            path:
            if cfg.localPath != null then
              config.lib.file.mkOutOfStoreSymlink "${cfg.localPath}/${path}"
            else
              "${self}/${path}";
        in
        {
          options.modulos.home.core.dotfiles = {
            localPath = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Ruta local del repo para symlinks directos (cambios instantáneos sin rebuild)";
            };
            nvim.enable = lib.mkEnableOption "configuración de Neovim";
            kitty.enable = lib.mkEnableOption "configuración de Kitty";
            fastfetch.enable = lib.mkEnableOption "configuración de Fastfetch";
            zsh.enable = lib.mkEnableOption "configuración de ZSH (.zshrc + plugins)";
            tmux.enable = lib.mkEnableOption "configuración de Tmux";
            alacritty.enable = lib.mkEnableOption "configuración de Alacritty";
            sway.enable = lib.mkEnableOption "configuración de Sway";
            waybar.enable = lib.mkEnableOption "configuración de Waybar";
            wal.enable = lib.mkEnableOption "configuración de Pywal";
            hypr.enable = lib.mkEnableOption "configuración de Hyprland";
            wlogout.enable = lib.mkEnableOption "configuración de Wlogout";
            albert.enable = lib.mkEnableOption "configuración de Albert launcher";
            code.enable = lib.mkEnableOption "configuración de VS Code";
            xdgUserDirs.enable = lib.mkEnableOption "directorios XDG con nombres en español";
          };

          config = lib.mkMerge [
            (lib.mkIf cfg.nvim.enable {
              home.file.".config/nvim" = {
                source = resolveSource "config/nvim";
                recursive = true;
              };
            })
            (lib.mkIf cfg.kitty.enable {
              home.file.".config/kitty" = {
                source = resolveSource "config/kitty";
                recursive = true;
              };
            })
            (lib.mkIf cfg.fastfetch.enable {
              home.file.".config/fastfetch" = {
                source = resolveSource "config/fastfetch";
                recursive = true;
              };
            })
            (lib.mkIf cfg.zsh.enable {
              home.file = {
                ".config/zsh" = {
                  source = resolveSource "config/zsh";
                  recursive = true;
                };
                ".zshrc" = {
                  source = resolveSource "homedots/zshrc";
                };
              };
            })
            (lib.mkIf cfg.tmux.enable {
              home.file.".config/tmux" = {
                source = resolveSource "config/tmux";
                recursive = true;
              };
            })
            (lib.mkIf cfg.alacritty.enable {
              home.file.".config/alacritty" = {
                source = resolveSource "config/alacritty";
                recursive = true;
              };
            })
            (lib.mkIf cfg.sway.enable {
              home.file.".config/sway" = {
                source = resolveSource "config/sway";
                recursive = true;
              };
            })
            (lib.mkIf cfg.waybar.enable {
              home.file.".config/waybar" = {
                source = resolveSource "config/waybar";
                recursive = true;
              };
            })
            (lib.mkIf cfg.wal.enable {
              home.file.".config/wal" = {
                source = resolveSource "config/wal";
                recursive = true;
              };
            })
            (lib.mkIf cfg.hypr.enable {
              home.file.".config/hypr" = {
                source = resolveSource "config/hypr";
                recursive = true;
              };
            })
            (lib.mkIf cfg.wlogout.enable {
              home.file.".config/wlogout" = {
                source = resolveSource "config/wlogout";
                recursive = true;
              };
            })
            (lib.mkIf cfg.albert.enable {
              home.file = {
                ".config/albert" = {
                  source = resolveSource "config/albert";
                  recursive = true;
                };
                ".local/share/albert/widgetsboxmodel" = {
                  source = resolveSource "config/albert/widgetsboxmodel";
                  recursive = true;
                };
              };
            })
            (lib.mkIf cfg.code.enable {
              home.file.".config/Code/User/settings.json" = {
                source = resolveSource "config/code/settings.json";
              };
            })
            (lib.mkIf cfg.xdgUserDirs.enable {
              xdg.userDirs = {
                enable = true;
                createDirectories = true;
                setSessionVariables = false;
                desktop = "$HOME/Documentos/Escritorio";
                documents = "$HOME/Documentos";
                download = "$HOME/Descargas";
                music = "$HOME/Media/Música";
                pictures = "$HOME/Media/Imágenes";
                videos = "$HOME/Media/Vídeos";
                templates = "$HOME/Documentos/Plantillas";
                publicShare = "$HOME/Documentos/Público";
              };
            })
          ];
        };
    in
    {
      homeManagerModules = {
        default = mkDotfiles;
      };
    };
}
