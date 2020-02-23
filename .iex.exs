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
  Repo
}

:timer.sleep(8000);

clear
######################################################################

defmodule LetMeSee do
  @moduledoc """
  Open N+1 in a terminal
  Open regular in another terminal

  iex> mix ecto.reset
  iex> iex -S mix

  cmd+r


  LetMeSee.index_faq_category()
  LetMeSee.index_faq()
  LetMeSee.index_language()
  LetMeSee.index_press_article()
  LetMeSee.index_profile()
  LetMeSee.index_subscriber()
  LetMeSee.index_user()
  LetMeSee.index_vacancy()

  LetMeSee.find_faq_category(id)

  LetMeSee.show_faq(id)
  LetMeSee.show_faq_category(id)
  LetMeSee.show_language(id)
  LetMeSee.show_press_article(id)
  LetMeSee.show_profile(id)
  LetMeSee.show_subscriber(id)
  LetMeSee.show_user(id)
  LetMeSee.show_vacancy(id)
  LetMeSee.show_zipcode(id)

  LetMeSee.search_titles(word)
  LetMeSee.search_profession(args)
  LetMeSee.search_zipcode(args)

  LetMeSee.get_code(args)
  LetMeSee.get_token(args)
  LetMeSee.get_refresh_token_code(args)
  LetMeSee.get_refresh_token(args)
  LetMeSee.verify_token(args)

  LetMeSee.signup(args)
  LetMeSee.signin(args)

  LetMeSee.create_faq(args)
  LetMeSee.create_faq_category(args)
  LetMeSee.create_language(args)
  LetMeSee.create_press_article(args)
  LetMeSee.create_subscriber(args)
  LetMeSee.create_vacancy(args)
  LetMeSee.create_user(args)

  LetMeSee.update_faq(id, arg)
  LetMeSee.update_faq_category(id, args)
  LetMeSee.update_language(id, args)
  LetMeSee.update_press_article(id, args)
  LetMeSee.update_profile(id, args)
  LetMeSee.update_subscriber(id, args)
  LetMeSee.update_user(id, args)
  LetMeSee.update_vacancy(id, args)

  LetMeSee.delete_faq(id)
  LetMeSee.delete_faq_category(id)
  LetMeSee.delete_language(id)
  LetMeSee.delete_press_article(id)
  LetMeSee.delete_profile(id)
  LetMeSee.delete_subscriber(id)
  LetMeSee.delete_user(id)
  LetMeSee.delete_vacancy(id)
  """

  IO.puts(
    "\nAaron - This is your self from the past. Remember to reset the DB! mix ecto.reset.repo then do setup\n"
  )

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

  @last_vacancy Repo.all(Vacancy) |> List.last |> Map.get(:id)
  @last_press_article Repo.all(PressArticle) |> List.last |> Map.get(:id)
  @last_faq Repo.all(Faq) |> List.last |> Map.get(:id)
  @last_faq_category Repo.all(FaqCategory) |> List.last |> Map.get(:id)
  @last_language Repo.all(Language) |> List.last |> Map.get(:id)
  @last_subscriber Repo.all(Subscriber) |> List.last |> Map.get(:id)
  @last_user Repo.all(User) |> List.last |> Map.get(:id)
  @last_zipcode Repo.all(UsZipcode) |> List.first |> Map.get(:id)
  @search_word ~s(Article)
  @search_zipcode %{zipcode: 602}
  @profession %{bus_addr_zip: "84074", bus_st_code: "UT", first_name: "LiSa", last_name: "StEwArT"}
  @provider_key ~w(provider)a
  @code_provider_key ~w(code provider)a
  @token_provider_key ~w(provider token)a
  @localhost_key ~w(email password provider)a
  @localhost_keys ~w(email password password_confirmation provider)a
  @social_keys ~w(code email provider)a

  @spec index_faq() :: list()
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
    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

    IO.puts("\nThe Result:")
    result
  end

  @spec index_faq_category() :: list()
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
    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

    IO.puts("\nThe Result:")
    result
  end

  @spec index_press_article() :: list()
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
    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

    IO.puts("\nThe Result:")
    result
  end

  @spec index_vacancy() :: list()
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
    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

    IO.puts("\nThe Result:")
    result
  end

  @spec index_language() :: list()
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
    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

    IO.puts("\nThe Result:")
    result
  end

  @spec index_subscriber() :: list()
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
    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

    IO.puts("\nThe Result:")
    result
  end

  @spec index_user() :: list()
  def index_user do
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
    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

    IO.puts("\nThe Result:")
    result
  end

  @spec index_profile() :: list()
  def index_profile do
    request = """
    query {
      allProfiles{
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
    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

    IO.puts("\nThe Result:")
    result
  end

  @spec find_faq_category(bitstring()) :: map() | error_tuple
  def find_faq_category(id \\ @last_faq_category) do
    case Ecto.UUID.cast(id) do
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec show_faq(bitstring()) :: map() | error_map | error_tuple
  def show_faq(id \\ @last_faq) do
    case Ecto.UUID.cast(id) do
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec show_faq_category(bitstring()) :: map() | error_map | error_tuple
  def show_faq_category(id \\ @last_faq_category) do
    case Ecto.UUID.cast(id) do
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec show_press_article(bitstring()) :: map() | error_map | error_tuple
  def show_press_article(id \\ @last_press_article) do
    case Ecto.UUID.cast(id) do
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec show_vacancy(bitstring()) :: map() | error_map | error_tuple
  def show_vacancy(id \\ @last_vacancy) do
    case Ecto.UUID.cast(id) do
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec show_language(bitstring()) :: map() | error_map | error_tuple
  def show_language(id \\ @last_language) do
    case Ecto.UUID.cast(id) do
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec show_subscriber(bitstring()) :: map() | error_map | error_tuple
  def show_subscriber(id \\ @last_subscriber) do
    case Ecto.UUID.cast(id) do
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec show_user(bitstring()) :: map() | error_map | error_tuple
  def show_user(id \\ @last_user) do
    case Ecto.UUID.cast(id) do
      {:ok, binaryId} ->
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec show_zipcode(bitstring()) :: map() | error_map | error_tuple
  def show_zipcode(id \\ @last_zipcode) do
    case Ecto.UUID.cast(id) do
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec show_profile(bitstring()) :: map() | error_map | error_tuple
  def show_profile(id \\ @last_user) do
    case Ecto.UUID.cast(id) do
      {:ok, binaryId} ->
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec search_title(map()) :: map() | error_map | error_tuple
  def search_title(word \\ @search_word) do
    request = """
    query {
      searchTitles(title: \"#{word}\") {
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
    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

    IO.puts("\nThe Result:")
    result
  end

  @profession_keys ~w(bus_addr_zip bus_st_code first_name last_name)a |> Enum.sort

  @spec search_profession(map()) :: map() | error_tuple
  def search_profession(args \\ @profession) do
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  @zipcode_keys ~w(zipcode)a

  @spec search_zipcode(map()) :: map() | error_tuple
  def search_zipcode(args \\ @search_zipcode) do
    case Map.keys(args) do
      @zipcode_keys ->
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  @spec get_code(map()) :: map() | error_tuple
  def get_code(args \\ %{provider: "localhost"}) do
    case Map.keys(args) do
      @provider_key ->
        request = """
        query {
          getCode(
            provider: \"#{args.provider}\"
          ) {
            code
          }
        }
        """
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  @spec get_token(map()) :: map() | error_tuple
  def get_token(args) do
    case Map.keys(args) do
      @code_provider_key ->
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  @spec get_refresh_token_code(map()) :: map() | error_tuple
  def get_refresh_token_code(args \\ %{provider: "localhost", token: nil}) do
    case Map.keys(args) do
      @code_provider_key ->
        request = """
        query {
          getRefreshTokenCode(
            provider: \"#{args.provider}\",
            token: \"#{args.token}\"
          ) {
            code
          }
        }
        """
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  @spec get_refresh_token(map()) :: map() | error_tuple
  def get_refresh_token(args \\ %{provider: "localhost", token: "xxx"}) do
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  @spec verify_token(map()) :: map() | error_tuple
  def verify_token(args) do
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  def signup(args) do
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      @social_keys ->
        request = """
        mutation {
          signUp(
            code: \"#{args.code}\",
            email: \"#{args.email}\",
            provider: \"#{args.provider}\"
          ) {
            access_token
            provider
            error
            error_description
          }
        }
        """
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  def signin(args) do
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      @code_provider_key ->
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  @faq_keys ~w(content title faq_category_id)a |> Enum.sort

  @spec create_faq(map()) :: map() | error_map | error_tuple
  def create_faq(args) do
    case Map.keys(args) do
      @faq_keys ->
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
            IO.puts("The Request:")
            IO.puts(request)

            {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

            IO.puts("\nThe Result:")
            result
          :error ->
            {:error, message: "Oops! Something Wrong with Id"}
        end
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  @faq_category_keys ~w(title)a |> Enum.sort

  @spec create_faq_category(map()) :: map() | error_map | error_tuple
  def create_faq_category(args) do
    case Map.keys(args) do
      @faq_category_keys ->
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  @press_article_keys ~w(author img_url preview_text title url)a |> Enum.sort

  @spec create_press_article(map()) :: map() | error_map | error_tuple
  def create_press_article(args) do
    case Map.keys(args) do
      @press_article_keys ->
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
            preview_text
            title
            url
            inserted_at
            updated_at
          }
        }
        """
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  @vacancy_keys ~w(content department title)a |> Enum.sort

  @spec create_vacancy(map()) :: map() | error_map | error_tuple
  def create_vacancy(args) do
    case Map.keys(args) do
      @vacancy_keys ->
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  @language_keys ~w(abbr name)a |> Enum.sort

  @spec create_language(map()) :: map() | error_map | error_tuple
  def create_language(args) do
    case Map.keys(args) do
      @language_keys ->
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  @subscriber_keys ~w(email pro_role)a |> Enum.sort

  @spec create_subscriber(map()) :: map() | error | error_map | error_tuple
  def create_subscriber(args) do
    case Map.keys(args) do
      @subscriber_keys ->
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  @user_keys ~w(
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

  @spec create_user(map()) :: map() | error | error_map | error_tuple
  def create_user(args) do
    case Map.keys(args) do
      @user_keys ->
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

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
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
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      _ ->
        {:error, message: "Oops! Something Wrong with an args"}
    end
  end

  @spec update_faq(bitstring(), map()) :: map() | error | error_map | error_tuple
  def update_faq(id \\ @last_faq, args) do
    case Ecto.UUID.cast(id) do
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
            IO.puts("The Request:")
            IO.puts(request)

            {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

            IO.puts("\nThe Result:")
            result
          _ ->
            {:error, message: "Oops! Something Wrong with an args"}
        end
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec update_faq_category(bitstring(), map()) :: map() | error | error_map | error_tuple
  def update_faq_category(id \\ @last_faq_category, args) do
    case Ecto.UUID.cast(id) do
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
            IO.puts("The Request:")
            IO.puts(request)

            {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

            IO.puts("\nThe Result:")
            result
          _ ->
            {:error, message: "Oops! Something Wrong with an args"}
        end
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec update_press_article(bitstring(), map()) :: map() | error | error_map | error_tuple
  def update_press_article(id \\ @last_press_article, args) do
    case Ecto.UUID.cast(id) do
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
                preview_text
                title
                url
                inserted_at
                updated_at
              }
            }
            """
            IO.puts("The Request:")
            IO.puts(request)

            {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

            IO.puts("\nThe Result:")
            result
          _ ->
            {:error, message: "Oops! Something Wrong with an args"}
        end
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec update_vacancy(bitstring(), map()) :: map() | error | error_map | error_tuple
  def update_vacancy(id \\ @last_vacancy, args) do
    case Ecto.UUID.cast(id) do
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
            IO.puts("The Request:")
            IO.puts(request)

            {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

            IO.puts("\nThe Result:")
            result
          _ ->
            {:error, message: "Oops! Something Wrong with an args"}
        end
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec update_language(bitstring(), map()) :: map() | error | error_map | error_tuple
  def update_language(id \\ @last_language, args) do
    case Ecto.UUID.cast(id) do
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
            IO.puts("The Request:")
            IO.puts(request)

            {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

            IO.puts("\nThe Result:")
            result
          _ ->
            {:error, message: "Oops! Something Wrong with an args"}
        end
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec update_subscriber(bitstring(), map()) :: map() | error | error_map | error_tuple
  def update_subscriber(id \\ @last_subscriber, args) do
    case Ecto.UUID.cast(id) do
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
            IO.puts("The Request:")
            IO.puts(request)

            {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

            IO.puts("\nThe Result:")
            result
          _ ->
            {:error, message: "Oops! Something Wrong with an args"}
        end
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec update_user(bitstring(), map()) :: map() | error | error_map | error_tuple
  def update_user(id \\ @last_user, args) do
    case Ecto.UUID.cast(id) do
      {:ok, binaryId} ->
        case Map.keys(args) do
          @user_keys ->
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
            IO.puts("The Request:")
            IO.puts(request)

            {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

            IO.puts("\nThe Result:")
            result
          _ ->
            {:error, message: "Oops! Something Wrong with an args"}
        end
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @profile_keys ~w(address banner description us_zipcode_id user_id)a |> Enum.sort

  @spec update_profile(bitstring(), map()) :: map() | error | error_map | error_tuple
  def update_profile(id \\ @last_user, args) do
    case Ecto.UUID.cast(id) do
      {:ok, binaryId} ->
        case Map.keys(args) do
          @profile_keys ->
            request = """
            mutation {
              updateProfile(
                id: \"#{binaryId}\",
                profile: {
                  address: \"#{args.address}\",
                  banner: \"#{args.banner}\",
                  description: \"#{args.description}\",
                  us_zipcodeId: \"#{args.us_zipcode_id}\",
                  userId: \"#{args.user_id}\"
                }
              ) {
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
            IO.puts("The Request:")
            IO.puts(request)

            {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

            IO.puts("\nThe Result:")
            result
          _ ->
            {:error, message: "Oops! Something Wrong with an args"}
        end
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec delete_faq(bitstring()) :: map() | error | error_map | error_tuple
  def delete_faq(id \\ @last_faq) do
    case Ecto.UUID.cast(id) do
      {:ok, binaryId} ->
        request = """
        mutation {
          deleteFaq(id: \"#{binaryId}\") {id}
        }
        """
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec delete_faq_category(bitstring()) :: map() | error | error_map | error_tuple
  def delete_faq_category(id \\ @last_faq_category) do
    case Ecto.UUID.cast(id) do
      {:ok, binaryId} ->
        request = """
        mutation {
          deleteFaqCategory(id: \"#{binaryId}\") {id}
        }
        """
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec delete_press_article(bitstring()) :: map() | error | error_map | error_tuple
  def delete_press_article(id \\ @last_press_article) do
    case Ecto.UUID.cast(id) do
      {:ok, binaryId} ->
        request = """
        mutation {
          deletePressArticle(id: \"#{binaryId}\") {id}
        }
        """
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec delete_vacancy(bitstring()) :: map() | error | error_map | error_tuple
  def delete_vacancy(id \\ @last_vacancy) do
    case Ecto.UUID.cast(id) do
      {:ok, binaryId} ->
        request = """
        mutation {
          deleteVacancy(id: \"#{binaryId}\") {id}
        }
        """
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec delete_language(bitstring()) :: map() | error | error_map | error_tuple
  def delete_language(id \\ @last_language) do
    case Ecto.UUID.cast(id) do
      {:ok, binaryId} ->
        request = """
        mutation {
          deleteLanguage(id: \"#{binaryId}\") {id}
        }
        """
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec delete_subscriber(bitstring()) :: map() | error | error_map | error_tuple
  def delete_subscriber(id \\ @last_subscriber) do
    case Ecto.UUID.cast(id) do
      {:ok, binaryId} ->
        request = """
        mutation {
          deleteSubscriber(id: \"#{binaryId}\") {id}
        }
        """
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec delete_user(bitstring()) :: map() | error | error_map | error_tuple
  def delete_user(id \\ @last_user) do
    case Ecto.UUID.cast(id) do
      {:ok, binaryId} ->
        request = """
        mutation {
          deleteUser(id: \"#{binaryId}\") {id}
        }
        """
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end

  @spec delete_profile(bitstring()) :: map() | error | error_map | error_tuple
  def delete_profile(id \\ @last_user) do
    case Ecto.UUID.cast(id) do
      {:ok, binaryId} ->
        request = """
        mutation {
          deleteProfile(id: \"#{binaryId}\") {user {id}}
        }
        """
        IO.puts("The Request:")
        IO.puts(request)

        {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

        IO.puts("\nThe Result:")
        result
      :error ->
        {:error, message: "Oops! Something Wrong with Id"}
    end
  end
end
