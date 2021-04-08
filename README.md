**GH has 2 ways to public docker images: packages and ghcr.io only ghcr.io allows anonymous access to the images. Use ghcr.io**
**GITHUB-TOKEN are used only in GitHub Action Workflow. it is a one-time secret and generated anew for every workflow run**

[Correct Blog ](https://blog.bitsrc.io/using-github-container-registry-in-practice-295677c6f65e)
[GH docs](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
[GH docs How to configure public access for CR](https://ghcr.io/en/packages/guides/configuring-access-control-and-visibility-for-container-images)

```                                                                                                                                                                                                          
cat ~/gh-token.txt | docker login https://ghcr.io -u alex-y-kozlov --password-stdin
docker build -t ghcr.io/alex-y-kozlov-sandbox/helloworld-k8s/helloworld-node:1.0.0 .
docker push ghcr.io/alex-y-kozlov-sandbox/helloworld-k8s/helloworld-node:1.0.0
```


port forward to a pod:
` kubectl port-forward service/helloworld-node 3000:3000 -n teastore `

# AppD on K8S

```
kubectl create namespace appdynamics

kubectl -n appdynamics create secret generic cluster-agent-secret  ...

kubectl apply -f https://raw.githubusercontent.com/Appdynamics/appdynamics-operator/master/deploy/cluster-agent-operator.yaml

kubectl apply -f ../k8s/appd-k8s/appd-cluster-agent.yml
kubectl -n appdynamics create secret generic cluster-agent-secret --from-literal=controller-key=b1099c08-65fa-4f9e-XXXXXXXXX --from-literal=api-user=DemoXXXXXXXX
```