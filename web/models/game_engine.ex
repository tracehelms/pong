defmodule Pong.GameEngine do

  @velocity 20
  @game_width 640
  @game_height 480
  @paddle_width 12
  @paddle_height 100
  @paddle_velocity 20
  @paddle_distance_from_side 20
  @ball_diameter 20

  def new_game_state(score \\ {0, 0}) do
    %{
      score: score,
      left: %{
        location: {@paddle_distance_from_side, div(@game_height, 2) - div(@paddle_height, 2)},
        moving: :nope
      },
      right: %{
        location: {@game_width - @paddle_distance_from_side - @paddle_width, div(@game_height, 2) - div(@paddle_height, 2)},
        moving: :nope
      },
      ball_location: {div(@game_width, 2) - div(@ball_diameter, 2), div(@game_height, 2) - div(@ball_diameter, 2)},
      ball_velocity: {0, 0}
    }
  end

  def move_paddle(state, player_side) do
    direction = Map.get(state, player_side).moving
    {x, y} = Map.get(state, player_side).location

    new_location = case direction do
      :up when y > 0 ->
        {x, y - @paddle_velocity}
      :down when y < (@game_height - @paddle_height) ->
        {x, y + @paddle_velocity}
      _ ->
        {x, y}
    end

    put_in(state, [player_side, :location], new_location)
  end

  def move_ball(state = %{ball_location: location, ball_velocity: {0, 0}}) do
    state
    |> Map.put(:ball_location, location)
    |> Map.put(:ball_velocity, {@velocity, @velocity})
  end

  def move_ball(state = %{ball_location: {loc_x, loc_y}, ball_velocity: {vel_x, vel_y}}) do
    state
    |> Map.put(:ball_location, {loc_x + vel_x, loc_y + vel_y})
  end

  def check_wall_collisions(state = %{ball_location: {_loc_x, loc_y}, ball_velocity: {vel_x, vel_y}}) when loc_y <= 0 or loc_y >= @game_height do
    state
    |> Map.put(:ball_velocity, {vel_x, -vel_y})
  end
  def check_wall_collisions(state), do: state

  def print_to_console(state) do
    IO.puts("=========================")
    IO.puts("ball location: #{inspect state.ball_location}")
    IO.puts("ball velocity: #{inspect state.ball_velocity}")
    IO.puts("left player location: #{inspect state.left.location}")
    IO.puts("left player moving: #{inspect state.left.moving}")
    IO.puts("right player location: #{inspect state.right.location}")
    IO.puts("right player moving: #{inspect state.right.moving}")
    IO.puts("score: #{inspect state.score}")

    {leftx, lefty} = state.left.location
    {rightx, righty} = state.right.location
    {ballx, bally} = state.ball_location

    leftx = div(leftx, 20)
    lefty = div(lefty, 20)
    rightx = div(rightx, 20)
    righty = div(righty, 20)
    ballx = div(ballx, 20)
    bally = div(bally, 20)

    Enum.each(0..div(@game_height, 20), fn(y) ->
      Enum.each(0..div(@game_width, 20), fn(x) ->
        cond do
          y == 0  || y == div(@game_height, 20) ->
            IO.write " X "
          x == 0 ->
            IO.write " X"
          x == div(@game_width, 20) ->
            IO.write "  X"
          draw_paddle?(x, y, leftx, lefty) ->
            IO.write "  O"
          draw_paddle?(x, y, rightx, righty) ->
            IO.write "  O"
          draw_ball?(x, y, ballx, bally) ->
            IO.write " O "
          true ->
            IO.write "   "
        end
      end)
      IO.write "\n"
    end)

    state
  end

  defp draw_paddle?(x, y, paddlex, paddley) do
    if x >= paddlex && x <= (paddlex + div(@paddle_width, 20)) && y >= paddley && y <= (paddley + div(@paddle_height, 20)) do
      true
    else
      false
    end
  end

  defp draw_ball?(x, y, ballx, bally) do
    if x >= ballx && x <= (ballx + div(@ball_diameter, 20)) && y >= bally && y <= (bally + div(@ball_diameter, 20)) do
      true
    else
      false
    end
  end
end
