const { app } = require("electron");

app.userAgentFallback = "Mozilla/5.0 (X11; Linux x86_64; rv:145.0) Gecko/20100101 Firefox/145.0";

require("./bundle.js");
