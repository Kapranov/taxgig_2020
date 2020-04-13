Application.put_env(:elixir, :ansi_enabled, true)

IO.puts IO.ANSI.magenta()
        <> IO.ANSI.color_background(1, 0, 1)
        <> IO.ANSI.bright()
        <> IO.ANSI.underline()
        <> IO.ANSI.blink_slow()
        <> "Using global .iex.exs (located in ~/.iex.exs)" <> IO.ANSI.reset()

queue_length = fn ->
  self()
  |> Process.info()
  |> Keyword.get(:message_queue_len)
end

prefix = IO.ANSI.light_black_background() <> IO.ANSI.magenta() <> "%prefix" <> IO.ANSI.reset()
counter = IO.ANSI.light_black_background() <> IO.ANSI.black() <> "-%node-(%counter)" <> IO.ANSI.reset()
info = IO.ANSI.light_blue() <> "✉ #{queue_length.()}" <> IO.ANSI.reset()
last = IO.ANSI.yellow() <> "➤➤➤" <> IO.ANSI.reset()
alive = IO.ANSI.bright() <> IO.ANSI.yellow() <> IO.ANSI.blink_rapid() <> "⚡" <> IO.ANSI.reset()

default_prompt = prefix <> counter <> " | " <> info <> " | " <> last
alive_prompt = prefix <> counter <> " | " <> info <> " | " <> alive <> last

inspect_limit = 150
history_size = 1_000_000_000

eval_result = [:green, :bright]
eval_error = [:red, :bright]
eval_info = [:blue, :bright]

IEx.configure [
  inspect: [limit: inspect_limit],
  history_size: history_size,
  colors: [
    eval_result: eval_result,
    eval_error: eval_error,
    eval_info: eval_info,
    syntax_colors: [
      number: :light_yellow,
      atom: :light_cyan,
      string: :light_black,
      boolean: [:light_blue],
      nil: [:magenta, :bright]
    ],
    ls_directory: :cyan,
    ls_device: :yellow,
    doc_code: :green,
    doc_inline_code: :magenta,
    doc_headings: [:cyan, :underline],
    doc_title: [:cyan, :bright, :underline]
  ],
  default_prompt: default_prompt,
  # default_prompt: ["\e[G", :light_magenta, "⚡ iex", ">", :white, :reset] |> IO.ANSI.format() |> IO.chardata_to_string(),
  alive_prompt: alive_prompt
]

import_if_available Plug.Conn
import_if_available Phoenix.HTML

phoenix_app = :application.info()
  |> Keyword.get(:running)
  |> Enum.reject(fn {_x, y} ->
    y == :undefined
  end)
  |> Enum.find(fn {x, _y} ->
    x |> Atom.to_string() |> String.match?(~r{_web})
  end)

case phoenix_app do
  nil -> IO.puts "No Phoenix App found"
  {app, _pid} ->
    IO.puts "Phoenix app found: #{app}"
    ecto_app = app
      |> Atom.to_string()
      |> (&Regex.split(~r{_web}, &1)).()
      |> Enum.at(0)
      |> String.to_atom()

    exists = :application.info()
      |> Keyword.get(:running)
      |> Enum.reject(fn {_x, y} ->
        y == :undefined
      end)
      |> Enum.map(fn {x, _y} -> x end)
      |> Enum.member?(ecto_app)

    case exists do
      false -> IO.puts "Ecto app #{ecto_app} doesn't exist or isn't running"
      true ->
        IO.puts "Ecto app found: #{ecto_app}"

        import_if_available Ecto.Query
        import_if_available Ecto.Changeset

        repo = ecto_app |> Application.get_env(:ecto_repos) |> Enum.at(0)
        ptin = ecto_app |> Application.get_env(:ecto_repos) |> Enum.at(1)
        quote do
          alias unquote(repo), as: Repo
          alias unquote(ptin), as: DB
        end
    end
end

######################################################################
######################################################################
import Ecto.Query

alias Blockscore

alias Core.{
  Accounts,
  Accounts.Profile,
  Accounts.Subscriber,
  Accounts.User,
  Landing,
  Landing.Faq,
  Landing.FaqCategory,
  Landing.PressArticle,
  Landing.Vacancy,
  Localization,
  Localization.Language,
  Lookup,
  Lookup.UsZipcode,
  Media,
  Media.Picture,
  Repo
}

alias Ptin.Repo, as: PtinRepo

alias Ptin.{
  Services,
  Services.Downloads,
  Services.Ptin
}

:timer.sleep(8000);

# clear
######################################################################

defmodule LetMeSee do
  @moduledoc """
  Open N+1 in a terminal
  Open regular in another terminal

  iex> mix ecto.reset
  iex> iex -S mix

  cmd+r

  LetMeSee.index_faq()
  LetMeSee.index_faq_category()
  LetMeSee.index_language()
  LetMeSee.index_press_article()
  LetMeSee.index_profile(args)
  LetMeSee.index_subscriber()
  LetMeSee.index_user(args)
  LetMeSee.index_vacancy()

  LetMeSee.show_faq(args)
  LetMeSee.show_faq_category(args)
  LetMeSee.show_language(args)
  LetMeSee.show_press_article(args)
  LetMeSee.show_profile(args)
  LetMeSee.show_subscriber(args)
  LetMeSee.show_user(args)
  LetMeSee.show_vacancy(args)
  LetMeSee.show_zipcode(args)

  LetMeSee.create_faq(args)
  LetMeSee.create_faq_category(args)
  LetMeSee.create_language(args)
  LetMeSee.create_press_article(args)
  LetMeSee.create_ptin(args)
  LetMeSee.create_subscriber(args)
  LetMeSee.create_user(args)
  LetMeSee.create_vacancy(args)

  LetMeSee.update_faq(args)
  LetMeSee.update_faq_category(args)
  LetMeSee.update_language(args)
  LetMeSee.update_press_article(args)
  LetMeSee.update_profile(args)
  LetMeSee.update_subscriber(args)
  LetMeSee.update_user(args)
  LetMeSee.update_vacancy(args)

  LetMeSee.delete_dir_ptin(args)
  LetMeSee.delete_faq(args)
  LetMeSee.delete_faq_category(args)
  LetMeSee.delete_language(args)
  LetMeSee.delete_press_article(args)
  LetMeSee.delete_profile(args)
  LetMeSee.delete_ptin()
  LetMeSee.delete_subscriber(args)
  LetMeSee.delete_user(args)
  LetMeSee.delete_vacancy(args)

  LetMeSee.find_faq_category(args)

  LetMeSee.search_profession(args)
  LetMeSee.search_ptin(args)
  LetMeSee.search_titles(args)
  LetMeSee.search_zipcode(args)

  LetMeSee.get_code(args)
  LetMeSee.get_refresh_token(args)
  LetMeSee.get_refresh_token_code(args)
  LetMeSee.get_status(args)
  LetMeSee.get_token(args)

  LetMeSee.verify_token(args)

  LetMeSee.picture(args)
  LetMeSee.upload_picture(args)

  LetMeSee.signin(args)
  LetMeSee.signup(args)
  """

  if Mix.env == :dev do
    IO.puts "\n______________________________________________________________________________________________________________\n\nAaron - This is your self from the past. Remember to reset the DB! mix ecto.reset.core and mix ecto.reset.ptin\n______________________________________________________________________________________________________________\n"
    IO.puts "\n\t\t\t\tApplication has started in Development ENV\n"

    @type t :: __MODULE__.t()
    @type action :: bitstring()
    @type msg :: bitstring()
    @type int :: integer()
    @type reason :: any
    @type success_map :: %{data: map()}
    @type error_tuple :: {:error, reason}
    @type error_map :: %{data: %{action => nil}, errors: [%{locations: [%{column: int, line: int}], message: msg, path: [action]}]}
    @type error :: %{errors: [%{locations: [%{column: int, line: int}], message: msg, path: [action]}]}
    @type result :: success_map | error_map
    @type result_selection_t :: %{
      String.t() =>
        nil
        | integer
        | float
        | boolean
        | binary
        | atom
        | [result_selection_t]
    }
    @type result_error_t ::
            %{message: String.t()}
            | %{message: String.t(), locations: [%{line: integer, column: integer}]}
    @type result_t ::
            %{data: nil | result_selection_t}
            | %{data: nil | result_selection_t, errors: [result_error_t]}
            | %{errors: [result_error_t]}
    @type run_opts :: [
            context: %{},
            adapter: Absinthe.Adapter.t(),
            root_value: term,
            operation_name: String.t(),
            analyze_complexity: boolean,
            max_complexity: non_neg_integer | :infinity
          ]
    @type run_result :: {:ok, result_t} | {:error, String.t()}

    @format [
      frames: :strokes,
      spinner_color: IO.ANSI.magenta,
      text: "The Request:",
      done: [IO.ANSI.green, "✓", IO.ANSI.reset, " The Result:"],
    ]

    @first_zipcode Repo.all(UsZipcode) |> List.first |> Map.get(:id)
    @last_faq Repo.all(Faq) |> List.last |> Map.get(:id)
    @last_faq_category Repo.all(FaqCategory) |> List.last |> Map.get(:id)
    @last_language Repo.all(Language) |> List.last |> Map.get(:id)
    @last_press_article Repo.all(PressArticle) |> List.last |> Map.get(:id)
    @last_subscriber Repo.all(Subscriber) |> List.last |> Map.get(:id)
    @last_user Repo.all(User) |> List.last |> Map.get(:id)
    @last_vacancy Repo.all(Vacancy) |> List.last |> Map.get(:id)
    @last_zipcode Repo.all(UsZipcode) |> List.last |> Map.get(:id)
    @search_word ~s(Article)
    @blockscore_keys ~w(address_city address_country_code address_postal_code address_street1 address_street2 address_subdivision birth_day birth_month birth_year document_type document_value name_first name_last name_middle)a
    @faq_category_keys ~w(id title)a |> Enum.sort
    @faq_keys ~w(id content title faq_category_id)a |> Enum.sort
    @language_keys ~w(id abbr name)a |> Enum.sort
    @localhost_key ~w(email password provider)a
    @localhost_keys ~w(email password password_confirmation provider)a
    @picture_keys ~w(alt name file profile_id)a |> Enum.sort
    @ptin_keys ~w(expired url)a |> Enum.sort
    @press_article_keys ~w(id author img_url preview_text title url)a |> Enum.sort
    @profession_keys ~w(bus_addr_zip bus_st_code first_name last_name)a |> Enum.sort
    @profile_keys ~w(address banner description us_zipcode_id user_id)a |> Enum.sort
    @provider_key ~w(provider)a
    @social_keys ~w(code provider)a
    @subscriber_keys ~w(id email pro_role)a |> Enum.sort
    @token_provider_key ~w(provider token)a
    @vacancy_keys ~w(id content department title)a |> Enum.sort
    @zipcode_keys ~w(id zipcode)a
    @user_keys ~w(
      id
      active
      admin_role
      avatar
      bio
      birthday
      email
      first_name
      init_setup
      languages
      last_name
      middle_name
      password
      password_confirmation
      phone
      pro_role
      provider
      sex
      ssn
      street
      zip
    )a |> Enum.sort
    @user_mini_keys ~w(email languages password password_confirmation)a |> Enum.sort

    @current_user Repo.all(User) |> List.last

    @faq_params %{
      id: @last_faq,
      content: "updated text",
      title: "updated text",
      faq_category_id: @last_faq_category
    }

    @faq_category_params %{
      id: @last_faq_category,
      title: "updated text"
    }

    @language_params %{
      id: @last_language,
      abbr: "updated text",
      name: "updated text"
    }

    @press_article_params %{
      id: @last_press_article,
      author: "updated text",
      img_url: "updated text",
      preview_text: "updated text",
      title: "updated text",
      url: "updated text"
    }

    @profile_params %{
      id: @last_user,
      address: "updated text",
      banner: "updated text",
      description: "updated text",
      us_zipcode_id: @first_zipcode,
      user_id: @last_user
    }

    @subscriber_params %{
      id: @last_subscriber,
      email: "josh@yahoo.com",
      pro_role: true
    }

    @user_params %{
      active: true,
      admin_role: true,
      avatar: "updated avatar",
      bio: "updated bio",
      birthday: Timex.today,
      email: "josh@yahoo.com",
      first_name: "Edward",
      id: @last_user,
      init_setup: true,
      languages: "portuguese, greek, french",
      last_name: "Witten",
      middle_name: "Junior",
      password: "qwerty",
      password_confirmation: "qwerty",
      phone: "updated text",
      pro_role: true,
      provider: "localhost",
      sex: "updated text",
      ssn: 987654321,
      street: "updated text",
      zip: 987654321
    }

    @vacancy_params %{
      id: @last_vacancy,
      content: "updated text",
      department: "updated text",
      title: "updated text"
    }

    @spec index_faq() :: [%{atom => any}] | list()
    def index_faq do
      request = """
      query {
        allFaqs {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            title
            inserted_at
            updated_at
          }
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec index_faq_category() :: [%{atom => any}] | list()
    def index_faq_category do
      request = """
      query {
        allFaqCategories {
          id
          faqs_count
          title
          inserted_at
          updated_at
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec index_language() :: [%{atom => any}] | list()
    def index_language do
      request = """
      query {
        allLanguages{
          id
          abbr
          name
          inserted_at
          updated_at
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec index_press_article() :: [%{atom => any}] | list()
    def index_press_article do
      request = """
      query {
        allPressArticles{
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec index_profile(User.t()) :: map() | list()
    def index_profile(args \\ @current_user) do
      if is_map(args) and Map.has_key?(args, :id) do
        context = %{current_user: args}
        request = """
        query {
          allProfiles{
            address
            banner
            description
            logo {id content_type name size url inserted_at updated_at}
            us_zipcode {id city state zipcode}
            user {
              id
              active
              admin_role
              avatar
              bio
              birthday
              email
              first_name
              init_setup
              languages {id abbr name inserted_at updated_at}
              last_name
              middle_name
              phone
              pro_role
              provider
              sex
              ssn
              street
              zip
              inserted_at
              updated_at
            }
            inserted_at
            updated_at
          }
        }
        """
        IO.puts(request)
        format = Keyword.merge(@format, [frames: :braille])
        ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
        run(request, ServerWeb.GraphQL.Schema, [context: context])
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec index_subscriber() :: [%{atom => any}] | list()
    def index_subscriber do
      request = """
      query {
        allSubscribers{
          id
          email
          pro_role
          inserted_at
          updated_at
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec index_user(User.t()) :: map() | list()
    def index_user(args \\ @current_user) do
      if is_map(args) and Map.has_key?(args, :id) do
        context = %{current_user: args}
        request = """
        query {
          allUsers{
            id
            active
            admin_role
            avatar
            bio
            birthday
            email
            first_name
            init_setup
            languages {id abbr name inserted_at updated_at}
            last_name
            middle_name
            phone
            pro_role
            provider
            sex
            ssn
            street
            zip
            inserted_at
            updated_at
          }
        }
        """
        IO.puts(request)
        format = Keyword.merge(@format, [frames: :braille])
        ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
        run(request, ServerWeb.GraphQL.Schema, [context: context])
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec index_vacancy() :: [%{atom => any}] | list()
    def index_vacancy do
      request = """
      query {
        allVacancies{
          id
          content
          department
          title
          inserted_at
          updated_at
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec show_faq(%{atom => String.t()}) :: map() | error_map() | error_tuple()
    def show_faq(args \\ %{id: @last_faq}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            request = """
            query {
              showFaq(id: \"#{binaryId}\") {
                id
                content
                title
                inserted_at
                updated_at
                faq_categories {
                  id
                  title
                  inserted_at
                  updated_at
                }
              }
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec show_faq_category(%{atom => String.t()}) :: map() | error_map() | error_tuple()
    def show_faq_category(args \\ %{id: @last_faq_category}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            request = """
            query {
              showFaqCategory(id: \"#{binaryId}\") {
                id
                faqs_count
                title
                inserted_at
                updated_at
              }
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec show_language(%{atom => String.t()}) :: map() | error_map() | error_tuple()
    def show_language(args \\ %{id: @last_language}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            request = """
            query {
              showLanguage(id: \"#{binaryId}\") {
                id
                abbr
                name
                inserted_at
                updated_at
              }
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec show_press_article(%{atom => String.t()}) :: map() | error_map() | error_tuple()
    def show_press_article(args \\ %{id: @last_press_article}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            request = """
            query {
              showPressArticle(id: \"#{binaryId}\") {
                id
                author
                img_url
                preview_text
                title
                url
                inserted_at
                updated_at
              }
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec show_profile(User.t()) :: map() | error_map() | error_tuple()
    def show_profile(args \\ @current_user) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            context = %{current_user: args}
            request = """
            query {
              showProfile(id: \"#{binaryId}\") {
                address
                banner
                description
                us_zipcode {id city state zipcode}
                user {
                  id
                  active
                  admin_role
                  avatar
                  bio
                  birthday
                  email
                  first_name
                  init_setup
                  languages {id abbr name inserted_at updated_at}
                  last_name
                  middle_name
                  phone
                  pro_role
                  provider
                  sex
                  ssn
                  street
                  zip
                  inserted_at
                  updated_at
                }
                inserted_at
                updated_at
              }
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request, ServerWeb.GraphQL.Schema, [context: context])
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec show_subscriber(%{atom => String.t()}) :: map() | error_map() | error_tuple()
    def show_subscriber(args \\ %{id: @last_subscriber}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            request = """
            query {
              showSubscriber(id: \"#{binaryId}\") {
                id
                email
                pro_role
                inserted_at
                updated_at
              }
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec show_user(User.t()) :: map() | error_map() | error_tuple()
    def show_user(args \\ @current_user) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            context = %{current_user: args}
            request = """
            query {
              showUser(id: \"#{binaryId}\") {
                id
                active
                admin_role
                avatar
                bio
                birthday
                email
                first_name
                init_setup
                languages {id abbr name inserted_at updated_at}
                last_name
                middle_name
                phone
                pro_role
                provider
                sex
                ssn
                street
                zip
                inserted_at
                updated_at
              }
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request, ServerWeb.GraphQL.Schema, [context: context])
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec show_vacancy(%{atom => String.t()}) :: map() | error_map() | error_tuple()
    def show_vacancy(args \\ %{id: @last_vacancy}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            request = """
            query {
              showVacancy(id: \"#{binaryId}\") {
                id
                content
                department
                title
                inserted_at
                updated_at
              }
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec show_zipcode(%{atom => String.t()}) :: map() | error_map() | error_tuple()
    def show_zipcode(args \\ %{id: @last_zipcode}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            request = """
            query {
              showZipcode(id: \"#{binaryId}\") {
                id
                city
                state
                zipcode
              }
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @keys List.delete(@faq_keys, :id)

    @spec create_faq(%{atom => String.t()}) :: map() | error_map() | error_tuple()
    def create_faq(args) when is_map(args) do
      case Map.keys(args) do
        @keys ->
          case Ecto.UUID.cast(args.faq_category_id) do
            {:ok, binaryId} ->
              request = """
              mutation {
                createFaq(
                  content: "#{args.content}\",
                  title: \"#{args.title}\",
                  faq_categoryId: \"#{binaryId}\"
                ) {
                  id
                  content
                  title
                  inserted_at
                  updated_at
                  faq_categories {
                    id
                    title
                    inserted_at
                    updated_at
                  }
                }
              }
              """
              IO.puts(request)
              format = Keyword.merge(@format, [frames: :braille])
              ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
              run(request)
            :error ->
              {:error, message: "Oops! Something Wrong with Id"}
          end
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec create_faq(any()) :: error_tuple()
    def create_faq(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @keys List.delete(@faq_category_keys, :id)

    @spec create_faq_category(%{atom => String.t()}) :: map() | error_map() | error_tuple()
    def create_faq_category(args) when is_map(args) do
      case Map.keys(args) do
        @keys ->
          request = """
          mutation {
            createFaqCategory(
              title: \"#{args.title}\"
            ) {
              id
              title
              inserted_at
              updated_at
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec create_faq_category(any()) :: error_tuple()
    def create_faq_category(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @keys List.delete(@language_keys, :id)

    @spec create_language(%{atom => String.t()}) :: map() | error_map() | error_tuple()
    def create_language(args) when is_map(args) do
      case Map.keys(args) do
        @keys ->
          request = """
          mutation {
            createLanguage(
              abbr: \"#{args.abbr}\",
              name: \"#{args.name}\"
            ) {
              id
              abbr
              name
              inserted_at
              updated_at
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec create_language(any()) :: error_tuple()
    def create_language(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @keys List.delete(@press_article_keys, :id)

    @spec create_press_article(%{atom => String.t()}) :: map() | error_map() | error_tuple()
    def create_press_article(args) when is_map(args) do
      case Map.keys(args) do
        @keys ->
          request = """
          mutation {
            createPressArticle(
              author: \"#{args.author}\",
              img_url: \"#{args.img_url}\",
              preview_text: \"#{args.preview_text}\",
              title: \"#{args.title}\",
              url: \"#{args.url}\"
            ) {
              id
              author
              img_url
              preview_text
              title
              url
              inserted_at
              updated_at
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec create_press_article(any()) :: error_tuple()
    def create_press_article(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec create_ptin(%{atom => String.t()}) :: map()
    def create_ptin(args) when is_map(args) do
      case Map.keys(args) do
        @ptin_keys ->
          request = """
          mutation {
            createPtin(
              expired:\"#{args.expired}\",
              url: \"#{args.url}\"
            ) {
              path
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec create_ptin(any()) :: error_tuple()
    def create_ptin(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @keys List.delete(@subscriber_keys, :id)

    @spec create_subscriber(%{atom => String.t() | boolean()}) :: map() | error() | error_map() | error_tuple()
    def create_subscriber(args) when is_map(args) do
      case Map.keys(args) do
        @keys ->
          request = """
          mutation {
            createSubscriber(
              email:\"#{args.email}\",
              pro_role: #{args.pro_role}
            ) {
              id
              email
              pro_role
              inserted_at
              updated_at
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec create_subscriber(any()) :: error_tuple()
    def create_subscriber(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @keys List.delete(@user_keys, :id)

    @spec create_user(%{atom => String.t() | boolean() | integer()}) :: map() | error() | error_map() | error_tuple()
    def create_user(args) when is_map(args) do
      case Map.keys(args) do
        @keys ->
          request = """
          mutation {
            createUser(
              active: #{args.active},
              admin_role: #{args.admin_role},
              avatar: \"#{args.avatar}\",
              bio: \"#{args.bio}\",
              birthday: \"#{args.birthday}\",
              email: \"#{args.email}\",
              first_name: \"#{args.first_name}\",
              init_setup: #{args.init_setup},
              languages: \"#{args.languages}\",
              last_name: \"#{args.last_name}\",
              middle_name: \"#{args.middle_name}\",
              password: \"#{args.password}\",
              password_confirmation: "#{args.password_confirmation}\",
              phone: \"#{args.phone}\",
              pro_role: #{args.pro_role},
              provider: \"#{args.provider}\",
              sex: \"#{args.sex}\",
              ssn: #{args.ssn},
              street: "#{args.street}\",
              zip: #{args.zip}
            ) {
              id
              active
              admin_role
              avatar
              bio
              birthday
              email
              first_name
              init_setup
              languages {id abbr name inserted_at updated_at}
              last_name
              middle_name
              phone
              pro_role
              provider
              sex
              ssn
              street
              zip
              inserted_at
              updated_at
            }
          }
          """
          IO.puts("The Request:")
          IO.puts(request)
          IO.puts("\nThe Result:")
          run(request)
        @user_mini_keys ->
          request = """
          mutation {
            createUser(
              email: \"#{args.email}\",
              languages: \"#{args.languages}\",
              password: \"#{args.password}\",
              password_confirmation: "#{args.password_confirmation}\"
            ) {
              id
              active
              admin_role
              avatar
              bio
              birthday
              email
              first_name
              init_setup
              languages {id abbr name inserted_at updated_at}
              last_name
              middle_name
              phone
              pro_role
              provider
              sex
              ssn
              street
              zip
              inserted_at
              updated_at
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec create_user(any()) :: error_tuple()
    def create_user(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @keys List.delete(@vacancy_keys, :id)

    @spec create_vacancy(%{atom => String.t()}) :: map() | error_map() | error_tuple()
    def create_vacancy(args) when is_map(args) do
      case Map.keys(args) do
        @keys ->
          request = """
          mutation {
            createVacancy(
              content: \"#{args.content}\",
              department: \"#{args.department}\",
              title: \"#{args.title}\"
            ) {
              id
              content
              department
              title
              inserted_at
              updated_at
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec create_vacancy(any()) :: error_tuple()
    def create_vacancy(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec update_faq(%{atom => String.t()}) :: map() | error() | error_map() | error_tuple()
    def update_faq(args \\ @faq_params) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            case Map.keys(args) do
              @faq_keys ->
                request = """
                mutation {
                  updateFaq(
                    id: \"#{binaryId}\",
                    faq: {
                      content: \"#{args.content}\",
                      title: \"#{args.title}\",
                      faq_categoryId: \"#{args.faq_category_id}\"
                    }
                  ) {
                    id
                    content
                    title
                    inserted_at
                    updated_at
                    faq_categories {
                      id
                      title
                      inserted_at
                      updated_at
                    }
                  }
                }
                """
                IO.puts(request)
                format = Keyword.merge(@format, [frames: :braille])
                ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
                run(request)
              _ ->
                {:error, message: "Oops! Something Wrong with an args"}
            end
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec update_faq_category(%{atom => String.t()}) :: map() | error() | error_map() | error_tuple()
    def update_faq_category(args \\ @faq_category_params) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            case Map.keys(args) do
              @faq_category_keys ->
                request = """
                mutation {
                  updateFaqCategory(
                    id: \"#{binaryId}\",
                    faq_category: {
                      title: \"#{args.title}\"
                    }
                  ) {
                    id
                    title
                    inserted_at
                    updated_at
                  }
                }
                """
                IO.puts(request)
                format = Keyword.merge(@format, [frames: :braille])
                ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
                run(request)
              _ ->
                {:error, message: "Oops! Something Wrong with an args"}
            end
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec update_language(%{atom => String.t()}) :: map() | error() | error_map() | error_tuple()
    def update_language(args \\ @language_params) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            case Map.keys(args) do
              @language_keys ->
                request = """
                mutation {
                  updateLanguage(
                    id: \"#{binaryId}\",
                    language: {
                      abbr: \"#{args.abbr}\",
                      name: \"#{args.name}\"
                    }
                  ) {
                    id
                    abbr
                    name
                    inserted_at
                    updated_at
                  }
                }
                """
                IO.puts(request)
                format = Keyword.merge(@format, [frames: :braille])
                ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
                run(request)
              _ ->
                {:error, message: "Oops! Something Wrong with an args"}
            end
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec update_press_article(%{atom => String.t()}) :: map() | error() | error_map() | error_tuple()
    def update_press_article(args \\ @press_article_params) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            case Map.keys(args) do
              @press_article_keys ->
                request = """
                mutation {
                  updatePressArticle(
                    id: \"#{binaryId}\",
                    press_article: {
                      author: \"#{args.author}\",
                      img_url: \"#{args.img_url}\",
                      preview_text: \"#{args.preview_text}\",
                      title: \"#{args.title}\",
                      url: \"#{args.url}\"
                    }
                  ) {
                    id
                    author
                    img_url
                    preview_text
                    title
                    url
                    inserted_at
                    updated_at
                  }
                }
                """
                IO.puts(request)
                format = Keyword.merge(@format, [frames: :braille])
                ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
                run(request)
              _ ->
                {:error, message: "Oops! Something Wrong with an args"}
            end
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec update_profile(%{atom => String.t()}) :: map() | error() | error_map() | error_tuple()
    def update_profile(args \\ @profile_params) do
      if is_map(args) and Map.has_key?(args, :user_id) do
        case Ecto.UUID.cast(args.user_id) do
          {:ok, binaryId} ->
            case Map.keys(args) do
              @profile_keys ->
                user = if is_nil(args.user_id), do: :error, else: Core.Repo.get(User, args.user_id)
                context = %{current_user: user}
                variables = %{}
                request = """
                mutation {
                  updateProfile(
                    id: \"#{binaryId}\",
                    logo: {},
                    profile: {
                      address: \"#{args.address}\",
                      banner: \"#{args.banner}\",
                      description: \"#{args.description}\",
                      us_zipcodeId: \"#{args.us_zipcode_id}\"
                    }
                  ) {
                    address
                    banner
                    description
                    logo {id content_type name size url inserted_at updated_at}
                    us_zipcode {id city state zipcode}
                    user {
                      id
                      active
                      admin_role
                      avatar
                      bio
                      birthday
                      email
                      first_name
                      init_setup
                      languages {id abbr name inserted_at updated_at}
                      last_name
                      middle_name
                      phone
                      pro_role
                      provider
                      sex
                      ssn
                      street
                      zip
                      inserted_at
                      updated_at
                    }
                    inserted_at
                    updated_at
                  }
                }
                """
                IO.puts(request)
                format = Keyword.merge(@format, [frames: :braille])
                ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
                run(request, ServerWeb.GraphQL.Schema, [context: context, variables: variables])
              _ ->
                {:error, message: "Oops! Something Wrong with an args"}
            end
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec update_subscriber(%{atom => String.t() | boolean()}) :: map() | error() | error_map() | error_tuple()
    def update_subscriber(args \\ @subscriber_params) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            case Map.keys(args) do
              @subscriber_keys ->
                request = """
                mutation {
                  updateSubscriber(
                    id: \"#{binaryId}\",
                    subscriber: {
                      email: \"#{args.email}\",
                      pro_role: #{args.pro_role}
                    }
                  ) {
                    id
                    email
                    pro_role
                    inserted_at
                    updated_at
                  }
                }
                """
                IO.puts(request)
                format = Keyword.merge(@format, [frames: :braille])
                ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
                run(request)
              _ ->
                {:error, message: "Oops! Something Wrong with an args"}
            end
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec update_user(%{atom => String.t() | boolean() | integer()}) :: map() | error() | error_map() | error_tuple()
    def update_user(args \\ @user_params) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            case Map.keys(args) do
              @user_keys ->
                user = if is_nil(args.id), do: :error, else: Core.Repo.get(User, args.id)
                context = %{current_user: user}
                variables = %{}
                request = """
                mutation {
                  updateUser(
                    id: \"#{binaryId}\",
                    user: {
                      active: #{args.active},
                      admin_role: #{args.admin_role},
                      avatar: \"#{args.avatar}\",
                      bio: \"#{args.bio}\",
                      birthday: \"#{args.birthday}\",
                      email: \"#{args.email}\",
                      first_name: \"#{args.first_name}\",
                      init_setup: #{args.init_setup},
                      languages: \"#{args.languages}\",
                      last_name: \"#{args.last_name}\",
                      middle_name: \"#{args.middle_name}\",
                      password: \"#{args.password}\",
                      password_confirmation: \"#{args.password_confirmation}\",
                      phone: \"#{args.phone}\",
                      pro_role: #{args.pro_role},
                      provider: \"#{args.provider}\",
                      sex: \"#{args.sex}\",
                      ssn: #{args.ssn},
                      street: \"#{args.street}\",
                      zip: #{args.zip}
                    }
                  ) {
                    id
                    active
                    admin_role
                    avatar
                    bio
                    birthday
                    email
                    first_name
                    init_setup
                    languages {id abbr name inserted_at updated_at}
                    last_name
                    middle_name
                    phone
                    pro_role
                    provider
                    sex
                    ssn
                    street
                    zip
                    inserted_at
                    updated_at
                  }
                }
                """
                IO.puts(request)
                format = Keyword.merge(@format, [frames: :braille])
                ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
                run(request, ServerWeb.GraphQL.Schema, [context: context, variables: variables])
              _ ->
                {:error, message: "Oops! Something Wrong with an args"}
            end
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec update_vacancy(%{atom => String.t()}) :: map() | error() | error_map() | error_tuple()
    def update_vacancy(args \\ @vacancy_params) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            case Map.keys(args) do
              @vacancy_keys ->
                request = """
                mutation {
                  updateVacancy(
                    id: \"#{binaryId}\",
                    vacancy: {
                      content: \"#{args.content}\",
                      department: \"#{args.department}\",
                      title: \"#{args.title}\"
                    }
                  ) {
                    id
                    content
                    department
                    title
                    inserted_at
                    updated_at
                  }
                }
                """
                IO.puts(request)
                format = Keyword.merge(@format, [frames: :braille])
                ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
                run(request)
              _ ->
                {:error, message: "Oops! Something Wrong with an args"}
            end
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec delete_dir_ptin(%{atom => String.t()}) :: map() | error_tuple()
    def delete_dir_ptin(args) when is_map(args) do
      if Map.has_key?(args, :date) do
        request = """
        mutation {
          deleteDir(date: \"#{args.date}\") { path }
        }
        """
        IO.puts(request)
        format = Keyword.merge(@format, [frames: :braille])
        ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
        run(request)
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec delete_dir_ptin(any()) :: error_tuple()
    def delete_dir_ptin(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec delete_faq(%{atom => String.t()}) :: map() | error() | error_map() | error_tuple()
    def delete_faq(args \\ %{id: @last_faq}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            request = """
            mutation {
              deleteFaq(id: \"#{binaryId}\") {id}
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec delete_faq_category(%{atom => String.t()}) :: map() | error() | error_map() | error_tuple()
    def delete_faq_category(args \\ %{id: @last_faq_category}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            request = """
            mutation {
              deleteFaqCategory(id: \"#{binaryId}\") {id}
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec delete_language(%{atom => String.t()}) :: map() | error() | error_map() | error_tuple()
    def delete_language(args \\ %{id: @last_language}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            request = """
            mutation {
              deleteLanguage(id: \"#{binaryId}\") {id}
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec delete_press_article(%{atom => String.t()}) :: map() | error() | error_map() | error_tuple()
    def delete_press_article(args \\ %{id: @last_press_article}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            request = """
            mutation {
              deletePressArticle(id: \"#{binaryId}\") {id}
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec delete_profile(%{atom => String.t()}) :: map() | error() | error_map() | error_tuple()
    def delete_profile(args \\ %{id: @last_user}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            user = if is_nil(args.id), do: :error, else: Core.Repo.get(User, args.id)
            context = %{current_user: user}
            variables = %{}
            request = """
            mutation {
              deleteProfile(id: \"#{binaryId}\") {user {id}}
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request, ServerWeb.GraphQL.Schema, [context: context, variables: variables])
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec delete_ptin() :: map()
    def delete_ptin do
      request = """
      mutation {
        deletePtin() { ptin }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec delete_subscriber(%{atom => String.t()}) :: map() | error() | error_map() | error_tuple()
    def delete_subscriber(args \\ %{id: @last_subscriber}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            request = """
            mutation {
              deleteSubscriber(id: \"#{binaryId}\") {id}
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec delete_user(%{atom => String.t()}) :: map() | error() | error_map() | error_tuple()
    def delete_user(args \\ %{id: @last_user}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            user = if is_nil(args.id), do: :error, else: Core.Repo.get(User, args.id)
            context = %{current_user: user}
            variables = %{}
            request = """
            mutation {
              deleteUser(id: \"#{binaryId}\") {id}
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request, ServerWeb.GraphQL.Schema, [context: context, variables: variables])
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec delete_vacancy(%{atom => String.t()}) :: map() | error() | error_map() | error_tuple()
    def delete_vacancy(args \\ %{id: @last_vacancy}) do
      if is_map(args) and Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            request = """
            mutation {
              deleteVacancy(id: \"#{binaryId}\") {id}
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec find_faq_category() :: map()
    def find_faq_category do
      request = """
      query {
        findFaqCategory(id: \"#{@last_faq_category}\") {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            faqs_count
            title
            inserted_at
            updated_at
          }
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec find_faq_category(%{atom => String.t()}) :: map() | error_tuple()
    def find_faq_category(args) when is_map(args) do
      if Map.has_key?(args, :id) do
        case Ecto.UUID.cast(args.id) do
          {:ok, binaryId} ->
            request = """
            query {
              findFaqCategory(id: \"#{binaryId}\") {
                id
                content
                title
                inserted_at
                updated_at
                faq_categories {
                  id
                  faqs_count
                  title
                  inserted_at
                  updated_at
                }
              }
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec find_faq_category(any()) :: error_tuple()
    def find_faq_category(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec search_profession() :: map()
    def search_profession do
      request = """
      query {
        searchProfession(
          bus_addr_zip: "84074",
          bus_st_code: "UT",
          first_name: "LiSa",
          last_name: "StEwArT"
        ) {
          profession
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec search_profession(%{atom => String.t()}) :: map() | error_tuple()
    def search_profession(args) when is_map(args) do
      case Map.keys(args) do
        @profession_keys ->
          request = """
          query {
            searchProfession(
              bus_addr_zip: \"#{args.bus_addr_zip}\",
              bus_st_code: \"#{args.bus_st_code}\",
              first_name: \"#{args.first_name}\",
              last_name: \"#{args.last_name}\"
            ) {
              profession
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec search_profession(any()) :: error_tuple()
    def search_profession(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec search_ptin() :: map()
    def search_ptin do
      request = """
      query {
        searchProfession(
          bus_addr_zip: "84074",
          bus_st_code: "UT",
          first_name: "LiSa",
          last_name: "StEwArT"
        ) {
          profession
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec search_ptin(%{atom => String.t()}) :: map() | error_tuple()
    def search_ptin(args) when is_map(args) do
      case Map.keys(args) do
        @profession_keys ->
          request = """
          query {
            searchProfession(
              bus_addr_zip: \"#{args.bus_addr_zip}\",
              bus_st_code: \"#{args.bus_st_code}\",
              first_name: \"#{args.first_name}\",
              last_name: \"#{args.last_name}\"
            ) {
              profession
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec search_ptin(any()) :: error_tuple()
    def search_ptin(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec search_title() :: map()
    def search_title do
      request = """
      query {
        searchTitles(title: \"#{@search_word}\") {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            title
            inserted_at
            updated_at
          }
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec search_title(%{atom => String.t()}) :: map() | error_tuple()
    def search_title(args) when is_map(args) do
      if Map.has_key?(args, :title) and !is_nil(args.title) do
        request = """
        query {
          searchTitles(title: \"#{args.title}\") {
            id
            content
            title
            inserted_at
            updated_at
            faq_categories {
              id
              title
              inserted_at
              updated_at
            }
          }
        }
        """
        IO.puts(request)
        format = Keyword.merge(@format, [frames: :braille])
        ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
        run(request)
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    def search_title(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec search_zipcode() :: map()
    def search_zipcode do
      request = """
      query {
        searchZipcode(
          zipcode: 602
        ) {
          id
          city
          state
          zipcode
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @keys List.delete(@zipcode_keys, :id)

    @spec search_zipcode(%{atom => integer()}) :: map() | error_tuple()
    def search_zipcode(args) when is_map(args) do
      if Map.has_key?(args, :zipcode) and !is_nil(args.zipcode) do
        case Map.keys(args) do
          @keys ->
            request = """
            query {
              searchZipcode(
                zipcode: #{args.zipcode}
              ) {
                id
                city
                state
                zipcode
              }
            }
            """
            IO.puts(request)
            format = Keyword.merge(@format, [frames: :braille])
            ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
            run(request)
          _ ->
            {:error, message: "Oops! Something Wrong with an args"}
        end
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    def search_zipcode(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec get_code() :: map()
    def get_code do
      request = """
      query {
        getCode(
          provider: "localhost"
        ) {
          code
          provider
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec get_code(%{atom => String.t()}) :: map() | error_tuple()
    def get_code(args) when is_map(args) do
      case Map.keys(args) do
        @provider_key ->
          request = """
          query {
            getCode(
              provider: \"#{args.provider}\"
            ) {
              code
              provider
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec get_code(any()) :: error_tuple()
    def get_code(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec get_refresh_token() :: map()
    def get_refresh_token do
      request = """
      query {
        getRefreshToken(
          provider: "localhost",
          token: "xxx"
        ) {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec get_refresh_token(%{atom => String.t()}) :: map() | error_tuple()
    def get_refresh_token(args) when is_map(args) do
      case Map.keys(args) do
        @token_provider_key ->
          request = """
          query {
            getRefreshToken(
              provider: \"#{args.provider}\",
              token: \"#{args.token}\"
            ) {
              access_token
              error
              error_description
              expires_in
              id_token
              provider
              refresh_token
              scope
              token_type
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec get_refresh_token(any()) :: error_tuple()
    def get_refresh_token(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec get_refresh_token_code() :: map()
    def get_refresh_token_code do
      request = """
      query {
        getRefreshTokenCode(
          provider: "localhost",
          token: "nil"
        ) {
          code
          provider
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec get_refresh_token_code(%{atom => String.t()}) :: map() | error_tuple()
    def get_refresh_token_code(args) when is_map(args) do
      case Map.keys(args) do
        @token_provider_key ->
          request = """
          query {
            getRefreshTokenCode(
              provider: \"#{args.provider}\",
              token: \"#{args.token}\"
            ) {
              code
              provider
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec get_refresh_token_code() :: error_tuple()
    def get_refresh_token_code(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec get_status() :: map()
    def get_status() do
      request = """
      query {
        getStatusBlockscore(
          address_city: "Cupertino",
          address_country_code: "US",
          address_postal_code: "95014",
          address_street1: "1 Infinite Loop",
          address_street2: "Apt 6",
          address_subdivision: "CA",
          birth_day: 23,
          birth_month: 8,
          birth_year: 1993,
          document_type: "ssn",
          document_value: "0000",
          name_first: "John",
          name_last: "Doe",
          name_middle: "Pearce"
        ) {
          status
        }
      }
      """
      IO.puts(request)
      format = Keyword.merge(@format, [frames: :braille])
      ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
      run(request)
    end

    @spec get_status(%{atom => String.t() | integer()}) :: map()
    def get_status(args) when is_map(args) do
      case Map.keys(args) do
        @blockscore_keys ->
          request = """
          query {
            getStatusBlockscore(
              address_city: \"#{args.address_city}\",
              address_country_code: \"#{args.address_country_code}\",
              address_postal_code: \"#{args.address_postal_code}\",
              address_street1: \"#{args.address_street1}\",
              address_street2: \"#{args.address_street2}\",
              address_subdivision: \"#{args.address_subdivision}\",
              birth_day: #{args.birth_day},
              birth_month: #{args.birth_month},
              birth_year: #{args.birth_year},
              document_type: \"#{args.document_type}\",
              document_value: \"#{args.document_value}\",
              name_first: \"#{args.name_first}\",
              name_last: \"#{args.name_last}\",
              name_middle: \"#{args.name_middle}\"
            ) {
              status
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec get_status() :: error_tuple()
    def get_status(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec get_token(%{atom => String.t()}) :: map() | error_tuple()
    def get_token(args) when is_map(args) do
      case Map.keys(args) do
        @social_keys ->
          request = """
          query {
            getToken(
              code: \"#{args.code}\",
              provider: \"#{args.provider}\"
            ) {
              access_token
              error
              error_description
              expires_in
              id_token
              provider
              refresh_token
              scope
              token_type
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        @localhost_key ->
          request = """
          query {
            getToken(
              email: \"#{args.email}\",
              password: \"#{args.password}\",
              provider: \"#{args.provider}\"
            ) {
              access_token
              error
              error_description
              expires_in
              id_token
              provider
              refresh_token
              scope
              token_type
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec get_token(any()) :: error_tuple()
    def get_token(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec verify_token(%{atom => String.t()}) :: map() | error_tuple()
    def verify_token(args) when is_map(args) do
      case Map.keys(args) do
        @token_provider_key ->
          request = """
          query {
            getVerify(
              provider: \"#{args.provider}\",
              token: \"#{args.token}\"
            ) {
              access_type
              aud
              azp
              email
              error
              error_description
              exp
              expires_in
              provider
              scope
              sub
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec verify_token(any()) :: error_tuple()
    def verify_token(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec picture(%{atom => String.t()}) :: map()
    def picture(args) when is_map(args) do
      if Map.has_key?(args, :id) and !is_nil(args.id) do
        request = """
        query {
          picture(id: \"#{args.id}\") {
            id
            content_type
            name
            size
            url
            inserted_at
            updated_at
          }
        }
        """
        IO.puts(request)
        format = Keyword.merge(@format, [frames: :braille])
        ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
        run(request)
      else
        {:error, "Please fill out all required arguments!"}
      end
    end

    @spec picture(any()) :: error_tuple()
    def picture(_) do
      {:error, "Please fill out all required arguments!"}
    end

    # 1. profile = Repo.all(Profile) |> List.last
    # 2. user = Accounts.get_user!(profile.user_id)
    # 3. authenticated = %{context: %{current_user: user}}
    # 4. args = %{name: "my pic", alt: "represents something", file: "picture.png"}
    # 5. path = Path.absname("apps/core/test/fixtures/#{args.file}")
    # 6. input = %Plug.Upload{content_type: "image/png", filename: args.file, path: path}
    # 7. params = %{alt: args.alt, name: args.name, profile_id: profile.user_id, file: input}
    # 8. {:ok, uploaded} = ServerWeb.GraphQL.Resolvers.Media.PicturesResolver.upload_picture(nil, params, authenticated)

    @spec upload_picture(%{atom => String.t()}) :: map()
    def upload_picture(args) when is_map(args) do
      case Map.keys(args) do
        @picture_keys ->
          user = if is_nil(args.profile_id), do: :error, else: Core.Repo.get(User, args.profile_id)
          context = %{current_user: user}
          path = Path.absname("apps/core/test/fixtures/#{args.file}")
          variables = %{
            file: %Plug.Upload{content_type: "image/png", filename: args.file, path: path}
          }
          request = """
          mutation ($file: Upload!) {
            uploadPicture(
              alt: \"#{args.alt}\",
              name: \"#{args.name}\",
              file: $file,
              profileId: \"#{user.id}\"
            ) {
              id
              content_type
              name
              size
              url
              inserted_at
              updated_at
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request, ServerWeb.GraphQL.Schema, [
            context: context,
            operation_name: "f",
            variables: variables
          ])
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec upload_picture(any()) :: error_tuple()
    def upload_picture(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec signin(%{atom => String.t()}) :: map() | error_tuple()
    def signin(args) when is_map(args) do
      case Map.keys(args) do
        @localhost_keys ->
          request = """
          query {
            signIn(
              email: \"#{args.email}\",
              password: \"#{args.password}\",
              password_confirmation: \"#{args.password_confirmation}\",
              provider: \"#{args.provider}\"
            ) {
              access_token
              provider
              error
              error_description
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        @social_keys ->
          request = """
          query {
            signIn(
              code: \"#{args.code}\",
              provider: \"#{args.provider}\"
            ) {
              access_token
              provider
              error
              error_description
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec signin(any()) :: error_tuple()
    def signin(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec signup(%{atom => String.t()}) :: map() | error_tuple()
    def signup(args) when is_map(args) do
      case Map.keys(args) do
        @localhost_keys ->
          request = """
          mutation {
            signUp(
              email: \"#{args.email}\",
              password: \"#{args.password}\",
              password_confirmation: \"#{args.password_confirmation}\",
              provider: \"#{args.provider}\"
            ) {
              access_token
              provider
              error
              error_description
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        @social_keys ->
          request = """
          mutation {
            signUp(
              code: \"#{args.code}\",
              provider: \"#{args.provider}\"
            ) {
              access_token
              provider
              error
              error_description
            }
          }
          """
          IO.puts(request)
          format = Keyword.merge(@format, [frames: :braille])
          ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
          run(request)
        _ ->
          {:error, message: "Oops! Something Wrong with an args"}
      end
    end

    @spec signup(any()) :: error_tuple()
    def signup(_) do
      {:error, "Please fill out all required arguments!"}
    end

    @spec run(
            binary | Absinthe.Language.Source.t() | Absinthe.Language.Document.t(),
            Absinthe.Schema.t(),
            run_opts
          ) :: run_result
    defp run(request, schema \\ ServerWeb.GraphQL.Schema, opts \\ []) do
      {:ok, result} = Absinthe.run(request, schema, opts)
      result
    end
  else
    IO.puts("\nApplication started in Benchmark Enviroment\n")
  end
end
