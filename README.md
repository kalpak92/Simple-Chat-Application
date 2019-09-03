# Distributed Tasks - Simple Chat Application
The Chat application is pretty simple. 
It sends messages to remote nodes and remote nodes respond to those messages by IO.puts-ing them out to the STDOUT of the remote node.

## Usage

In one terminal window, start up our chat app in a named iex session
```elixir
iex --sname alex@localhost -S mix
```
Open up another terminal window to start the app on a different named node:
```elixir
iex --sname kate@localhost -S mix
```
Now, from the alex node, we can send a message to the kate node:
```elixir
iex(alex@localhost)> Chat.send_message(:kate@localhost, "hi")
:ok
```
Switch to the kate window and you should see the message:
```elixir
iex(kate@localhost)> hi
```
The kate node can respond back to the alex node:
```elixir
iex(kate@localhost)> hi
Chat.send_message(:alex@localhost, "how are you?")
:ok
iex(kate@localhost)>
```
And it will show up in the alex node’s iex session:
```elixir
iex(alex@localhost)> how are you?
```

Let's have another node named moebi
```elixir
iex --sname moebi@localhost -S mix
```
Let’s have alex send a message to moebi:
```elixir
iex(alex@localhost)> Chat.send_message(:moebi@localhost, "hi")
chicken?
:ok
```

We can see that the alex node received the response, `"chicken?"`. If we open the `kate` node, we’ll see that no message was received, since neither `alex` nor `moebi` send her one (sorry `kate`). And if we open the `moebi` node’s terminal window, we’ll see the message that the `alex` node sent:
```elixir
iex(moebi@localhost)> hi
```