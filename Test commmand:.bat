Test commmand:

kubectl ex-cp -p -c jsapps-ssr jsapps-f6996cb7f-mbv2k pm2apps.json

kubectl ex-cp -p -c saml-proxy solr-0 apache2.conf 

kubectl ex-cp -c saml-proxy solr-0 apache2.conf 
Target container set to: saml-proxy
script download file from solr-0 pod on date: 06-03-2025-09-21
pod name solr-0
parameters solr-0, apache2.conf
you have set apache2.conf for download
we will check if file/folder apache2.conf exists
file apache2.conf exists
we will download apache2.conf
error: tar contents corrupted
   16 -rw-r--r--@  1 I313063  staff   7.0K Oct 19 10:07 apache2.conf 3
   16 -rw-r--r--   1 I313063  staff   7.0K Oct 19 10:07 apache2.conf 2
   16 -rw-r--r--   1 I313063  staff   7.0K Oct 19 10:07 apache2.conf
    8 -rw-r--r--@  1 I313063  staff   3.0K Mar  6 09:21 apache2.conf.tar.gz
apache2.conf has been downloaded 
   16 -rw-r--r--@  1 I313063  staff   7.0K Oct 19 10:07 apache2.conf 3
   16 -rw-r--r--   1 I313063  staff   7.0K Oct 19 10:07 apache2.conf 2
   16 -rw-r--r--   1 I313063  staff   7.0K Oct 19 10:07 apache2.conf
    8 -rw-r--r--@  1 I313063  staff   3.0K Mar  6 09:21 apache2.conf.tar.gz


script usage: kubectl ex-cp [-p|-u] [-c container_name] pod_name [file path]

Error message:
I313063@XXMQW99GXL desktop % kubectl ex-cp solr-0 CHANGES.txt 
script download file from solr-0 pod on date: 06-03-2025-09-31
pod name solr-0
parameters solr-0, CHANGES.txt
you have set CHANGES.txt for download
we will check if file/folder CHANGES.txt exists
Defaulted container "solr" out of: solr, saml-proxy, install-oneagent (init)
Defaulted container "solr" out of: solr, saml-proxy, install-oneagent (init)
file CHANGES.txt exists
we will download CHANGES.txt
Defaulted container "solr" out of: solr, saml-proxy, install-oneagent (init)
error: tar contents corrupted
CHANGES.txt has been downloaded 

kubectl ex-cp -p solr-0 CHANGES.txt ===>>works



Test command Mar 11:
kubectl ex-cp -u -c  jsapps-ssr jsapps-f6996cb7f-mbv2k /opt/app/pm2apps.json
kubectl ex-cp -p -c  jsapps-ssr jsapps-f6996cb7f-mbv2k /opt/app/pm2apps.json

Mar 12
kubectl ex-cp -p -c  jsapps-ssr jsapps-f6996cb7f-mbv2k /opt/app/b2bspastore   #for folder
kubectl ex-cp -u -c  jsapps-ssr jsapps-f6996cb7f-mbv2k /opt/app/b2bspastore

kubectl ex-cp -p jsapps-f6996cb7f-mbv2k /opt/jsapps-custom.properties    ##Test for default container
kubectl ex-cp -p -c jsapps jsapps-f6996cb7f-mbv2k /opt/jsapps-custom.properties

********
kubectl ex-cp -p jsapps-f6996cb7f-mbv2k /opt/jsapps-custom.properties      
you have selected -p flag, so [file/folder] will be compressed
script download file from jsapps-f6996cb7f-mbv2k pod on date: 12-03-2025-10-32
pod name jsapps-f6996cb7f-mbv2k
parameters jsapps-f6996cb7f-mbv2k, /opt/jsapps-custom.properties
you have set /opt/jsapps-custom.properties for download
we will check if file/folder /opt/jsapps-custom.properties exists
Defaulted container "jsapps" out of: jsapps, jsapps-ssr, install-oneagent (init)
Defaulted container "jsapps" out of: jsapps, jsapps-ssr, install-oneagent (init)
file /opt/jsapps-custom.properties exists
we will compress jsapps-custom.properties
Defaulted container "jsapps" out of: jsapps, jsapps-ssr, install-oneagent (init)
jsapps-custom.properties
jsapps-custom.properties has been compressed
Defaulted container "jsapps" out of: jsapps, jsapps-ssr, install-oneagent (init)
   4.0K -rw-r--r--    1 nginx    nginx        151 Mar 12 02:32 jsapps-custom.properties.tar.gz
we will download jsapps-custom.properties
Defaulted container "jsapps" out of: jsapps, jsapps-ssr, install-oneagent (init)
tar: removing leading '/' from member names
   8 -rw-r--r--   1 I313063  staff   151B Mar 12 10:32 jsapps-custom.properties.tar.gz
clear files on k8s side
Defaulted container "jsapps" out of: jsapps, jsapps-ssr, install-oneagent (init)
jsapps-custom.properties has been downloaded 
   8 -rw-r--r--   1 I313063  staff   151B Mar 12 10:32 jsapps-custom.properties.tar.gz
********

kubectl ex-cp -u -c jsapps jsapps-f6996cb7f-mbv2k /opt/jsapps-custom.properties

Mar 13th
kubectl ex-cp -p -c saml-proxy solr-0 /etc/apache2/apache2.conf