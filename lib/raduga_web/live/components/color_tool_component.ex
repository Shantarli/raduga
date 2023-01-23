defmodule RadugaWeb.Components.ColorToolComponent do
  @moduledoc """
  A tool for changing selected color: the color itself, the speed of change, and a save button
  """
  use RadugaWeb, :live_component

  def render(%{color: color} = assigns) do
    ~H"""
    <div
      id={"color-tool-" <> to_string(color["id"])}
      class="color-tool"
      x-data={"{id:" <> to_string(color["id"]) <> "}"}
      x-show="id == $store.state.selected.id"
      @click.away="
              $store.state.selected.dropChanges(),
              $store.state.selected.clear()"
    >
      <div class="color-input-wrapper" title="Change the color">
        <input
          id={"color-input-" <> to_string(color["id"])}
          type="color"
          value={"#" <> to_string(color["hex"])}
          data-initial={"#" <> to_string(color["hex"])}
        />
      </div>
      <input
        id={"speed-input-" <> to_string(color["id"])}
        type="range"
        min="0.10"
        max="0.90"
        step="0.01"
        data-initial={color["speed"]}
        value={color["speed"]}
        title="Speed of change"
      />
      <button
        id={"save-button-" <> to_string(color["id"])}
        class="with-icon save-button"
        title="Save this color"
        @click="
                  $store.state.isLoading = true,
                  $dispatch('update-color', {
                    color_id: $store.state.selected.id,
                    hex: $store.state.selected.inputs.color.value,
                    speed: $store.state.selected.inputs.speed.value
                    }),
                    $nextTick(()=>{
                      $store.state.selected.clear()
                    })
                  "
        phx-hook="UpdateColor"
      >
        <img src="/icons/save-icon.svg" class="icon" />
      </button>
      <div class="backdrop" style={"background:#" <> color["hex"]}></div>
    </div>
    """
  end
end
