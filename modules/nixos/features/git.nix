{ ... }: {
  flake.nixosModules.git = {
    programs.git = {
      enable = true;
      config = {
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
