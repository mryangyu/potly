fs = require 'fs'
yaml = require 'js-yaml'
path = require 'path'

DEFAULTS = yaml.load(fs.readFileSync(path.join(__dirname, 'defaults.yml'), 'utf8'))
DEFAULTS = DEFAULTS[process.env.WEBSITE_SITE_NAME or process.env.NODE_ENV or 'development']

module.exports = DEFAULTS