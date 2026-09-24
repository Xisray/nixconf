{
  flake.wrappers.git = { wlib, ... }: {
    imports = [ wlib.wrapperModules.git ];
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
}
