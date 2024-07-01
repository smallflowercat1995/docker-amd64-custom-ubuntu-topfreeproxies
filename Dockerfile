FROM ubuntu:latest
WORKDIR /topfreeproxies
ADD init.sh requirements.txt topfreeproxies ./
RUN bash init.sh ; rm -fv init.sh requirements.txt

CMD ["bash", "-c", "cd /topfreeproxies ; sudo bash start.sh"]
