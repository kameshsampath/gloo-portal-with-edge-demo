# Gloo Portal Demo

A simple demo to show how Gloo Portal works. In this demo we will explore,

- setup of Gloo Portal with Gloo Edge
- Authentication
- Federation

## Requires Tools

- [direnv](https://direnv.net/docs/installation.html#from-system-packages)
- [nixos](https://nixos.org/manual/nix/stable/#chap-quick-start)
- Docker for Desktop

Ensure you have permsisions to create the Kubernetes Clusters on the clouds AWS, GKE and Civo.

## Start Shell

The shell has all the tools required for running this demo, have them installed by running the command,

```bash
nix-shell
```

## Create and Update Variables

The following command will create Ansible encrypted variables file, please have it updated to your settings before you proceed further,

```bash
make encrypt-vars 
```

## Create Kubernetes Clusters

```bash
make create-kube-clusters
```

## Deploy Gloo

```bash
make deploy-gloo
```

### Deploy Keycloak

```bash
make deploy-keycloak
```

### Deploy Portal

The portal deployments includes

- httpbin application deployment
- Petstore application deployment
- create Gloo Portal Resources

```bash
make deploy-portal
```

### Enable Security

```bash
make secure-portal
```