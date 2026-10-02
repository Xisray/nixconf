{
  flake.wrappers.lgaicm = {
    wlib,
    pkgs,
    lib,
    ...
  }: {
    imports = [wlib.modules.default];
    package = pkgs.stdenvNoCC.mkDerivation {
      pname = "lgaicm";
      version = "0-unstable-2026-09-27";

      src = pkgs.fetchFromGitHub {
        owner = "rakotomandimby";
        repo = "lgaicm";
        rev = "080cd554638ae4addde9173c0820e0922fd044ba";
        hash = "sha256-6gMs2mNN31nInG2Si1jSJk86zL24i0k3/E6umn8EM00=";
      };
      dontBuild = true;
      installPhase = ''
        runHook preInstall
        install -Dm755 lgaicm $out/bin/lgaicm
        runHook postInstall
      '';

      meta = with lib; {
        description = "LazyGit AI Commit Message (Gemini)";
        homepage = "https://github.com/rakotomandimby/lgaicm";
        license = licenses.mit;
        mainProgram = "lgaicm";
        platforms = platforms.unix;
      };
    };

    runtimePkgs = with pkgs; [bash git curl jq coreutils];

    env = {
      GOOGLEAI_API_KEY = {
        data = "$(cat /run/secrets/gemini_api_key)";
        esc-fn = wlib.escapeShellArgWithEnv;
      };
      LGAICM_API_URL = {
        data = "https://generativelanguage.googleapis.com/v1beta/models";
        esc-fn = wlib.escapeShellArgWithEnv;
      };
      https_proxy = "http://127.0.0.1:7897";
      http_proxy = "http://127.0.0.1:7897";
      all_proxy = "socks5h://127.0.0.1:7897";
      # no_proxy = "localhost,127.0.0.1";
    };
  };
}
