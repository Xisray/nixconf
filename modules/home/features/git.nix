{ ... }: {
  flake.homeModules.git = {
    programs.git = {
      enable = true;
      settings = {
        init = {
          defaultBranch = "main";
        };
        user = {
          name = "Xisray";
          email = "safixxkir@yandex.ru";
        };
      };
    };
  };
}
