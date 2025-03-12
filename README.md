# k8sbash

**Main change:**


a. Change compression from "-c" to "-p" (abbreviation for pack)

b. Introduce the "-c" option to add possibility to specify container.

**Test steps:**

1.Download file from default container

```
kubectl ex-cp -p solr-0 CHANGES.txt
```

2. Download folder from default container

```
kubectl ex-cp -p solr-0 bin 
```

3. Download file from specific container

```
kubectl ex-cp -p -c saml-proxy solr-0 apache2.conf
you have selected -p flag, so [file/folder] will be compressed
Target container set to: saml-proxy
script download file from solr-0 pod on date: 06-03-2025-14-42
pod name solr-0
parameters solr-0, apache2.conf
you have set apache2.conf for download
we will check if file/folder apache2.conf exists
file apache2.conf exists
we will compress apache2.conf
apache2.conf
apache2.conf has been compressed
4.0K -rw-r--r-- 1 root root 3.1K Mar  6 06:43 apache2.conf.tar.gz
we will download apache2.conf
tar: Removing leading `/' from member names
   8 -rw-r--r--   1 I313063  staff   3.0K Mar  6 14:43 apache2.conf.tar.gz
clear files on k8s side
apache2.conf has been downloaded 
   8 -rw-r--r--   1 I313063  staff   3.0K Mar  6 14:43 apache2.conf.tar.gz

```

4. Download folder from specific container

```
kubectl ex-cp -p -c saml-proxy solr-0 conf-enabled  
you have selected -p flag, so [file/folder] will be compressed
Target container set to: saml-proxy
script download file from solr-0 pod on date: 06-03-2025-14-52
pod name solr-0
parameters solr-0, conf-enabled
you have set conf-enabled for download
we will check if file/folder conf-enabled exists
folder conf-enabled exists
we will compress conf-enabled
conf-enabled/
conf-enabled/other-vhosts-access-log.conf
conf-enabled/charset.conf
conf-enabled/serve-cgi-bin.conf
conf-enabled/localized-error-pages.conf
conf-enabled/security.conf
conf-enabled has been compressed
4.0K -rw-r--r-- 1 root root 282 Mar  6 06:52 conf-enabled.tar.gz
we will download conf-enabled
tar: Removing leading `/' from member names
   8 -rw-r--r--   1 I313063  staff   282B Mar  6 14:52 conf-enabled.tar.gz
clear files on k8s side
conf-enabled has been downloaded 
   8 -rw-r--r--   1 I313063  staff   282B Mar  6 14:52 conf-enabled.tar.gz
```

5. Test it on jsapp-ssr container

```
kubectl ex-cp -p -c jsapps-ssr jsapps-f6996cb7f-mbv2k pm2apps.json
you have selected -p flag, so [file/folder] will be compressed
Target container set to: jsapps-ssr
script download file from jsapps-f6996cb7f-mbv2k pod on date: 06-03-2025-14-58
pod name jsapps-f6996cb7f-mbv2k
parameters jsapps-f6996cb7f-mbv2k, pm2apps.json
you have set pm2apps.json for download
we will check if file/folder pm2apps.json exists
file pm2apps.json exists
we will compress pm2apps.json
pm2apps.json
pm2apps.json has been compressed
4.0K -rw-r--r-- 1 pm2 pm2 313 Mar  6 06:58 pm2apps.json.tar.gz
we will download pm2apps.json
tar: Removing leading `/' from member names
   8 -rw-r--r--   1 I313063  staff   313B Mar  6 14:58 pm2apps.json.tar.gz
clear files on k8s side
pm2apps.json has been downloaded 
   8 -rw-r--r--   1 I313063  staff   313B Mar  6 14:58 pm2apps.json.tar.gz
```

6. Test it with uncompress option.

```


kubectl ex-cp -u solr-0 /opt/solr/NOTICE.txtyou have selected -u flag, so [file/folder] will be uncompressed
script download file from solr-0 pod on date: 11-03-2025-13-52
pod name solr-0
parameters solr-0, /opt/solr/NOTICE.txt
you have set /opt/solr/NOTICE.txt for download
we will check if file/folder /opt/solr/NOTICE.txt exists
Defaulted container "solr" out of: solr, saml-proxy, install-oneagent (init)
Defaulted container "solr" out of: solr, saml-proxy, install-oneagent (init)
file /opt/solr/NOTICE.txt exists
we will download NOTICE.txt
Defaulted container "solr" out of: solr, saml-proxy, install-oneagent (init)
tar: Removing leading `/' from member names
  64 -rw-r--r--   1 I313063  staff    30K Mar 11 13:52 NOTICE.txt
NOTICE.txt has been downloaded
now we will try to uncompress NOTICE.txt
script will only try to uncompress files with extension .tar.gz
  64 -rw-r--r--   1 I313063  staff    30K Mar 11 13:52 NOTICE.txt
```
