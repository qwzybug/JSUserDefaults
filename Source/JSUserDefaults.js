var JSUserDefaults = {
  results: {},
  iframes: {},
  setObjectForKey: function(key, value) {
    var url = "NSUserDefaults://set?key=" + JSON.stringify(key) + "&value=" + JSON.stringify(value);
    iframe = document.createElement('iframe');
    iframe.style.display = 'none';
    iframe.src = url;
    document.body.appendChild(iframe);
    document.body.removeChild(iframe);
  },
  objectForKey: function(key) {
    this.iframes[key] = document.createElement('iframe');
    this.iframes[key].style.display = 'none';
    var url = "NSUserDefaults://get?key=" + JSON.stringify(key);
    this.iframes[key].src = url;
    document.body.appendChild(this.iframes[key]);
    while (this.iframes[key]) { }
    return this.results[key];
  },
  callback: function(key, value) {
    this.results[key] = value;
    document.body.removeChild(this.iframes[key]);
    delete this.iframes[key];
  }
}
