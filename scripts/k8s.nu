kubectl get pods --all-namespaces -o jsonpath='{range .spec.containers[*]}{"Container Name: "}{.name}{"\n"}{"Limits:"}{.resources.limits}{"\n"}{end}'

kubectl get pods --all-namespaces -o jsonpath='{range .spec.containers[*]}{"Container Name: "}{.name}{end}'

kubectl get pods podcaster-recommender-manual-pff9q-s4kfp --namespace=production -o jsonpath='{range .spec.containers[*]}{"Container Name: "}{.name}{end}'


; kubectl get pods -A -o jsonpath='{range .items[*]}{.metadata.name}{'\n'} {.spec.containers[*].resources.limits}{'\n'} {end}'

; kubectl get pods -A -o jsonpath='{range .items[*]}{.metadata.name}{'\n'} {.spec.containers[*].resources.limits}{'\n'} {end}'