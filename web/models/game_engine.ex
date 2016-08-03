defmodule Pong.GameEngine do

  @velocity 20
  @game_width 640
  @game_height 480
  @paddle_width 12
  @paddle_height 100
  @paddle_velocity 10
  @paddle_distance_from_side 20
  @ball_diameter 20

  def new_game_state(score \\ {0, 0}) do
    %{
      score: score,
      left: %{
        location: {@paddle_distance_from_side, (@game_height / 2) - (@paddle_height / 2)},
        moving: :nope
      },
      right: %{
        location: {@game_width - @paddle_distance_from_side - @paddle_width, (@game_height / 2) - (@paddle_height / 2)},
        moving: :nope
      },
      ball_location: {(@game_width / 2) - (@ball_diameter / 2), (@game_height / 2) - (@ball_diameter / 2)},
      ball_velocity: {0, 0}
    }
  end

  # TODO
  #
  # change this to receive and return a game state
  # so basically this happens:
  # when player presses up or down key, that gets sent to the server
  # and we store in state whether they are moving up or down
  # when key is releases, same thing
  # then, as a part of the game tick, we move the paddles up or down
  # based on what direction we have stored in state
  #
  def move_paddle(state, player_side) do
    direction = Map.get(state, player_side).moving
    {x, y} = Map.get(state, player_side).location

    new_location = case direction do
      :up when y > 0 ->
        {x, y - 10}
      :down when y < (@game_height - @paddle_height) ->
        {x, y + 10}
      _ ->
        {x, y}
    end

    # updated_player_info = Map.put(player_info, :location, new_location)
    # Map.put(state, player_side, updated_player_info)
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

  # def check_collision({x, y}) do
  # end

  # def check_point({x, y}) do
  # end

  def print_to_console(state) do
    IO.puts("=========================")
    IO.puts("ball location: #{inspect state.ball_location}")
    IO.puts("ball velocity: #{inspect state.ball_velocity}")
    IO.puts("left player location: #{inspect state.left.location}")
    IO.puts("left player moving: #{inspect state.left.moving}")
    IO.puts("right player location: #{inspect state.right.location}")
    IO.puts("right player moving: #{inspect state.right.moving}")
    IO.puts("score: #{inspect state.score}")
    state
  end

end
