local moveList = 
{
	{3},
	{5},
	{2},
	{1},
}
table.sort(moveList, function(pre, post)
	return pre[1] > post[1]
end)

for _,v in ipairs(moveList) do
	print(v[1])
end