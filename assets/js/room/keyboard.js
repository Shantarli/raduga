export function setKeyboard(state) {
    return {
        down(event) {

            // Color selection
            if (event.key >= 1 && event.key <= 7) {
                if (event.repeat) return;
                let button = document.getElementById(`tool-button-${event.key}`);
                if (button) {
                    state.selected.set(button.dataset.id)
                    button.click();
                }
            }

            if (event.key == "Escape") {
                state.selected.dropChanges();
                state.selected.clear();
            }
            // Random selected color
            if (event.code == "KeyE" && state.selected.id) {
                let input = state.selected.inputs.color
                input.click()
            }
            // Random selected color
            if (event.code == "KeyR" && state.selected.id) {
                let input = state.selected.inputs.color
                input.value = "#" + ((Math.random() + 2) * 16777216 | 0).toString(16).slice(1)
            }

            // Change speed of selected color
            if ((event.code == "ArrowLeft" || event.code == "ArrowRight") && state.selected.id) {
                let input = state.selected.inputs.speed
                let change = event.code == "ArrowLeft" ? -0.05 : 0.05
                input.value = parseFloat(input.value) + change;
            }

            // Save selected color
            if (event.code == "KeyS" && state.selected.id) {
                state.selected.inputs.save.click()
            }

            // Delete selected color
            if (event.code == "KeyD" && state.selected.id && state.sidebar.visible) {
                let button = document.getElementById("delete-button");
                if (button) button.click();
            }

            // Add new color
            if (event.code == "KeyA" && state.sidebar.visible) {
                let button = document.getElementById("add-button");
                if (button) button.click();
            }

            if (event.code == "Space") state.sidebar.toggle();

            if (event.code == "KeyQ" && state.sidebar.visible)
                state.sharebar.toggle();
        },
    };
}