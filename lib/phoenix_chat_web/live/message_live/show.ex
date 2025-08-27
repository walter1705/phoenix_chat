defmodule PhoenixChatWeb.MessageLive.Show do
  use PhoenixChatWeb, :live_view

  alias PhoenixChat.Chat

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Message {@message.id}
        <:subtitle>This is a message record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/messages"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/messages/#{@message}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit message
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Content">{@message.content}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Message")
     |> assign(:message, Chat.get_message!(id))}
  end
end
