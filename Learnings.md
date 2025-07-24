Docker pull fails saying max pull requests reached from IP


## Failure during scheduling


`Insufficient Resource`

Memory
Can be CPU as well


`Unbound Persistent Volume`

If there is no PV created from PVC, due to SC not present or some other errors


`nodeSelector acts as requiredDuringScheduling`

It is not recommened to use nodeName in the spec

Can use

requiredDuringSchedulingIgnoredDuringExecution

preferredDuringSchedulingIgnoredDuringExecution


`Node Taint`

k taint node <node-name> taint=true:NoSchedule

Also apply tolerations to solve the issue
Uncomment and apply again the K8s manifest


## Failure during Container Creation


`Unavailable Configmap`

`Unavailable Secret`

To solve problem like this

Make sure to create these before applying K8s manifests for apps