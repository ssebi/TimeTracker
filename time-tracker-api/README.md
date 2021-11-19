### Deployment

```
git remote add dokku dokku@49.12.217.151:api
git subtree push --prefix time-tracker-api dokku master
```

### DockerBuild

```
docker build . -t time-tracker-api
docker run -i -t -p 3000:3000 --name time-tracker-api time-tracker-api
```

```
dokku config:set api DOKKU_PROXY_PORT_MAP=http:80:3000

```

```
http://api.time-tracker.ml/
```
