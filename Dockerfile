FROM haskell

RUN apt-get install postgres

COPY . .
RUN stack build

CMD ["stack exec ordermage"]
