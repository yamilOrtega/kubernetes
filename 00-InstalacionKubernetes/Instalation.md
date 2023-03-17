Existen diversas formas y proveedores de kubernetes. 
En este tutorial utizaremos 4 maquinas virtuales en una misma red.

Esta serie de instrucciones estan basadas en la guia proporcionada por 
https://www.linuxtechi.com/install-kubernetes-on-ubuntu-22-04/

#Instalacion Kubernetes On Premise

##Equipo Main
Dentro de este equipo se deberan realizar los siguientes comandos

Instalacion de herramientas de red
```Python
$ sudo apt install net-tools
$ ifconfig
```
El nodo principal tendra el hostname main
```Python
$ sudo hostnamectl set-hostname "main.congresofoss.net"
```
Se deshabilita el swap

```Python
$ sudo swapoff -a
$ sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

Se agregan modulos y reinicia system
```Python
$ sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

$ sudo modprobe overlay
$ sudo modprobe br_netfilter


$ sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
$ sudo sysctl --system
```
Se habilitan certificados e instalacion de docker
```Python
$ sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
$ sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
$ sudo apt upgrade
$ sudo apt update
$ sudo apt install -y containerd.io
$ containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
$ sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
$ sudo systemctl restart containerd
$ sudo systemctl enable containerd
```

Se agrega repositorio y realiza la instalacion de kubernetes

```Python
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
$ sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
$ sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-jammy main"
$ sudo apt update
$ sudo apt install -y kubelet kubeadm kubectl
$ sudo apt-mark hold kubelet kubeadm kubectl
```
Repetir todos los anterior en los nodos workers excepto que la linea del nombre de host sera distinta

```Python
$ sudo hostnamectl set-hostname "worker1.congresofoss.net"
$ sudo hostnamectl set-hostname "worker2.congresofoss.net"
```

Identificar ip de nodo main, worker1 y worker2 y editar archivo /etc/hosts de cada nodo.

```Python
$ sudo vi /etc/hosts

127.0.0.1 localhost
127.0.1.1 main

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

192.168.122.19   main.congresofoss.net master
192.168.122.30   worker1.congresofoss.net worker1
192.168.122.31   worker2.congresofoss.net worker2
```
Es importante que despues de reiniciar los equipos, estos puedan volver a obtener las ips con las que fueron establecidas en el archivo hosts. En el caso de Ubuntu, esto realiza a traves del netplan. Este es un archivo ejemplo del nodo main.

```Python
main@main:/$ cat /etc/netplan/00-installer-config.yaml
# This is the network config written by 'subiquity'
network:
  ethernets:
    enp1s0:
      addresses: [192.168.122.19/24]
      gateway4: 192.168.122.1
      nameservers:
        addresses: [192.168.122.1]
  version: 2
main@main:/$ sudo netplan apply
```
Una vez configuradas las ips estaticas, inicalizar el nodo principal de kubernetes/

```Python
$sudo kubeadm init --control-plane-endpoint=main.congresofoss.net
```

La salida del comando anterior, si funciono correctamente, mostrara las instrucciones para poder utilizar el nodo.

```Python
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

En los nodows workers, ejecutar el siguiente comando que puede variar dependiendo de la salida


```Python
sudo kubeadm join master.congresofoss.net:6443 --token 6h3x0j.zn9y5ukyi3ri8c7b \
        --discovery-token-ca-cert-hash sha256:047482a373b84ae655d3780d894fa3e207cd72ab5aa3364e75bad661dd010bbc

```
Aunque los nodos se hayan agregado correctamente, estos no estaran disponibles a menos que se instale un manejador de red. En este caso utilizaremos Calico
```Python
main@main:~$ kubectl get nodes
NAME                       STATUS     ROLES           AGE     VERSION
main.congresofoss.net      NotReady   control-plane   5m35s   v1.26.2
worker1.congresofoss.net   NotReady   <none>          30s     v1.26.2
worker2.congresofoss.net   NotReady   <none>          23s     v1.26.2

main@main:~$ kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

poddisruptionbudget.policy/calico-kube-controllers created
serviceaccount/calico-kube-controllers created
serviceaccount/calico-node created
configmap/calico-config created
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/caliconodestatuses.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipreservations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
clusterrole.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrole.rbac.authorization.k8s.io/calico-node created
clusterrolebinding.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrolebinding.rbac.authorization.k8s.io/calico-node created
daemonset.apps/calico-node created
deployment.apps/calico-kube-controllers created


```
Se verifica el estado de la creacion de calico

```Python
main@main:~$ kubectl get pods -n kube-system -w
NAME                                            READY   STATUS    RESTARTS   AGE
calico-kube-controllers-57b57c56f-sl2dt         1/1     Running   0          16m
calico-node-fskdk                               1/1     Running   0          16m
calico-node-hclfx                               1/1     Running   0          16m
calico-node-mnpdx                               1/1     Running   0          16m
coredns-787d4945fb-lnffj                        1/1     Running   0          22m
coredns-787d4945fb-pdg2b                        1/1     Running   0          22m
etcd-main.congresofoss.net                      1/1     Running   0          23m
kube-apiserver-main.congresofoss.net            1/1     Running   0          22m
kube-controller-manager-main.congresofoss.net   1/1     Running   0          23m
kube-proxy-gg5qx                                1/1     Running   0          17m
kube-proxy-mbssk                                1/1     Running   0          22m
kube-proxy-zfx2s                                1/1     Running   0          17m
kube-scheduler-main.congresofoss.net            1/1     Running   0          23m
```
Pueden pasar varios minutos hasta que los nodos se encuentren en estatus RUNNING. Cuando todos los pods se encuentren en estado RUNNING podemos verificar nuevamente el estado de los pods.

```Python

main@main:~$ kubectl get nodes
NAME                       STATUS   ROLES           AGE   VERSION
main.congresofoss.net      Ready    control-plane   24m   v1.26.2
worker1.congresofoss.net   Ready    <none>          18m   v1.26.2
worker2.congresofoss.net   Ready    <none>          18m   v1.26.2
main@main:~$
```
Cuando los nodos aparecen como ready, esta listo para utilizar Kubernetes.



