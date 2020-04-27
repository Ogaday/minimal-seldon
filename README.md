# Minimal Seldon Deployment

With a custom Python image. For simplicity, I'll define an identity image,
which will return the response provided to it. Assumes running microk8s with
dns, storage, istio and registry enabled, with Seldon
[installed](https://github.com/SeldonIO/seldon-core#install-seldon-core) and
using istio ingress.


## Instructions

```bash
docker build -t ogaday/identity:0.1.0 .
# Sending build context to Docker daemon  71.68kB
# Step 1/10 : FROM continuumio/miniconda3
# ...
# Successfully tagged ogaday/identity:0.1.0
docker push ogaday/identity:0.1.0
# The push refers to repository [docker.io/ogaday/identity]
# ...
# 0.1.0: digest: sha256:f7289695ff8daced2de991907689615dfa0932f9d7d625fdeb1d751d1ee7272a size: 1580
kubectl apply -f ns.yaml
# namespace/models created
kubectl apply -f sdep.yaml
# seldondeployment.machinelearning.seldon.io/identity created
kubectl get all -n models
# NAME                                      READY   STATUS    RESTARTS   AGE
# identity-model-0-model-86d5cf8d77-l4rrk   2/2     Running   0          2m24s
ISTIO_NODEPORT=$(kubectl get svc istio-ingressgateway -n istio-system -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
ISTIO_GATEWAY=localhost:$ISTIO_NODEPORT
curl -X POST \
  http://$ISTIO_GATEWAY/seldon/models/identity/api/v1.0/predictions \
  -H "Content-Type: application/json" \
  -d '{"data":{"ndarray":[[1], [2], [3], [4]]}}'
# {"data":{"names":["t:0"],"ndarray":[[1],[2],[3],[4]]},"meta":{}}
```
