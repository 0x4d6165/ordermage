FROM haskell

RUN apt-get update && apt-get install -y postgresql-client postgresql postgresql-server-dev-all

COPY . .
RUN stack build

CMD ["stack exec ordermage"]
