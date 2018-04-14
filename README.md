P4 environment setting
===

## Environment
- OS: Ubuntu 16.04 64-bits  
- CPU: at least 2 cores  
- RAM: at least 2G  
- Disk: at least 25G  

## Install P4 Lab
### Quickly install
```sh
$ wget -O setup.sh https://goo.gl/EHgk4v && sudo bash setup.sh && wget -O - https://goo.gl/NKaau7 | bash
```

### Using this repo's script
-  [p4-environment.sh](https://github.com/sufuf3/p4-install-environment/blob/master/p4-environment.sh)
```sh
$ wget -O - https://goo.gl/pNmWbS | bash
```
> This setup script finished in Sep 2017. However, the env meet p4c-bm2-ss compile failed. Wait for fixing.

### Using [P4 tutorials](https://github.com/p4lang/tutorials/tree/master/P4D2_2018_East/vm)
- root-bootstrap.sh
```sh
$ wget -O - https://goo.gl/NUA5p8 | bash
```
> Haven't tested yet.(Refer to user-bootstrap.sh, some dependencies need to install first, when you exec the script. Need to rewrite.)

- ✅ Rewirited [user-bootstrap.sh](https://github.com/sufuf3/p4-install-environment/blob/master/user-bootstrap.sh)
```sh
$ wget -O - https://goo.gl/NKaau7 | bash
```

Ref: https://github.com/p4lang/tutorials/tree/master/SIGCOMM_2015#obtaining-required-software
