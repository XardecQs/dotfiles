{
  description = "Dotfiles personales para NixOS + Sway";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      configDir = "${self}/config";
      homeDots = "${self}/homedots";

      mkDotfiles =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          cfg = config.modulos.home.core.dotfiles;
        in
        {
          options.modulos.home.core.dotfiles = {
            enable = lib.mkEnableOption "dotfiles";
          };

          config = lib.mkIf cfg.enable {
            home.file = {
              ".config/nvim" = {
                source = "${configDir}/nvim";
                recursive = true;
              };
              ".config/kitty" = {
                source = "${configDir}/kitty";
                recursive = true;
              };
              ".config/fastfetch" = {
                source = "${configDir}/fastfetch";
                recursive = true;
              };
              ".config/zsh" = {
                source = "${configDir}/zsh";
                recursive = true;
              };
              ".config/Code/User/settings.json" = {
                source = "${configDir}/code/settings.json";
              };
              ".config/tmux" = {
                source = "${configDir}/tmux";
                recursive = true;
              };
              ".zshrc" = {
                source = "${homeDots}/zshrc";
              };
              ".config/alacritty" = {
                source = "${configDir}/alacritty";
                recursive = true;
              };
              ".config/sway" = {
                source = "${configDir}/sway";
                recursive = true;
              };
              ".config/waybar" = {
                source = "${configDir}/waybar";
                recursive = true;
              };
              ".config/wal" = {
                source = "${configDir}/wal";
                recursive = true;
              };
              ".config/albert" = {
                source = "${configDir}/albert";
                recursive = true;
              };
              ".local/share/albert/widgetsboxmodel" = {
                source = "${configDir}/albert/widgetsboxmodel";
                recursive = true;
              };
            };

            xdg.userDirs = {
              enable = true;
              createDirectories = true;
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
