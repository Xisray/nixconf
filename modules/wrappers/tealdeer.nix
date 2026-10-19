{
  flake.wrappers.tealdeer = {wlib, ...}: {
    imports = [wlib.wrapperModules.tealdeer];
    settings.updates.auto_update = true;
  };
}
