@moduledoc """
A schema is a keyword list which represents how to map, transform, and validate
configuration values parsed from the .conf file. The following is an explanation of
each key in the schema definition in order of appearance, and how to use them.

## Import

A list of application names (as atoms), which represent apps to load modules from
which you can then reference in your schema definition. This is how you import your
own custom Validator/Transform modules, or general utility modules for use in
validator/transform functions in the schema. For example, if you have an application
`:foo` which contains a custom Transform module, you would add it to your schema like so:

`[ import: [:foo], ..., transforms: ["myapp.some.setting": MyApp.SomeTransform]]`

## Extends

A list of application names (as atoms), which contain schemas that you want to extend
with this schema. By extending a schema, you effectively re-use definitions in the
extended schema. You may also override definitions from the extended schema by redefining them
in the extending schema. You use `:extends` like so:

`[ extends: [:foo], ... ]`

## Mappings

Mappings define how to interpret settings in the .conf when they are translated to
runtime configuration. They also define how the .conf will be generated, things like
documention, @see references, example values, etc.

See the moduledoc for `Conform.Schema.Mapping` for more details.

## Transforms

Transforms are custom functions which are executed to build the value which will be
stored at the path defined by the key. Transforms have access to the current config
state via the `Conform.Conf` module, and can use that to build complex configuration
from a combination of other config values.

See the moduledoc for `Conform.Schema.Transform` for more details and examples.

## Validators

Validators are simple functions which take two arguments, the value to be validated,
and arguments provided to the validator (used only by custom validators). A validator
checks the value, and returns `:ok` if it is valid, `{:warn, message}` if it is valid,
but should be brought to the users attention, or `{:error, message}` if it is invalid.

See the moduledoc for `Conform.Schema.Validator` for more details and examples.
"""
[
  extends: [:astarte_rpc],
  import: [],
  mappings: [
    # Available options
    "jwt_public_key_path": [
      commented: true,
      datatype: :binary,
      env_var: "PAIRING_API_JWT_PUBLIC_KEY_PATH",
      doc: "The path to the public key used to verify the Agent JWT.",
      hidden: false,
      required: true,
      to: "astarte_pairing_api.jwt_public_key_path"
    ],
    "port": [
      commented: true,
      datatype: :integer,
      default: 4003,
      env_var: "PAIRING_API_PORT",
      doc: "The port used from the Phoenix server.",
      hidden: false,
      to: "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.http.port"
    ],
    "bind_address": [
      commented: true,
      datatype: :binary,
      env_var: "PAIRING_API_BIND_ADDRESS",
      doc: "The bind address for the Phoenix server.",
      default: "0.0.0.0",
      hidden: false,
      to: "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.http.ip"
    ],
    # Hidden options
    "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.url.host": [
      commented: false,
      datatype: :binary,
      default: "localhost",
      doc: "Provide documentation for astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.url.host here.",
      hidden: true,
      to: "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.url.host"
    ],
    "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.secret_key_base": [
      commented: false,
      datatype: :binary,
      default: "LXWGqSIaFRDtOaX5Qgfw5TrSAsWQs6V8OkXEsGuuqRhc1oFvrGax/SfP7F7gAIcX",
      doc: "Provide documentation for astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.secret_key_base here.",
      hidden: true,
      to: "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.secret_key_base"
    ],
    "astarte_pairing_api.namespace": [
      commented: false,
      datatype: :atom,
      default: Astarte.Pairing.API,
      doc: "Provide documentation for astarte_pairing_api.namespace here.",
      hidden: true,
      to: "astarte_pairing_api.namespace"
    ],
    "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.render_errors.view": [
      commented: false,
      datatype: :atom,
      default: Astarte.Pairing.APIWeb.ErrorView,
      doc: "Provide documentation for astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.render_errors.view here.",
      hidden: true,
      to: "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.render_errors.view"
    ],
    "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.render_errors.accepts": [
      commented: false,
      datatype: [
        list: :binary
      ],
      default: [
        "json"
      ],
      doc: "Provide documentation for astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.render_errors.accepts here.",
      hidden: true,
      to: "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.render_errors.accepts"
    ],
    "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.pubsub.name": [
      commented: false,
      datatype: :atom,
      default: Astarte.Pairing.API.PubSub,
      doc: "Provide documentation for astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.pubsub.name here.",
      hidden: true,
      to: "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.pubsub.name"
    ],
    "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.pubsub.adapter": [
      commented: false,
      datatype: :atom,
      default: Phoenix.PubSub.PG2,
      doc: "Provide documentation for astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.pubsub.adapter here.",
      hidden: true,
      to: "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.pubsub.adapter"
    ],
    "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.debug_errors": [
      commented: false,
      datatype: :atom,
      default: true,
      doc: "Provide documentation for astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.debug_errors here.",
      hidden: true,
      to: "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.debug_errors"
    ],
    "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.code_reloader": [
      commented: false,
      datatype: :atom,
      default: true,
      doc: "Provide documentation for astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.code_reloader here.",
      hidden: true,
      to: "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.code_reloader"
    ],
    "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.check_origin": [
      commented: false,
      datatype: :atom,
      default: false,
      doc: "Provide documentation for astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.check_origin here.",
      hidden: true,
      to: "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.check_origin"
    ],
    "logger.console.metadata": [
      commented: false,
      datatype: [
        list: :atom
      ],
      default: [
        :request_id
      ],
      doc: "Provide documentation for logger.console.metadata here.",
      hidden: true,
      to: "logger.console.metadata"
    ],
    "logger.console.format": [
      commented: false,
      datatype: :binary,
      default: """
      [$level] $message
      """,
      doc: "Provide documentation for logger.console.format here.",
      hidden: true,
      to: "logger.console.format"
    ],
    "phoenix.stacktrace_depth": [
      commented: false,
      datatype: :integer,
      default: 20,
      doc: "Provide documentation for phoenix.stacktrace_depth here.",
      hidden: true,
      to: "phoenix.stacktrace_depth"
    ]
  ],
  transforms: [
    "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.http.ip": fn conf ->
      [{_, ip}] =Conform.Conf.get(conf, "astarte_pairing_api.Elixir.Astarte.Pairing.APIWeb.Endpoint.http.ip")

      charlist_ip = to_charlist(ip)

      case :inet.parse_address(charlist_ip) do
        {:ok, tuple_ip} -> tuple_ip
        _ -> raise "Invalid IP address in bind_address"
      end
    end,
    "astarte_pairing_api.jwt_public_key": fn conf ->
      [{_, public_key_path}] = Conform.Conf.get(conf, "astarte_pairing_api.jwt_public_key_path")

      if public_key_path == nil, do: raise "No JWT public key path configured"

      case JOSE.JWK.from_pem_file(public_key_path) do
        [] -> raise "Can't load JWT public key from path #{public_key_path}"
        jwk -> jwk
      end
    end
  ],
  validators: []
]
