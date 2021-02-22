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
                if text:match("^demos/") then
                    name = string.gsub(text, ".*/", "")
                    link = "demos/" .. name .. "/" .. name
                    source = "demos/" .. name
                else
                    name = text
                    link = "examples/" .. name
                    source = "examples/" .. name .. ".c"
                end
                content2[i] = pandoc.Div(
                    pandoc.Para {
                        pandoc.Str(name),
                        pandoc.Link("try", "https://allegro5.org/examples/" .. link .. ".html", "Try", {class = "try"}),
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
