1.0添加对imx8mp编译固件

1.1 添加 m7 启动配置
    若需打开m7 tcm 启动 uboot中配置:
    setenv m7_bin hello_world.bin
    setenv m7_addr 0x7e0000
    setenv use_m7 yes