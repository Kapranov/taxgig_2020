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
  # @forgot_password_html_path "#{@root_dir}/forgot_password.html"

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
    # {:ok, data} = File.read("#{@forgot_password_html_path}")
    # data
    body_html = ~s"""
      <html lang="en">
      <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta http-equiv="X-UA-Compatible" content="ie=edge">
      <title>taxgig</title>
      <link href="https://fonts.googleapis.com/css?family=Lora:400,700|Work+Sans:400,500,600,700" rel="stylesheet"></link>
      </head>
      <body style="margin: 0;">
      <div style="width: 100%; height: 100%; background-color: #292F42; padding: 0; margin: 0; font-family: 'Work Sans', sans-serif; margin: 0 auto;">
      <table style="max-width: 600px; background-color: #292F42; padding: 0; margin: 0; font-family: 'Work Sans', sans-serif; margin: 0 auto;">
      <table style="padding: 0; margin: 0; font-family: 'Work Sans', sans-serif; background-color: #292F42; margin: 0 auto; padding-left: 16px; padding-right: 16px; padding-top: 16px; padding-bottom: 8px;">
      <tr style="max-width: 600px; font-family: 'Work Sans', sans-serif; background-color: #fafafa; border-radius: 5px; border: 1px solid #000; display: block; padding: 32px;">
      <td>
      <h2 style="font-family: 'Work Sans', sans-serif; font-size: 32px; font-weight: 600; letter-spacing: 0.3px; color: #292F42;">Email - do-not-reply@projectname.com
          <h2 style="font-family: 'Work Sans', sans-serif; font-size: 32px; font-weight: 600; letter-spacing: 0.3px; color: #292F42;">Subject - Reset your projectnamepassword
      </h2>
      <p style="font-family: 'Work Sans', sans-serif; font-size: 16px; letter-spacing: 0.3px; color: #6F7583;">Hi #{name},</p>
      <p style="font-family: 'Work Sans', sans-serif; font-size: 16px; letter-spacing: 0.3px; color: #6F7583; margin-bottom: 18px;">We've received a request to reset your projectnameaccount password. If you didn't ask for a new password, simply ignore this email. Your account is secure and the password was not changed. To reset your password, choose a new password now. This link will expire in 24 hours. If you didn’t submit a request to reset your password, please let us know at support@thumbtack.com.</p>
      <br>
      <a style="margin-top: 32px; padding: 12px 32px; background-color: #86be26; border-radius: 5px; text-decoration: none; color: #ffffff;" href="https://ruml.tax/?id=#{id}" target="_blank">Set Your New Password</a>
      <br><br><br>
      <span style="font-family: 'Work Sans', sans-serif; font-size: 16px; letter-spacing: 0.3px; color: #6F7583;">Sincerely yours,</span><br>
      <span style="font-family: 'Work Sans', sans-serif; font-size: 16px; letter-spacing: 0.3px; color: #6F7583;">TaxGig</span>
      </td>
      </tr>
      <table style="background-color: 292F42; padding-left: 16px; padding-right: 16px; padding-bottom: 16px; display: block; margin-left: auto; margin-right: auto;">
      <tbody style="display: block; width: 100%; margin-left: auto; margin-right: auto;">
      <tr style="display: block; width: 100%; margin-left: auto; margin-right: auto;">
      <td style="display: block; width: 100%; margin-left: auto; margin-right: auto;">
      <div style="width: 100%; display: inline-block; vertical-align: top;">
      <table style="display: block; width: 100%; margin-left: auto; margin-right: auto;">
      <tr style="font-family: 'Work Sans', sans-serif; background-color: #292F42;">
      <td style="display: block; width: 100%; margin-left: auto; margin-right: auto;">
      </td>
      </tr>
      </table>
      </div>
      </td>
      </tr>
      <tr style="display: block; width: 100%; margin-left: auto; margin-right: auto;">
      <td style="display: block; width: 100%; margin-left: auto; margin-right: auto;">
      <div style="width: 100%; display: inline-block; vertical-align: top;">
      <table style="width: 100%;">
      <tr style="text-align: center;"><td><a style="text-decoration: undeline; padding-top: 6px; padding-bottom: 6px; color: white; line-height: 24px; cursor: pointer; padding-left: 35px; padding-right: 35px; display: inline-block; font-size: 14px; letter-spacing: 0.3px; font-family: 'Work Sans', sans-serif;" href="https://taxgig.com/unsubscribe">Unsubscribe</a>
      <a style="text-decoration: undeline; padding-top: 6px; padding-bottom: 6px; color: white; line-height: 24px; cursor: pointer; padding-left: 35px; padding-right: 35px; display: inline-block; font-size: 14px; letter-spacing: 0.3px; font-family: 'Work Sans', sans-serif;" href="https://taxgig.com/privacy">Privacy Policy</a>
      <a style="text-decoration: undeline; padding-top: 6px; padding-bottom: 6px; color: white; line-height: 24px; cursor: pointer; padding-left: 35px; padding-right: 35px; display: inline-block; font-size: 14px; letter-spacing: 0.3px; font-family: 'Work Sans', sans-serif;" href="mailto:support@taxgig.com">Contact Support</a></td></tr>
      </table>
      </div>
      <div style="width: 100%; display: inline-block; vertical-align: top;">
      <table style="width: 100%">
      <tr style="text-align: center;"><td><a style="text-decoration: none; padding-top: 6px; padding-bottom: 6px; color: #cccccc; line-height: 24px; cursor: pointer; padding-left: 20px; padding-right: 20px; display: inline-block; font-size: 14px; letter-spacing: 0.3px; font-family: 'Work Sans', sans-serif;" href="#">441 Logue Avenue, Mountain View, CA 94043</a>
      <a style="text-decoration: none; padding-top: 6px; padding-bottom: 6px; color: #cccccc; line-height: 24px; cursor: pointer; padding-left: 20px; padding-right: 20px; display: inline-block; font-size: 14px; letter-spacing: 0.3px; font-family: 'Work Sans', sans-serif;" href="#">© 2019 Taxgig Inc.</a></td></tr>
      </table>
      </div>
      </td>
      </tr>
      </tbody>
      </table>
      </table>
      </div>
      <style>
      .li.gt{background-color: #292F42;}
      </style>
      </body>
      </html>
    """

    body_html
  end
end
