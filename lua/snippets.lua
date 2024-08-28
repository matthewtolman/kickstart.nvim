local ls = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
ls.config.setup {}

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
      return args[1]
end

local function file_name()
  local path = vim.fn.expand('%')
  local file_name = ""
  for part in path:gmatch("([^/\\]+)") do
      file_name = part
  end

  return file_name:gsub("%..*", "")
end

ls.add_snippets("elixir", {
  s("defl", {
    t({"@doc \"\"\"", "\t"}),
    i(5, "Description"),
    t({"", "\t", "\t## Examples", "\t", "\t\tiex> "}),
    f(copy, 1),
    t("("),
    i(6, ""),
    t(")"),
    t({"", "\t\t"}),
    i(7, ":ok"),
    t({"", "\t", "\"\"\"", "@spec "}),
    f(copy, 1),
    t("("),
    i(3, ""),
    t(") :: "),
    i(4, "any()"),
    t({"", "def "}),
    i(1, "func_name"),
    t("("),
    i(2, ""),
    t("), do: "),
    i(0, ":ok")
  }),

  s("del", {
    t("def "),
    i(1, "func_name"),
    t("("),
    i(2, ""),
    t("), do: "),
    i(0, ":ok"),
  }),

  s("de", {
    t("def "),
    i(1, "func_name"),
    t("("),
    i(2, ""),
    t({") do ", "\t"}),
    i(0, ":ok"),
    t({"", "end"})
  }),

  s({trig="def", priority=99999999}, {
    t({"@doc \"\"\"", "\t"}),
    i(5, "Description"),
    t({"", "\t", "\t## Examples", "\t", "\t\tiex> "}),
    f(copy, 1),
    t("("),
    i(6, ""),
    t(")"),
    t({"", "\t\t"}),
    i(7, ":ok"),
    t({"", "\t", "\"\"\"", "@spec "}),
    f(copy, 1),
    t("("),
    i(3, ""),
    t(") :: "),
    i(4, "any()"),
    t({"", "def "}),
    i(1, "func_name"),
    t("("),
    i(2, ""),
    t({") do", "\t"}),
    i(0, ":ok"),
    t({"", "end"})
  }),

  s({trig="defg", priority=99999999}, {
    t({"@doc \"\"\"", "\t"}),
    i(6, "Description"),
    t({"", "\t", "\t## Examples", "\t", "\t\tiex> "}),
    f(copy, 1),
    t("("),
    i(7, ""),
    t(")"),
    t({"", "\t\t"}),
    i(8, ":ok"),
    t({"", "\t", "\"\"\"", "@spec "}),
    f(copy, 1),
    t("("),
    i(4, ""),
    t(") :: "),
    i(5, "any()"),
    t({"", "def "}),
    i(1, "func_name"),
    t("("),
    i(2, ""),
    t({")", "\twhen "}),
    i(3, "true"),
    t({"", "do", "\t"}),
    i(0, ":ok"),
    t({"", "end"})
  }),

  s({trig="defp", priority=99999999}, {
    t({"@doc \"\"\"", "\t"}),
    i(5, "Description"),
    t({"", "\t", "\t## Examples", "\t", "\t\tiex> "}),
    f(copy, 1),
    t("("),
    i(6, ""),
    t(")"),
    t({"", "\t\t"}),
    i(7, ":ok"),
    t({"", "\t", "\"\"\"", "@spec "}),
    f(copy, 1),
    t("("),
    i(3, ""),
    t(") :: "),
    i(4, "any()"),
    t({"", "defp "}),
    i(1, "func_name"),
    t("("),
    i(2, ""),
    t({") do", "\t"}),
    i(0, ":ok"),
    t({"", "end"})
  }),

  s("type", {
    t("@type "),
    i(1, "type_name"),
    t(" :: "),
    i(2, "type"),
    t("()")
  }),

  s("defkwargs", {
    t({"@doc \"\"\"", "\t"}),
    i(6, "Description"),
    t({"", "\t", "\t## Examples", "\t", "\t\tiex> "}),
    f(copy, 1),
    t("("),
    i(7, "arg1: :val1"),
    t(")"),
    t({"", "\t\t"}),
    i(8, ":ok"),
    t({"", "\t", "\"\"\"", "@spec "}),
    f(copy, 1),
    t("("),
    i(4, "[arg1: any()]"),
    t(") :: "),
    i(5, "any()"),
    t({"", "def "}),
    i(1, "func_name"),
    t("("),
    i(2, "args"),
    t(" \\\\ ["),
    i(3, ""),
    t("]"),
    t({") do", "\t"}),
    i(0, ":ok"),
    t({"", "end"})
  }),

  s("defu", {
    t("defmacro __using__("),
    i(1, "opts"),
    t({") do", "\t"}),
    i(2, "arg1"),
    t(" = Keyword.get("),
    f(copy, 1),
    t(", :"),
    f(copy, 2),
    t(")"),
    t({"", "\t"}),
    i(3),
    t({"", "\tquote do", "\t\t"}),
    i(0, ":ok"),
    t({"", "\tend", "end"})
  }),
})

ls.add_snippets("erlang", {
  s("specf", {
    t("-spec "),
    i(1, "fn_name"),
    t("("),
    i(2, "any()"),
    t(") -> "),
    i(3, "any()"),
    t(".")
  }),

  s("docmod", {
    t({"%% ----------------------------------", "%%", "%% @author "}),
    i(1, "Author"),
    t({"", "%% @copyright "}),
    i(2, "Year"),
    t(" "),
    i(3, "Holder"),
    t({"", "%% @doc "}),
    i(4, "Description"),
    t({".", "%% @end", "%% @version "}),
    i(5, "Version"),
    t({"", "%% @end", "%%", "%% ----------------------------------"})
  }),

  s("docfun", {
    t({"%% ----------------------------------", "%%", "%% @doc "}),
    i(1, "Description"),
    t({".", "%% @end", "%%", "%% ----------------------------------"})
  }),

  s("docparam", {
    t({"@param "}),
    i(1, "Name"),
    t(" "),
    i(0, "Description"),
    t(".")
  }),

  s("docthrow", {
    t({"@throws "}),
    i(0, "term"),
    t(".")
  }),

  s("docdep", {
    t({"@deprecated Please use {@link "}),
    i(0, "replacement"),
    t("}"),
    t(".")
  }),

  s("docsee", {
    t({"@see "}),
    i(0, "func_or_module"),
    t(".")

  }),

  s("docequiv", {
    t({"%% @equiv "}),
    i(0, "expression"),
  }),

  s("docpriv", {
    t({"@private"})
  }),

  s("dochide", {
    t({"@hidden"})
  }),

  s("docsince", {
    t({"@since "}),
    i(0, "Version"),
    t("")
  }),

  s("docline", {
    t({"%% @doc "}),
    i(0, "Description")
  }),

  s("fun", {
    t({"%% ----------------------------------", "%%", "%% @doc "}),
    i(2, "Description"),
    t({".", "%% @end", "%%", "%% ----------------------------------"}),
    t("-spec "),
    i(1, "fn_name"),
    t("("),
    i(3, "any()"),
    t(") -> "),
    i(4, "any()"),
    t({".", ""}),
    f(copy, 1),
    t("("),
    i(5, "Arg"),
    t({") -> ", "\t"}),
    i(0, "nil"),
    t(".")
  }),

  s("handle_call", {
    t("handle_call("),
    i(1, "Msg"),
    t(", "),
    i(2, "_From"),
    t(", "),
    i(3, "State"),
    t(") ->"),
    i(4, ""),
    t({"", "\t"}),
    t("{reply, "),
    i(5, "Response"),
    t(", "),
    f(copy, 3),
    t("};"),
  }),

  s("nitrogen_page", {
    t("-module("),
    f(file_name),
    t({
      ").",
      "",
      "-compile(export_all).",
      "",
      "-include_lib(\"nitrogen_core/include/wf.hrl\").",
      "",
      "main() ->",
      "\t#template{file = \""}),
    i(1, "./site/templates/bare.html"),
    t({"\"}.", "", "title() ->", "\t\""}),
    i(2, "Page Title"),
    t({"\".", "", "body() ->", "\t#panel{id=inner_body, body=inner_body()}.", "", "inner_body() -> "}),
    i(3, "[]"),
    t(".")
  }),

  s("handle_call_unknown", {
    t({"handle_call(_Msg, _From, State) ->", "\t{reply, {error, bad_msg}, State}."})
  }),

  s("gen_server", {
    t("-module("),
    f(file_name),
    t({
      ").",
      "",
      "-export([start_link/1, start_link/0]).",
      "-export([init/1, terminate/2, handle_call/3, handle_cast/2, handle_info/2,",
      "\thandle_continue/2, code_change/3]).",
      "",
      "-behavior(gen_server).",
      "",
      "-record(state, {field}).",
      "",
      "start_link() -> start_link([]).",
      "",
      "start_link(Args) -> gen_server:start_link(",
    }),
    i(2, "{local, ?MODULE}, "),
    t({
      "?MODULE, Args, []).",
      "",
      "%% Client Methods",
      "",
      "client_methods() -> gen_server:call(?MODULE).",
      "",
      "%% Gen Server Init",
      "",
      "init(Args) ->",
      "\t{ok, #state{}}.",
      "",
      "handle_call(_Msg, _From, State=#state{}) ->",
      "\t{reply, {error, bad_msg}, State};",
      "handle_call(_Msg, _From, State) ->",
      "\t{stop, bad_state, {error, bad_msg}, State}.",
      "",
      "handle_cast(_Msg, State=#state{}) ->",
      "\t{noreply, State}.",
      "",
      "handle_continue(_Msg, State) ->",
      "\t{noreply, State}.",
      "",
      "handle_info(_Msg, State) ->",
      "\t{noreply, State}.",
      "",
      "terminate(_Reason, _State) ->",
      "\tok.",
      "",
      "code_change(_OldVsn, State, _Extra) ->",
      "\t{ok, State}.",
      "",
      "%% Implementation",
      "",
      "implementation_methods() -> ok.",
      ""
    })
  }),

  s("eunit", {
    t("-module("),
    f(file_name),
    t({
      ").",
      "",
      "-include_lib(\"eunit/include/eunit.hrl\").",
      "",
      "sample_test() -> ok = ok."
    })
  })
})

