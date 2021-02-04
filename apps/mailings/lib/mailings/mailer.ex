defmodule Mailings.Mailer do
  @moduledoc """
  A client API to the Mailgun .
  """

  alias Faker.{Lorem, Lorem.Shakespeare.En}

  @config domain: Application.get_env(:mailings, :mailgun_domain),
    key: Application.get_env(:mailings, :mailgun_key),
    httpc_opts: [connect_timeout: 2000, timeout: 3000]

  @root_dir Path.expand("../../../mailings/data/", __DIR__)
  @tp_html_path "#{@root_dir}/email_tp.html"
  @pro_html_path "#{@root_dir}/email_pro.html"
  @forgot_password_html_path "#{@root_dir}/forgot_password.html"
  @tp_email_subject "Join this tax season"
  @pro_email_subject "Become a Tax Pro"
  @tp_template "subscriber_client"
  @pro_template "subscriber_pro"
  @forgot_password_template "forgot_password"

  use Mailgun.Client, @config

  @from "noreply@mail.taxgig.com"

  @doc """
  Send an email in format txt for customer TP.

  ## Examples

      iex> Mailings.Mailer.send_tp_text("test@example.com")
      :ok
  """
  @spec send_tp_text(String.t()) :: :ok
  def send_tp_text(customer) do
    send_email to: customer,
               from: @from,
               subject: email_subject(),
               text: welcome_tp_text()
    :ok
  end

  @doc """
  Send an email in format txt for customer Pro.

  ## Examples

      iex> Mailings.Mailer.send_pro_text("test@example.com")
      :ok
  """
  @spec send_pro_text(String.t()) :: :ok
  def send_pro_text(customer) do
    send_email to: customer,
               from: @from,
               subject: email_subject(),
               text: welcome_pro_text()
    :ok
  end

  @doc """
  Send an email in format html for customer TP.

  ## Examples

      iex> Mailings.Mailer.send_tp_html"test@example.com")
      :ok
  """
  @spec send_tp_html(String.t()) :: :ok
  def send_tp_html(customer) do
    send_email to: customer,
               from: @from,
               subject: @tp_email_subject,
               template: @tp_template
    :ok
  end

  @doc """
  Send an email in format html for customer PRO.

  ## Examples

      iex> Mailings.Mailer.send_pro_html("test@example.com")
      :ok
  """
  @spec send_pro_html(String.t()) :: :ok
  def send_pro_html(customer) do
    send_email to: customer,
               from: @from,
               subject: @pro_email_subject,
               template: @pro_template

    :ok
  end

  @doc """
  Send an email in format html if customer forgot password.

  ## Examples

      iex> Mailings.Mailer.send_forgot_password_html("123", "test@example.com", "John")
      :ok
  """
  @user_link "https://taxgig.com/?id=9ukGONGpyZZz0XYiVE"
  @spec send_forgot_password_html(String.t(), String.t(), String.t()) :: :ok
  def send_forgot_password_html(id, email, name) do
    year = Timex.format!(Timex.now, "%Y", :strftime)
    send_email to: email,
               from: @from,
               subject: forgot_password_subject(),
               template: @forgot_password_template,
               'v:firstname': name,
               'v:user_id': id,
               'v:year': year,
               'v:user_link': @user_link
    :ok
  end

  @doc """
  Send Message by Tp's user for user by role pro.

  ## Examples

      iex> users = [%{email: "kapranov.lugatex@gmail.com", user_id: FlakeId.get()}]
      iex> Mailings.Mailer.send_total_match(users)
      :ok
  """
  @spec send_total_match([%{email: String.t(), user_id: String.t()}]) :: :ok
  def send_total_match(users) do
    Enum.map(users, &(send_email(to: Map.get(&1, :email), from: @from, subject: email_subject(), text: welcome_tp_text())))
    :ok
  end

  @doc false
  @spec email_subject() :: String.t()
  defp email_subject do
    Lorem.word()
  end

  @doc false
  @spec forgot_password_subject() :: String.t()
  defp forgot_password_subject do
    "Update for Password"
  end

  @doc false
  @spec welcome_tp_text() :: String.t()
  defp welcome_tp_text do
    En.hamlet()
  end

  @doc false
  @spec welcome_pro_text() :: String.t()
  defp welcome_pro_text do
    En.hamlet()
  end

  @doc false
  @spec welcome_tp_html() :: String.t() | {:error, :enoent}
  def welcome_tp_html do
    {:ok, data} = File.read("#{@tp_html_path}")
    data
  end

  @doc false
  @spec welcome_pro_html() :: String.t() | {:error, :enoent}
  def welcome_pro_html do
    {:ok, data} = File.read("#{@pro_html_path}")
    data
  end

  @doc false
  @spec forgot_password_html(String.t(), String.t()) :: String.t() | {:error, :enoent}
  def forgot_password_html(id, name) do
    {:ok, data} = File.read("#{@forgot_password_html_path}")

    data
    |> String.replace("Hi", "Hello #{name},")
    |> String.replace("user_id", id)
  end
end
