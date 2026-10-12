local millennium = require("millennium")
local logger = require("logger")
return {
  on_load = function()
    logger:info("Home Installed Only source filter loaded")
    millennium.ready()
  end,
  on_unload = function()
    logger:info("Disabled; reload Steam UI to restore the original source")
  end,
  patches = {
    {
      file = [[chunk~[0-9a-f]+\.js]],
      find = [[let \w+=\w+\.md\.GetCollection\(\w+\.A8\.Recent\)\.visibleApps[\s\S]*?return \w+\.splice\(20\),JSON\.stringify\(\w+\.map\(\w+=>\w+\.appid\)\)]],
      transforms = {
        {
          match = [[return (\w+)\.splice\(20\),]],
          replace = [[return window.__homeInstalledOnlySource={before:\1.length},\1=\1.filter(e=>e.appid===0||e.BIsShortcut?.()||e.local_per_client_data?.installed===true),window.__homeInstalledOnlySource.removed=window.__homeInstalledOnlySource.before-\1.length,window.__homeInstalledOnlySource.ids=\1.slice(0,20).map(e=>e.appid),\1.splice(20),]],
        }
      }
    }
  }
}
