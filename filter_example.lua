--[[ this is a pandoc filter which takes items inside of an examples
block like this:

::: examples
a
b
c
:::

And then fills in the actual div for each example.
]]

function Div(elem)
    if elem.attr.classes[1] == "examples" then
        local content2 = {}
        local i = 1
        for _, block in pairs(elem.content[1]["content"]) do
            local text = block["text"]
            if text ~= nil then
                path = text:gsub(":.*", "")
                option = text:gsub(".*:", "")
                if text:match("^demos/") then
                    name = path:gsub(".*/", "")
                    link = "demos/" .. name .. "/" .. name
                    source = "demos/" .. name
                else
                    name = path
                    link = "examples/" .. name
                    source = "examples/" .. name .. ".c"
                end
                if option == "no_try" then
                    try_link = pandoc.Str("")
                else
                    try_link = pandoc.Link("try", "https://allegro5.org/examples/" .. link .. ".html", "Try", {class = "try"})
                end
                content2[i] = pandoc.Div(
                    pandoc.Para {
                        pandoc.Str(name),
                        try_link,
                        pandoc.Link("source", "https://github.com/liballeg/allegro5/tree/master/" .. source, "Source", {class = "try"}),
                        pandoc.LineBreak(),
                        pandoc.Image(name .. " screenshot", "screenshots/" .. name .. ".png")
                    },
                    {class = "example"})
                i = i + 1
            end
        end
        elem.content = content2
        return elem
    end
end
