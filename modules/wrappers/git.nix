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
      http.proxy = "http://127.0.0.1:7897";
      https.proxy = "http://127.0.0.1:7897";
    };
  };
}
