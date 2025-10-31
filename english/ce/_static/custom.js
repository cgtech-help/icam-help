/*
  Allow $ . # and : in tokens for search purposes.

  The split function regex is more general than the regex in the Python CustomSearchLanguage:split function,
  because I could not get the following matching code to work.

    window.splitQuery = function (query) {
      const regex = /\$[A-Za-z0-9_.]+|\#[0-9]+(?::[0-9]+)?|[\p{Letter}\p{Number}_\p{Emoji_Presentation}]+/gu;
      return Array.from(query.matchAll(regex), m => m[0]);
    };
*/

document.addEventListener("DOMContentLoaded", function () {
  window.splitQuery = (query) => query
    .split(/[^\p{Letter}\p{Number}_$.#:]+/gu) // split on non-matching characters
    .filter(term => term);  // remove empty strings
});


/*
  Allow the use of the Left|Right arrow or n|p keys to navigate to the previous|next section.
*/

document.addEventListener('keydown', function (e) {
  // Skip if focused in an input field or textarea
  const tag = document.activeElement.tagName.toLowerCase();
  if (tag === 'input' || tag === 'textarea') return;
  // Skip if Ctrl, Shift, or Alt is pressed
  if (e.ctrlKey || e.shiftKey || e.altKey) return;
  // Right|Left arrow or n|p key advances to the next|previous section
  const key = e.key.toLowerCase();
  if (key === 'arrowright' || key === 'n') {
    const next = document.querySelector('a[rel="next"]');
    if (next) {
      window.location.href = next.href;
    }
  } else if (key === 'arrowleft' || key === 'p') {
    const prev = document.querySelector('a[rel="prev"]');
    if (prev) {
      window.location.href = prev.href;
    }
  }
});
