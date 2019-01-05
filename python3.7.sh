#!/bin/bash
echo -e '\033[1;31m ********************************此脚本自动化编译安装Python3.7******************************** \033[0m'
echo -e '\033[1;31m 1.开始安装依赖包 \033[0m'
yum -y groupinstall "Development tools"
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel
echo -e '\033[1;31m 2.获取python3.7的安装包 \033[0m'
wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0a1.tar.xz
echo -e '\033[1;31m 3.解压 \033[0m'
tar -xvJf  Python-3.7.0a1.tar.xz
echo -e '\033[1;31m 4.配置python3的安装目录 \033[0m'
cd Python-3.7.0a1
./configure --prefix=/usr/local/bin/python3
echo -e '\033[1;31m 5.编译 \033[0m'
make
echo -e '\033[1;31m 6.安装 \033[0m'
make install
echo -e '\033[1;31m 7.创建软链接 \033[0m'
ln -s /usr/local/bin/python3/bin/python3 /usr/bin/python3
ln -s /usr/local/bin/python3/bin/pip3 /usr/bin/pip3
echo -e '\033[1;31m 8.查看pip3 版本 \033[0m'
pip3 -V
echo -e '\033[1;31m 9.查看python版本 \033[0m'
python3
echo -e "\033[1;32m python3安装完毕！ \033[0m"
exit