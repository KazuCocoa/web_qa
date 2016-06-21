FROM ubuntu:16.04
MAINTAINER KazuCocoa <fly.49.89.over@gmail.com>

RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8


# RUN apt-get update && apt-get install -y curl build-essential erlang-dev

#RUN echo "deb http://packages.erlang-solutions.com/ubuntu mathomatic contrib" >> /etc/apt/sources.list && \
#    apt-key adv --fetch-keys http://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc && \
RUN apt-get -qq update && apt-get install -y wget curl build-essential erlang-dev unzip postgresql-client && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
RUN curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
RUN apt-get update && apt-get install -y nodejs esl-erlang=1:18.2

RUN curl -L -O https://github.com/elixir-lang/elixir/releases/download/v1.3.0/Precompiled.zip && \
    unzip Precompiled.zip && \
    rm -f Precompiled.zip && \
    ln -s /elixir/bin/elixirc /usr/local/bin/elixirc && \
    ln -s /elixir/bin/elixir /usr/local/bin/elixir && \
    ln -s /elixir/bin/mix /usr/local/bin/mix && \
    ln -s /elixir/bin/iex /usr/local/bin/iex

ADD . /cookpad_device_manager

WORKDIR /cookpad_device_manager
RUN mix local.hex --force && \
    mix local.rebar --force && \
    MIX_ENV=prod mix do deps.get --only prod, compile
RUN npm install
RUN npm install -g brunch@1 && \
    brunch build --production && \
    MIX_ENV=prod mix phoenix.digest

# run
ENV PORT 80
EXPOSE 80
# ENV MIX_ENV prod
CMD ["mix", "phoenix.server"]
