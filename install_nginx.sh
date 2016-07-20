# url=https://imququ.com/post/my-nginx-conf.html
# 安装依赖库和编译要用的工具：
sudo apt-get install build-essential libpcre3 libpcre3-dev zlib1g-dev unzip git
# 获取 OpenSSL 源码、Cloudflare Patch 和 nginx-ct 源码，做好准备工作：
git clone https://github.com/cloudflare/sslconfig
wget -O openssl.zip -c https://github.com/openssl/openssl/archive/OpenSSL_1_0_2h.zip
unzip openssl.zip
mv openssl-OpenSSL_1_0_2h/ openssl
cd openssl
patch -p1 < ../sslconfig/patches/openssl__chacha20_poly1305_draft_and_rfc_ossl102g.patch 
cd ../
wget -O nginx-ct.zip -c https://github.com/grahamedgecombe/nginx-ct/archive/v1.2.0.zip
unzip nginx-ct.zip
# 选择二：HTTP/2 + SPDY
# 最近 Cloudflare 放出了一个让 Nginx 同时支持 HTTP/2 和 SPDY 的补丁现在还有一部分没有升级到最新版的浏览器只支持 SPDY，这个补丁可以给他们带来性能提升。本站目前在用这个补丁，但它只能用于 Nginx 1.9.7：
wget -c https://nginx.org/download/nginx-1.9.7.tar.gz
tar zxf nginx-1.9.7.tar.gz
cd nginx-1.9.7/
patch -p1 < ../sslconfig/patches/nginx__http2_spdy.patch
patch -p1 < ../sslconfig/patches/nginx__dynamic_tls_records.patch
./configure --add-module=../nginx-ct-1.2.0 --with-openssl=../openssl --with-http_v2_module --with-http_spdy_module --with-http_ssl_module --with-ipv6 --with-http_gzip_static_module
make
sudo make install
