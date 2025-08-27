defmodule PhoenixChatWeb.MessageLive.Index do
  use PhoenixChatWeb, :live_view

  alias PhoenixChat.Chat

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Messages
        <:actions>
          <.button variant="primary" navigate={~p"/messages/new"}>
            <.icon name="hero-plus" /> New Message
          </.button>
        </:actions>
      </.header>

      <.table
        id="messages"
        rows={@streams.messages}
        row_click={fn {_id, message} -> JS.navigate(~p"/messages/#{message}") end}
      >
        <:col :let={{_id, message}} label="Content">{message.content}</:col>
        <:action :let={{_id, message}}>
          <div class="sr-only">
            <.link navigate={~p"/messages/#{message}"}>Show</.link>
          </div>
          <.link navigate={~p"/messages/#{message}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, message}}>
          <.link
            phx-click={JS.push("delete", value: %{id: message.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Messages")
     |> stream(:messages, Chat.list_messages())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    message = Chat.get_message!(id)
    {:ok, _} = Chat.delete_message(message)

    {:noreply, stream_delete(socket, :messages, message)}
  end
end
