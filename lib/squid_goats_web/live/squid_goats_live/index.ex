defmodule SquidGoatsWeb.SquidGoatsLive.Index do
  use Phoenix.Component

  use SquidGoatsWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(SquidGoats.PubSub, "squid_goats")
    end

    assigns = [
      squids: 0,
      goats: 0,
      doors: get_doors(),
      status: :ready_to_guess
    ]

    {:ok, assign(socket, assigns)}
  end

  def get_doors() do
    Enum.shuffle([:squid, :squid, :goat])
  end

  def handle_event("guess", %{"value" => value}, socket) do
    guess_count = socket.assigns.goats + socket.assigns.squids
    guess_result = guess_correct?(socket.assigns.doors, Integer.parse(value))

    new_assigns = if guess_result do
      [goats: socket.assigns.goats + 1, status: :guess_correct]
    else
      [squids: socket.assigns.squids + 1, status: :guess_wrong]
    end

    new_assigns = if (guess_count == 9) do
      [hd(new_assigns) | [status: :game_over]]
    else
      new_assigns
    end

    {:noreply, assign(socket, new_assigns)}
  end

  def handle_event("new_game", _params, socket) do
    new_doors = get_doors()

    {:noreply, assign(socket, [doors: new_doors, status: :ready_to_guess, squids: 0, goats: 0])}
  end

  def handle_event("continue", _params ,socket) do
    new_doors = get_doors()

    {:noreply, assign(socket, [doors: new_doors, status: :ready_to_guess])}
  end

  def guess_correct?(doors, {guess, _}) do
    Enum.at(doors, guess) == :goat
  end

  def door(assigns) do
    ~H"""
      <span>
        <img
          style="width:254px; height:329px;"
          src={get_img_src(@status, @animal)}>
        <button
          value={@index}
          phx-click={get_phx_click(@status)}>
            <%= get_button_text(@status, @index) %>
          </button>
      </span>
    """
  end

  def get_img_src(:guess_wrong, animal) do
    get_img_src(:guess_correct, animal)
  end

  def get_img_src(:guess_correct, :squid) do
    "/images/squid.jpg"
  end

  def get_img_src(:guess_correct, :goat) do
    "/images/goat.jpeg"
  end

  def get_img_src(:ready_to_guess, _) do
    "/images/door.png"
  end

  def get_img_src(:game_over, animal) do
    get_img_src(:guess_correct, animal)
  end

  def get_phx_click(:guess_correct) do
    get_phx_click(:guess_wrong)
  end

  def get_phx_click(:guess_wrong) do
    "continue"
  end

  def get_phx_click(:ready_to_guess) do
    "guess"
  end

  def get_phx_click(:game_over) do
    "new_game"
  end

  def get_button_text(:ready_to_guess, index) do
    "Open door #{index + 1}!"
  end

  def get_button_text(:guess_correct, index) do
    get_button_text(:guess_wrong, index)
  end

  def get_button_text(:guess_wrong, _index) do
    "Next Guess!"
  end

  def get_button_text(:game_over, _index) do
    "Start a new game!"
  end
end
