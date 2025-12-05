
{ ... }:
{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "overload(control,escape)";
        };
        otherlayer = { };
      };
      extraConfig = ''
        # extra keyd config here if you want
      '';
    };
  };
}
