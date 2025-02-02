-module(eval).
-export([evaluate/1]).

evaluate([Token | _Rest]) ->
  {Expr, _Value, Body} = Token,
  if 
    Expr == calc ->
      calculate(Body);
    true ->
      trace_error(Token),
      exit
  end.

trace_error(Token) -> 
  {_Expr, Value, _Body} = Token,
  io:format("error: ~p ~n", [Value]). 

calculate([Token | _Rest]) ->
  {Expr, Value, Body} = Token,
  if 
    Expr == operator ->
      operate(Body, Value);
    (Expr == error) ->
      trace_error(Token);
    true ->
      ok
  end.

operate([], Operator) ->
  if 
    (Operator == plus) or (Operator == minus) ->
       0;
    (Operator == division) or (Operator == multiplication) ->
      1;
     true -> 0
  end;
operate([{Expr, Value, Body} | _Rest], _Operator) when Expr == error ->
  trace_error({Expr, Value, Body}),
  exit;
operate([{Expr} | _Rest], _Operator) when Expr /= integer ->
  trace_error({error, "must be specified a valid integer", []}),
  exit;
operate([Token | Rest], Operator) when Operator == plus ->
  {_Expr, Value} = Token,
  Value + operate(Rest, Operator);
operate([Token | Rest], Operator) when Operator == minus ->
  {_Expr, Value} = Token,
  Value - operate(Rest, Operator);
operate([Token | Rest], Operator) when Operator == division ->
  {_Expr, Value} = Token,
  Value / operate(Rest, Operator);
operate([Token | Rest], Operator) when Operator == multiplication ->
  {_Expr, Value} = Token,
  Value * operate(Rest, Operator).
