defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  # alias Ueberauth.Strategy.Helpers
  # alias UeberauthExample.UserFromAuth
  alias Discuss.Repo
  alias Discuss.User


  # def callback(conn, params) do
  #   IO.puts("_+++++++")
  #   IO.inspect(conn.assigns)
  #   IO.inspect(params)
  # end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do

    # IO.puts("_+++++++")
    # IO.inspect(auth)
    # IO.inspect(params)

    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
          |> put_flash(:info, "Welcome Back!")
          |> put_session(:user_id, user.id)
          |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _reason} ->
        conn
          |> put_flash(:error, "Error signing in")
          |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
