{ pkgs ? import
  (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-21.05.tar.gz")
  { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.zsh-completions
    pkgs.python39
    pkgs.python39Packages.ansible
    pkgs.python39Packages.requests
    pkgs.python39Packages.cryptography
    pkgs.python39Packages.google-auth
    pkgs.python39Packages.kubernetes
    pkgs.python39Packages.jsonpatch
    pkgs.fzf
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.kustomize
    pkgs.jq
    pkgs.yq-go
    pkgs.docker
    pkgs.kind
    pkgs.google-cloud-sdk
    pkgs.kubectx
    pkgs.stern
  ];

  shellHook = ''
    export PATH=$HOME/.local/bin:$PATH

    if [ -f $HOME/.kubectl_aliases ];
    then
      source $HOME/.kubectl_aliases
    fi

    if [ -f $HOME/.exports ];
    then
      source $HOME/.exports
    fi

    if [ -f $HOME/.aliases ];
    then
      source $HOME/.aliases
    fi

    ansible-galaxy collection install -r requirements.yml

  '';

  LICENSE_KEY = builtins.getEnv "GLOO_LICENSE_KEY";
  CLUSTER1 = "gke";
  CLUSTER2 = "civo";
  KUBECONFIG = builtins.toString ./.kube/config;
}
