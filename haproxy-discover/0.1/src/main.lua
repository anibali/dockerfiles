local cjson = require('cjson')
local http = require('httpclient').new()
local inspect = require('inspect')
local posix = require('posix')
local signal = require('posix.signal')
local unistd = require('posix.unistd')
local etlua = require('etlua')
local std = require('std')
local socket = require('socket')
local Registry = require('registry')

local optparse = std.optparse [[
  haproxy-discover 0.1.0-alpha

  This program comes with ABSOLUTELY NO WARRANTY.

  Usage: haproxy-discover [<options>]

  Options:

    -h, --help                display this help, then exit
        --version             display version information, then exit
    -s, --service=SERVICE     service name to discover backends for
    -p, --port=PORT           service port to discover backends for
    -i, --interval=5          poll interval for discovery in seconds
    -r, --registry=ADDR       address of backing registry
]]

local arg, opts = optparse:parse(arg, {interval=5})

-- Ensure that required options are specified
for i, opt in ipairs({'service', 'port', 'registry'}) do
  if opts[opt] == nil then
    optparse:opterr("option '" .. opt .. "' must be specified")
  end
end

-- Create registry object for discovering services
local registry = Registry.new(opts.registry)

-- Compile HAProxy config file template
local template_file = io.open('haproxy.cfg.tmpl')
local template = etlua.compile(template_file:read('*a'))
template_file:close()

print('Service discovery initialised')

local last_time = socket.gettime()

-- Main discovery loop
while true do
  local services, err = registry:fetch_services(opts.service, opts.port)

  if err then
    std.io.warn(err)
  else
    local haproxy_config = template({
      service_name=opts.service,
      port=opts.port,
      backends=services})

    local config_file = io.open('/etc/haproxy.cfg', 'w')
    config_file:write(haproxy_config)
    config_file:close()

    os.execute('./reload-haproxy.sh')

    local new_time = socket.gettime()
    print(string.format('Reloaded HAProxy after %.4fs', new_time - last_time))
    last_time = new_time
  end

  os.execute('sleep ' .. opts.interval)
end
