import "phoenix_html"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"  //

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content")

let Hooks = {}  //

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
})

liveSocket.connect()
window.liveSocket = liveSocket

/* ==========================================================
   TOPBAR
========================================================== */

topbar.config({
  barColors: {
    0: "#d4af37"
  },
  shadowColor: "rgba(0,0,0,.3)"
})

window.addEventListener("phx:page-loading-start", () => topbar.show())
window.addEventListener("phx:page-loading-stop",  () => topbar.hide())

/* ==========================================================
   JAGUAR PHOTOGRAPHY QUOTATION GENERATOR
========================================================== */

const basePrices = {
  wedding:    3500,
  graduation: 1200,
  portrait:    800,
  corporate:  2500,
  event:      1800
}

const hourlyRates = {
  wedding:    300,
  graduation: 150,
  portrait:   100,
  corporate:  250,
  event:      200
}

function calculateQuote() {
  const service      = document.getElementById("serviceType")
  const hours        = document.getElementById("hoursInput")
  const drone        = document.getElementById("droneCheck")
  const video        = document.getElementById("videoCheck")
  const totalElement = document.getElementById("quotePrice")

  if (!service || !hours || !drone || !video || !totalElement) return

  const serviceType = service.value
  const hoursValue  = parseInt(hours.value, 10) || 1
  const base        = basePrices[serviceType]  || 0
  const hourly      = hourlyRates[serviceType] || 0
  const droneFee    = drone.checked ? 1200 : 0
  const videoFee    = video.checked ? 1800 : 0
  const total       = base + hoursValue * hourly + droneFee + videoFee

  totalElement.textContent = `K ${total.toLocaleString()}`
}

/* ==========================================================
   BOOKING BUTTON
========================================================== */

function initializeBookingButton() {
  const bookingButton = document.getElementById("bookingButton")

  if (!bookingButton) return

  bookingButton.addEventListener("click", () => {
    bookingButton.textContent = "✓ Booking Submitted — We'll Be In Touch"
    bookingButton.style.background = "#2e7d32"
    bookingButton.disabled = true
  })
}

/* ==========================================================
   QUOTE EVENTS
========================================================== */

function initializeQuoteGenerator() {
  const elements = ["serviceType", "hoursInput", "droneCheck", "videoCheck"]

  elements.forEach(id => {
    const element = document.getElementById(id)
    if (!element) return

    element.addEventListener("change", calculateQuote)
    element.addEventListener("input",  calculateQuote)
  })

  calculateQuote()
}

/* ==========================================================
   SCROLL REVEAL
========================================================== */

function initializeScrollReveal() {
  const items = document.querySelectorAll(
    ".service-card, .testimonial-card, .pricing-card, .portfolio-item"
  )

  if (items.length === 0) return

  const observer = new IntersectionObserver(
    entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.style.opacity   = "1"
          entry.target.style.transform = "translateY(0)"
        }
      })
    },
    { threshold: 0.1 }
  )

  items.forEach(item => {
    item.style.opacity    = "0"
    item.style.transform  = "translateY(20px)"
    item.style.transition = "opacity 0.5s ease, transform 0.5s ease"
    observer.observe(item)
  })
}

/* ==========================================================
   PAGE INITIALIZATION
========================================================== */

function initializePage() {
  initializeQuoteGenerator()
  initializeBookingButton()
  initializeScrollReveal()
}

/* ==========================================================
   LOAD EVENTS
========================================================== */

// Initial page load
window.addEventListener("DOMContentLoaded", initializePage)

// Reinitialize after LiveView navigation
window.addEventListener("phx:page-loading-stop", initializePage)

// PDF download
window.addEventListener("phx:download_pdf", (e) => {
  const a = document.createElement("a")
  a.href = e.detail.url
  a.download = ""
  document.body.appendChild(a)
  a.click()
  document.body.removeChild(a)
})

function toggleMobileNav() {
  const btn    = document.getElementById("mobile-menu-btn");
  const drawer = document.getElementById("mobile-drawer");
  const isOpen = btn.getAttribute("aria-expanded") === "true";

  btn.classList.toggle("open", !isOpen);
  btn.setAttribute("aria-expanded", String(!isOpen));
  drawer.style.display  = "block";
  drawer.style.maxHeight = isOpen ? "0" : "500px";

  if (isOpen) {
    setTimeout(() => { drawer.style.display = "none"; }, 350);
  }
}

function closeMobileNav() {
  const btn    = document.getElementById("mobile-menu-btn");
  const drawer = document.getElementById("mobile-drawer");
  btn.classList.remove("open");
  btn.setAttribute("aria-expanded", "false");
  drawer.style.maxHeight = "0";
  setTimeout(() => { drawer.style.display = "none"; }, 350);
}

// Close drawer when clicking outside
document.addEventListener("click", (e) => {
  const nav    = document.getElementById("navbar");
  const drawer = document.getElementById("mobile-drawer");
  if (nav && drawer && !nav.contains(e.target) && !drawer.contains(e.target)) {
    closeMobileNav();
  }
});