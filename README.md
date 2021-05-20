**GH has 2 ways to public docker images: packages and ghcr.io. nly ghcr.io allows anonymous access to the images. Use ghcr.io**
**GITHUB-TOKEN are used only in GitHub Action Workflow. it is a one-time secret and generated anew for every workflow run**

[Correct Blog ](https://blog.bitsrc.io/using-github-container-registry-in-practice-295677c6f65e)
[GH docs](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
[GH docs How to configure public access for CR](https://ghcr.io/en/packages/guides/configuring-access-control-and-visibility-for-container-images)

## Publish docker image in GH CR
```                                                                                                                              cat ~/gh-token.txt | docker login https://ghcr.io -u alex-y-kozlov --password-stdin
docker build -t ghcr.io/alex-y-kozlov-sandbox/helloworld-k8s/helloworld-node:1.0.0 .
docker push ghcr.io/alex-y-kozlov-sandbox/helloworld-k8s/helloworld-node:1.0.0
```
## Deploy AppD Operator and a Cluster Agent on K8S

```
kubectl create namespace appdynamics
kubectl apply -f https://raw.githubusercontent.com/Appdynamics/appdynamics-operator/master/deploy/cluster-agent-operator.yaml
kubectl apply -f ./k8s/appd-k8s/appd-cluster-agent.yml
```

## Deploy Ingress controller and note an IP address of the LB
```sh
# Add the ingress-nginx repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# namespace for the ingress controller
kubectl create namespace ingress-basic

#run helm chart
helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-basic --set controller.replicaCount=2 --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux   --set controller.service.externalTrafficPolicy=Local
```

# Deploy helloworld-node apps
Deployment manifests are here. Naming self-explanatory:

- ./k8s/helloworld-node-cluster-agent.yml
- ./k8s/helloworld-node-init-container.yml

## Update IP adress in the ingress manifest
Replace IP address with public IP of the LB in each yml file. for example:
```
---
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
  name: helloworld-node-init-container
  namespace: helloworld
spec:
  rules:
  - host: helloworld-node-init-container.Replace-IP-Address-Here.nip.io
    http:
      paths:
      - backend:
          serviceName: helloworld-node-init-container
          servicePort: 3000
        path: /
```
## Deploy helloworld-node apps
Both deployment contain the same container image, so it's the same code deployed as 2 diff apps to illustrate 2 different instrumentation approaches:

``` 
kubectl apply -f  ./k8s/helloworld-node-cluster-agent.yml
kubectl apply -f  ./k8s/helloworld-node-init-container.yml
```

# Test
When deployment is done, exersise the apps with

curl http://helloworld-node.Replace-IP-Address-Here.nip.io
curl http://helloworld-node-init-container.Replace-IP-Address-Here.nip.io

In AppD you will see a new application HelloWorld with 2 tiers:

- helloworld-node
- helloworld-node-init-container


# helloworld-dotnetcore

```
cd ./helloworld-dotnetcore
dotnet new webapp --no-https
```

```
cd ..
docker build --rm --pull -f "./helloworld-dotnetcore/Dockerfile" -t "ghcr.io/alex-y-kozlov-sandbox/helloworld-k8s/helloworld-dotnetcore:1.0.0" "." 
cd ./helloworld-dotnetcore
docker push ghcr.io/alex-y-kozlov-sandbox/helloworld-k8s/helloworld-dotnetcore:1.0.0
```

## test the app
```
docker run --rm -ti -p 8080:8080 ghcr.io/alex-y-kozlov-sandbox/helloworld-k8s/helloworld-dotnetcore:1.0.0
```
