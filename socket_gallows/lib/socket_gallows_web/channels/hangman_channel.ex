defmodule SocketGallowsWeb.HangmanChannel do

  use Phoenix.Socket

  def join("hangman:game", _, socket) do
    { :ok, socket }
  end

end
