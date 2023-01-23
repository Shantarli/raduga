export function uiSetActiveColor(id) {
    document
        .querySelectorAll(".color-row")
        .forEach((el) => el.classList.remove("active"));
    let colorRow = document.getElementById(`color-row-${id}`);
    if (colorRow) colorRow.classList.add("active");
}