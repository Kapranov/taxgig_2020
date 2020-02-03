# Mailings

**TODO: Add description**

```
bash> mix new mailings

iex> Mailings.Mailer.send_tp_text("kapranov.lugatex@gmail.com")
iex> Mailings.Mailer.send_pro_text("kapranov.lugatex@gmail.com")
iex> Mailings.Mailer.send_tp_html("kapranov.lugatex@gmail.com")
iex> Mailings.Mailer.send_pro_html("kapranov.lugatex@gmail.com")
iex> Mailings.Mailer.send_forgot_password_html("6f79bc76-dcdd-46ef-a04b-8f39b48f52d5", "kapranov.lugatex@gmail.com", "Oleg G.Kapranov")
```

```
Application.ensure_all_started(:inets)
Application.ensure_all_started(:ssl)

task = Task.async(fn ->
  :httpc.request('https://google.com')
end)

{:ok, {_, _, body}} = Task.await(task)

IO.puts body

@spec create(String.t(), boolean()) :: {:ok} | {:error, String.t()}
def create(email, roles) when is_bitstring(email) and is_boolean(role) do
  Task.await(mailgun(email, role))
end

@spec send(String.t(), boolean()) :: {:ok} | {:error, String.t()}
defp send(email, role) do
  case role do
    true ->
      Task.async(fn ->
        Mailings.Mailer.send_pro_html(email)
      end)
    false ->
      Task.async(fn ->
        Mailings.Mailer.send_tp_html(email)
      end)
    nil ->
      {:error, "Role has been an empty"}
  end
end

@spec send(String.t(), boolean()) :: {:ok} | {:error}
def send(email, role) do
  if role do
    Task.async(fn ->
      Mailings.Mailer.send_pro_html(email)
    end)
  else
    Task.async(fn ->
      Mailings.Mailer.send_tp_html(email)
    end)
  enf
end
```

### 1 Feb 2020 by Oleg G.Kapranov
