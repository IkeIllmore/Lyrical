function WriteLine(str)
    Turbine.Shell.WriteLine(str);
end

function dump(arg, depth)
	if (depth == nil) then depth = 0; end
	local function indent(val)
		WriteLine(string.format("%s%s", string.rep("  ", depth), val));
	end
    if type(arg) == "table" then
        for k,v in pairs(arg) do
            if type(v) == "table" then
                indent(tostring(k) .. ":");
                dump(v, depth + 1);
            else
                indent(tostring(k) .. ": " .. tostring(v));
            end
        end
    else
        indent(tostring(arg));
    end
end


-- from lua-users.org/wiki/SplitJoin
function string:split(sep)
        local sep, fields = sep, {}
        local pattern = string.format("([^%s]+)", sep)
        self:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields
end

function compareversion(v1, v2)
    local e1 = v1:split(".");
    local e2 = v2:split(".");

    local i = 1;
    while (i < #e1 and i < #e2) do
        local n1 = tonumber(e1[i]);
        local n2 = tonumber(e2[i]);
        if (n1 < n2) then
            return 1;
        elseif (n1 > n2) then
            return -1;
        end
        i = i + 1;
    end

    if (#e1 < #e2) then
        return 1;
    elseif (#e1 > #e2) then
        return -1;
    end

    return 0;
end

function map(list, func)
    local output = {};
    for i,v in ipairs(list) do
        output[i] = func(v);
    end
    return output;
end

function filter(list, func)
    local output = {};
    for i,v in ipairs(list) do
        if (func(v)) then
            table.insert(output, v);
        end
    end
    return output;
end

function tail(list)
    table.remove(list, 1);
    return list;
end

function AddCallback(object, event, callback)
    if (object[event] == nil) then
        object[event] = callback;
    else
        if (type(object[event]) == "table") then
            table.insert(object[event], callback);
        else
            object[event] = {object[event], callback};
        end
    end
    return callback;
end

function RemoveCallback(object, event, callback)
    if (object[event] == callback) then
        object[event] = nil;
    else
        if (type(object[event]) == "table") then
            local size = table.getn(object[event]);
            for i = 1, size do
                if (object[event][i] == callback) then
                    table.remove(object[event], i);
                    break;
                end
            end
        end
    end
end

