# Kubernetes abbreviations

# Basic kubectl command
abbr -a -- k kubectl

# Apply operations
abbr -a -- kaf "kubectl apply -f"

# Interactive terminal
abbr -a -- keti "kubectl exec -ti"

# Configuration management
abbr -a -- kccc "kubectl config current-context"
abbr -a -- kcdc "kubectl config delete-context"
abbr -a -- kcgc "kubectl config get-contexts"
abbr -a -- kcsc "kubectl config set-context"
abbr -a -- kcsccn "kubectl config set-context --current --namespace"
abbr -a -- kcuc "kubectl config use-context"

# General operations
abbr -a -- kdel "kubectl delete"
abbr -a -- kdelf "kubectl delete -f"

# Pod management
abbr -a -- kdelp "kubectl delete pods"
abbr -a -- kdp "kubectl describe pods"
abbr -a -- kep "kubectl edit pods"
abbr -a -- kgp "kubectl get pods"
abbr -a -- kgpa "kubectl get pods --all-namespaces"
abbr -a -- kgpl "kubectl get pods -l"
abbr -a -- kgpn "kubectl get pods -n"
abbr -a -- kgpw "kubectl get pods --watch"
abbr -a -- kgpwide "kubectl get pods -o wide"

# Service management
abbr -a -- kdels "kubectl delete svc"
abbr -a -- kds "kubectl describe svc"
abbr -a -- kes "kubectl edit svc"
abbr -a -- kgs "kubectl get svc"
abbr -a -- kgsa "kubectl get svc --all-namespaces"
abbr -a -- kgsw "kubectl get svc --watch"
abbr -a -- kgswide "kubectl get svc -o wide"

# Ingress management
abbr -a -- kdeli "kubectl delete ingress"
abbr -a -- kdi "kubectl describe ingress"
abbr -a -- kei "kubectl edit ingress"
abbr -a -- kgi "kubectl get ingress"
abbr -a -- kgia "kubectl get ingress --all-namespaces"

# HTTPRoute management
abbr -a -- kdelh "kubectl delete httproute"
abbr -a -- kdh "kubectl describe httproute"
abbr -a -- keh "kubectl edit httproute"
abbr -a -- kgh "kubectl get httproute"
abbr -a -- kgha "kubectl get httproute --all-namespaces"

# GRPCRoute management
abbr -a -- kdelg "kubectl delete grpcroute"
abbr -a -- kdg "kubectl describe grpcroute"
abbr -a -- keg "kubectl edit grpcroute"
abbr -a -- kgg "kubectl get grpcroute"
abbr -a -- kgga "kubectl get grpcroute --all-namespaces"

# ReferenceGrant management
abbr -a -- kdelr "kubectl delete referencegrant"
abbr -a -- kdr "kubectl describe referencegrant"
abbr -a -- ker "kubectl edit referencegrant"
abbr -a -- kgr "kubectl get referencegrant"
abbr -a -- kgra "kubectl get referencegrant --all-namespaces"

# Namespace management
abbr -a -- kdelns "kubectl delete namespace"
abbr -a -- kdns "kubectl describe namespace"
abbr -a -- kens "kubectl edit namespace"
abbr -a -- kgns "kubectl get namespaces"

# ConfigMap management
abbr -a -- kdcm "kubectl describe configmap"
abbr -a -- kdelcm "kubectl delete configmap"
abbr -a -- kecm "kubectl edit configmap"
abbr -a -- kgcm "kubectl get configmaps"
abbr -a -- kgcma "kubectl get configmaps --all-namespaces"

# Secret management
abbr -a -- kdelsec "kubectl delete secret"
abbr -a -- kdsec "kubectl describe secret"
abbr -a -- kgsec "kubectl get secret"
abbr -a -- kgseca "kubectl get secret --all-namespaces"

# Deployment management
abbr -a -- kdd "kubectl describe deployment"
abbr -a -- kdeld "kubectl delete deployment"
abbr -a -- ked "kubectl edit deployment"
abbr -a -- kgd "kubectl get deployment"
abbr -a -- kgda "kubectl get deployment --all-namespaces"
abbr -a -- kgdw "kubectl get deployment --watch"
abbr -a -- kgdwide "kubectl get deployment -o wide"
abbr -a -- krsd "kubectl rollout status deployment"
abbr -a -- ksd "kubectl scale deployment"

# Rollout management
abbr -a -- kgrs "kubectl get rs"
abbr -a -- krh "kubectl rollout history"
abbr -a -- krr "kubectl rollout restart"
abbr -a -- kru "kubectl rollout undo"

# StatefulSet management
abbr -a -- kdelss "kubectl delete statefulset"
abbr -a -- kdss "kubectl describe statefulset"
abbr -a -- kess "kubectl edit statefulset"
abbr -a -- kgss "kubectl get statefulset"
abbr -a -- kgssa "kubectl get statefulset --all-namespaces"
abbr -a -- kgssw "kubectl get statefulset --watch"
abbr -a -- kgsswide "kubectl get statefulset -o wide"
abbr -a -- krsss "kubectl rollout status statefulset"
abbr -a -- ksss "kubectl scale statefulset"

# Port forwarding
abbr -a -- kpf "kubectl port-forward"

# Get all resources
abbr -a -- kga "kubectl get all"
abbr -a -- kgaa "kubectl get all --all-namespaces"

# Logs operations
abbr -a -- kl "kubectl logs"
abbr -a -- kl1h "kubectl logs --since 1h"
abbr -a -- kl1m "kubectl logs --since 1m"
abbr -a -- kl1s "kubectl logs --since 1s"
abbr -a -- klf "kubectl logs -f"
abbr -a -- klf1h "kubectl logs --since 1h -f"
abbr -a -- klf1m "kubectl logs --since 1m -f"
abbr -a -- klf1s "kubectl logs --since 1s -f"

# File copy
abbr -a -- kcp "kubectl cp"

# Node management
abbr -a -- kdelno "kubectl delete node"
abbr -a -- kdno "kubectl describe node"
abbr -a -- keno "kubectl edit node"
abbr -a -- kgno "kubectl get nodes"

# PVC management
abbr -a -- kdelpvc "kubectl delete pvc"
abbr -a -- kdpvc "kubectl describe pvc"
abbr -a -- kepvc "kubectl edit pvc"
abbr -a -- kgpvc "kubectl get pvc"
abbr -a -- kgpvca "kubectl get pvc --all-namespaces"
abbr -a -- kgpvcw "kubectl get pvc --watch"

# DaemonSet management
abbr -a -- kdds "kubectl describe ds"
abbr -a -- kdelds "kubectl delete ds"
abbr -a -- keds "kubectl edit ds"
abbr -a -- kgds "kubectl get ds"
abbr -a -- kgdsa "kubectl get ds --all-namespaces"
abbr -a -- kgdsw "kubectl get ds --watch"

# Events management
abbr -a -- kge "kubectl get events"
abbr -a -- kgea "kubectl get events --all-namespaces"
abbr -a -- kgew "kubectl get events --watch"