# telegraf

Cookbook to install and configure [telegraf](https://github.com/influxdb/telegraf)

This was influenced by [SimpleFinanace/chef-influxdb](https://github.com/SimpleFinance/chef-influxdb)

*Note:* Some plugins will require other packages be installed and that is out of scope for this
cookbook.  ie. `[netstat]` requires `lsof`

## Tested Platforms

* CentOS 7.1
* Ubuntu 14.04

## Requirements

* Chef 12.5+

## Usage

This cookbook can be used by including `telegraf::default` in your run list and settings attributes  
as needed.  Alternatively, you can use the custom resources directly.

### Attributes

| Key                                  | Type   | Description                                           | Default                                                                                                                                                             |
|--------------------------------------|--------|-------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| node['telegraf']['version']          | String | Version of telegraf to install, nil = latest          | nil                                                                                                                                                                 |
| node['telegraf']['config_file_path'] | String | Location of the telgraf main config file              | '/etc/opt/telegraf/telegraf.conf'                                                                                                                                   |
| node['telegraf']['config']           | Hash   | Config variables to be written to the telegraf config | {'tags' => {},'agent' => {'interval' => '10s','round_interval' => true,'flush_interval' => '10s','flush_jitter' => '5s'}                                            |
| node['telegraf']['outputs']          | Array  | telegraf outputs                                      | ['influxdb' => {'urls' => ['http://localhost:8086'],'database' => 'telegraf','precision' => 's'}]                                                                   |
| node['telegraf']['plugins']          | Hash   | telegraf plugins                                      | {'cpu' => {'percpu' => true,'totalcpu' => true,'drop' => ['cpu_time'],},'disk' => {},'io' => {},'mem' => {},'net' => {},'swap' => {},'system' => {}}                |

### Custom Resources

#### telegraf_install

Installs telegraf and configures the service. Optionally specifies a version, otherwise the latest available is installed

```ruby
telegraf_install 'default' do
  install_version '0.2.4'
  action :create
end
```

#### telegraf_config

Writes out the telegraf configuration file.  Optionally includes outputs and plugins.

```ruby
telegraf_config 'default' do
  path node['telegraf']['config_file_path']
  config node['telegraf']['config']
  outputs node['telegraf']['outputs']
  plugins node['telegraf']['plugins']
end
```

#### telegraf_outputs

Writes out telegraf outputs configuration file. You can call this several times to create multiple outputs config files.

```ruby
telegraf_outputs 'default' do
  path node['telegraf']['config_file_path']
  outputs node['telegraf']['outputs']
end
```

#### telegraf_plugins

Writes out telegraf plugins configuration file.

```ruby
telegraf_plugins 'default' do
  path node['telegraf']['config_file_path']
  plugins node['telegraf']['plugins']
end
```

You can call this several times to create multiple plugins config files. You'll need to specify different names for each telegraf_plugins resource, so they'll create separate config files.

For example, to add the nginx plugin:

```ruby
node.default['telegraf']['nginx'] = {
  'nginx' => {
    'urls' => ['http://localhost/status']
  }
}

telegraf_plugins 'nginx' do
  path '/etc/opt/telegraf/telegraf.d'
  plugins node['telegraf']['nginx']
  service_name 'default'
  reload true
end
```

Note that there are two optional parameters for this resource that could've been left out in this case:
  - service_name [default: 'default'] if you need to override which service should be restarted when the config changes;
  - reload [default: true] whether to restart the service when the config changes;

## License and Authors

```text
Copyright (C) 2015-2016 NorthPage

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
