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
defaultConfig = {
	Button: {
		caption: "按钮"
	}
	Input: {
		label: "输入框"
	}
	Checkbox: {

	}
	Image: {
		src: "./resources/images/white-image.png"
	}
	Divider: {

	}
	TextArea: {}
}


cola((model)->
	model.set("components", components)
	model.set("editor", {
		layout: {
			columns: 12
		}
	})
	wideClass = "one,two,three,four,five,six,seven,eight,nine,ten,eleven,twelve,thirteen,fourteen,fifteen,sixteen".split(",")
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
							content: [
								{
									tagName: "div"
									class: "eight wide field"
								}
							]
						})
						$field.next().before(fields);
						setTimeout(()->
							$(fields).prepend($field)
							$field.addClass("eight wide")
						, 50)
					else
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
	});
	$(".draw-pad>.ui.grid>.column,.draw-pad>.ui.form .field").droppable({
		hoverClass: "accepted"
		accept: (el)->
			return true
		drop: (event, ui)->
			name = ui.draggable.attr("cname")
			constr = cola[name]
			button = new constr(defaultConfig[name])
			dom = button.getDom()
			$fly(event.target).append(dom)
	})

	$(".draw-pad>.ui.form>.field").hover(()->
		$(@).addClass("active")
	, ()->
		$(@).removeClass("active")
	)
)