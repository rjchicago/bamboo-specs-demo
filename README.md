# Bamboo Specs Demo

[![video](https://img.youtube.com/vi/D_Lg3EqN0IA/0.jpg)](https://www.youtube.com/watch?v=D_Lg3EqN0IA)

## usage

``` sh
# clone this repo
git clone https://github.com/rjchicago/bamboo-specs-demo.git
cd bamboo-specs-demo

# create .env and edit
cp .env.example .env
code .env

# run replace
sh replace.sh
code .
```

## Bamboo

``` sh
cd demo
docker-compose up -d
open http://localhost:8085
```

## revert replacements

``` sh
git reset master --hard
```
