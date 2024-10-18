import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["cell"]; 

  flag(event) {
    event.preventDefault(); 
    
    if (this.isGameOver()) {
      alert("The game is over! Start a new game to play again.");
      return;
    }

    const cell = event.target;

    if (cell.classList.contains("flagged")) {
      cell.classList.remove("flagged");
      cell.innerHTML = ""; 
    } else {
      cell.classList.add("flagged");
      cell.innerHTML = "🚩"; 
    }
  }

  reveal(event) {
    if (this.isGameOver()) {
      alert("The game is over! Start a new game to play again.");
      return;
    }
    
    const cell = event.target;
    const row = cell.dataset.row;
    const col = cell.dataset.col;

    fetch(`/boards/${this.element.dataset.boardId}/reveal_cell?row=${row}&col=${col}`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      },
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.cell_value === "M") {
          cell.innerHTML = "💣";
        } else {
          cell.innerHTML = data.cell_value;
        }
        cell.classList.remove("unrevealed");
        cell.classList.add("revealed");

        if (data.game_over) {
          this.element.classList.add("game-over");
          alert("Game over! You clicked on a mine.");
        }
      });
  }

  isGameOver() {
    return this.element.classList.contains("game-over");
  }
}
