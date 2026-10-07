{self, ...}: {
  flake.wrappers.lazygit = {
    wlib,
    lib,
    pkgs,
    config,
    ...
  }: let
    format = pkgs.formats.yaml {};
    lgaicm = self.packages.${pkgs.stdenv.hostPlatform.system}.lgaicm or null;
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
  in {
    imports = [wlib.modules.default];
    options.settings = lib.mkOption {
      type = format.type;
      default = {};
    };
    config = {
      package = pkgs.lazygit;
      runtimePkgs =
        [
          (self.packages.${pkgs.stdenv.hostPlatform.system}.git or pkgs.git)
        ]
        ++ lib.optional (lgaicm != null) lgaicm;
      env.LG_CONFIG_FILE = {
        data = "${format.generate "lazygit-config.yml" config.settings}";
        esc-fn = wlib.escapeShellArgWithEnv;
      };
      settings = {
        disableStartupPopups = true;
        customCommands = lib.mkIf (lgaicm != null) [
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
    };
  };
}
