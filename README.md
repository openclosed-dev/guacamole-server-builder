# Guacamole Server Builder

Docker image for generating binary package of Apache Guacamole Server.

## Usage

### Building the docker image

```
docker compose build
```

### Generating binary package from source distribution

Download the source distribution of the Guacamole Server and save it into `work` directory.
```
wget https://dlcdn.apache.org/guacamole/<version>/source/guacamole-server-<version>.tar.gz -P work
```

Starting the Docker container automatically generates `.deb` package file in `work` directory.
```
docker compose up
```

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
