# The existing docker image should be deployable on binder - we just need
# to copy the content across to the $HOME directory ... see
# https://mybinder.readthedocs.io/en/latest/dockerfile.html#when-should-you-use-a-dockerfile
# for details

# SHA tagging would be better
FROM lmoresi/quagmire:0.3

ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

# tidy up

USER root

# RUN mkdir .scratch || true
# RUN mv quagmire-src    .scratch || true
# RUN mv external      .scratch || true
# RUN mv scripts       .scratch || true
# RUN mv Notebooks     .scratch
# RUN mv .scratch/Notebooks/* .

## This is not used by binder but useful for testing locally
ADD run-jupyter.sh .run-jupyter.sh

## Set config options - we are currently
## just using this to set a default starting
## point. Binder can do this when you make a link
## but if we want to have a proper wrapper then
## something more is needed.

RUN rm -rf .jupyter || true
RUN mkdir  .jupyter
ADD jupyter_notebook_config.py .jupyter/jupyter_notebook_config.py


RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}

# ENTRYPOINT ["/usr/local/bin/tini", "--", "/usr/local/bin/xvfbrun.sh"]
CMD ./.run-jupyter.sh
