#
# This file is part of Astarte.
#
# Astarte is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Astarte is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Astarte.  If not, see <http://www.gnu.org/licenses/>.
#
# Copyright (C) 2017 Ispirata Srl
#

defmodule Astarte.Pairing.Mock do
  alias Astarte.Pairing.API.Config

  @test_broker_url "ssl://broker.example.com:9000"
  @test_version "1"
  @existing_hw_id "yaLu85t5SmWPC-ALn5g-_Q"
  @test_api_key_prefix "testapikeyprefix"

  @certificate_base "I hereby certify that you're really you: "
  @valid_api_key "validapikey"

  @valid_crt "validcrt"
  @ms_in_a_month 2_628_000_000

  use Astarte.RPC.AMQPServer
  use Astarte.RPC.Protocol.Pairing

  def broker_url do
    @test_broker_url
  end

  def version do
    @test_version
  end

  def api_key(realm, hw_id) do
    @test_api_key_prefix <> realm <> hw_id
  end

  def existing_hw_id do
    @existing_hw_id
  end

  def certificate(csr, device_ip) do
    @certificate_base <> csr <> device_ip
  end

  def valid_api_key do
    @valid_api_key
  end

  def valid_crt do
    @valid_crt
  end

  def process_rpc(payload) do
    extract_call_tuple(Call.decode(payload))
    |> execute_rpc()
  end

  defp extract_call_tuple(%Call{call: call_tuple}) do
    call_tuple
  end

  defp execute_rpc({:get_info, %GetInfo{}}) do
    %GetInfoReply{url: @test_broker_url, version: @test_version}
    |> encode_reply(:get_info_reply)
    |> ok_wrap()
  end

  defp execute_rpc({:generate_api_key, %GenerateAPIKey{realm: _realm, hw_id: @existing_hw_id}}) do
    generic_error(:device_exists)
    |> ok_wrap()
  end

  defp execute_rpc({:generate_api_key, %GenerateAPIKey{realm: realm, hw_id: hw_id}}) do
    %GenerateAPIKeyReply{api_key: @test_api_key_prefix <> realm <> hw_id}
    |> encode_reply(:generate_api_key_reply)
    |> ok_wrap()
  end

  defp execute_rpc(
         {:do_pairing, %DoPairing{csr: csr, api_key: @valid_api_key, device_ip: device_ip}}
       ) do
    %DoPairingReply{client_crt: @certificate_base <> csr <> device_ip}
    |> encode_reply(:do_pairing_reply)
    |> ok_wrap()
  end

  defp execute_rpc(
         {:do_pairing, %DoPairing{csr: _csr, api_key: _valid_api_key, device_ip: _device_ip}}
       ) do
    generic_error(:invalid_api_key)
    |> ok_wrap()
  end

  defp execute_rpc({:verify_certificate, %VerifyCertificate{crt: @valid_crt}}) do
    now_ms =
      DateTime.utc_now()
      |> DateTime.to_unix(:milliseconds)

    one_month_from_now = now_ms + @ms_in_a_month

    %VerifyCertificateReply{valid: true, timestamp: now_ms, until: one_month_from_now}
    |> encode_reply(:verify_certificate_reply)
    |> ok_wrap()
  end

  defp execute_rpc({:verify_certificate, %VerifyCertificate{crt: _invalid}}) do
    now_ms =
      DateTime.utc_now()
      |> DateTime.to_unix(:milliseconds)

    %VerifyCertificateReply{
      valid: false,
      timestamp: now_ms,
      cause: :INVALID,
      details: "invalid_certificate"
    }
    |> encode_reply(:verify_certificate_reply)
    |> ok_wrap()
  end

  defp generic_error(error_name) do
    %GenericErrorReply{error_name: to_string(error_name)}
    |> encode_reply(:generic_error_reply)
  end

  defp encode_reply(reply, reply_type) do
    %Reply{reply: {reply_type, reply}}
    |> Reply.encode()
  end

  defp ok_wrap(result) do
    {:ok, result}
  end
end
