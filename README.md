# Guacamole Server Builder

Docker image for building binary package of Apache Guacamole Server.

## Usage

### Preparing the source distribution

Download the source distribution of the Guacamole Server and save it into `work` directory.

```
wget https://dlcdn.apache.org/guacamole/<version>/source/guacamole-server-1.5.5.tar.gz -P work
```

### Building the binary packages

Build all binary packages from the downloaded source distribution.

```
./build-all.sh
```

The following installer files each for Ubuntu LTS version will be generated in the `work` directory.

* guacd_\<version\>-\<revision\>focal_amd64.deb
* guacd_\<version\>-\<revision\>jammy_amd64.deb
* guacd_\<version\>-\<revision\>noble_amd64.deb

### Installing the binary package

The built package can be installed using the following command.
```
sudo apt install ./guacd_<version>-<revision>_amd64.deb
```

The server can be started using `systemctl` command.
```
sudo systemctl enable guacd
sudo systemctl start guacd
```

The status of the server can be verified as follows.
```
sudo systemctl status guacd
```
