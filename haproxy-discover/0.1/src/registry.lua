local std = require('std')

local M = {}
local Etcd_Registry = {}

function Etcd_Registry:fetch_services(service_name, service_port)
  local response, err = self.client:get(self.prefix .. '/' .. service_name)
  if err then
    return nil, 'Unable to contact etcd: ' .. err
  end
  if response.node == nil then
    return nil, 'etcd directory not found: /' .. self.prefix .. '/' .. service_name
  end

  local services = {}
  for i, node in ipairs(response.node.nodes) do
    local name, sp = string.match(node.key, "([^/]*):(%d+)$")
    if sp == service_port then
      local ip, port = string.match(node.value, "(.*):(.*)")
      table.insert(services, {
        ip=ip,
        port=port,
        name=string.gsub(name, "[^%w]", "_")})
    end
  end

  return services, nil
end

function M.new(registry_string)
  local self = {}

  self.backend = string.match(registry_string, "^(.*)://")

  if self.backend == 'etcd' then
    setmetatable(self, {__index = Etcd_Registry})

    self.address, self.port, self.prefix =
      string.match(registry_string, "etcd://([^:]*):([^/]*)/(.*)")

    local url = string.format('http://%s:%s', self.address, self.port)
    self.client = require('etcd').new(url)
  else
    std.io.die('Unsupported registry backend: %s', self.backend)
  end

  return self
end

return M
