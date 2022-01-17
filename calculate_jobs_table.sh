#! /bin/bash

while getopts o: flag
do
    case "$flag" in
        o) output=${OPTARG}
    esac
done

run_elixir_jobs() {
    if test $1
    then
        ./elixir_jobs $1
    else
        ./elixir_jobs
    fi
}

if test -f "elixir_jobs"
then
    run_elixir_jobs $output
else
    mix escript.build
    run_elixir_jobs $output
fi
