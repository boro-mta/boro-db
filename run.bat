docker build -t boro-db .
docker run --memory=3g -d -p 1433:1433 boro-db