### Deployment

```
git remote add dokku dokku@49.12.217.151:time-tracking-api
git subtree push --prefix time-tracker-api dokku master
```

### DockerBuild

```
docker build . -t time-tracker-api
docker run -i -t -p 3000:3000 --name time-tracker-api time-tracker-api
```
