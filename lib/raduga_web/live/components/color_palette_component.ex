defmodule RadugaWeb.Components.ColorPaletteComponent do
  @moduledoc """
  This component displays colors in the form of small dots,
  also contains `RadugaWeb.Components.ColorToolComponent` and a button to add a new color
  """
  use RadugaWeb, :live_component

  def render(%{isOwner: is_owner, room: room} = assigns) do
    ~H"""
    <div class="color-palette">
      <%= for {color, index} <- Enum.with_index(@room.colors) do %>
        <div id={"color-row-" <> to_string(color["id"])} class="color-row" x-cloak>
          <button
            id={"tool-button-" <> to_string(index + 1)}
            class="color-tool-toggle"
            data-id={color["id"]}
            data-index={index + 1}
            @click="
              !$store.state.isLoading &&
              $nextTick(()=> {
                $store.state.selected.set($event.target.dataset.id),
                $store.state.sharebar.visible = false
              })"
            title={"Color #{index + 1} options"}
          >
            <div class="color-mark" style={"background:#" <> color["hex"]}></div>
            <div class="color-mark-separator"></div>
          </button>

          <%= if is_owner do %>
            <.live_component
              module={RadugaWeb.Components.ColorToolComponent}
              id={"phx-color-tool" <> to_string(color["id"])}
              color={color}
            />
          <% end %>
        </div>
      <% end %>

      <%!-- ADD BUTTON --%>
      <%= if length(@room.colors) < 7 && is_owner do %>
        <button
          id="add-button"
          class="with-icon"
          title="Add new"
          phx-hook="AddColor"
          @click="!$store.state.isLoading && $dispatch('add-color'),
                  $store.state.isLoading = true"
        >
          <img src="/icons/add-icon.svg" class="icon" />
        </button>
      <% end %>
    </div>
    """
  end
end
