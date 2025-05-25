#!/bin/bash

echo "Tworzenie woluminu nginx_data..."
docker volume create nginx_data

echo "Uruchamianie kontenera Nginx z podłączonym woluminem..."
docker run -d --name nginx_container -p 8080:80 -v nginx_data:/usr/share/nginx/html nginx

echo "Kontener Nginx został uruchomiony i dostępny pod adresem: http://localhost:8080"

# Utworzenie tymczasowego katalogu dla plików HTML
mkdir -p ~/nginx_temp
cd ~/nginx_temp

cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Moja własna strona Nginx</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 30px;
            background-color: #f4f4f4;
            color: #333;
        }
        h1 {
            color: #2573a7;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Witaj na mojej stronie!</h1>
        <p>Ta strona została utworzona przy użyciu niestandardowego woluminu Docker.</p>
        <p>Data i godzina utworzenia: <span id="datetime"></span></p>
    </div>
    <script>
        document.getElementById("datetime").textContent = new Date().toLocaleString();
    </script>
</body>
</html>
EOF

# Kopiowanie plików HTML do woluminu Docker
echo "Kopiowanie plików HTML do woluminu..."
docker cp index.html nginx_container:/usr/share/nginx/html/

