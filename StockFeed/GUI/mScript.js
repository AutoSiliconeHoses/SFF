window.resizeTo(240, 385);
window.focus();

//Define Global Variables
var count = 0;

function openURL() {
  var shell = new ActiveXObject("WScript.Shell");
  shell.run("Chrome https://sellercentral.amazon.co.uk/listing/upload?ref=xx_download_apvu_xx");
}

function checkall(formname, checkname, thestate) {
  var el_collection = eval("document.forms." + formname + "." + checkname);
  for (c = 0; c < el_collection.length; c++) {
    el_collection[c].checked = thestate;
  }
}

function runBat(name) {
  var shell, path;
  if (name == "push") {
    shell = new ActiveXObject("WScript.Shell");
    path = ("\\\\DISKSTATION\\Feeds\\Stock File Fetcher\\StockFeed\\GUI\\" + name + ".bat");
    shell.run("explorer " + path, 0, true);
  }
  else if (name == "pop") {
    while (getCount("Z:\\Stock File Fetcher\\StockFeed\\GUI\\Output") != count) {
      getCount("Z:\\Stock File Fetcher\\StockFeed\\GUI\\Output");
    }

    scrap();
    compile();

    // Checks if amazon.txt is in Upload
    while (getCount("Z:\\Stock File Fetcher\\Upload") != 1) {
      getCount("Z:\\Stock File Fetcher\\Upload");
    }

    shell = new ActiveXObject("WScript.Shell");
    path = ("Z:\\Stock File Fetcher\\StockFeed\\GUI\\" + name + ".bat");
    shell.run("explorer " + path, 0, true);

    window.resizeTo(240, 385);
    window.focus();
    window.alert("Process Complete");
  }
  // else if (name == "toolbank") {
  //   shell = new ActiveXObject("WScript.Shell");
  //   path = ("\\\\DISKSTATION\\Feeds\\Stock File Fetcher\\StockFeed\\GUI\\Shortcuts\\" + name + ".lnk");
  //   shell.run("explorer " + path, 1, true);
  // }
  else {
    shell = new ActiveXObject("WScript.Shell");
    path = ("\\\\DISKSTATION\\Feeds\\Stock File Fetcher\\StockFeed\\" + name + "Feed\\" + name + ".bat");
    shell.run("explorer " + path, 0, true);
  }
}

function openFolder() {
  shell = new ActiveXObject("WScript.Shell");
  path = ("\\\\DISKSTATION\\Feeds\\Stock File Fetcher\\Upload")
  shell.run("explorer " + path, 1, true);
}

function getCount(path) {
  var myObject, f, filesCount;
  myObject = new ActiveXObject("Scripting.FileSystemObject");
  f = myObject.GetFolder(path);
  filesCount = f.files.Count;
  return filesCount;
}

function scrap() {
  shell = new ActiveXObject("WScript.Shell");
  path = ("Z:\\Stock File Fetcher\\StockFeed\\GUI\\scrap.bat");
  shell.run("explorer " + path, 0, false);
}

function compile() {
  shell = new ActiveXObject("WScript.Shell");
  path = ("Z:\\Stock File Fetcher\\StockFeed\\GUI\\compile.bat");
  shell.run("explorer " + path, 0, false);
}

function checkEm() {
  window.resizeTo(240, 0);
  count = 0;

  runBat("push");
  scrap();

  if (document.getElementById("checkstax").checked) {
    count++;
    runBat("stax");
  }
  if (document.getElementById("checktoolbank").checked) {
    count++;
    runBat("toolbank");
  }
  if (document.getElementById("checkhomehardware").checked) {
    count++;
    runBat("homehardware");
  }
  if (document.getElementById("checktoolstream").checked) {
    count++;
    runBat("toolstream");
  }
  if (document.getElementById("checkdraper").checked) {
    count++;
    runBat("draper");
  }
  if (document.getElementById("checkvaleo").checked) {
    count++;
    runBat("valeo");
  }
  if (document.getElementById("checktetrosyl").checked) {
    count++;
    runBat("tetrosyl");
  }
  if (document.getElementById("checkkyb").checked) {
    count++;
    runBat("kyb");
  }
  if (document.getElementById("checkdecco").checked) {
    count++;
    runBat("decco");
  }
  setTimeout(function() {
    runBat("pop");
  }, 1000);
}
