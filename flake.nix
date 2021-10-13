{
  description = "my gloo demos infra project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    my-pkgs.url = "github:kameshsampath/nixpkgs/main";
    my-pkgs.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = { self, nixpkgs, flake-utils,my-pkgs }:
    flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"] 
      (system:
        let 
          pkgs = nixpkgs.legacyPackages.${system}; 
          mypkgs = my-pkgs.packages.${system}; 
        in
        {
          devShell = import ./shell.nix { inherit pkgs mypkgs; };
        }
      );
}