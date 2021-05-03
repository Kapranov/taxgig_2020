defmodule TaxgigEx.MixProject do
  use Mix.Project

  @seed_core_repo_path "apps/core/priv/repo/seeds.exs"
  @seed_stripy_repo_path "apps/stripy/priv/repo/seeds.exs"
  @seed_server_repo_path "apps/server/priv/repo/seeds.exs"
  @version "1.0.0-beta.1"

  def project do
    [
      aliases: aliases(),
      app: :taxgig,
      apps_path: "apps",
      deps: deps(),
      description: description(),
      docs: docs(),
      elixirc_options: [warnings_as_errors: warnings_as_errors(Mix.env())],
      homepage_url: "https://api.taxgig.com/",
      name: "Taxgig",
      preferred_cli_env: cli_env_for(:test, [
        "coveralls", "coveralls.detail", "coveralls.post",
        "coveralls.html", "coveralls.json", "test.reset"
      ]),
      releases: releases(),
      source_url: "https://github.com/kapranov/taxgig_2020",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      updated: update_version(@version),
      version: version(@version)
    ]
  end

  defp aliases do
    [
      bless: [&bless/1],
      "deps.get": [
        "deps.get",
        &update_version/1
      ],
      "ecto.setup.core": [
        "ecto.create -r Core.Repo",
        "cmd --app core mix ecto.migrate -r Core.Repo",
        "run #{@seed_core_repo_path}"
      ],
      "ecto.setup.stripy": [
        "cmd --app stripy mix ecto.migrate -r Stripy.Repo",
        "run #{@seed_stripy_repo_path}",
        "run #{@seed_server_repo_path}"
      ],
      "ecto.reset.core": [
        "ecto.drop -r Core.Repo",
        "ecto.setup.core"
      ],
      "ecto.drop.core": [
        "cmd --app core mix ecto.drop -r Core.Repo"
      ],
      "ecto.migrate.core": [
        "ecto.migrate -r Core.Repo",
        "ecto.dump -r Core.Repo"
      ],
      "ecto.migrate.stripy": [
        "ecto.migrate -r Stripy.Repo",
        "ecto.dump -r Stripy.Repo"
      ],
      "ecto.create.core": [
        "cmd --app core mix ecto.create -r Core.Repo"
      ],
      "benchmark.reset.core": [
        "ecto.drop -r Core.Repo",
        "ecto.create -r Core.Repo",
        "ecto.migrate -r Core.Repo"
      ],
      "benchmark.setup.stripy": [
        "ecto.migrate -r Core.Repo"
      ],
      "test.core": [
        "ecto.drop -r Core.Repo",
        "ecto.create --quiet -r Core.Repo",
        "ecto.migrate -r Core.Repo"
      ],
      "test.stripy": [
        "cmd --app stripy mix ecto.migrate -r Stripy.Repo"
      ],
      "test.reset.core": [
        "ecto.drop -r Core.Repo",
        "ecto.create -r Core.Repo",
        "ecto.migrate -r Core.Repo",
      ],
      "test.reset.stripy": [
        "cmd --app stripy mix ecto.migrate -r Stripy.Repo"
      ],
      "test.setup.stripy": [
        "ecto.migrate -r Stripy.Repo"
      ],
      "test.cover": &run_default_coverage/1,
      "test.cover.html": &run_html_coverage/1,
      "test.no.start": ["test --no-start"],
      init: [
      ],
      reset: [
      ],
      seed: [
      ]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.22", runtime: false},
      {:ex_spec, "~> 2.0", only: [:test]},
      {:ex_unit_notifier, "~> 0.1", only: [:test]},
      {:excoveralls, "~> 0.13", only: [:test]},
      {:junit_formatter, "~> 3.1"},
      {:mix_test_watch, "~> 1.0", only: [:dev], runtime: false},
      {:progress_bar, "~> 2.0"}
    ]
  end

  defp description do
    contents = "An easy way to manage GraphQL Channel and much more for Pure Agency Inc. Honolulu"
    Mix.shell().info("Synopsis version with: #{inspect(contents)}")
  end

  defp docs do
    [
      name: "TaxgigEx",
      source_url: "https://github.com/kapranov/taxgig_2020",
      homepage_url: "htts://api.taxgig.me:4001/docs",
      docs: [
        main: "TaxgigEx",
        logo: "",
        extras: ["README.md"]
      ]
    ]
  end

  defp cli_env_for(env, tasks) do
    Enum.reduce(tasks, [], fn(key, acc) -> Keyword.put(acc, :"#{key}", env) end)
  end

  defp releases do
    [
      taxgig_ex: [
        include_executables_for: [:unix],
        steps: [:assemble, &copy_files/1, &copy_nginx_config/1]
      ]
    ]
  end

  def copy_files(%{path: target_path} = release) do
    File.cp_r!("./uploads", target_path)
    release
  end

  def copy_nginx_config(%{path: target_path} = release) do
    File.cp!(
      "./doc/taxgig.nginx",
      Path.join([target_path, "doc", "taxgig.nginx"])
    )

    release
  end

  defp warnings_as_errors(:prod), do: false
  defp warnings_as_errors(_), do: true

  defp update_version(_) do
    contents = [
      version(@version),
      get_commit_sha(),
      get_commit_date()
    ]

    Mix.shell().info("Updating version with: #{inspect(contents)}")
    File.write("VERSION", Enum.join(contents, "\n"), [:write])
  end

  defp version(version) do
    identifier_filter = ~r/[^0-9a-z\-]+/i

    git_pre_release =
      with {tag, 0} <-
           System.cmd("git", ["describe", "--tags", "--abbrev=0"], stderr_to_stdout: true),
           {describe, 0} <- System.cmd("git", ["describe", "--tags", "--abbrev=8"]) do
        describe
        |> String.trim()
        |> String.replace(String.trim(tag), "")
        |> String.trim_leading("-")
        |> String.trim()
      else
        _ ->
          {commit_hash, 0} = System.cmd("git", ["rev-parse", "--short", "HEAD"])
          "0-g" <> String.trim(commit_hash)
      end

    branch_name =
      with {branch_name, 0} <- System.cmd("git", ["rev-parse", "--abbrev-ref", "HEAD"]),
           branch_name <- String.trim(branch_name),
           branch_name <- System.get_env("PLEROMA_BUILD_BRANCH") || branch_name,
           true <-
             !Enum.any?(["master", "HEAD", "release/", "stable"], fn name ->
               String.starts_with?(name, branch_name)
             end) do
        branch_name =
          branch_name
          |> String.trim()
          |> String.replace(identifier_filter, "-")

        branch_name
      end

    build_name =
      cond do
        name = Application.get_env(:taxgig_ex, :build_name) -> name
        name = System.get_env("COMMUNITY_BUILD_NAME") -> name
        true -> nil
      end

    env_name = if Mix.env() != :prod, do: to_string(Mix.env())
    env_override = System.get_env("COMMUNITY_BUILD_NAME")

    env_name =
      case env_override do
        nil -> env_name
        env_override when env_override in ["", "prod"] -> nil
        env_override -> env_override
      end

    pre_release =
      [git_pre_release, branch_name]
      |> Enum.filter(fn string -> string && string != "" end)
      |> Enum.join(".")
      |> (fn
        "" -> nil
        string -> "-" <> String.replace(string, identifier_filter, "-")
      end).()

    build_metadata =
      [build_name, env_name]
      |> Enum.filter(fn string -> string && string != "" end)
      |> Enum.join(".")
      |> (fn
        "" -> nil
        string -> "+" <> String.replace(string, identifier_filter, "-")
      end).()

    [version, pre_release, build_metadata]
    |> Enum.filter(fn string -> string && string != "" end)
    |> Enum.join()
  end

  defp bless(_) do
    [
      {"compile", ["--warnings-as-errors", "--force"]},
      {"coveralls.html", []},
      {"format", ["--check-formatted"]},
      {"credo", []}
    ]
    |>  Enum.each(fn {task, args} ->
      IO.ANSI.format([:cyan, "Running #{task} with args #{inspect(args)}"])
      |> IO.puts()

      Mix.Task.run(task, args)
    end)
  end

  defp run_default_coverage(args), do: run_coverage("coveralls", args)
  defp run_html_coverage(args), do: run_coverage("coveralls.html", args)

  defp run_coverage(task, args) do
    {_, res} =
      System.cmd(
        "mix",
        [task | args],
        into: IO.binstream(:stdio, :line),
        env: [{"MIX_ENV", "test"}]
      )

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end
  end

  defp get_commit_sha do
    System.cmd("git", ["rev-parse", "HEAD"])
    |> elem(0)
    |> String.trim()
  end

  defp get_commit_date do
    [sec, tz] =
      System.cmd("git", ~w|log -1 --date=raw --format=%cd|)
      |> elem(0)
      |> String.split(~r/\s+/, trim: true)
      |> Enum.map(&String.to_integer/1)

    DateTime.from_unix!(sec + tz * 36) |> to_string
  end
end
