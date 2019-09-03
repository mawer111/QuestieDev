dofile("zhCN/lookup.lua")
mysql = require "luasql.mysql"
env = assert(mysql.mysql())
conn = assert(env:connect ( "mangos0", "root", "mawer111", "127.0.0.1", "3306"))

function start()
    for k,v in pairs(LangQuestLookup["zhCN"]) do
        if type(v) == "table" and v[1] == nil then
            -- query database and setup table
            local row = queryQuestName(k)
            local title = row["Title_loc4"];
            local detail = row["Details_loc4"];
            local obj = row["Objectives_loc4"];
            table.insert( v, 1,title);
            table.insert( v, 2,detail);
            table.insert( v, 3,obj);
        end
    end
    genFile(LangQuestLookup["zhCN"]);
end

--根据id查询任务名称
function queryQuestName(Entry)
    conn:execute("set names utf8");
    local cur = conn:execute("select Title_loc4,Details_loc4,Objectives_loc4 from locales_quest where entry = "..Entry);
    local row = cur:fetch({}, 'a');
    local title = row["Title_loc4"];
    local detail = row["Details_loc4"];
    local obj = row["Objectives_loc4"];
    return row;
end
--[2] = {nil, nil, nil},
function genFile(Quests)
    local tkeys = {}
    for k in pairs(Quests) do table.insert(tkeys, k) end
    table.sort(tkeys)

    for _, k in ipairs(tkeys) do
      local v = Quests[k];
      local row = "["..k.."] = {";
      for k1,v1 in pairs(v) do
        row = row.." '"..v1.."',";
      end
      row = row.."},";
      print(row);
    end
end

start()