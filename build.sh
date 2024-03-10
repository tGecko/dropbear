#!/bin/sh

export CROSS_COMPILE="/opt/miyoomini-toolchain/bin/arm-linux-gnueabihf-"
export CC="$CROSS_COMPILE""gcc"
export CXX="$CROSS_COMPILE""g++"
export CPP="$CROSS_COMPILE""gcc -E"
export STRIP="$CROSS_COMPILE""strip"
export AR="$CROSS_COMPILE""gcc-ar"
export RANLIB="$CROSS_COMPILE""gcc-ranlib"
export CFLAGS="-Wno-undef -O3 -marm -mtune=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -march=armv7ve+simd -ffunction-sections -fdata-sections -Wl,--gc-sections -Wl,-rpath=/mnt/SDCARD/.tmp_update/lib"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-L/usr/local/lib -s"

make clean
rm ./localoptions.h

cat <<- EOF > ./localoptions.h
#define DSS_PRIV_FILENAME "/mnt/SDCARD/.tmp_update/etc/dropbear/dropbear_dss_host_key"
#define RSA_PRIV_FILENAME "/mnt/SDCARD/.tmp_update/etc/dropbear/dropbear_rsa_host_key"
#define ECDSA_PRIV_FILENAME "/mnt/SDCARD/.tmp_update/etc/dropbear/dropbear_ecdsa_host_key"
#define ED25519_PRIV_FILENAME "/mnt/SDCARD/.tmp_update/etc/dropbear/dropbear_ed25519_host_key"
#define INETD_MODE 0
#define DROPBEAR_REEXEC 0
#define DROPBEAR_CLI_LOCALTCPFWD 0
#define DROPBEAR_SVR_LOCALTCPFWD 0
#define DROPBEAR_CLI_REMOTETCPFWD 0
#define DROPBEAR_SVR_REMOTETCPFWD 0
#define DROPBEAR_CLI_AGENTFWD 0
#define DROPBEAR_SVR_AGENTFWD 0
#define DROPBEAR_CLI_PROXYCMD 0
#define DROPBEAR_CLI_NETCAT 0
#define DROPBEAR_USER_ALGO_LIST 0
#define DROPBEAR_AES256 0
#define DROPBEAR_3DES 1
#define DROPBEAR_CHACHA20POLY1305 0
#define DROPBEAR_ENABLE_CBC_MODE 1
#define DROPBEAR_SHA2_256_HMAC 0
#define DROPBEAR_DSS 1
#define DROPBEAR_SK_KEYS 0
#define DROPBEAR_DEFAULT_RSA_SIZE 1024
#define DROPBEAR_DH_GROUP14_SHA256 0
#define DROPBEAR_DH_GROUP1 1
#define DROPBEAR_DH_GROUP1_CLIENTONLY 0
#define DO_MOTD 0
#define DROPBEAR_SVR_PUBKEY_AUTH 0
#define DROPBEAR_SVR_PUBKEY_OPTIONS 0
#define DROPBEAR_CLI_PUBKEY_AUTH 0
#define DROPBEAR_DEFAULT_CLI_AUTHKEY ""
#define DROPBEAR_USE_PASSWORD_ENV 0
#define DROPBEAR_SFTPSERVER 1
#define SFTPSERVER_PATH "/mnt/SDCARD/.tmp_update/bin/sftp-server"
#define DROPBEAR_PATH_SSH_PROGRAM ""
#define DEFAULT_ROOT_PATH "/customer/app:/mnt/SDCARD/.tmp_update/bin:/usr/sbin:/usr/bin:/sbin:/bin:/config"
#define DEFAULT_LIBRARY_PATH "/lib:/config/lib:/mnt/SDCARD/miyoo/lib:/mnt/SDCARD/.tmp_update/lib:/mnt/SDCARD/.tmp_update/lib/parasyte"
#define DROPBEAR_SVR_NO_LOGIN_SHELL 1
#define DROPBEAR_SVR_NO_CHDIR 1
#define DROPBEAR_SVR_EVERYONE_LOGIN_AS_ROOT 1
EOF

./configure --host=arm-linux-gnueabihf \
    --target=arm-linux-gnueabihf --disable-harden --disable-zlib --disable-pam --disable-largefile \
    --disable-syslog --enable-bundled-libtom --disable-lastlog --disable-loginfunc --disable-shadow \
    --disable-utmp --disable-utmpx --disable-wtmp --disable-wtmpx --disable-pututline --disable-pututxline \
    && make PROGRAMS="dropbear" -j"$(nproc)"