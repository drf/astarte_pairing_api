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

defmodule Astarte.Pairing.APIWeb.APIKeyControllerTest do
  use Astarte.Pairing.APIWeb.ConnCase

  alias Astarte.Pairing.API.Agent.Realm
  alias Astarte.Pairing.APIWeb.TestJWTProducer
  alias Astarte.Pairing.Mock

  @test_realm "testrealm"
  @test_hw_id "2imLILqtRP2vq0ZVy-TGRQ"
  @test_hw_id_256 "ova1YgZZZo3p_2m8UjJ_c3sOOmpLh3GOc0CARFwE-V4"
  @empty_invalid_hw_id ""
  @short_invalid_hw_id "YQ"
  @toolong_invalid_hw_id "y8wj2_k9juwgfF4_ir1sd8gUzR4V8MFnpap2ks73sniR"
  @invalid_hw_id "5GGciygQUcHZqXyc1BNeC%"

  @create_attrs %{"hwId" => @test_hw_id}
  @create_attrs_256 %{"hwId" => @test_hw_id_256}
  @invalid_attrs %{"hwId" => @empty_invalid_hw_id}
  @short_invalid_attrs %{"hwId" => @short_invalid_hw_id}
  @toolong_invalid_attrs %{"hwId" => @toolong_invalid_hw_id}
  @bad_encoding_invalid_attrs %{"hwId" => @invalid_hw_id}
  @existing_attrs %{"hwId" => Mock.existing_hw_id()}

  describe "create api_key" do
    setup %{conn: conn} do
      {:ok, jwt, _claims} =
        %Realm{realm_name: @test_realm}
        |> TestJWTProducer.encode_and_sign()

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", jwt)

      {:ok, conn: conn}
    end

    test "renders api_key when data is valid", %{conn: conn} do
      conn = post conn, api_key_path(conn, :create), @create_attrs
      assert %{"apiKey" => api_key} = json_response(conn, 201)
      assert api_key == Mock.api_key(@test_realm, @test_hw_id)
    end

    test "renders api_key when data is valid and hardware id is 256 bits long", %{conn: conn} do
      conn = post conn, api_key_path(conn, :create), @create_attrs_256
      assert %{"apiKey" => api_key} = json_response(conn, 201)
      assert api_key == Mock.api_key(@test_realm, @test_hw_id_256)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_key_path(conn, :create), @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when hardware id is too short", %{conn: conn} do
      conn = post conn, api_key_path(conn, :create), @short_invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when hardware id is too long", %{conn: conn} do
      conn = post conn, api_key_path(conn, :create), @toolong_invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when hardware id is not valid base64", %{conn: conn} do
      conn = post conn, api_key_path(conn, :create), @bad_encoding_invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when device already exists", %{conn: conn} do
      conn = post conn, api_key_path(conn, :create), @existing_attrs
      assert json_response(conn, 422)["errors"] == %{"error_name" => ["device_exists"]}
    end

    test "renders errors when unauthorized", %{conn: conn} do
      conn =
        conn
        |> delete_req_header("authorization")
        |> post(api_key_path(conn, :create), api_key: @create_attrs)

      assert json_response(conn, 401)["errors"] == %{"detail" => "Unauthorized"}
    end
  end
end
