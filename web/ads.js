function interstitialAd() {
    var script = document.getElementById("vigorousTag");
    if (script) return;
    script = document.createElement('script');
    script.setAttribute("id", "vigorousTag");
    script.setAttribute("async", "async");
    script.setAttribute("data-cfasync", "false");
    script.setAttribute("src", "//arsnivyr.com/1?z=5567331");
    document.getElementsByTagName("head")[0].appendChild(script);
}

function detectAdblock() {
  return new Promise(function (resolve, reject) {
    const testURL = 'https://arsnivyr.com/1?z=5567331';
    const myInit = { method: 'HEAD', mode: 'no-cors' };
    var myRequest = new Request(testURL, myInit);
    fetch(myRequest)
        .then((response) => { return response; })
        .then((response) => { resolve(false); })
        .catch((error) => { resolve(true); });
  });
}