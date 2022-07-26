FROM continuumio/miniconda3:latest

RUN conda install anaconda-client conda-build

COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]