{ pkgs, mypkgs }:
pkgs.mkShell {
  name = "gloo.demos";
  buildInputs = [
    mypkgs.kubectl-aliases
    pkgs.bash
    pkgs.bash-completion
    pkgs.nix-bash-completions
    pkgs.bashInteractive
    pkgs.binutils
    pkgs.coreutils
    pkgs.curl
    pkgs.direnv
    pkgs.findutils
    pkgs.gawk
    pkgs.gnutar
    pkgs.gnused
    pkgs.gnugrep
    pkgs.gettext
    pkgs.gzip
    pkgs.httpie
    pkgs.jq
    pkgs.kubectx
    pkgs.kubectl
    pkgs.kustomize
    pkgs.kubernetes-helm
    pkgs.nix-direnv
    pkgs.patchelf
    pkgs.yq-go
    pkgs.vim
    pkgs.python39
    pkgs.vagrant
    pkgs.wget
  ];

  shellHook = ''
    if [ $SHELL == '/bin/bash' ];
    then 
      source "${pkgs.bash-completion}/share/bash-completion/bash_completion"
      # some helpers for kube
      alias k=kubectl
      source <(kubectl completion bash)
      complete -F __start_kubectl k
      # direnv setup
      eval "$(direnv hook bash)"
    elif [ $SHELL == '/bin/zsh' ];
    then
      # direnv setup
      eval "$(direnv hook zsh)"
    fi

    # keeping collections local to the project 
    export ANSIBLE_COLLECTIONS_PATHS="$PWD/.ansible/collections"
    mkdir -p "$ANSIBLE_COLLECTIONS_PATHS"
        
    # the kube config file location, so that it does not pollute global ~/.kube/config of the user
    mkdir -p "$PWD/.kube"
    export KUBECONFIG="$PWD/.kube/config"
    
    # source kubectl aliases
    source "${mypkgs.kubectl-aliases}/kubectl_aliases"

    poetry install

    poetry shell

    # install all the Ansible collections/roles
    ansible-galaxy collection install -r requirements.yml

  '';

  LICENSE_KEY = builtins.getEnv "GLOO_LICENSE_KEY";
  # update it if you want to change the cluster context names
  CLUSTER1 = "gke";
  CLUSTER2 = "aws";
  MGMT = "civo";
  # CLUSTER4 = "azure";
}
