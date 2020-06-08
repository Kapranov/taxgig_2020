defmodule Server.LoadTesting.Fetcher do
  alias Core.{
    Accounts.User,
    Repo
  }

  @spec run_benchmarks(User.t()) :: any()
  def run_benchmarks(user) do
    fetch_user(user)
  end

  defp fetch_user(user) do
    Benchee.run(
      %{
        "By id" => fn -> Repo.get_by(User, id: user.id) end,
        "By active" => fn -> Repo.get_by(User, email: user.active) end,
        "By avatar" => fn -> Repo.get_by(User, email: user.avatar) end,
        "By bio" => fn -> Repo.get_by(User, email: user.bio) end,
        "By birthday" => fn -> Repo.get_by(User, email: user.birthday) end,
        "By email" => fn -> Repo.get_by(User, email: user.email) end,
        "By first_name" => fn -> Repo.get_by(User, email: user.first_name) end,
        "By init_setup" => fn -> Repo.get_by(User, email: user.init_setup) end,
        "By last_name" => fn -> Repo.get_by(User, email: user.last_name) end,
        "By middle_name" => fn -> Repo.get_by(User, email: user.middle_name) end,
        "By phone" => fn -> Repo.get_by(User, email: user.phone) end,
        "By role" => fn -> Repo.get_by(User, email: user.role) end,
        "By provider" => fn -> Repo.get_by(User, email: user.provider) end,
        "By sex" => fn -> Repo.get_by(User, email: user.sex) end,
        "By ssn" => fn -> Repo.get_by(User, email: user.ssn) end,
        "By street" => fn -> Repo.get_by(User, email: user.street) end,
        "By zip" => fn -> Repo.get_by(User, email: user.zip) end
      },
      formatters: formatters()
    )
  end

  defp formatters do
    [
      Benchee.Formatters.Console
    ]
  end
end
