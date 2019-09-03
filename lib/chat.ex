defmodule Chat do
  @moduledoc """
  Documentation for Chat.
  """

  @doc """
  Our Chat application is pretty simple.
  It sends messages to remote nodes and remote nodes respond to those messages by IO.puts-ing them out to the
  STDOUT of the remote node.
  """
  # let’s define a function, Chat.receive_message/1, that we want our task to execute on a remote node.
  def receive_message(message) do
        IO.puts message
  end

  def receive_message_for_moebi(message, from) do
    IO.puts message
    send_message(from, "CHICKEN ???")
  end

  # Next up, let’s teach the Chat module how to send the message to a remote node using a supervised task.
  # We’ll define a method Chat.send_message/2 that will enact this process:

  @doc """
  We’ll define another version of our send_message/2 function that pattern matches on the recipient argument.
  If the recipient is :moebi@locahost, we will
    Grab the name of the current node using Node.self()
    Give the name of the current node, i.e. the sender, to a new function receive_message_for_moebi/2,
    so that we can send a message back to that node.
  """

  def send_message(:moebi@localhost, message) do
    spawn_task(__MODULE__, :receive_message_for_moebi, :moebi@localhost, [message, Node.self() ])
  end

  def send_message(recipient, message) do
    spawn_task(__MODULE__, :receive_message, recipient, [message])
  end

  def spawn_task(module, fun, recipient, args) do
    recipient
    |> remote_supervisor()
    |> Task.Supervisor.async(module, fun, args)
    |> Task.await()
  end

  defp remote_supervisor(recipient) do
    #{Chat.TaskSupervisor, recipient}
    Application.get_env(:chat, :remote_supervisor).(recipient)
  end


end
