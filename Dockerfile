FROM ubuntu:latest

# Устанавливаем нужные утилиты
RUN apt-get update && apt-get install -y wget unzip curl

# Скачиваем сервер Террарии (версия 1.4.4.9 как пример)
RUN wget https://terraria.org/api/download/pc-dedicated-server/terraria-server-1449.zip \
    && unzip terraria-server-1456.zip -d /terraria \
    && rm terraria-server-1456.zip

# Скачиваем playit.gg для проброса портов
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data-beta ./ " | tee /etc/apt/sources.list.d/playit-beta.list \
    && apt-get update \
    && apt-get install playit -y

# Создаем скрипт запуска
RUN echo '#!/bin/bash\nplayit & \n/terraria/1456/Linux/TerrariaServer.bin.x86_64 -config /terraria/serverconfig.txt' > /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
