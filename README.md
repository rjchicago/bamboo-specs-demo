# Bamboo Specs Demo

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
docker volume create --name bamboo_data
docker run -d \
  -v bamboo_data:/var/atlassian/application-data/bamboo \
  --name="bamboo" \
  -p 8085:8085 \
  -p 54663:54663 \
  atlassian/bamboo

docker volume create --name bamboo_postgres

open http://localhost:8085
```

## revert replacements

``` sh
git reset master --hard
```
