{self, ...}: {
  flake.wrappers.lazygit = {
    pkgs,
    wlib,
    config,
    lib,
    ...
  }: let
    lgaicm = self.packages.${pkgs.stdenv.hostPlatform.system}.lgaicm;

    commitTypes = {
      feat = "A new feature";
      fix = "A bug fix";
      chore = "Maintenance / tooling / non-user-facing";
      docs = "Documentation only";
      style = "Formatting / linting / no behavior change";
      refactor = "Refactor without behavior change";
      perf = "Performance improvement";
      test = "Add or update tests";
      ci = "CI configuration / scripts";
      build = "Build system / dependencies";
    };

    lazygitConfig = {
      disableStartupPopups = true;
      customCommands = [
        {
          key = "<c-a>";
          description = "AI-powered conventional commit (multiline)";
          context = "global";
          loadingText = "Generating commit messages...";
          prompts = [
            {
              type = "menu";
              key = "Type";
              title = "Type of change";
              options =
                lib.mapAttrsToList
                (name: description: {
                  inherit name description;
                  value = name;
                })
                commitTypes;
            }
            {
              type = "menuFromCommand";
              title = "AI Generated Commit Messages";
              key = "CommitFile";
              command = "lgaicm suggest --type {{.Form.Type}}";
              filter = "^(?P<label>.*?) <===> (?P<file>.*)$";
              valueFormat = "{{.file}}";
              labelFormat = "{{.label}}";
            }
          ];
          command = "lgaicm commit --file {{.Form.CommitFile | quote}}";
        }
      ];
    };
  in {
    imports = [wlib.modules.default];
    package = pkgs.lazygit;
    runtimePkgs = [
      (self.packages.${pkgs.stdenv.hostPlatform.system}.git or pkgs.git)
      lgaicm
    ];
    constructFiles.lazygit-config = {
      relPath = "share/lazygit/config.yml";
      content = lib.generators.toYAML {} lazygitConfig;
    };
    env.LG_CONFIG_FILE = {
      data = "${config.constructFiles.lazygit-config.path},$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/custom.yml";
      esc-fn = wlib.escapeShellArgWithEnv;
    };
  };
}
