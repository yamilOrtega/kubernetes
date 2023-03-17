Existen diversas formas y proveedores de kubernetes. 
En este tutorial utizaremos 4 maquinas virtuales en una misma red.

Esta serie de instrucciones estan basadas en la guia proporcionada por 
https://www.linuxtechi.com/install-kubernetes-on-ubuntu-22-04/

#Instalacion Kubernetes On Premise

##Equipo Main
Dentro de este equipo se deberan realizar los siguientes comandos

Instalacion de herramientas de red
```Python
$sudo apt install net-tools
$ifconfig
```
El nodo principal tendra el hostname main
```Python
$sudo hostnamectl set-hostname "main.congresofoss.net"
```
Se deshabilita el swap

```Python
$sudo swapoff -a
$sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

Se agregan modulos y reinicia system
```Python
$sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

$sudo modprobe overlay
$sudo modprobe br_netfilter


$sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
$sudo sysctl --system
```
Se habilitan certificados e instalacion de docker
```Python
$sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
$sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
$sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
$sudo apt upgrade
$sudo apt update
$sudo apt install -y containerd.io
$containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
$sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
$sudo systemctl restart containerd
$sudo systemctl enable containerd
```

Se agrega repositorio y realiza la instalacion de kubernetes

```Python
$curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
$sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
$sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-jammy main"
$sudo apt update
$sudo apt install -y kubelet kubeadm kubectl
$sudo apt-mark hold kubelet kubeadm kubectl
```
Repetir todos los anterior en los nodos workers excepto que la linea del nombre de host sera distinta

```Python
$sudo hostnamectl set-hostname "worker1.congresofoss.net"
$sudo hostnamectl set-hostname "worker2.congresofoss.net"
```

Identificar ip de nodo main, worker1 y worker2 y editar archivo /etc/hosts de cada nodo.

```Python
$sudo vi /etc/hosts

127.0.0.1 localhost
127.0.1.1 main

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

192.168.122.19   main.congresofoss.net master
192.168.122.231   worker1.congresofoss.net worker1
192.168.122.232   worker2.congresofoss.net worker2
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
kubeadm join master.congresofoss.net:6443 --token 6h3x0j.zn9y5ukyi3ri8c7b \
        --discovery-token-ca-cert-hash sha256:047482a373b84ae655d3780d894fa3e207cd72ab5aa3364e75bad661dd010bbc

```
Aunque los nodos se hayan agregado correctamente, estos no estaran disponibles a menos que se instale un manejador de red. En este caso utilizaremos Calico
```Python
$kubectl get nodes 
```
```Python
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
```

```Python
$kubectl get nodes 
```
Cuando los nodos aparecen como ready, esta listo para utilizar Kubernetes.



