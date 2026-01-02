
{ ... }:
{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "overload(control,escape)";
          "f23+leftshift+leftmeta" = "oneshot(capslock)";
        };
        otherlayer = { };
      };
      extraConfig = ''
        # extra keyd config here if you want
      '';
    };
  };
}
