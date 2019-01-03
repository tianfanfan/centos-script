
#!/bin/bash
#--------------------------------脚本变量设置--------------------------------
#项目根目录
HOME_DIR="/home"
#项目目录:/mect
PROJECT_DIR="mect"
#日志目录:/log
LOG_DIR="log"
#备份目录：/backup
BACKUP_DIR="mect-backup"
#资源目录：/resource
RESOURCE_DIR="resource"
#脚本目录：/script
SCRIPT_DIR="script"
#配置文件目录：/config
CONFIG_DIR="config"
#项目中所有jar包的位置
JAR_DIR="jar/**/target"
#项目中shell脚本位置
BASH_DIR="script"
#获取本机ip地址
IP_ADDRESS=$(ip a | grep inet | grep -v inet6 | grep -v 127 | sed 's/^[ \t]*//g' | cut -d ' ' -f2 | grep -v 172 | cut -d '/' -f1)
#临时文件夹目录
TMP_DIR="tmp"


#--------------------------------1.新建目录--------------------------------
echo "当前本机IP地址为：${IP_ADDRESS}"
echo "--------------------------------1.开始创建Jenkins自动部署目录--------------------------------"
echo "项目目录结构为："
echo "/home/"
echo "├── mect-backup"
echo "├── tmp"
echo "└── mect"
echo "   ├── config"
echo "   ├── log"
echo "   ├── resource"
echo "   └── script"
echo "①创建：${HOME_DIR}/${PROJECT_DIR}/{${LOG_DIR},${RESOURCE_DIR},${SCRIPT_DIR},${CONFIG_DIR},${TMP_DIR}}"
mkdir -p ${HOME_DIR}/${PROJECT_DIR}/{${LOG_DIR},${RESOURCE_DIR},${SCRIPT_DIR},${CONFIG_DIR},${TMP_DIR}}
echo "②创建备份文件夹：${HOME_DIR}/${BACKUP_DIR}"
mkdir -p ${HOME_DIR}/${BACKUP_DIR}
echo "--------------------------------目录构建完成--------------------------------"
tree ${HOME_DIR}/${PROJECT_DIR}


#--------------------------------2.备份项目旧版本--------------------------------
echo "--------------------------------2.开始备份项目旧版本--------------------------------"
BACKUP_DATE="$(date "+%Y-%m-%d %H:%M:%S")"
echo "①.根据日期新建备份文件夹"
mkdir -p ${HOME_DIR}/${BACKUP_DIR}/"${BACKUP_DATE}"
echo "②.将原项目目录全部复制到备份目录下"
mv ${HOME_DIR}/${PROJECT_DIR} ${HOME_DIR}/${BACKUP_DIR}/"${BACKUP_DATE}"
cp /root/service-config.txt ${HOME_DIR}/${PROJECT_DIR} ${HOME_DIR}/${BACKUP_DIR}/"${BACKUP_DATE}"/${PROJECT_DIR}/${CONFIG_DIR}
echo "③.将临时文件夹移动到项目部署路径下"
mv ${HOME_DIR}/${TMP_DIR}/*  ${HOME_DIR}/${PROJECT_DIR}
echo "--------------------------------旧项目备份完成--------------------------------"
tree ${HOME_DIR}/${BACKUP_DIR}/"${BACKUP_DATE}"


#--------------------------------3.生成docker-compose.yml--------------------------------
echo "--------------------------------3.生成docker-compose.yml配置文件--------------------------------"
echo "①.获取java8镜像"
docker pull leif0207/medcaptain-java:8
echo "②.执行脚本，生成docker-compose.yml配置文件"
bash ${HOME_DIR}/${PROJECT_DIR}/${SCRIPT_DIR}/docker-compose.sh
echo "--------------------------------配置文件生成成功--------------------------------"

#--------------------------------4.构建镜像并启动容器--------------------------------
echo "--------------------------------4.构建镜像并启动容器--------------------------------"
cd ${HOME_DIR}/${PROJECT_DIR}/${CONFIG_DIR}
docker-compose up -d
echo "--------------------------------构建镜像并启动容器完成--------------------------------"
docker ps

exit