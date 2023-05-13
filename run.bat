docker build -t boro-db .
docker run -d -p 1433:1433 boro-db