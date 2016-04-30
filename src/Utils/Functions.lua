--
-- Author: HLZ
-- Date: 2016-01-06 10:00:33
-- 功能重写类




--获取文件的扩展名
function getExtension(str)
    return str:match(".+%.(%w+)$")
end

--封装switch语句
function switch(c)
  local swtbl = {
    casevar = c,
    caseof = function (self, code)
      local f
      if (self.casevar) then
        f = code[self.casevar] or code.default
      else
        f = code.missing or code.default
      end
      if f then
        if type(f)=="function" then
          return f(self.casevar,self)
        else
          error("case "..tostring(self.casevar).." not a function")
        end
      end
    end
  }
  return swtbl
end
