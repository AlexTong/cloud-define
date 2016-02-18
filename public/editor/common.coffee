components = [
	{name: "Button", label: "按钮", icon: "button"}
	{name: "Input", label: "输入框", icon: "input"}
	{name: "Checkbox", label: "复选框", icon: "checkbox"}
	{name: "Image", label: "图片", icon: "image"}
	{name: "Divider", label: "分割线", icon: "divider"}
	{name: "TextArea", label: "多行输入框", icon: "text_area"}
#	{name: "Label", label: "文本框", icon: "text"}
	{name: "Toggle", label: "滑动开关", icon: "toggle"}
	{name: "Link", label: "超链接", icon: "link"}
	{name: "Grid", label: "布局", icon: "text"}
]
defaultConfig =
	Button:
		caption: "按钮"
	Input:
		label: "输入框"
	Checkbox: {}
	Image:
		src: "./resources/images/white-image.png"
	Divider: {}
	TextArea: {}
wideClass = "one,two,three,four,five,six,seven,eight,nine,ten,eleven,twelve,thirteen,fourteen,fifteen,sixteen".split(",")
removeIndicator = (indicator)->
	parentNode = indicator.parentNode
	$indicator = $(indicator)
	if parentNode and $(parentNode).hasClass("fields")
		pWide = 0
		for className in wideClass
			if $indicator.hasClass(className)
				pWide = wideClass.indexOf(className) + 1
				break
		$(parentNode).attr("wide", 16 - pWide)
	$(indicator).remove()
editor =
	indicators: []
	droppableOptions:
		fields:
			hoverClass: "accepted"
			greedy: true
			accept: (el)->
				return true
			activate: ()->
				wide = $(@).attr("wide")
				if wide
					wide = parseInt(wide)
				else
					wide = 16
				if wide < 16
					wideClassName = wideClass[15 - wide]
					indicator = $.xCreate({
						tagName: "div"
						class: "#{wideClassName} wide field c-indicator"
					})
					$(@).append(indicator)
					$(indicator).droppable(editor.droppableOptions.field)
					editor.indicators.push(indicator)
					$(@).attr("wide", 16)
		field:
			hoverClass: "accepted"
			greedy: true
			accept: (el)->
				return !$(@).hasClass("do-not")
			drop: (event, ui)->
				name = ui.draggable.attr("cname")
				widget = new cola[name](defaultConfig[name])
				dom = widget.getDom()
				$fly(@).append(dom).removeClass("c-indicator").addClass("do-not")
				index = editor.indicators.indexOf(@)
				if index >= 0
					editor.indicators.splice(index, 1)


cola((model)->
	model.set("components", components)
	model.set("editor", {
		layout: {
			columns: 12
		}
	})
	toolbar = {}

	toolbarEl = $.xCreate({
		tagName: "div"
		class: "toolbar"
		content: [
			{
				tagName: "i"
				class: "compress icon f-compress"
				contextKey: "compress"
				click: ()->
					$field = $(@).closest('.field');
					wide = 0
					wideClassName = ""
					for className in wideClass
						if $field.hasClass(className)
							wide = wideClass.indexOf(className) + 1
							wideClassName = className
							break
					if wide is 0
						fields = $.xCreate({
							tagName: "div"
							class: "fields"
							wide: 8
						})
						$field.after(fields);
						$(fields).droppable(editor.droppableOptions.fields).find(">.field").droppable(editor.droppableOptions.field)
						setTimeout(()->
							$(fields).prepend($field)
							$field.addClass("eight wide")
						, 50)
					else
						parentFields = $(@).closest('.fields')
						if parentFields.length > 0
							oldWide = parentFields.attr("wide")
							if oldWide
								oldWide = parseInt(oldWide)
							else
								oldWide = 16
							parentFields.attr("wide", oldWide - 1);
						currentClassName = wideClass[wide - 2]
						$field.removeClass(wideClassName).addClass(currentClassName)

			}
			{
				tagName: "i"
				class: "expand icon f-expand"
				contextKey: "expand"
				click: ()->
					$field = $(@).closest('.field');
					wide = 0
					wideClassName = ""
					for className in wideClass
						if $field.hasClass(className)
							wide = wideClass.indexOf(className) + 1
							wideClassName = className
							break
					if wide is 16
						return
					else
						parentFields = $(@).closest('.fields')
						if parentFields.length > 0
							oldWide = parentFields.attr("wide")
							if oldWide
								oldWide = parseInt(oldWide)
							else
								oldWide = 16
							parentFields.attr("wide", oldWide + 1)
						currentClassName = wideClass[wide]
						$field.removeClass(wideClassName).addClass(currentClassName)
			}
			{
				tagName: "i"
				class: "remove icon f-remove"
				contextKey: "remove"
				click: ()->
					$field = $(@).closest('.field')
					cola._ignoreNodeRemoved = true
					$field[0].removeChild(toolbarEl)
					$field.remove()
					cola._ignoreNodeRemoved = false

			}
		]
	}, toolbar)

	$(".components").delegate(".component", "mousemove", ()->
		$(@).addClass("current");
	).delegate(".component", "mouseleave", ()->
		$(@).removeClass("current");
	);
	$(".draw-pad").delegate(".field", "click", ()->
		$(@).append(toolbarEl)
	)
)

cola.on("ready", ()->
	$(".component").draggable({
		helper: (event)->
			target = event.currentTarget
			targetClassName = target.children[0].className
			return $.xCreate({
				tagName: "div"
				class: targetClassName
			})
		appendTo: "body"
		revert: "invalid"
		cursor: "pointer"
		cursorAt:
			left: 2
			top: 2
		stop: ()->
			setTimeout(()->
				for indicator in editor.indicators
					removeIndicator(indicator)
				editor.indicators = []
			, 100)

	});

	$(".draw-pad>.ui.form").droppable({
		hoverClass: "accepted"
		greedy: true
		activate: ()->
			indicator = $.xCreate({
				tagName: "div"
				class: "field"
			})
			$(@).append(indicator)
			$(indicator).droppable(editor.droppableOptions.field)
			editor.indicators.push(indicator)
	})
)