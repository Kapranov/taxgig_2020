Application.put_env(:elixir, :ansi_enabled, true)

IO.puts IO.ANSI.magenta()
        # <> IO.ANSI.light_black_background()
        <> IO.ANSI.bright()
        <> IO.ANSI.underline()
        <> IO.ANSI.blink_slow()
        <> "Using global .iex.exs (located in ~/.iex.exs)" <> IO.ANSI.reset()

queue_length = fn ->
  self()
  |> Process.info()
  |> Keyword.get(:message_queue_len)
end

prefix = IO.ANSI.light_black_background() <> IO.ANSI.magenta() <> "%prefix"
         <> IO.ANSI.reset()
counter = IO.ANSI.light_black_background() <> IO.ANSI.black() <> "-%node-(%counter)"
          <> IO.ANSI.reset()
info = IO.ANSI.light_blue() <> "✉ #{queue_length.()}" <> IO.ANSI.reset()
last = IO.ANSI.yellow() <> "➤➤➤" <> IO.ANSI.reset()
alive = IO.ANSI.bright() <> IO.ANSI.yellow() <> IO.ANSI.blink_rapid() <> "⚡"
        <> IO.ANSI.reset()

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
  ],
  default_prompt: default_prompt,
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
        quote do
          alias unquote(repo), as: Repo
        end
    end
end

######################################################################
######################################################################
import Ecto.Query

alias Core.{
  Landing,
  Landing.Faq,
  Landing.FaqCategory,
  Landing.PressArticle,
  Landing.Vacancy,
  Ptin,
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

  LetMeSee.index_faqs()
  LetMeSee.index_faq_categories()
  LetMeSee.index_press_articles()
  LetMeSee.index_vacancies()

  LetMeSee.find_faq_category(args)

  LetMeSee.show_faq(args)
  LetMeSee.show_faq_category(args)
  LetMeSee.show_press_article(args)
  LetMeSee.show_vacancy(args)

  LetMeSee.search_titles(args)

  LetMeSee.create_faq(args)
  LetMeSee.create_faq_category()
  LetMeSee.create_press_article()
  LetMeSee.create_vacancy()

  LetMeSee.update_faq(id, arg)
  LetMeSee.update_faq_category(args)
  LetMeSee.update_press_article(args)
  LetMeSee.update_vacancy(args)

  LetMeSee.delete_faq(args)
  LetMeSee.delete_faq_category(args)
  LetMeSee.delete_press_article(args)
  LetMeSee.delete_vacancy(args)
  """

  IO.puts(
    "\nAaron - This is your self from the past. Remember to reset the DB! mix ecto.reset.repo then do setup\n"
  )

  @last_vacancy Repo.all(Vacancy) |> List.last |> Map.get(:id)
  @last_press_article Repo.all(PressArticle) |> List.last |> Map.get(:id)
  @last_faq Repo.all(Faq) |> List.last |> Map.get(:id)
  @last_faq_category Repo.all(FaqCategory) |> List.last |> Map.get(:id)
  @search_word ~s(Article)

  def index_faqs do
    request = """
    {
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

  def index_faq_categories do
    request = """
    {
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

  def index_press_articles do
    request = """
    {
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

  def index_vacancies do
    request = """
    {
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

  def find_faq_category(id \\ @last_faq_category) do
    request = """
    {
      findFaqCategory(id: \"#{id}\") {
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
  end

  def show_faq(id \\ @last_faq) do
    request = """
    {
      showFaq(id: \"#{id}\") {
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

  def show_faq_category(id \\ @last_faq_category) do
    request = """
    {
      showFaqCategory(id: \"#{id}\") {
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

  def show_press_article(id \\ @last_press_article) do
    request = """
    {
      showPressArticle(id: \"#{id}\") {
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

  def show_vacancy(id \\ @last_vacancy) do
    request = """
    {
      showVacancy(id: \"#{id}\") {
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

  def search_titles(word \\ @search_word) do
    request = """
    {
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

  def create_faq(id \\ @last_faq_category) do
    request = """
    {
      createFaq(
        content: "some text",
        title: "some text",
        faq_categoryId: \"#{id}\"
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
  end

  def create_faq_category do
    request = """
    {
      createFaqCategory(
        title: "some text"
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
  end

  def create_press_article do
    request = """
    {
      createPressArticle(
        author: "some text",
        img_url: "some text",
        preview_text: "some text",
        title: "some text",
        url: "some text"
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
  end

  def create_vacancy do
    request = """
    {
      createVacancy(
        content: "some text",
        department: "some text",
        title: "some text"
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
  end

  def update_faq(id \\ @last_faq, arg \\ @last_faq_category) do
    request = """
    {
      updateFaq(
        id: \"#{id}\",
        faq: {
          content: "updated text",
          title: "updated text",
          faq_categoryId: \"#{arg}\"
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
  end

  def update_faq_category(id \\ @last_faq_category) do
    request = """
    {
      updateFaqCategory(
        id: \"#{id}\",
        faq_category: {
          title: "updated text"
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
  end

  def update_press_article(id \\ @last_press_article) do
    request = """
    {
      updatePressArticle(
        id: \"#{id}\",
        press_article: {
          author: "updated text",
          img_url: "updated text",
          preview_text: "updated text",
          title: "updated text",
          url: "updated text"
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
  end

  def update_vacancy(id \\ @last_vacancy) do
    request = """
    {
      updateVacancy(
        id: \"#{id}\",
        vacancy: {
          content: "updated text",
          department: "updated text",
          title: "updated text"
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
  end

  def delete_faq(id \\ @last_faq) do
    request = """
    {
      deleteFaq(id: \"#{id}\") {id}
    }
    """
    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

    IO.puts("\nThe Result:")
    result
  end

  def delete_faq_category(id \\ @last_faq_category) do
    request = """
    {
      deleteFaqCategory(id: \"#{id}\") {id}
    }
    """
    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

    IO.puts("\nThe Result:")
    result
  end

  def delete_press_article(id \\ @last_press_article) do
    request = """
    {
      deletePressArticle(id: \"#{id}\") {id}
    }
    """
    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

    IO.puts("\nThe Result:")
    result
  end

  def delete_vacancy(id \\ @last_vacancy) do
    request = """
    {
      deleteVacancy(id: \"#{id}\") {id}
    }
    """
    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ServerWeb.GraphQL.Schema)

    IO.puts("\nThe Result:")
    result
  end
end
