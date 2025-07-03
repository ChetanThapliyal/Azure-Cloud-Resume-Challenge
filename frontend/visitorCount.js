// Visitor Count Script
console.log("visitorCount.js loaded");

document.addEventListener("DOMContentLoaded", () => {
  const counterElement = document.getElementById("visitorCount");

  if (!counterElement) {
    console.warn("No element with ID 'visitorCount' found on the page.");
    return;
  }

  const apiUrl = "https://crc-cosmos-visiorcount-g2a6dwd3andyb3dy.westus2-01.azurewebsites.net/api/visitorCounter";

  fetch(apiUrl)
    .then((response) => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    })
    .then((data) => {
      if (data.count !== undefined) {
        counterElement.textContent = data.count;
      } else {
        console.warn("API response did not include a 'count' field.");
      }
    })
    .catch((error) => {
      console.error("Failed to fetch visitor count:", error);
      counterElement.textContent = "Error";
    });
});