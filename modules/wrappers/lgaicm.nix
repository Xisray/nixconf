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
        hash = lib.fakeHash;
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

    env.GOOGLEAI_API_KEY = {
      data = "$(cat /run/secrets/googleai-api-key)";
      esc-fn = wlib.escapeShellArgWithEnv;
    };
  };
}
