# Gloo Portal Demo

A simple demo to show how Gloo Portal works. In this demo we will explore,

- setup of Gloo Portal with Gloo Edge
- Authentication
- Federation

## Requires Tools

- [direnv](https://direnv.net/docs/installation.html#from-system-packages)
- [nixos](https://nixos.org/manual/nix/stable/#chap-quick-start)
- Docker for Desktop

## Configure Env

**TODO**

## Start Shell

The shell has all the tools required for running this demo, have them installed by running the command,

```bash
nix-shell
```

## Create Kubernetes Clusters

```bash
make create-kube-clusters
```

## Deploy Gloo

```bash
make deploy-gloo
```

### Deploy Httpbin

```bash
kubectl --context="$CLUSTER1" apply -f manifests/httpbin.yaml
```

Wait for httpbin,

```bash
kubectl --context="$CLUSTER1" rollout status deploy httpbin --timeout=120s
```

### Deploy Petstore App(Services)

```bash
kubectl --context="$CLUSTER1" apply -k manifests/app
```

Wait for petstore app,

```bash
kubectl --context="$CLUSTER1" rollout status deploy petstore-v1 --timeout=120s
kubectl --context="$CLUSTER1" rollout status deploy petstore-v2 --timeout=120s
```

### Create API Doc

The following command creates three API docs,

- users
- pets
- all (users/pets/stores)

```bash
kubectl --context="$CLUSTER1" apply -k manifests/apidocs
```

### Create APIProduct

```bash
kubectl --context="$CLUSTER1" apply -f manifests/apiproduct.yaml
```

### Create Environment

```bash
kubectl --context="$CLUSTER1" apply -f manifests/environment.yaml
```

### Create Portal

```bash
kubectl --context="$CLUSTER1" apply -f manifests/portal.yaml
```

# v1
# one of the /pet endpoints
curl -s http://api.kameshs.me/ecommerce/v1/api/pets/1 | jq

# one of the /user endpoints
curl -s -X POST http://api.kameshs.me/ecommerce/v2/api/user/createWithList -d '[{"id":0,"username":"jdoe","firstName":"John","lastName":"Doe","email":"john@doe.me","password":"string","phone":"string","userStatus":0}]' -H "Content-type: application/json"

curl -s http://api.kameshs.me/ecommerce/v2/api/user/jdoe | jq

# v2
# one of the /store endpoints
curl -s http://api.kameshs.me/ecommerce/v2/api/store/order/1 | jq
