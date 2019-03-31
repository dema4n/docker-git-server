# Docker-git-server
This repository contains a docker image with git server

Features:
* support ssh, https protocols
* creating multiple repositories through an environment variable
* has web interface

Pull command:
```bash
docker pull dema4n/docker-git-server
```

## Supported Tags

* `2.11.0-2019.03.31`, `latest`.

## Usage
### You must set environment variables
* `USER_ID` - your user identifier (UID). It will set up to user in container for avoid volume permission error
* `REPOSITORIES` - names of the git repositories that you want to create

### You can mount volumes from container to host machine
* `/home/httpd/git/repos` - git repositories 
* `/home/httpd/.ssh/` - ssh public keys for git server

### Examples
Manual run:
```
docker run \
    --rm \
    --publish 2200:22 \
    --publish 4430:443 \
    --env USER_ID=${UID} \
    --env REPOSITORIES="repo1 repo2" \
    --volume /git/repos/:/home/httpd/git/repos \
    --volume /git/ssh/authorized_keys/:/home/httpd/.ssh/ \
    --tty \
    --interactive \
    --name localhost \
    dema4n/docker-git-server:latest
```

Configuration in docker-compose.yml:
```
git:
    image: dema4n/docker-git-server:latest
    environment:
      USER_ID: ${USER_ID}
      REPOSITORIES: "repo1 repo2"
    ports:
      - "4430:443"
      - "2200:22"
    volumes:
      - ./git/repos/:/home/httpd/git/repos
      - ./git/ssh/authorized_keys/:/home/httpd/.ssh/
```

### How to make initial commit to repository
```
export GIT_SSL_NO_VERIFY=1  # Ignore error about self signed certificate

git clone ssh://httpd@localhost:2200/home/httpd/git/repos/repo1.git 
or  
git clone https://httpd:httpd@localhost:4430/git/repos/repo1.git

cd repo1
touch init_file
git init
git add .
git commit -m "initial commit"
git push origin master
```
You can see results in web interface: https://localhost:4430/gitweb/

## Links
* GitHub: https://github.com/dema4n/docker-git-server
* DockerHub: https://hub.docker.com/r/dema4n/docker-git-server
