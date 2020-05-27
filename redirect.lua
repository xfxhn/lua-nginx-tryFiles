
--[[
-- ngx.req.get_headers   获取请求头
-- ngx.redirect   重定向
-- ngx.print  输出响应内容体
-- ngx.say   同ngx.print,但是最后会输出一个换行符
-- ngx.header  输出响应头
-- ngx.req.get_uri_args(); 获取url请求参数
-- nginx变量 local variable = ngx.var;
--]]--



function redicret_home(uri,path)
	local str = string.match(uri,'^/[%w_]+');
	return path..str.."/index.html";
end

function jump_index(uri,path) 	
	local index = io.open(redicret_home(uri,path),'rb');
	ngx.say(index:read("*a"));
	index:close();
end


ngx.header.content_type = "text/html;charset=utf-8";
--外部传进来的参数
local path = ngx.var.path_prefix;

if (path=='') then
	ngx.say("请设置目录---path_prefix");
	ngx.exit(ngx.OK);
	return
end
--ngx.say(ngx.arg[1])
--请求当前的URI
local request_uri = ngx.var.uri;


local real_uri = path..request_uri;

local file = io.open(real_uri,'rb');
 
if (not file) then
	jump_index(request_uri,path);
else
	local html = file:read("*a");
	if (html) then
		ngx.say(html);
		file:close();
		
	else
		local default_index = io.open(path..request_uri.."/index.html",'rb');
				
		if (default_index) then
			ngx.say(default_index:read("*a"));
			default_index:close();
		else			
			jump_index(request_uri,path);	
		end

	end
end


