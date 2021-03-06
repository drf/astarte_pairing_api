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

defmodule Astarte.Pairing.APIWeb.EndpointTest do
  use Astarte.Pairing.APIWeb.ConnCase

  alias Astarte.Pairing.Mock

  @invalid_attrs ""

  describe "create certificate" do
    @create_attrs "csr"

    setup %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-api-key", Mock.valid_api_key())
        |> put_resp_header("accept", "application/json")

      {:ok, conn: conn}
    end

    test "renders certificate when data is valid", %{conn: conn} do
      conn = post conn, "/api/v1/pairing", @create_attrs
      assert %{"clientCrt" => clientCrt} = json_response(conn, 201)
      assert clientCrt == Mock.certificate(@create_attrs, "127.0.0.1")
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, "/api/v1/pairing", @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
