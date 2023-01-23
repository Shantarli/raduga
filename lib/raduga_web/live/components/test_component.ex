# defmodule GenericjamWeb.CvLive.References do
#   use GenericjamWeb, :live_component

#   def render(assigns) do
#     ~H"""
#     <div>
#       <h3 class="" id="references">References</h3>
#       <%= for key_int <- 0.. (Enum.count( @data )-1)  do %>
#         <.section_box item={@data["#{key_int}"]} key={"#{key_int}"} />
#       <% end %>
#     </div>
#     """
#   end
# end
