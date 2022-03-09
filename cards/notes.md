
iex -S mix = to start the app

Pipe operator = |>

Install deps = mix deps.get

Generate Docs = mix docs

## Tests

Doctest = test from doc modules

Case Test = test at .exs


Refute ==
Asset !=

## Maps
Collection
Hashes - Ruby
Objects - JS

e.g 

iex> colors = %{primary: "red", secondary: "blue"}
iex> colors.primary
or
iex> %{secondary: secondary_color} = colors
iex> secondary_color

### Mutating Maps

First way
iex> colors = Map.put(colors, :primary, "green")

Second way (For update only)

iex> colors = %{colors | primary: "blue"}

## Keyword Lists

Declare one way
iex> colors = [{:primary, "red"}, {:secondary, "green"}]

Access
    iex> colors[:primary]
    "red"

Declare second way
iex> colors = [primary: "red", secondary "blue"]

Note: You can have same key for a list

Sample usecase as Stephen said
iex> query = User.find_where([where: user.age > 10, where: user.subscribed == true])

