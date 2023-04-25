defmodule MyAppWeb.ThermostatLiveTest do
  use ExUnit.Case
  use MyAppWeb.ConnCase

  test "mount assigns the temperature from the Thermostat module" do
    user_id = 1
    temperature = 20

    Thermostat = %{get_user_reading: fn(_user_id) -> temperature end}

    {:ok, socket} = connect(MyAppWeb.ThermostatLive, %{"current_user_id" => user_id}, Thermostat)

    assert socket.assigns.temperature == temperature
  end
end