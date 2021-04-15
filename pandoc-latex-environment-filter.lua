
function get_begin_environment(environment)
    return pandoc.RawBlock("latex", "\\begin{" .. environment .. "}")
end

function get_end_environment(environment)
    return pandoc.RawBlock("latex", "\\end{" .. environment .. "}")
end

-- Returns an array of strings: the div's classes
function get_div_classes(div)
    return div.attr.classes
end

-- Returns an array: the div's content excluding meta data
function get_div_content(div)
    return div.content[1].content
end

-- Returns true if div has the class "margin"
function is_margin_class(div)
    local classes = get_div_classes(div)
    for _,i in ipairs(classes) do
        if i == "margin" then
            return true
        end
    end
    return false
end







-- Get metadata for mapping div class to latex environment
function get_class_environment_map(doc)

    local meta = doc.meta

    local options = {}
    if meta["pandoc-latex-environment-filter"] then
        for environment,classes in pairs(meta["pandoc-latex-environment-filter"]) do
            options[environment] = classes
        end
    end
    return options
end

function Pandoc(doc)
    if FORMAT == 'latex' then
        local map = get_class_environment_map(doc)
        -- TODO: Check if map is empty

        local blocks = {}
        for i, block in pairs(doc.blocks) do
            local b = swap_classes_with_environments(map, block)
            table.insert(blocks, b)
        end
        return pandoc.Pandoc(blocks, doc.meta)
    else
        return doc
    end
end

function swap_classes_with_environments(map, block)
    if block.tag == "Div" then
        local div_classes = get_div_classes(block)
        local environment = get_environment_for_classes(map, div_classes)

        if environment then
            table.insert(block.content, 1, get_begin_environment(environment))
            table.insert(block.content, get_end_environment(environment))
        end
    end
    return block
end

-- TODO: Put in utilities
function print_table(table)
    print("Printing table:")
    for i,j in ipairs(table) do
        print(i,j)
    end
    print("Printing list:")
    for i,j in pairs(table) do
        print(i,j)
    end
end

function get_environment_for_classes(map, classes)
    for _,class in ipairs(classes) do
        local environment = get_environment_for_class(map, class)
        if environment then
            return environment
        end
    end
    return nil
end

-- TODO: Tidy up to get utility functions which gather ANY meta data
function get_environment_for_class(map, class)
    for environment,classes in pairs(map) do
        for _,i in pairs(classes) do
            for _,j in pairs(i) do
                for _,c in pairs(j) do
                    if c == class then
                        return environment
                    end
                end
            end
        end
    end
    return nil
end
