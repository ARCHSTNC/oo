# docker-gitweb

# build
```
> docker build -t muquu/gitweb:1.0 .
```

# usage
```
> docker run -d -p 80:80 -v /c/Users/<user_name>/git:/var/lib/git:ro muquu/gitweb:1.0
```