#! /bin/bash

if test -f "elixir_jobs"
then
    ./elixir_jobs
else
    mix escript.build
    ./elixir_jobs
fi
