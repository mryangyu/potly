# Only require libs when this file is required itself
# So that it can also be used by angular which doesn't use require()
if module?
	`_ = require('lodash');`

_.defaultsDeep = _.partialRight _.merge, deep = (value, other) ->
  _.merge(value, other, deep)

_.isHash = (val) ->
	_.isObject(val) and not _.isArray(val)

# http://stackoverflow.com/questions/12700145/how-to-format-a-telephone-number-in-angularjs
_.formatTel = (tel, onlyDashes = no) ->
	return "" unless tel
	value = tel.toString().trim().replace(/^\+/, "")
	return tel  if value.match(/[^0-9]/)
	country = undefined
	city = undefined
	number = undefined
	switch value.length
		when 10 # +1PPP####### -> C (PPP) ###-####
			country = 1
			city = value.slice(0, 3)
			number = value.slice(3)
		when 11 # +CPPP####### -> CCC (PP) ###-####
			country = value[0]
			city = value.slice(1, 4)
			number = value.slice(4)
		when 12 # +CCCPP####### -> CCC (PP) ###-####
			country = value.slice(0, 3)
			city = value.slice(3, 5)
			number = value.slice(5)
		else
			return tel
	country = ""  if country is 1
	number = number.slice(0, 3) + "-" + number.slice(3)

	if onlyDashes
		((if country?.length then country + "-" else "")+ city + "-" + number).trim()
	else
		(country + " (" + city + ") " + number).trim()

_.formatHeight = (cm) ->
	return unless cm?
	INCH_TO_CM = 2.54
	inches = cm / INCH_TO_CM;

	feet = Math.floor inches / 12
	rem  = Math.round inches % 12
	if rem is 12
		feet += 1
		rem = 0

	"#{feet}'#{rem}\""

_.formatWeight = (kg) ->
	return unless kg?
	KG_TO_POUNDS = 2.20462
	(if kg > 91 then kg else Math.floor(kg * KG_TO_POUNDS)) + "lbs"

_.wordTrim = (str, MAX_LENGTH = 40, ellipses = no) ->
	# TODO: _.wordTrim("hello there", yes, 11)
	# will return "hello..." instead of "hello there"
	MAX_LENGTH -= 3 if ellipses

	str = str.trim()

	# go to char at maxLength and then back until we hit a ' '
	i = Math.min MAX_LENGTH, str.length
	origI = i
	
	# if it's not already at word end, go back till we find an end
	unless str[i] is undefined or str[i] is ' '
		while str[i] isnt ' ' and i >= 0
			i -= 1

	# If 'i' has changed then we know we trimmed at least one word
	hasTrimmedWords = i isnt origI

	if i is -1
		# It is one long word so we trim it
		str = str.substring(0, MAX_LENGTH)
	else
		# Trim until the last word that fits
		str = str.substring(0, i)

	# If we've trimmed and ellipses is true
	if ellipses and hasTrimmedWords
		str += "..."

	str

_.pickGood = (obj, omit=[]) ->
	return unless obj?
	clone = {}
	for k,v of obj
		continue if k[0] is '_' or _.isFunction(v) or k in omit
		clone[k] = v
	clone

_.changed = (cur, old) ->
	changed = _.clone(cur)
	for k,v of old
		if changed[k] is undefined
			changed[k] = null
		else
			delete changed[k] if _.isEqual(changed[k], v)
	changed

# Expose
module?.exports = _