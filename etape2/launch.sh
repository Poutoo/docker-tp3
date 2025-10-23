#!/bin/bash

# Supprimer les conteneurs et le réseau existants pour éviter les conflits
docker stop HTTP SCRIPT DATA 2>/dev/null
docker rm HTTP SCRIPT DATA 2>/dev/null
docker network rm tp3-network 2>/dev/null

# Créer le réseau Docker
docker network create tp3-network

# Lancer le conteneur DATA (MariaDB)
docker run -d --name DATA --network tp3-network \
    -e MARIADB_RANDOM_ROOT_PASSWORD=yes \
    -v /c/Users/thiba/Desktop/docker-tp3/etape2/app:/docker-entrypoint-initdb.d \
    mariadb:latest

# Lancer le conteneur SCRIPT (PHP-FPM avec mysqli)
docker run -d --name SCRIPT --network tp3-network \
    -v /c/Users/thiba/Desktop/docker-tp3/etape2/app:/app \
    my-php-fpm

# Lancer le conteneur HTTP (NGINX)
docker run -d --name HTTP --network tp3-network -p 8080:8080 \
    -v /c/Users/thiba/Desktop/docker-tp3/etape2/nginx/default.conf:/etc/nginx/conf.d/default.conf \
    -v /c/Users/thiba/Desktop/docker-tp3/etape2/app:/app \
    nginx:latest

# Vérifier les conteneurs en cours d'exécution
docker ps

# Afficher les logs pour dépannage
echo "Logs du conteneur HTTP :"
docker logs HTTP
echo "Logs du conteneur SCRIPT :"
docker logs SCRIPT
echo "Logs du conteneur DATA :"
docker logs DATA