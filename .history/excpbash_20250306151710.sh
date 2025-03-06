#!/bin/bash
# use chinese comments in this file
d=`date +%d-%m-%Y-%H-%M`
pod_name=
current_folder=$(pwd) 
cp_file=
arch_file=
folder_for_cp=
is_folder_to_process=false
re="^([a-zA-Z0-9]*)(-[a-zA-Z0-9]*){1,5}"
compress=false
uncompress=false
selected_file=
selected_aspect=
re='^[0-9]+$'
re_pod="^([a-zA-Z0-9]*)(-[a-zA-Z0-9]*){1,5}"
container_name="" #增加container name

# 选择aspect
query_user_for_aspect(){
	declare -a arrAspects
	arrAspects=("accstorefront" "backoffice" "api" "backgroundprocessing" "solr" "zookeeper" "apache2" "jsapps")
	
	arrIN=(${pod_name//-/ })

	list_size="${#arrAspects[@]}"

	for ((i = 0 ; i < $list_size ; i++)); do
		if [ "${arrAspects[$i]}" = "${arrIN[0]}" ]; then
			selected_aspect="${arrAspects[$i]}"
		fi
    done

	echo "Following aspect: $selected_aspect will be set as active one."
	arrAspects=()
}

# 根据 selected_aspect 选择不同的默认文件列表

query_user_for_file(){

	declare -a arrFiles
	
	if [ "$selected_aspect" = "apache2" ]; then
		arrFiles=("/usr/local/apache2/conf/httpd.conf")
	elif [ "$selected_aspect" = "jsapps" ]; then
		arrFiles=("/opt/jsapps" "/opt/jsapps/spartacusstore/index.html")
	elif [ "$selected_aspect" = "solr" ]; then
		arrFiles=("/var/solr" "/var/solr/configsets" "/var/solr/solr.xml" "/var/solr/zoo.cfg" "/var/solr/solr.jks" "/var/solr/configs")
	elif [ "$selected_aspect" = "zookeeper" ]; then
		arrFiles=("/opt/zookeeper/" "/opt/zookeeper/conf" "/var/zookeeper/version-2")
	elif [ "$selected_aspect" = "accstorefront" ] || [ "$selected_aspect" = "backoffice" ] || [ "$selected_aspect" = "api" ] || [ "$selected_aspect" = "backgroundprocessing" ]; then
		arrFiles=("/opt/aspects" "/opt/hybris/config" "/opt/hybris/log/jdbc.log" "/opt/hybris/log" "/opt/hybris/bin/custom" "/opt/hybris/log/solrstats/stats.log" "/opt/hybris/log/performance.log" "/opt/hybris/temp")
	else
		arrFiles=()
		echo "selected aspect is not supported in file/folder suggestion mode, so script will finish at this point (try execute script with 2 params)"
		exit 1
	fi

	list_size="${#arrFiles[@]}"
	echo "Please choose file/folder which you would like to download"
	for ((i = 0 ; i < $list_size ; i++)); do
		if ! (( $i % 2 )); then
			echo -e "\033[0;34mType $i for - ${arrFiles[$i]}\033[0m"
		else 
			echo "Type $i for - ${arrFiles[$i]}"
		fi
    done
				
	read -p "Please type here position number :" file_number 
    		
    if ! [[ $file_number =~ $re ]] ; then
       	echo "Please enter only numbers here" 
    elif (($file_number >= 0 && $file_number < list_size)); then
      	selected_file="${arrFiles[$file_number]}"

       	echo "Following object: $selected_file was selected for downloading."
    fi
	arrFiles=()
}


# 解析命令行参数
# Loop through arguments and process them
# 增加container 选项
for arg in "$@"
do
    case $arg in
	    -c|--container)
        shift
        container_name="$1"
        echo "Target container set to: $container_name"
        shift
        ;;
        -p|--compress)     #change the compress to -p
        echo 'you have selected -p flag, so [file/folder] will be compressed'
        compress=true
        shift # Remove --compress from processing
        ;;
        -u|--uncompress)
        uncompress=true
        echo 'you have selected -u flag, so [file/folder] will be uncompressed'
        shift # Remove --uncompress from processing
        ;;
        -h|--help)
        echo 'supported flags: '
        echo "-u|--uncompress -> use it when you want to uncompress downloaded file"
        echo "-p|--compress -> use it when you want to compress file which you are going to download"   #change the compress to -p
		echo "-c|--container -> Specify the target container"
		echo "script usage: kubectl ex-cp [-p|-u] [-c container_name] pod_name [file path]" #增加sample command
        exit 1
        ;;        
        *)
        OTHER_ARGUMENTS=("$arg")
        ;;
    esac
done

#增加container的判断
if [ -n "$container_name" ]; then
    container_option="--container $container_name"
else
    container_option=""
fi

if [ -n "$1" ]
  echo script download file from $1 pod on date: $d # format will be 12-30-2017 
  pod_name=$1
  echo "pod name $pod_name"
  then
  	echo "parameters $1, $2"
	if !  [[ $pod_name =~ $re_pod ]] 
		then	
			echo "$pod_name <- not supported name of pod"
			exit 1	
	fi
	
	if [ -n "$2" ]
		then  
			folder_for_cp=$2
			echo "you have set $2 for download"
	else
			# 2nd parameter was not defined, so we will ask for some defaults
			query_user_for_aspect
			query_user_for_file

			folder_for_cp=$selected_file
	fi  

#检查文件是否存在
#增加container option
	echo "we will check if file/folder $folder_for_cp exists"
    folder_check=$(kubectl exec $pod_name $container_option -- sh -c "test -d $folder_for_cp && echo 'it exists' || echo 'it does not exists'")
    file_check=$(kubectl exec $pod_name $container_option -- sh -c "test -f $folder_for_cp && echo 'it exists' || echo 'it does not exists'")
	
	if  [[ $folder_check == "it exists" ]]
		then
			echo "folder $folder_for_cp exists"
			is_folder_to_process=true
	elif [[ $file_check == "it exists" ]]
		then
			echo "file $folder_for_cp exists"
	else 
			echo "[file/folder] doesn't exist, so please fix [file/folder] path and rerun the script"
			exit 1
	fi

	if [ "$is_folder_to_process" = true ]
		then
			# compress folder and download
			cp_dir=$(echo "$folder_for_cp"|xargs dirname)
			cp_last_dir=$(basename $folder_for_cp)
			cp_file=$cp_last_dir
			arch_file="${cp_last_dir}.tar.gz"
			# all folders will be compressed
			compress=true
	else
			# compress file and download
			cp_dir=$(echo "$folder_for_cp"  | xargs dirname)
			cp_file=$(echo "${folder_for_cp##*/}")
			arch_file=$cp_file.tar.gz
	fi

#增加containername	
	if [ "$compress" = true ]
		then
			echo "we will compress ${cp_file}"
            kubectl exec $pod_name $container_option -- sh -c "cd $cp_dir && tar -czvf /tmp/$arch_file $cp_file"
			echo "${cp_file} has been compressed"
			kubectl exec $pod_name $container_option -- sh -c "ls -lstrh /tmp | grep $arch_file"
	fi
	
	echo "we will download ${cp_file}"
	if [ "$compress" = true ]
		then
			kubectl cp $container_option "$pod_name:/tmp/$arch_file" "$current_folder/$arch_file"
			ls -lstrh | grep "$arch_file"
			
			echo "clear files on k8s side"
			kubectl exec $pod_name $container_option -- sh -c "rm /tmp/$arch_file"
	else
		kubectl cp "$pod_name:$cp_dir/$cp_file" "$current_folder/$cp_file" $container_option
		ls -lstrh | grep "$cp_file"
	fi
	
	echo "${cp_file} has been downloaded "
	
#压缩和下载

	if [ "$uncompress" = true ]
		then		
			if [ "$compress" = true ] 
				then
					echo "now we will uncompress ${arch_file}"
					tar -zxvf $arch_file
					echo "File ${arch_file} was uncompressed"
			else
					echo "now we will try to uncompress ${cp_file}"
					if [[ "$cp_file" == *.tar.gz ]] 
						then 
							tar -zxvf $cp_file
							echo "File ${cp_file} was uncompressed"
					else
						echo 'script will only try to uncompress files with extension .tar.gz'
					fi
			fi
	fi
	ls -lstrh | grep "$cp_file"

else 
  echo "you have to call script with at least 1 parameter [pod name]"
fi

