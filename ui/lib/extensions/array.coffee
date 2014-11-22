Array::remove = ->
	what = undefined
	a = arguments
	L = a.length
	ax = undefined
	while L and @length
		what = a[--L]
		@splice ax, 1 while (ax = @indexOf(what)) isnt -1
	this

Array::insert = (index, item) -> @splice(index, 0, item)

Array::append = (other) -> Array::push.apply @, other

Array::prepend = (another) -> Array::unshift.apply @, another

Array::join2 = (one = ", ", two = " and ") ->
	if @length <= 1
		@join(two)
	else
		str = ""
		str += @slice(0,-1).join(one)
		str += two + @slice(-1)[0]
		str
