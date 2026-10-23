FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       g++ openssh-server \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash tester \
    && mkdir -p /run/sshd /home/tester/.ssh \
    && chown tester:tester /home/tester/.ssh \
    && chmod 700 /home/tester/.ssh

COPY keys/robot_test.pub /tmp/robot_test.pub
COPY sensor_app.cpp /tmp/sensor_app.cpp

RUN install -o tester -g tester -m 600 \
       /tmp/robot_test.pub \
       /home/tester/.ssh/authorized_keys \
    && g++ -std=c++17 -O2 -Wall -Wextra -Werror \
       /tmp/sensor_app.cpp -o /usr/local/bin/sensor_app \
    && chmod 755 /usr/local/bin/sensor_app \
    && rm /tmp/robot_test.pub /tmp/sensor_app.cpp

RUN printf '%s\n' \
    'PubkeyAuthentication yes' \
    'PasswordAuthentication no' \
    'PermitRootLogin no' \
    > /etc/ssh/sshd_config.d/robot-test.conf

EXPOSE 22

CMD ["sh", "-c", "ssh-keygen -A && exec /usr/sbin/sshd -D -e"]
