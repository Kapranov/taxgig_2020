defmodule Mailings.Mailer do
  @moduledoc """
  A client API to the Mailgun .
  """

  alias Faker.{Lorem, Lorem.Shakespeare.En}

  @config domain: Application.get_env(:mailings, :mailgun_domain),
    key: Application.get_env(:mailings, :mailgun_key)

  @root_dir Path.expand("../../../mailings/data/", __DIR__)
  @tp_html_path "#{@root_dir}/email_tp.html"
  @pro_html_path "#{@root_dir}/email_pro.html"
  @forgot_password_html_path "#{@root_dir}/forgot_password.html"

  use Mailgun.Client, @config

  @from "contact@mail.taxgig.com"

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
               subject: email_subject(),
               html: welcome_tp_html()

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
               subject: email_subject(),
               html: welcome_pro_html()

    :ok
  end

  @doc """
  Send an email in format html if customer forgot password.

  ## Examples

      iex> Mailings.Mailer.send_forgot_password_html("123", "test@example.com", "John")
      :ok
  """
  @spec send_forgot_password_html(String.t(), String.t(), String.t()) :: :ok
  def send_forgot_password_html(id, email, name) do
    send_email to: email,
               from: @from,
               subject: forgot_password_subject(),
               html: forgot_password_html(id, name)

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
  defp welcome_tp_html do
    {:ok, data} = File.read("#{@tp_html_path}")
    data
  end

  @doc false
  @spec welcome_pro_html() :: String.t() | {:error, :enoent}
  defp welcome_pro_html do
    {:ok, data} = File.read("#{@pro_html_path}")
    data
  end

  @doc false
  @spec forgot_password_html(String.t(), String.t()) :: String.t() | {:error, :enoent}
  defp forgot_password_html(id, name) do
    {:ok, data} = File.read("#{@forgot_password_html_path}")

    data
    |> String.replace("Hi", "Hello #{name},")
    |> String.replace("user_id", id)
  end
end
