// Phoenix hooks
export function setHooks(state) {
    let Hooks = {
        AddColor: {
            mounted() {
                this.el.addEventListener("add-color", () => this.pushEvent("add-color"));
            },
        },
        DeleteColor: {
            mounted() {
                this.el.addEventListener("delete-color", (event) =>
                    this.pushEvent("delete-color", event.detail)
                );
            },
        },
        UpdateColor: {
            mounted() {
                this.el.addEventListener("update-color", (event) =>
                    this.pushEvent("update-color", event.detail)
                );
            },
        },
        Navigation: {
            mounted() {
                this.el.addEventListener("go-home", () => this.pushEvent("go-home"));
            },
        },
        DataBus: {
            mounted() {
                this.handleEvent("is-loaded", () => {
                    state.isLoading = false;
                });
            },
        }
    }
    return Hooks
}