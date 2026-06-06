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
            enable = lib.mkEnableOption "dotfiles";
            localPath = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Ruta local del repo para symlinks directos (cambios instantáneos sin rebuild)";
            };
          };

          config = lib.mkIf cfg.enable {
            home.file = {
              ".config/nvim" = {
                source = resolveSource "config/nvim";
                recursive = true;
              };
              ".config/kitty" = {
                source = resolveSource "config/kitty";
                recursive = true;
              };
              ".config/fastfetch" = {
                source = resolveSource "config/fastfetch";
                recursive = true;
              };
              ".config/zsh" = {
                source = resolveSource "config/zsh";
                recursive = true;
              };
              ".config/Code/User/settings.json" = {
                source = resolveSource "config/code/settings.json";
              };
              ".config/tmux" = {
                source = resolveSource "config/tmux";
                recursive = true;
              };
              ".zshrc" = {
                source = resolveSource "homedots/zshrc";
              };
              ".config/alacritty" = {
                source = resolveSource "config/alacritty";
                recursive = true;
              };
              ".config/sway" = {
                source = resolveSource "config/sway";
                recursive = true;
              };
              ".config/waybar" = {
                source = resolveSource "config/waybar";
                recursive = true;
              };
              ".config/wal" = {
                source = resolveSource "config/wal";
                recursive = true;
              };
              ".config/hypr" = {
                source = resolveSource "config/hypr";
                recursive = true;
              };
              ".config/wlogout" = {
                source = resolveSource "config/wlogout";
                recursive = true;
              };
              ".config/albert" = {
                source = resolveSource "config/albert";
                recursive = true;
              };
              ".local/share/albert/widgetsboxmodel" = {
                source = resolveSource "config/albert/widgetsboxmodel";
                recursive = true;
              };
            };

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
          };
        };
    in
    {
      homeManagerModules = {
        default = mkDotfiles;
      };
    };
}
