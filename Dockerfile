FROM busybox

ARG RANDOM
ENV RANDOM=${RANDOM:-RANDOM}

RUN echo ${RANDOM} && sleep 1
RUN echo Hello cache!
