use Mix.Config

config :elixir_jobs,
  jobs_path: "data/technical-test-jobs.csv",
  cowboy_port: 8080,
  professions_path: "data/technical-test-professions.csv"
