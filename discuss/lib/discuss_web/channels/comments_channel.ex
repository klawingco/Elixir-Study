defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel
  alias Discuss.Topic
  alias Discuss.Repo
  alias Discuss.{Topic, Comment}

  # @impl true
  # def join("comments:subtopic", payload, socket) do

  #   {:ok, socket}
  #   # if authorized?(payload) do
  #   #   {:ok, socket}
  #   # else
  #   #   {:error, %{reason: "unauthorized"}}
  #   # end
  # end

  @impl true
  def join("comments:" <> topic_id, payload, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
      |> Repo.get(topic_id)
      |> Repo.preload(comments: [:user])
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end
  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (user:lobby).
  # @impl true
  # def handle_in("shout", payload, socket) do
  #   broadcast(socket, "shout", payload)
  #   {:noreply, socket}
  # end

  def handle_in(name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id

    changeset = topic
      |> Ecto.build_assoc(:comments, user_id: user_id )
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new",
          %{comment: comment}
        )
        {:reply, :ok, socket}

      {:err, _reason} -> {:reply, {:error, %{errors: changeset}}, socket}

    end
  end


  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
