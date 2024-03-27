FROM ubuntu:latest
ADD init.sh requirements.txt debian.backup /
RUN bash /init.sh ; rm -fv /init.sh /requirements.txt

CMD ["bash", "-c", "cd /debian.backup/topfreeproxies ; sudo bash start.sh"]
