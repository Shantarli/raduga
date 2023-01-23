import Alpine from "alpinejs";

Alpine.store('state', {
    selected: {
        id: undefined,
        inputs: {
            color: null,
            speed: null,
            save: null
        },
        set(id) {
            this.id = id
            this.inputs.color = document.getElementById(`color-input-${id}`)
            this.inputs.speed = document.getElementById(`speed-input-${id}`)
            this.inputs.save = document.getElementById(`save-button-${id}`)
        },
        dropChanges() {
            this.inputs.color.value = this.inputs.color.dataset.initial
            this.inputs.speed.value = this.inputs.speed.dataset.initial
        },
        clear() {
            this.id = null
        }
    },
    isLoading: false,
    sidebar: {
        visible: true,
        toggle() {
            this.visible = !this.visible
            Alpine.store('state').sharebar.visible = false
        }
    },
    sharebar: {
        visible: false,
        toggle() {
            this.visible = !this.visible
            Alpine.store('state').selected.clear()
        }
    }
})