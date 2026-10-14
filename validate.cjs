const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const assert = require('node:assert/strict');
const lua = fs.readFileSync(path.join(__dirname,'backend/main.lua'),'utf8');
const find = new RegExp(lua.match(/find = \[\[([\s\S]*?)\]\]/)[1],'g');
const match = new RegExp(lua.match(/match = \[\[([\s\S]*?)\]\]/)[1]);
const replacement = lua.match(/replace = \[\[([\s\S]*?)\]\]/)[1].replace(/\\1/g,'$1');
if (process.argv[2]) {
  let matches = 0;
  for (const file of fs.readdirSync(process.argv[2]).filter(name=>/^(?:chunk~.*|sp)\.js$/.test(name))) {
    const bundle = fs.readFileSync(path.join(process.argv[2],file),'utf8');
    const count = [...bundle.matchAll(find)].length;
    matches += count;
    if (count) new vm.Script(bundle.replace(find,segment=>segment.replace(match,replacement)));
  }
  assert.equal(matches,1,'exactly one Big Picture home function must match');
}
const run = new Function('d','window',replacement.replace(/\$1/g,'d')+'JSON.stringify(d.map(e=>e.appid))');
const apps = Array.from({length:50},(_,i)=>({appid:i+1,local_per_client_data:{installed:i%2===0},BIsShortcut:()=>false}));
const state = {};
assert.deepEqual(JSON.parse(run(apps,state)),apps.filter(e=>e.local_per_client_data.installed).slice(0,20).map(e=>e.appid));
assert.equal(apps.length,50,'original array preserved');
assert.equal(state.__homeInstalledOnlySource.removed,25);
assert.deepEqual(JSON.parse(run([{appid:99,BIsShortcut:()=>true},{appid:100},{appid:0}],{})),[99,0]);
console.log('PASS: filter before limit, source preservation, shortcuts and placeholder' + (process.argv[2] ? ', unique source match and patched bundle syntax' : ''));
