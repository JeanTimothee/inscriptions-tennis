import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["currentTabLink"]

  followLink() {
    // Follow the link in the current tab after a short delay
    setTimeout(() => {
      this.currentTabLinkTarget.click();
    }, 500);
  }
}
