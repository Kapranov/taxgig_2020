use Mix.Config

ssl_dir = Path.expand("../priv/cert/", __DIR__)
ssl_cer_path = "#{ssl_dir}/fullchain.pem"
ssl_key_path = "#{ssl_dir}/privkey.pem"

config :server, ServerWeb.Endpoint,
  url: [scheme: "https", host: "taxgig.me", port: 4001],
  https: [
    port: 4001,
    cipher_suite: :strong,
    certfile: "#{ssl_cer_path}",
    keyfile:  "#{ssl_key_path}",
    versions: [:"tlsv1.2"],
    ciphers: [
      'ECDHE-ECDSA-AES256-GCM-SHA384',
      'ECDHE-RSA-AES256-GCM-SHA384',
      'ECDHE-ECDSA-AES256-SHA384',
      'ECDHE-RSA-AES256-SHA384',
      'ECDHE-ECDSA-DES-CBC3-SHA',
      'ECDH-ECDSA-AES256-GCM-SHA384',
      'ECDH-RSA-AES256-GCM-SHA384',
      'ECDH-ECDSA-AES256-SHA384',
      'ECDH-RSA-AES256-SHA384',
      'DHE-DSS-AES256-GCM-SHA384',
      'DHE-DSS-AES256-SHA256',
      'AES256-GCM-SHA384',
      'AES256-SHA256',
      'ECDHE-ECDSA-AES128-GCM-SHA256',
      'ECDHE-RSA-AES128-GCM-SHA256',
      'ECDHE-ECDSA-AES128-SHA256',
      'ECDHE-RSA-AES128-SHA256',
      'ECDH-ECDSA-AES128-GCM-SHA256',
      'ECDH-RSA-AES128-GCM-SHA256',
      'ECDH-ECDSA-AES128-SHA256',
      'ECDH-RSA-AES128-SHA256',
      'DHE-DSS-AES128-GCM-SHA256',
      'DHE-DSS-AES128-SHA256',
      'AES128-GCM-SHA256',
      'AES128-SHA256',
      'ECDHE-ECDSA-AES256-SHA',
      'ECDHE-RSA-AES256-SHA',
      'DHE-DSS-AES256-SHA',
      'ECDH-ECDSA-AES256-SHA',
      'ECDH-RSA-AES256-SHA',
      'AES256-SHA',
      'ECDHE-ECDSA-AES128-SHA',
      'ECDHE-RSA-AES128-SHA',
      'DHE-DSS-AES128-SHA',
      'ECDH-ECDSA-AES128-SHA',
      'ECDH-RSA-AES128-SHA',
      'AES128-SHA'
    ],
    secure_renegotiate: true,
    reuse_sessions: true,
    honor_cipher_order: true,
    transport_options: [
      max_connections: :infinity
    ]
  ],
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
