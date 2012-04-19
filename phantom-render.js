var page = require('webpage').create(),
  address, output, size;

if (phantom.args.length < 2 || phantom.args.length > 3) {
  console.log('Usage: rasterize.js URL filename');
  phantom.exit();
} else {
  address = phantom.args[0];
  output = phantom.args[1];
  page.settings.userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/536.8 (KHTML, like Gecko) Chrome/20.0.1105.0 Safari/536.8";
  page.viewportSize = { width: 1000, height: 1000 };
  page.clipRect = { top: 0, left: 0, width: 1000, height: 1000 };
  page.open(address, function (status) {
    if (status !== 'success') {
      phantom.exit(1);
    } else {
      window.setTimeout(function () {
        page.render(output);
        phantom.exit(0);
      }, 1000);
    }
  });
}
