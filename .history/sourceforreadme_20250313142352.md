# Tools

Purpose of this repository is to allow us to execute some diagnostic tools on kubernetes pods.

# Prerequisites

You have to install:
- kubernetes client

# Installing

You have to execute install.sh script as root or using sudo

```
$ sudo install.sh
```

This should:
> copy ./k8s-plugin/* to /usr/local/bin/ which will be scanned by kubernetes client plugin
> set env variable tools_folder, which should point to folder with this repo 

# Running

> export KUBECONFIG=your-kubeconfig-file
> display pod list 
```
$ kubectl get po
```
## Plugins

### tools-on

> description

This plugin will allow you to enable on particular pod following supported programs:
- ps
- top.

> execute plugin
```
$ kubectl tools-on name-of-pod
```
after that command, it should login you into bash on name-of-pod pod, then just allow you to call any supported tools:
- ps 
- top

example command (view threads):
```
top -n 1 -H -c -b -p process_id
```

### gen-histo

> description

This plugin will trigger java histogram on particular pod and it will download it to current local folder.

> execute plugin
```
$ kubectl gen-histo name-of-pod
```
params:
- pod name
- process id (default = 1)

```
$ kubectl gen-histo 1
```

### gen-td

> description

This plugin will trigger java thread dump on particular pod and it will pack there, then download and unpack it to current local folder.

> execute plugin
```
$ kubectl gen-td [-c container_name] pod_name [PID] [number of threads to generate] [interval in seconds]
$ kubectl gen-td [-c container_name] -a mask_for_pods [PID] [number of threads to generate] [interval in seconds]
```
params:
- -c container name
- pod name or -a mask for pods
- process id (default = 1)
- number of thread dumps (default = 1)
- interval between thread dump captures (in seconds)

```
$ kubectl gen-td name-of-pod 1 2
```

### gen-top

> description

This plugin will trigger top command on particular pod and it will download it to current local folder.

> execute plugin
```
$ kubectl gen-top name-of-pod
```
params:
- pod name
- process id (default = 1)

```
$ kubectl gen-td name-of-pod 1
```

### gen-all

> description

This plugin will trigger commands from following plugins: 
	- gen-histo, 
	- gen-top, 
	- gen-td 
on particular pod, and it will pack results, download it and unpack to current local folder.

> execute plugin
```
$ kubectl gen-all name-of-pod
```
params:
- pod name
- process id (default = 1)

```
$ kubectl gen-all name-of-pod 1
```

### gen-heap
> description

This plugin will trigger generation of java heap dump on particular pod, it will pack generated hprof file and download it to current local folder.

Plugin will use Dynatrace folder "/opt/dynatrace/oneagent/log/memorydump" or "/var/lib/dynatrace/oneagent/datastorage/memorydump" designed for storing heap dumps on kubernetes pod level , if it will not exist, it will try to create it. 

When there will be no free space on disk level, you can follow instructions from CCv2 Heap Dumps Disk Space Issue Workaround (https://cxwiki.sap.com/display/cloudss/CCv2+Heap+Dumps+Disk+Space+Issue+Workaround) or just use script on Jenkins server heap dump folder extender (https://jenkins-machine.westeurope.cloudapp.azure.com/job/Scripts/job/ccl2%20heap%20dump%20folder%20extender/) which will mount VMSS's temporary space to "/opt/dynatrace/oneagent/log/memorydump" or "/var/lib/dynatrace/oneagent/datastorage/memorydump" folder.

> execute plugin
```
$ kubectl gen-heap name-of-pod
```

params:

- pod name
- process id (default = 1)
- folder name (optional), but if you will not define it script will ask you to choose one folder from 2 supported by 2 Dynatrace
```
$ kubectl gen-heap name-of-pod 1
```


### ex-gc

> description

This plugin will trigger Java GC command on particular pod or all pods from particular aspect.

> execute plugin
```
$ kubectl ex-gc name-of-pod
or 
$ kubectl ex-gc all
```
params:
- pod name or all, if you will call script with 'all' param script will ask you to choose aspect
- process id (default = 1)

```
$ kubectl ex-gc name-of-pod 1
```


### ex-ba

> description

This plugin will login you into bash on particular pod.

> execute plugin
```
$ kubectl ex-ba name-of-pod
```
params:
- pod name



### ex-df

> description

This plugin will trigger 'df -h' command on particular pod or all pods from particular aspect.

> execute plugin
```
$ kubectl ex-df name-of-pod
or 
$ kubectl ex-df all
```
params:
- pod name or all, if you will call script with 'all' param script will ask you to choose aspect
- folder (default is '')

```
$ kubectl ex-df name-of-pod /var
```


### ex-ls

> description

This plugin will trigger 'ls -lstr' command on particular pod or all pods from particular aspect.

> execute plugin
```
$ kubectl ex-ls name-of-pod
or 
$ kubectl ex-ls all
```
params:
- pod name or all, if you will call script with 'all' param script will ask you to choose aspect
- folder (default is '')

```
$ kubectl ex-ls name-of-pod /var
```

### ex-cp

> description

This plugin will download file or folder from particular pod.

> execute plugin
```
$ kubectl ex-cp name-of-pod [folder|file]
or 
$ kubectl ex-cp -c -u  name-of-pod [folder|file]
```
params:
- pod name 
- path of folder or file

flags:
-c|--compress -> if you will set this flag, file/folder will be downloaded as compressed (folders will be always downloaded as compressed)
-u|--uncompress -> if you will set this flag, file/folder after downloading it will be uncompressed locally

examples of usage:
```
$ kubectl ex-cp -c -u  accstorefront-644465b8cc-xj25j /opt/dynatrace/oneagent/log/memorydump/20201110073831_1/dump.hprof
$ kubectl ex-cp -u solr-0 /var/solr/master_apparel-uk_Product_default_shard1_replica_n1
$ kubectl ex-cp -c -u apache2-igc-c594c46cd-7vcbv /usr/local/apache2/conf/httpd.conf
```

### db

> description

This plugin will extract database credentials and url from platform-props-common secret. If Data Hub is available it will also extract Data Hub's database credentials.

> execute plugin
```
$ kubectl db
```

examples of usage:
```
$ kubectl db
```

### apacheconf

> description

This plugin will download Apache Ingress configuration file.

> execute plugin
```
$ kubectl apacheconf
```

examples of usage:
```
$ kubectl apacheconf
```
### kill-failed-ingress

> description

This plugin will kill all apache ingress pods in failed phase.

> execute plugin
```
$ kubectl kill-failed-ingress
```

examples of usage:
```
$ kubectl kill-failed-ingress
```

### nettest

> description

This plugin created Ubuntu pod inside k8s cluster, copies host aliases and trusted certificates from one fo the running application pods and test the connection to specified host and port using both netcat and java class (along with trusted certificates).

> execute plugin
```
$ kubectl nettest host [port]
```
params:
- host name 
- port (default is 443)

examples of usage:
```
$ kubectl nettest www.google.com
$ kubectl nettest www.google.com 443
```

### gen-rem
> description

This plugin will generate list of solr remnant cores and cores missing physical representation on disk, it will generate file containg CLUSTERSTATUS response from solr and download it to current local folder and save gathered results split by solr pod and . 

> execute plugin
```
$ kubectl gen-rem name-of-pod port-number
$ kubectl gen-rem -j name-of-pod port-number
```

params:

- pod name (default is solr-0) -> solr pod from which CLUSTERSTATUS should be downloaded
- port number (default is 7117 ) -> port on which connection to pod should be established to download CLUSTERSTATUS

flags:
- -j -> changes CLUSTERSTATUS parsing tool to JQ from GREP (should be faster but requires instalation of additional bash tool)

examples of usage:
```
$ kubectl gen-rem
$ kubectl gen-rem solr-1 8983
$ kubectl gen-rem -j solr-1 
```
